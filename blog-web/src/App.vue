<template>
  <div id="app">
    <DynamicBackground :intensity="1.2" :density="80" themeColor="#6366f1" />
    <TheHeader />
    <MobileMenu />
    <SearchDialog />
    <router-view class="main-container" />
    <TheFooter />
    <FloatingButtons />
    <div class="cursor-container"></div>
  </div>
</template>

<script>
import TheHeader from '@/layout/Header/index.vue'
import TheFooter from '@/layout/Footer/index.vue'
import DynamicBackground from '@/components/DynamicBackground/index.vue'
import FloatingButtons from '@/components/common/FloatingButtons.vue'
import { getWebConfigApi, reportApi,getNoticeApi } from '@/api/site'
import { mapActions } from 'vuex'
import { initTheme } from '@/utils/theme'
import SearchDialog from '@/components/Search/index.vue'
import MobileMenu from '@/layout/MobileMenu/index.vue'
import { getCookie,removeCookie } from '@/utils/cookie'

export default {
  name: 'App',
  components: {
    TheHeader,
    TheFooter,
    DynamicBackground,
    FloatingButtons,
    SearchDialog,
    MobileMenu,
  },

  async created() {
    await reportApi()
    const res = await getWebConfigApi()
    this.setSiteInfo(res.data)
    this.$store.commit('setVisitorAccess', res.extra.visitorCount)
    this.$store.commit('setSiteAccess', res.extra.blogViewsCount)

    const noticeRes = await getNoticeApi()
    this.$store.commit('SET_NOTICE', noticeRes.data)
    initTheme()
    
    //这里等待第三方登录处理完成在获取用户信息
    await this.getUserInfo();

    //跳转到缓存地址
    let url = getCookie('redirectUrl')
    if (url) {
      removeCookie('redirectUrl')
      window.location.href = url
    }
  },
  methods: {
    ...mapActions(['setSiteInfo','getUserInfo']),

    /**
     * 初始化鼠标点击效果
     */
    initCursorEffect() {
      const container = document.querySelector('.cursor-container')
      
      document.addEventListener('click', (e) => {
        const cursor = document.createElement('div')
        cursor.className = 'cursor-fx'
        cursor.style.left = `${e.clientX}px`
        cursor.style.top = `${e.clientY}px`
        container.appendChild(cursor)
        
        cursor.addEventListener('animationend', () => {
          cursor.remove()
        })
      })
    }
  },
  mounted() {
    this.initCursorEffect()
  }
}
</script>

<style lang="scss">

@import 'animate.css';
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');
* {
  margin: 0;
  padding: 0;
  font-family: "LXGW WenKai", "Source Han Serif CN", Georgia, sans-serif;
  box-sizing: border-box;
}

.cursor-fx {
    position: fixed;
    width: 20px;
    height: 20px;
    border: 2px solid var(--primary);
    border-radius: 50%;
    transform: translate(-50%, -50%);
    pointer-events: none;
    animation: cursor-ripple 0.6s ease-out;
    z-index: 9999;
    opacity: 0;
}

@keyframes cursor-ripple {
    0% {
        width: 10px;
        height: 10px;
        opacity: 0.8;
    }
    100% {
        width: 60px;
        height: 60px;
        opacity: 0;
    }
}
</style> 
