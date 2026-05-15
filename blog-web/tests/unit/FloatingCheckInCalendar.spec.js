import { mount, createLocalVue } from '@vue/test-utils'
import ElementUI from 'element-ui'
import FloatingCheckInCalendar from '@/components/FloatingCheckInCalendar/index.vue'

const localVue = createLocalVue()
localVue.use(ElementUI)

describe('FloatingCheckInCalendar', () => {
  beforeEach(() => {
    document.body.innerHTML = '<button class="calendar-toggle-btn" style="position:fixed;top:12px;right:12px;width:16px;height:16px;"></button>'
    HTMLElement.prototype.animate = jest.fn(() => {
      const animation = {}
      setTimeout(() => {
        if (typeof animation.onfinish === 'function') {
          animation.onfinish()
        }
      }, 0)
      return animation
    })
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  it('emits collapse lifecycle callback after animation finish', async () => {
    const onCollapse = jest.fn()
    const wrapper = mount(FloatingCheckInCalendar, {
      localVue,
      propsData: {
        visible: true,
        onCollapse
      },
      attachTo: document.body
    })

    await wrapper.find('.collapse-btn').trigger('click')
    await new Promise(resolve => setTimeout(resolve, 20))

    expect(wrapper.emitted('collapse-finish')).toBeTruthy()
    expect(onCollapse).toHaveBeenCalled()
  })
})
