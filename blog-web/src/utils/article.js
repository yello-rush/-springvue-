/**
 * @description 文章相关通用方法封装
 * @module utils/article
 */

/**
 * 格式化大数字
 * @param {Number|String} num 原始数字
 * @returns {Number|String} 格式化后的数字
 */
const formatNumber = (num) => {
  const n = Number(num);
  if (isNaN(n)) return 0;
  // 此处简单兜底，不进行类似1k的复杂转换，保持与原项目风格一致，或按需扩展
  return n;
};

/**
 * 获取文章点赞数
 * @param {Object} article 文章对象
 * @returns {Number} 点赞数
 */
export const getLikeCount = (article) => {
  if (!article) return 0;
  return formatNumber(article.likeCount || article.likeNum || 0);
};

/**
 * 获取文章阅读数
 * @param {Object} article 文章对象
 * @returns {Number} 阅读数
 */
export const getViewCount = (article) => {
  if (!article) return 0;
  return formatNumber(article.quantity || article.viewCount || article.views || 0);
};

/**
 * 获取文章收藏数
 * @param {Object} article 文章对象
 * @returns {Number} 收藏数
 */
export const getFavoriteCount = (article) => {
  if (!article) return 0;
  return formatNumber(article.favoriteCount || article.collectCount || 0);
};

/**
 * 获取文章预计阅读时间（分钟）
 * 假设中文阅读速度为 300字/分钟
 * @param {Object} article 文章对象
 * @returns {Number} 预计阅读时间（分钟）
 */
export const getEstimatedReadTime = (article) => {
  if (!article) return 0;
  // 优先使用后端返回的预计阅读时间字段（如果有）
  if (article.readTime) return formatNumber(article.readTime);
  
  // 兜底计算逻辑：基于文章内容长度计算
  const content = article.content || article.contentMd || '';
  if (!content) return 1; // 默认最少1分钟
  
  // 移除HTML标签和Markdown特殊字符，粗略计算纯文本长度
  const textContent = content.replace(/<[^>]+>/g, '').replace(/[#*`~>-]/g, '');
  const length = textContent.length;
  
  const readTime = Math.ceil(length / 300);
  return readTime > 0 ? readTime : 1;
};

/**
 * 获取文章发布时间
 * @param {Object} article 文章对象
 * @returns {String} 发布时间
 */
export const getPublishTime = (article) => {
  if (!article) return '';
  return article.createTime || article.createTimeStr || article.publishTime || '';
};

// 异步封装示例（假设需要从接口重新获取最新数据时使用）
import { getArticleDetailApi } from '@/api/article';

/**
 * 异步获取文章最新指标数据
 * @param {Number|String} articleId 文章ID
 * @returns {Promise<Object>} 包含各项指标的对象
 */
export const fetchArticleMetricsAsync = async (articleId) => {
  if (!articleId) {
    return Promise.reject(new Error('Article ID is required'));
  }
  
  try {
    const res = await getArticleDetailApi(articleId);
    if (res.code === 200 && res.data) {
      const article = res.data;
      return {
        likeCount: getLikeCount(article),
        viewCount: getViewCount(article),
        favoriteCount: getFavoriteCount(article),
        readTime: getEstimatedReadTime(article),
        publishTime: getPublishTime(article)
      };
    }
    return Promise.reject(new Error(res.message || 'Fetch article metrics failed'));
  } catch (error) {
    console.error('Error fetching article metrics:', error);
    // 兜底返回0值
    return {
      likeCount: 0,
      viewCount: 0,
      favoriteCount: 0,
      readTime: 0,
      publishTime: ''
    };
  }
};
