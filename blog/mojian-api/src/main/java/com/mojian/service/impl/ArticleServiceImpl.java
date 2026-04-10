package com.mojian.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.thread.ThreadUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.support.SFunction;
import com.mojian.common.RedisConstants;
import com.mojian.entity.SysArticle;
import com.mojian.entity.SysCategory;
import com.mojian.entity.SysNotifications;
import com.mojian.service.ArticleService;
import com.mojian.utils.DateUtil;
import com.mojian.utils.IpUtil;
import com.mojian.utils.NotificationsUtil;
import com.mojian.utils.RedisUtil;
import com.mojian.vo.article.ArchiveListVo;
import com.mojian.vo.article.ArticleDetailVo;
import com.mojian.vo.article.ArticleListVo;
import com.mojian.vo.article.CategoryListVo;
import com.mojian.mapper.SysArticleMapper;
import com.mojian.mapper.SysCategoryMapper;
import com.mojian.utils.PageUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    private final SysArticleMapper sysArticleMapper;

    private final SysCategoryMapper sysCategoryMapper;

    private final RedisUtil redisUtil;

    private final NotificationsUtil notificationsUtil;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean collect(Long articleId) {
        String loginIdAsString = StpUtil.getLoginIdAsString();
        Integer userId = Integer.valueOf(loginIdAsString);
        Boolean userIsCollect = sysArticleMapper.getUserIsCollect(articleId, userId);

        LambdaUpdateWrapper<SysArticle> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(SysArticle::getId, articleId);
        SysArticle sysArticle = sysArticleMapper.selectById(articleId);

        if (userIsCollect) {
            sysArticleMapper.unCollect(articleId, userId);
            updateWrapper.set(SysArticle::getFavoriteNum, sysArticle.getFavoriteNum() - 1);
            sysArticleMapper.update(null, updateWrapper);
            return false;
        } else {
            sysArticleMapper.collect(articleId, userId);
            updateWrapper.set(SysArticle::getFavoriteNum, sysArticle.getFavoriteNum() + 1);
            sysArticleMapper.update(null, updateWrapper);
            return true;
        }
    }

    @Override
    public IPage<ArticleListVo> getArticleList(Integer tagId, Integer categoryId, String keyword) {
        return sysArticleMapper.getArticleListApi(PageUtil.getPage(), tagId, categoryId, keyword);
    }

    @Override
    public ArticleDetailVo getArticleDetail(Long id) {
        try {
            // 更新访问时间
            SysArticle sysArticle = sysArticleMapper.selectById(id);
            if (sysArticle != null) {
                LocalDateTime now = LocalDateTime.now();
                if (sysArticle.getFirstAccessedTime() == null) {
                    sysArticle.setFirstAccessedTime(now);
                }
                sysArticle.setLastAccessedTime(now);
                sysArticleMapper.updateById(sysArticle);
            }

            ArticleDetailVo detailVo = sysArticleMapper.getArticleDetail(id);
            // 判断是否点赞和收藏，以及添加浏览记录
            Object userId = StpUtil.getLoginIdDefaultNull();
            if (userId != null) {
                detailVo.setIsLike(sysArticleMapper.getUserIsLike(id, Integer.parseInt(userId.toString())));
                Boolean isCollect = sysArticleMapper.getUserIsCollect(id, Integer.parseInt(userId.toString()));
                detailVo.setIsFavorite(isCollect);
                detailVo.setIsCollected(isCollect);

                // 添加/更新浏览记录
                ThreadUtil.execAsync(() -> {
                    try {
                        sysArticleMapper.saveOrUpdateHistory(id, Integer.parseInt(userId.toString()));
                    } catch (Exception e) {
                        log.error("添加浏览记录失败", e);
                    }
                });
            }

            //添加阅读量
            String ip = IpUtil.getIp();
            ThreadUtil.execAsync(() -> {
                Map<Object, Object> map = redisUtil.hGetAll(RedisConstants.ARTICLE_QUANTITY);
                List<String> ipList = (List<String>) map.get(id.toString());
                if (ipList != null) {
                    if (!ipList.contains(ip)) {
                        ipList.add(ip);
                    }
                } else {
                    ipList = new ArrayList<>();
                    ipList.add(ip);
                }
                map.put(id.toString(), ipList);
                redisUtil.hSetAll(RedisConstants.ARTICLE_QUANTITY, map);
            });
            return detailVo;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public List<ArchiveListVo> getArticleArchive() {

        List<ArchiveListVo> list = new ArrayList<>();

        List<Integer> years = sysArticleMapper.getArticleArchive();
        for (Integer year : years) {
            List<ArticleListVo> articleListVos = sysArticleMapper.getArticleByYear(year);
            list.add(new ArchiveListVo(year, articleListVos));
        }
        return list;
    }

    @Override
    public List<CategoryListVo> getArticleCategories() {
        return sysCategoryMapper.getArticleCategories();
    }

    @Override
    public List<ArticleListVo> getCarouselArticle() {
        // 固定从文章热榜获取（默认取周榜前5条，按热度）
        return getHotArticleList("week", 0, 5, "views");
    }

    @Override
    public List<ArticleListVo> getHotArticleList(String period, int offset, int limit, String orderBy) {
        String startTime = null;
        LocalDateTime now = LocalDateTime.now();
        if ("day".equals(period)) {
            startTime = now.minusDays(1).format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        } else if ("week".equals(period)) {
            startTime = now.minusWeeks(1).format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        } else if ("month".equals(period)) {
            startTime = now.minusMonths(1).format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
        List<ArticleListVo> hotList = sysArticleMapper.getHotArticleList(startTime, offset, limit, orderBy);
        
        // 随机抽样 5% 验证数据一致性
        if (hotList != null && !hotList.isEmpty()) {
            ThreadUtil.execAsync(() -> {
                try {
                    int sampleSize = Math.max(1, (int) Math.ceil(hotList.size() * 0.05));
                    List<ArticleListVo> samples = new ArrayList<>(hotList);
                    Collections.shuffle(samples);
                    for (int i = 0; i < sampleSize; i++) {
                        ArticleListVo hotItem = samples.get(i);
                        ArticleDetailVo dbItem = sysArticleMapper.getArticleDetail(hotItem.getId());
                        if (dbItem != null) {
                            double viewDiff = Math.abs((double) (hotItem.getQuantity() - dbItem.getQuantity()) / Math.max(1, dbItem.getQuantity()));
                            double likeDiff = Math.abs((double) (hotItem.getLikeNum() - dbItem.getLikeNum()) / Math.max(1, dbItem.getLikeNum()));
                            if (viewDiff > 0.01 || likeDiff > 0.01) {
                                log.warn("【数据一致性告警】热榜数据与数据库真实数据差异超过1%！文章ID：{}，热榜[阅读:{}, 点赞:{}]，数据库[阅读:{}, 点赞:{}]",
                                        hotItem.getId(), hotItem.getQuantity(), hotItem.getLikeNum(), dbItem.getQuantity(), dbItem.getLikeNum());
                                // 清除缓存强制同步
                                redisUtil.hDelete(RedisConstants.ARTICLE_QUANTITY, hotItem.getId().toString());
                            }
                        }
                    }
                } catch (Exception e) {
                    log.error("数据一致性检查失败", e);
                }
            });
        }
        return hotList;
    }

    @Override
    public List<ArticleListVo> getRecommendArticle() {
        return getArticlesByCondition(SysArticle::getIsRecommend);
    }

    @Override
    public Boolean like(Long articleId) {
        // 判断是否点赞
        int userId = StpUtil.getLoginIdAsInt();
        Boolean isLike = sysArticleMapper.getUserIsLike(articleId, userId);
        if (isLike) {
            // 点过则取消点赞
            sysArticleMapper.unLike(articleId, userId);
        } else {
            sysArticleMapper.like(articleId, userId);
            ThreadUtil.execAsync(() -> {
                //发送通知事件
                SysNotifications notifications = SysNotifications.builder()
                        .title("文章点赞通知")
                        .articleId(articleId)
                        .isRead(0)
                        .type("like")
                        .fromUserId(StpUtil.getLoginIdAsLong())
                        .build();
                notificationsUtil.publish(notifications);
            });
        }
        return true;
    }

    @Override
    public List<SysCategory> getCategoryAll() {
        return sysCategoryMapper.selectList(new LambdaQueryWrapper<SysCategory>()
                .orderByAsc(SysCategory::getSort));
    }

    private List<ArticleListVo> getArticlesByCondition(SFunction<SysArticle, Object> conditionField) {
        LambdaQueryWrapper<SysArticle> wrapper = new LambdaQueryWrapper<SysArticle>()
                .select(SysArticle::getId, SysArticle::getTitle, SysArticle::getCover, SysArticle::getCreateTime)
                .orderByDesc(SysArticle::getCreateTime)
                .eq(conditionField, 1);

        List<SysArticle> sysArticles = sysArticleMapper.selectList(wrapper);

        if (sysArticles == null || sysArticles.isEmpty()) {
            return Collections.emptyList();
        }

        return sysArticles.stream().map(item -> ArticleListVo.builder()
                .id(item.getId())
                .cover(item.getCover())
                .title(item.getTitle())
                .createTime(item.getCreateTime())
                .build()).collect(Collectors.toList());
    }
}
