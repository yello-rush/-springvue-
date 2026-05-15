package com.mojian.service.impl;

import com.mojian.entity.SysArticle;
import com.mojian.mapper.SysArticleMapper;
import com.mojian.mapper.SysCategoryMapper;
import com.mojian.utils.NotificationsUtil;
import com.mojian.utils.RedisUtil;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.http.HttpServletRequest;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ArticleServiceImplCollectTest {

    @Mock
    private SysArticleMapper sysArticleMapper;
    @Mock
    private SysCategoryMapper sysCategoryMapper;
    @Mock
    private RedisUtil redisUtil;
    @Mock
    private NotificationsUtil notificationsUtil;

    private TestableArticleService service;

    @BeforeEach
    void setUp() {
        service = new TestableArticleService(sysArticleMapper, sysCategoryMapper, redisUtil, notificationsUtil);
        service.userId = 1;
        service.clientIp = "127.0.0.1";
    }

    @Test
    void collectShouldCancelWhenCurrentStatusIsCollected() {
        SysArticle article = new SysArticle();
        article.setFavoriteNum(10);
        when(sysArticleMapper.getCollectStatus(100L, 1)).thenReturn(1);
        when(sysArticleMapper.selectById(100L)).thenReturn(article);

        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getAttribute(anyString())).thenReturn(1);
        when(request.getRequestURI()).thenReturn("/api/article/collect/100");
        service.request = request;

        Boolean result = service.collect(100L);

        Assertions.assertFalse(result);
        verify(sysArticleMapper).unCollect(100L, 1);
        verify(sysArticleMapper).update(any(), any());
        verify(sysArticleMapper).recordCollectBehavior(anyInt(), anyLong(), anyString(), anyInt(), any(), any(), anyString(), anyString());
    }

    @Test
    void collectShouldRecoverWhenCurrentStatusIsCancelled() {
        SysArticle article = new SysArticle();
        article.setFavoriteNum(10);
        when(sysArticleMapper.getCollectStatus(100L, 1)).thenReturn(0);
        when(sysArticleMapper.selectById(100L)).thenReturn(article);

        Boolean result = service.collect(100L);

        Assertions.assertTrue(result);
        verify(sysArticleMapper).reCollect(100L, 1);
        verify(sysArticleMapper, never()).collect(anyLong(), anyInt());
        verify(sysArticleMapper).recordCollectBehavior(anyInt(), anyLong(), anyString(), anyInt(), any(), any(), any(), anyString());
    }

    @Test
    void collectShouldInsertWhenNoCollectRecordExists() {
        SysArticle article = new SysArticle();
        article.setFavoriteNum(0);
        when(sysArticleMapper.getCollectStatus(200L, 1)).thenReturn(null);
        when(sysArticleMapper.selectById(200L)).thenReturn(article);

        Boolean result = service.collect(200L);

        Assertions.assertTrue(result);
        verify(sysArticleMapper).collect(200L, 1);
        verify(sysArticleMapper, never()).reCollect(anyLong(), anyInt());
    }

    private static class TestableArticleService extends ArticleServiceImpl {
        private Integer userId;
        private HttpServletRequest request;
        private String clientIp;

        TestableArticleService(SysArticleMapper sysArticleMapper, SysCategoryMapper sysCategoryMapper,
                               RedisUtil redisUtil, NotificationsUtil notificationsUtil) {
            super(sysArticleMapper, sysCategoryMapper, redisUtil, notificationsUtil);
        }

        @Override
        protected Integer getCurrentUserId() {
            return userId;
        }

        @Override
        protected HttpServletRequest currentRequest() {
            return request;
        }

        @Override
        protected String currentIp() {
            return clientIp;
        }
    }
}
