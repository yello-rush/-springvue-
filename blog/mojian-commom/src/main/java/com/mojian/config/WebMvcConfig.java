package com.mojian.config;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mojian.config.interceptor.ApiAccessLogInterceptor;
import com.mojian.entity.SysFileOss;
import com.mojian.enums.FileOssEnum;
import com.mojian.mapper.SysFileOssMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;
import java.util.List;

/**
 * @author blue
 * @date 2022/3/10
 * @apiNote
 */
@Configuration
@EnableWebMvc
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    private final SysFileOssMapper sysFileOssMapper;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("doc.html")
                .addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");

        List<SysFileOss> sysFileOssList = sysFileOssMapper.selectList(new LambdaQueryWrapper<SysFileOss>()
                .eq(SysFileOss::getPlatform, FileOssEnum.LOCAL.getValue()).last("limit 1"));

        if (!sysFileOssList.isEmpty()) {
            SysFileOss sysFileOss = sysFileOssList.get(0);
            String storagePath = sysFileOss.getStoragePath();
            if (!storagePath.startsWith("/") && !storagePath.contains(":")) {
                storagePath = System.getProperty("user.dir") + "/" + storagePath;
            }
            //本地存储升级版
            registry.addResourceHandler(sysFileOss.getPathPatterns())
                    .addResourceLocations("file:" + storagePath);
        }
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new ApiAccessLogInterceptor());
    }

    /**
     * 注册跨域信息
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*") // 允许所有跨域地址
                .allowedHeaders("*")
                .allowedMethods("*")
                .maxAge(3600);
    }

    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }



}
