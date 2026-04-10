import ArticleService from '../../src/services/articleService';
import request from '@/utils/request';

describe('ArticleService', () => {
  beforeEach(async () => {
    // 强制清除可能存在的缓存，不计入当前测试的 mock 调用次数
    await ArticleService.getHotArticles('day', true).catch(() => {});
    await ArticleService.getArticleLikes(3, true).catch(() => {});
    await ArticleService.getArticleFavorites(1, true).catch(() => {});
    jest.clearAllMocks();
  });

  describe('getArticleLikes', () => {
    it('正常返回点赞数据', async () => {
      request.mockResolvedValueOnce({ code: 200, data: { likeNum: 100, isLike: true }, message: 'success' });
      const res = await ArticleService.getArticleLikes(1);
      expect(res.code).toBe(200);
      expect(res.data.likeCount).toBe(100);
      expect(res.data.isLike).toBe(true);
    });

    it('异常返回兜底数据 (网络异常)', async () => {
      request.mockRejectedValueOnce(new Error('Network Error'));
      const res = await ArticleService.getArticleLikes(2);
      expect(res.code).toBe(500);
      expect(res.data.likeCount).toBe(0);
      expect(res.data.isLike).toBe(false);
    });

    it('异常返回兜底数据 (404/403)', async () => {
      request.mockResolvedValueOnce({ code: 404, message: 'Not Found' });
      const res = await ArticleService.getArticleLikes(2);
      expect(res.code).toBe(404);
      expect(res.data.likeCount).toBe(0);
      expect(res.data.isLike).toBe(false);
    });

    it('返回格式异常兜底', async () => {
      request.mockResolvedValueOnce({ code: 200, data: null });
      const res = await ArticleService.getArticleLikes(2);
      expect(res.code).toBe(200);
      expect(res.data.likeCount).toBe(0);
      expect(res.data.isLike).toBe(false);
    });

    it('缓存命中逻辑', async () => {
      request.mockResolvedValue({ code: 200, data: { likeNum: 50, isLike: false }, message: 'success' });
      const r1 = await ArticleService.getArticleLikes(3); // 第一次请求
      const r2 = await ArticleService.getArticleLikes(3); // 第二次命中缓存
      expect(request).toHaveBeenCalledTimes(1);

      await ArticleService.getArticleLikes(3, true); // 强制刷新
      expect(request).toHaveBeenCalledTimes(2);
    });
  });

  describe('getArticleComments', () => {
    it('正常返回分页数据', async () => {
      request.mockResolvedValueOnce({ code: 200, data: { records: [{ id: 1 }], total: 1 }, message: 'success' });
      const res = await ArticleService.getArticleComments(1, { pageNum: 1, pageSize: 10 });
      expect(res.code).toBe(200);
      expect(res.data.total).toBe(1);
      expect(res.data.records.length).toBe(1);
    });

    it('网络异常兜底', async () => {
      request.mockRejectedValueOnce(new Error('timeout'));
      const res = await ArticleService.getArticleComments(1);
      expect(res.code).toBe(500);
      expect(res.data.total).toBe(0);
      expect(res.data.records.length).toBe(0);
    });
  });

  describe('getArticleFavorites', () => {
    it('正常返回收藏数据', async () => {
      request.mockResolvedValueOnce({ code: 200, data: { favoriteNum: 200, isFavorite: false }, message: 'success' });
      const res = await ArticleService.getArticleFavorites(1);
      expect(res.code).toBe(200);
      expect(res.data.favoriteCount).toBe(200);
      expect(res.data.isFavorite).toBe(false);
    });

    it('异常返回兜底数据', async () => {
      request.mockRejectedValueOnce(new Error('timeout'));
      const res = await ArticleService.getArticleFavorites(1);
      expect(res.code).toBe(500);
      expect(res.data.favoriteCount).toBe(0);
    });
  });

  describe('getArticleImages', () => {
    it('正常解析图片URL和封面', async () => {
      request.mockResolvedValueOnce({
        code: 200,
        data: {
          cover: 'http://example.com/cover.jpg',
          content: '<p>test</p><img src="http://example.com/img1.png" /><img src="http://example.com/img2.png" />'
        },
        message: 'success'
      });
      const res = await ArticleService.getArticleImages(1);
      expect(res.code).toBe(200);
      expect(res.data.cover).toBe('http://example.com/cover.jpg');
      expect(res.data.images.length).toBe(2);
      expect(res.data.images[0]).toBe('http://example.com/img1.png');
    });

    it('无图片返回空数组', async () => {
      request.mockResolvedValueOnce({
        code: 200,
        data: { cover: '', content: '<p>no image</p>' },
        message: 'success'
      });
      const res = await ArticleService.getArticleImages(2);
      expect(res.data.images.length).toBe(0);
    });

    it('网络异常兜底', async () => {
      request.mockRejectedValueOnce(new Error('timeout'));
      const res = await ArticleService.getArticleImages(1);
      expect(res.code).toBe(500);
      expect(res.data.images.length).toBe(0);
    });

    it('非200状态码', async () => {
      request.mockResolvedValueOnce({ code: 403, message: 'Forbidden' });
      const res = await ArticleService.getArticleImages(1);
      expect(res.code).toBe(403);
      expect(res.data.images.length).toBe(0);
    });
  });

  describe('getArticleHeat', () => {
    it('正确聚合计算热度值', async () => {
      // 热度公式: 阅读(1) + 点赞(5) + 收藏(10) + 评论(10)
      request.mockResolvedValueOnce({
        code: 200,
        data: { quantity: 100, likeNum: 10, favoriteNum: 5, commentNum: 2 },
        message: 'success'
      });
      const res = await ArticleService.getArticleHeat(1);
      expect(res.code).toBe(200);
      // 100*1 + 10*5 + 5*10 + 2*10 = 100 + 50 + 50 + 20 = 220
      expect(res.data.heatScore).toBe(220);
    });

    it('部分字段缺失正常兜底计算', async () => {
      request.mockResolvedValueOnce({
        code: 200,
        data: { quantity: 100 }, // 缺少其他字段
        message: 'success'
      });
      const res = await ArticleService.getArticleHeat(2);
      expect(res.data.heatScore).toBe(100);
    });

    it('网络异常兜底', async () => {
      request.mockRejectedValueOnce(new Error('timeout'));
      const res = await ArticleService.getArticleHeat(1);
      expect(res.code).toBe(500);
      expect(res.data.heatScore).toBe(0);
    });

    it('非200状态码', async () => {
      request.mockResolvedValueOnce({ code: 403, message: 'Forbidden' });
      const res = await ArticleService.getArticleHeat(1);
      expect(res.code).toBe(403);
      expect(res.data.heatScore).toBe(0);
    });
  });

  describe('getHotArticles', () => {
    it('返回热榜列表并缓存', async () => {
      request.mockResolvedValueOnce({ code: 200, data: [{ id: 1 }, { id: 2 }], message: 'success' });
      const res = await ArticleService.getHotArticles('day');
      expect(res.code).toBe(200);
      expect(res.data.length).toBe(2);
    });

    it('网络异常兜底', async () => {
      request.mockRejectedValueOnce(new Error('timeout'));
      const res = await ArticleService.getHotArticles('day');
      expect(res.code).toBe(500);
      expect(res.data.length).toBe(0);
    });
  });
});