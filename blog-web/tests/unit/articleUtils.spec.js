import { getLikeCount, getViewCount, getFavoriteCount, getEstimatedReadTime, getPublishTime } from '../../src/utils/article';

describe('Article Utils Formatting', () => {
  describe('数值格式化 (0, 1, 边界场景)', () => {
    it('点赞数格式化', () => {
      expect(getLikeCount(null)).toBe(0);
      expect(getLikeCount({})).toBe(0);
      expect(getLikeCount({ likeCount: 0 })).toBe(0);
      expect(getLikeCount({ likeNum: 1 })).toBe(1);
      expect(getLikeCount({ likeCount: 10000 })).toBe(10000); // utils 里只做了简单返回，大数字格式化在组件内
    });

    it('阅读量格式化', () => {
      expect(getViewCount(null)).toBe(0);
      expect(getViewCount({ quantity: 0 })).toBe(0);
      expect(getViewCount({ viewCount: 1 })).toBe(1);
      expect(getViewCount({ views: 10000 })).toBe(10000);
      expect(getViewCount({ quantity: 'invalid' })).toBe(0); // NaN 回退
    });

    it('预计阅读时间', () => {
      expect(getEstimatedReadTime(null)).toBe(0);
      expect(getEstimatedReadTime({ readTime: 5 })).toBe(5);
      // 中文长度兜底计算 (300字/分钟)
      const longText = '字'.repeat(900);
      expect(getEstimatedReadTime({ content: longText })).toBe(3);
      const shortText = '字'.repeat(10);
      expect(getEstimatedReadTime({ contentMd: shortText })).toBe(1); // 至少1分钟
    });

    it('发布时间', () => {
      expect(getPublishTime(null)).toBe('');
      expect(getPublishTime({ createTime: '2026-03-26' })).toBe('2026-03-26');
      expect(getPublishTime({ publishTime: '2026-03-26' })).toBe('2026-03-26');
    });
  });
});