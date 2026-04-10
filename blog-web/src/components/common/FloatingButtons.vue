<template>
  <div class="floating-buttons" :class="{ 'show-top': showBackToTop }">

    <!-- Removed Chat Button -->
 
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

export default {
  name: 'FloatingButtons',
  data() {
    return {
      isDarkMode: false,
      showBackToTop: false
    }
  },
  methods: {
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
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.handleScroll)
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
  gap: 15px;
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
