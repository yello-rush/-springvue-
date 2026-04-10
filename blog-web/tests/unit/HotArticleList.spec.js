import { shallowMount } from '@vue/test-utils';
import HotArticleList from '@/views/home/components/HotArticleList.vue';

// Mock Vuex or Router if needed, and element-ui components
import Vue from 'vue';
import ElementUI from 'element-ui';
Vue.use(ElementUI);

describe('HotArticleList.vue', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(HotArticleList, {
      stubs: ['el-card', 'el-radio-group', 'el-radio-button', 'el-button', 'el-empty']
    });
  });

  describe('数值格式化 formatNumber', () => {
    it('0 返回 0', () => {
      expect(wrapper.vm.formatNumber(0)).toBe(0);
    });

    it('1 返回 1', () => {
      expect(wrapper.vm.formatNumber(1)).toBe(1);
    });

    it('大于 1 万格式化为 w', () => {
      expect(wrapper.vm.formatNumber(10000)).toBe('1.0w');
      expect(wrapper.vm.formatNumber(15600)).toBe('1.6w');
    });

    it('大于 1 亿格式化为 亿', () => {
      expect(wrapper.vm.formatNumber(100000000)).toBe('1.0亿');
      expect(wrapper.vm.formatNumber(150000000)).toBe('1.5亿');
    });

    it('非法输入回退为 0', () => {
      expect(wrapper.vm.formatNumber('invalid')).toBe(0);
      expect(wrapper.vm.formatNumber(null)).toBe(0);
      expect(wrapper.vm.formatNumber(undefined)).toBe(0);
    });
  });
});