<template>
  <div class="floating-buttons" :class="{ 'show-top': showBackToTop }">

    <!-- Removed Chat Button -->
    <el-tooltip v-if="currentArticleId" :content="isCollected ? '取消收藏' : '收藏文章'" placement="left">
      <button
        class="float-btn collect-btn"
        :class="{ active: isCollected }"
        :disabled="collectLoading"
        @click="toggleCollect"
        title="收藏文章"
      >
        <i class="fas fa-star"></i>
      </button>
    </el-tooltip>
 
    <el-tooltip content="切换主题" placement="left">
      <button class="float-btn theme-btn" @click="toggleTheme" title="切换主题">
        <i :class="['fas', isDarkMode ? 'fa-sun' : 'fa-moon']"></i>
      </button>
    </el-tooltip>

    <el-tooltip content="回到顶部" placement="left">
      <button 
        v-show="showBackToTop"
        class="float-btn top-btn" 
        @click="scrollToTop"
        title="回到顶部"
      >
        <i class="fas fa-arrow-up"></i>
      </button>
    </el-tooltip>
  </div>
</template>

<script>
import { setThemeMode, initTheme, themeBus } from '@/utils/theme'
import { collectArticleApi, getArticleDetailApi } from '@/api/article'

export default {
  name: 'FloatingButtons',
  data() {
    return {
      isDarkMode: false,
      showBackToTop: false,
      isCollected: false,
      collectLoading: false,
      currentArticleId: ''
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler() {
        this.syncCollectState()
      }
    }
  },
  methods: {
    getCollectStorageKey() {
      return 'article-collect-state-map'
    },
    getCollectStateMap() {
      try {
        return JSON.parse(localStorage.getItem(this.getCollectStorageKey()) || '{}')
      } catch (e) {
        return {}
      }
    },
    persistCollectState(articleId, status) {
      const key = String(articleId)
      const stateMap = this.getCollectStateMap()
      stateMap[key] = Boolean(status)
      localStorage.setItem(this.getCollectStorageKey(), JSON.stringify(stateMap))
    },
    getCurrentArticleId(route = this.$route) {
      if (route.path && /^\/post\/\d+/.test(route.path)) {
        return String(route.params?.id || '')
      }
      return ''
    },
    async syncCollectState() {
      const articleId = this.getCurrentArticleId()
      this.currentArticleId = articleId
      if (!articleId) {
        this.isCollected = false
        return
      }
      const stateMap = this.getCollectStateMap()
      if (Object.prototype.hasOwnProperty.call(stateMap, articleId)) {
        this.isCollected = Boolean(stateMap[articleId])
      }
      try {
        const res = await getArticleDetailApi(articleId)
        const serverStatus = Boolean(res?.data?.isFavorite || res?.data?.isCollected)
        this.isCollected = serverStatus
        this.persistCollectState(articleId, serverStatus)
      } catch (error) {
        // 使用本地缓存兜底，不中断用户交互
      }
    },
    async toggleCollect() {
      if (!this.currentArticleId || this.collectLoading) return
      if (!this.$store.state.userInfo) {
        this.$message.warning('请先登录')
        return
      }
      this.collectLoading = true
      try {
        await collectArticleApi(this.currentArticleId)
        this.isCollected = !this.isCollected
        this.persistCollectState(this.currentArticleId, this.isCollected)
        window.dispatchEvent(new CustomEvent('article-collect-updated', {
          detail: {
            articleId: this.currentArticleId,
            isFavorite: this.isCollected
          }
        }))
        this.$message.success(this.isCollected ? '收藏成功' : '已取消收藏')
      } catch (error) {
        this.$message.error(error.message || '收藏操作失败')
      } finally {
        this.collectLoading = false
      }
    },
    handleExternalCollectUpdate(event) {
      const { articleId, isFavorite } = event?.detail || {}
      if (!articleId || String(articleId) !== String(this.currentArticleId)) return
      this.isCollected = Boolean(isFavorite)
      this.persistCollectState(this.currentArticleId, this.isCollected)
    },
    toggleTheme() {
      this.isDarkMode = !this.isDarkMode
      const mode = this.isDarkMode ? 'dark' : 'light'
      setThemeMode(mode)
    },
    scrollToTop() {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      })
    },
    handleScroll() {
      this.showBackToTop = window.pageYOffset > 300
    }
  },
  mounted() {
    this.isDarkMode = initTheme()
    // 监听主题变化
    themeBus.$on('theme-change', (mode) => {
      this.isDarkMode = mode === 'dark'
    })
    
    window.addEventListener('scroll', this.handleScroll)
    window.addEventListener('article-collect-updated', this.handleExternalCollectUpdate)
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.handleScroll)
    window.removeEventListener('article-collect-updated', this.handleExternalCollectUpdate)
    themeBus.$off('theme-change')
  }
}
</script>

<style lang="scss" scoped>
.floating-buttons {
  position: fixed;
  right: 30px;
  bottom: 50px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  z-index: 999;
}

.float-btn {
  width: 45px;
  height: 45px;
  border: none;
  border-radius: 50%;
  background: var(--card-bg);
  color: var(--text-primary);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(0,0,0,0.05);

  &:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
    color: var(--primary);
  }

  &:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }

  &.collect-btn.active {
    color: #f7ba2a;
    background: rgba(247, 186, 42, 0.12);
    border-color: rgba(247, 186, 42, 0.35);
    box-shadow: 0 8px 20px rgba(247, 186, 42, 0.25);
  }

  &.theme-btn {
    // simplified
  }
  
  &.top-btn {
    opacity: 0;
    visibility: hidden;
    transform: translateY(20px);

    .show-top & {
      opacity: 1;
      visibility: visible;
      transform: translateY(0);
    }
  }

  i {
    font-size: 1.1rem;
  }
}

@media (max-width: 768px) {
  .floating-buttons {
    right: 20px;
    bottom: 40px;
  }

  .float-btn {
    width: 40px;
    height: 40px;
  }
}
</style>
