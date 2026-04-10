import { mount, createLocalVue } from '@vue/test-utils';
import ArticleList from '@/components/ArticleList/index.vue';
import ElementUI from 'element-ui';

const localVue = createLocalVue();
localVue.use(ElementUI);
localVue.directive('lazy', {});

describe('ArticleList.vue', () => {
  const article = {
    id: 1,
    title: 'Test Article',
    quantity: 1234,
    likeNum: 500,
    favoriteNum: 100,
    commentNum: 15,
    createTime: '2023-10-01',
    contentMd: 'This is a test article content.'
  };

  it('renders tooltips for icons with correct delay', () => {
    const wrapper = mount(ArticleList, { 
      localVue, 
      propsData: { articles: [article] },
      stubs: ['router-link']
    });

    const tooltips = wrapper.findAllComponents({ name: 'ElTooltip' });
    // Expect 6 tooltips per article: date, read-time, views, likes, favorites, comments
    expect(tooltips.length).toBeGreaterThanOrEqual(6);
    
    // Check if open-delay is 300 and hide-after is 150
    const firstTooltip = tooltips.at(0);
    expect(firstTooltip.props('openDelay')).toBe(300);
    expect(firstTooltip.props('hideAfter')).toBe(150);
  });

  it('renders stats correctly', () => {
    const wrapper = mount(ArticleList, { 
      localVue, 
      propsData: { articles: [article] },
      stubs: ['router-link']
    });

    const text = wrapper.text();
    expect(text).toContain('1234'); // Views
    expect(text).toContain('500');  // Likes
    expect(text).toContain('100');  // Favorites
    expect(text).toContain('15');   // Comments
  });
});
