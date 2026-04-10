import request from '@/utils/request';
import store from '@/store';

// 用于缓存文章相关数据的简单内存缓存
const cache = {
  data: {},
  set(key, value, ttl = 300000) { // 默认5分钟缓存
    this.data[key] = {
      value,
      expire: Date.now() + ttl
    };
  },
  get(key) {
    const item = this.data[key];
    if (item && item.expire > Date.now()) {
      return item.value;
    }
    delete this.data[key];
    return null;
  },
  remove(key) {
    delete this.data[key];
  }
};

/**
 * 格式化返回值
 */
const formatResponse = (res, fallbackData = null) => {
  if (res && res.code === 200) {
    return { code: 200, data: res.data || fallbackData, msg: res.message || 'success' };
  }
  return { code: res?.code || 500, data: fallbackData, msg: res?.message || 'error' };
};

/**
 * ArticleService 类，封装文章相关原子方法
 */
class ArticleService {
  /**
   * 获取文章点赞数与当前用户是否点赞
   * @param {Number|String} articleId 
   * @param {Boolean} forceRefresh 是否强制刷新，忽略缓存
   */
  static async getArticleLikes(articleId, forceRefresh = false) {
    const cacheKey = `likes_${articleId}`;
    if (!forceRefresh) {
      const cached = cache.get(cacheKey);
      if (cached) return cached;
    }

    try {
      const res = await request({
        url: `/api/article/detail/${articleId}`,
        method: 'get'
      });
      const data = formatResponse(res, { likeNum: 0, isLike: false });
      const result = {
        code: data.code,
        data: {
          likeCount: data.data?.likeNum || 0,
          isLike: !!data.data?.isLike
        },
        msg: data.msg
      };
      if (data.code === 200) {
        cache.set(cacheKey, result);
      }
      return result;
    } catch (error) {
      return { code: 500, data: { likeCount: 0, isLike: false }, msg: error.message };
    }
  }

  /**
   * 获取文章分页评论
   * @param {Number|String} articleId 
   * @param {Object} params { pageNum, pageSize }
   */
  static async getArticleComments(articleId, { pageNum = 1, pageSize = 10 } = {}) {
    try {
      const res = await request({
        url: `/api/comment/list`,
        method: 'get',
        params: { articleId, pageNum, pageSize }
      });
      return formatResponse(res, { records: [], total: 0 });
    } catch (error) {
      return { code: 500, data: { records: [], total: 0 }, msg: error.message };
    }
  }

  /**
   * 获取文章收藏总数与用户是否收藏
   * @param {Number|String} articleId 
   * @param {Boolean} forceRefresh 
   */
  static async getArticleFavorites(articleId, forceRefresh = false) {
    const cacheKey = `favorites_${articleId}`;
    if (!forceRefresh) {
      const cached = cache.get(cacheKey);
      if (cached) return cached;
    }

    try {
      const res = await request({
        url: `/api/article/detail/${articleId}`,
        method: 'get'
      });
      const data = formatResponse(res, { favoriteNum: 0, isFavorite: false });
      const result = {
        code: data.code,
        data: {
          favoriteCount: data.data?.favoriteNum || 0,
          isFavorite: !!data.data?.isFavorite
        },
        msg: data.msg
      };
      if (data.code === 200) {
        cache.set(cacheKey, result);
      }
      return result;
    } catch (error) {
      return { code: 500, data: { favoriteCount: 0, isFavorite: false }, msg: error.message };
    }
  }

  /**
   * 获取文章内的所有图片URL数组及封面
   * @param {Number|String} articleId 
   */
  static async getArticleImages(articleId) {
    try {
      const res = await request({
        url: `/api/article/detail/${articleId}`,
        method: 'get'
      });
      const data = formatResponse(res);
      if (data.code === 200) {
        const content = data.data.content || '';
        const imgReg = /<img[^>]+src="([^">]+)"/g;
        const images = [];
        let match;
        while ((match = imgReg.exec(content))) {
          images.push(match[1]);
        }
        return {
          code: 200,
          data: {
            cover: data.data.cover || '',
            images
          },
          msg: 'success'
        };
      }
      return { code: data.code, data: { cover: '', images: [] }, msg: data.msg };
    } catch (error) {
      return { code: 500, data: { cover: '', images: [] }, msg: error.message };
    }
  }

  /**
   * 聚合获取文章热度值
   * @param {Number|String} articleId 
   */
  static async getArticleHeat(articleId) {
    try {
      const res = await request({
        url: `/api/article/detail/${articleId}`,
        method: 'get'
      });
      const data = formatResponse(res);
      if (data.code === 200) {
        const article = data.data;
        // 简单聚合逻辑：阅读(1) + 点赞(5) + 收藏(10) + 评论(10)
        const heat = (article.quantity || 0) * 1 + 
                     (article.likeNum || 0) * 5 + 
                     (article.favoriteNum || 0) * 10 + 
                     (article.commentNum || 0) * 10;
        return {
          code: 200,
          data: {
            heatScore: heat,
            quantity: article.quantity || 0,
            likeNum: article.likeNum || 0,
            favoriteNum: article.favoriteNum || 0,
            commentNum: article.commentNum || 0
          },
          msg: 'success'
        };
      }
      return { code: data.code, data: { heatScore: 0 }, msg: data.msg };
    } catch (error) {
      return { code: 500, data: { heatScore: 0 }, msg: error.message };
    }
  }

  /**
   * 获取热门文章列表（带缓存和强制刷新）
   */
  static async getHotArticles(period = 'day', forceRefresh = false, offset = 0, limit = 10, orderBy = 'likes') {
    const cacheKey = `hot_articles_${period}_${orderBy}_${offset}_${limit}`;
    if (!forceRefresh) {
      const cached = cache.get(cacheKey);
      if (cached) return cached;
    }

    try {
      const res = await request({
        url: '/api/article/hot-list',
        method: 'get',
        params: { period, offset, limit, orderBy }
      });
      const data = formatResponse(res, []);
      if (data.code === 200) {
        cache.set(cacheKey, data, 300000); // 5分钟缓存
      }
      return data;
    } catch (error) {
      return { code: 500, data: [], msg: error.message };
    }
  }
}

export default ArticleService;