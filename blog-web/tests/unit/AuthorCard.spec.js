import { shallowMount, createLocalVue } from '@vue/test-utils'
import AuthorCard from '@/views/home/components/AuthorCard.vue'
import ElementUI from 'element-ui'

const localVue = createLocalVue()
localVue.use(ElementUI)

describe('AuthorCard.vue', () => {
  let wrapper
  let storeMock

  beforeEach(() => {
    storeMock = {
      state: {
        webSiteInfo: {
          author: 'Test Author',
          authorInfo: 'Test Bio',
          authorAvatar: 'avatar.jpg',
          wechat: 'test_wechat',
          qqNumber: '123456789',
          github: 'https://github.com/test',
          weibo: 'https://weibo.com/test',
          weixinImage: 'wx_code.jpg',
          githubUser: 'testuser'
        }
      }
    }

    wrapper = shallowMount(AuthorCard, {
      localVue,
      mocks: {
        $store: storeMock,
        $message: {
          success: jest.fn(),
          error: jest.fn(),
          warning: jest.fn()
        }
      },
      stubs: {
        'el-card': true,
        'el-avatar': true,
        'el-tooltip': true,
        'el-dialog': true,
        'el-button': true
      }
    })
  })

  it('renders author info correctly', () => {
    expect(wrapper.find('.author-info h3').text()).toBe('Test Author')
    expect(wrapper.find('.author-info .bio').text()).toBe('Test Bio')
  })

  it('renders social buttons', () => {
    const buttons = wrapper.findAll('.social-btn')
    expect(buttons.length).toBe(4)
  })

  it('opens dialog when social button is clicked', async () => {
    const wechatBtn = wrapper.find('.social-btn.wechat')
    await wechatBtn.trigger('click')
    
    expect(wrapper.vm.dialogVisible).toBe(true)
    expect(wrapper.vm.currentSocial.type).toBe('wechat')
  })

  it('displays correct content for WeChat', async () => {
    await wrapper.setData({ 
      dialogVisible: true,
      currentSocial: { type: 'wechat', title: 'WeChat' }
    })
    
    const wechatContent = wrapper.find('.wechat-content')
    expect(wechatContent.exists()).toBe(true)
    expect(wechatContent.find('.wechat-id span').text()).toBe('test_wechat')
  })

  it('displays correct content for GitHub', async () => {
    await wrapper.setData({ 
      dialogVisible: true,
      currentSocial: { type: 'github', title: 'GitHub' }
    })
    
    const githubContent = wrapper.find('.github-content')
    expect(githubContent.exists()).toBe(true)
    expect(githubContent.find('h3').text()).toBe('testuser')
  })

  it('copies text to clipboard', async () => {
    // Mock navigator.clipboard
    const writeTextMock = jest.fn().mockResolvedValue()
    Object.assign(navigator, {
      clipboard: {
        writeText: writeTextMock
      }
    })

    await wrapper.vm.copyText('test text')
    expect(writeTextMock).toHaveBeenCalledWith('test text')
    expect(wrapper.vm.$message.success).toHaveBeenCalled()
  })

  it('opens link in new tab', () => {
    const openMock = jest.fn()
    window.open = openMock

    wrapper.vm.openLink('https://example.com')
    expect(openMock).toHaveBeenCalledWith('https://example.com', '_blank')
  })
})
