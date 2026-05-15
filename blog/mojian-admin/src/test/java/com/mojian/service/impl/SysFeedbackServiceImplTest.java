package com.mojian.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mojian.common.Constants;
import com.mojian.dto.feedback.SysFeedbackQueryDto;
import com.mojian.entity.SysFeedback;
import com.mojian.exception.ServiceException;
import com.mojian.mapper.SysFeedbackMapper;
import com.mojian.vo.feedback.SysFeedbackVo;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.util.ReflectionTestUtils;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SysFeedbackServiceImplTest {

    @Mock
    private SysFeedbackMapper sysFeedbackMapper;
    @Mock
    private JdbcTemplate jdbcTemplate;

    private TestableSysFeedbackService service;

    @BeforeEach
    void setUp() {
        service = new TestableSysFeedbackService(jdbcTemplate);
        ReflectionTestUtils.setField(service, "baseMapper", sysFeedbackMapper);
        service.currentUserId = 88L;
        when(jdbcTemplate.queryForObject(any(String.class), eq(Integer.class))).thenReturn(1);
    }

    @Test
    void insertShouldSaveNormalizedFeedbackType() {
        SysFeedback feedback = new SysFeedback();
        feedback.setFeedbackType(" bug_report ");
        feedback.setContent("test content");

        boolean result = service.insert(feedback);

        Assertions.assertTrue(result);
        Assertions.assertNotNull(service.savedFeedback);
        Assertions.assertEquals("bug_report", service.savedFeedback.getFeedbackType());
        Assertions.assertEquals(Long.valueOf(88L), service.savedFeedback.getUserId());
    }

    @Test
    void insertShouldThrowWhenFeedbackTypeMissing() {
        SysFeedback feedback = new SysFeedback();
        feedback.setFeedbackType(" ");
        feedback.setContent("test content");

        ServiceException exception = Assertions.assertThrows(ServiceException.class, () -> service.insert(feedback));
        Assertions.assertEquals("反馈类型不能为空", exception.getMessage());
    }

    @Test
    void insertShouldThrowWhenFeedbackTypeInvalid() {
        SysFeedback feedback = new SysFeedback();
        feedback.setFeedbackType("invalid_type");
        feedback.setContent("test content");

        ServiceException exception = Assertions.assertThrows(ServiceException.class, () -> service.insert(feedback));
        Assertions.assertEquals("反馈类型不合法", exception.getMessage());
    }

    @Test
    void updateShouldValidateFeedbackTypeWhenProvided() {
        SysFeedback feedback = new SysFeedback();
        feedback.setId(1L);
        feedback.setFeedbackType("ui_optimization");

        boolean result = service.update(feedback);

        Assertions.assertTrue(result);
        Assertions.assertEquals("ui_optimization", service.updatedFeedback.getFeedbackType());
    }

    @Test
    void updateShouldAllowEmptyFeedbackType() {
        SysFeedback feedback = new SysFeedback();
        feedback.setId(1L);
        feedback.setFeedbackType(null);

        boolean result = service.update(feedback);

        Assertions.assertTrue(result);
        Assertions.assertNull(service.updatedFeedback.getFeedbackType());
    }

    @Test
    void selectPageShouldInjectCurrentUserWhenPortalSource() {
        SysFeedbackQueryDto queryDto = new SysFeedbackQueryDto();
        queryDto.setSource("portal");
        queryDto.setFeedbackType("bug_report");
        IPage<SysFeedbackVo> mockPage = new Page<>();
        when(sysFeedbackMapper.page(any(Page.class), eq(queryDto))).thenReturn(mockPage);

        IPage<SysFeedbackVo> result = service.selectPage(queryDto);

        Assertions.assertEquals(mockPage, result);
        Assertions.assertEquals(Long.valueOf(88L), queryDto.getUserId());
        verify(sysFeedbackMapper).page(any(Page.class), eq(queryDto));
    }

    @Test
    void selectPageShouldKeepUserWhenAdminSource() {
        SysFeedbackQueryDto queryDto = new SysFeedbackQueryDto();
        queryDto.setSource(Constants.ADMIN);
        queryDto.setUserId(100L);
        IPage<SysFeedbackVo> mockPage = new Page<>();
        when(sysFeedbackMapper.page(any(Page.class), eq(queryDto))).thenReturn(mockPage);

        IPage<SysFeedbackVo> result = service.selectPage(queryDto);

        Assertions.assertEquals(mockPage, result);
        Assertions.assertEquals(Long.valueOf(100L), queryDto.getUserId());
        verify(sysFeedbackMapper).page(any(Page.class), eq(queryDto));
    }

    private static class TestableSysFeedbackService extends SysFeedbackServiceImpl {
        private Long currentUserId;
        private SysFeedback savedFeedback;
        private SysFeedback updatedFeedback;

        private TestableSysFeedbackService(JdbcTemplate jdbcTemplate) {
            super(jdbcTemplate);
        }

        @Override
        protected Long getCurrentUserId() {
            return currentUserId;
        }

        @Override
        public boolean save(SysFeedback entity) {
            this.savedFeedback = entity;
            return true;
        }

        @Override
        public boolean updateById(SysFeedback entity) {
            this.updatedFeedback = entity;
            return true;
        }

        @Override
        protected Page<Object> buildPage() {
            return new Page<>(1, 10);
        }
    }
}
