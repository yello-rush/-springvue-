package com.mojian.config;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.ReflectionUtils;
import org.springframework.web.servlet.mvc.method.RequestMappingInfoHandlerMapping;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Springfox 2.x 与 Spring Boot 2.6+ 路由匹配兼容补丁。
 */
@Configuration
public class SpringfoxCompatibilityConfig {

    @Bean
    public static BeanPostProcessor springfoxHandlerProviderBeanPostProcessor() {
        return new BeanPostProcessor() {
            @Override
            public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
                String className = bean.getClass().getName();
                if (className.contains("WebMvcRequestHandlerProvider") || className.contains("WebFluxRequestHandlerProvider")) {
                    customizeSpringfoxHandlerMappings(getHandlerMappings(bean));
                }
                return bean;
            }

            private void customizeSpringfoxHandlerMappings(List<RequestMappingInfoHandlerMapping> mappings) {
                if (mappings == null || mappings.isEmpty()) {
                    return;
                }
                List<RequestMappingInfoHandlerMapping> copy = mappings.stream()
                        .filter(mapping -> mapping.getPatternParser() == null)
                        .collect(Collectors.toList());
                mappings.clear();
                mappings.addAll(copy);
            }

            @SuppressWarnings("unchecked")
            private List<RequestMappingInfoHandlerMapping> getHandlerMappings(Object bean) {
                Field field = ReflectionUtils.findField(bean.getClass(), "handlerMappings");
                if (field == null) {
                    return new ArrayList<>();
                }
                field.setAccessible(true);
                try {
                    Object value = field.get(bean);
                    if (value instanceof List) {
                        return (List<RequestMappingInfoHandlerMapping>) value;
                    }
                } catch (IllegalAccessException ignored) {
                }
                return new ArrayList<>();
            }
        };
    }
}
