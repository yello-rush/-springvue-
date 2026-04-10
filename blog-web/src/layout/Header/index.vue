<template>
  <header class="site-header" :class="{ 'is-scrolled': isScrolled }">
    <nav class="navbar">
      <!-- 移动端菜单按钮 -->
      <button class="menu-btn" @click="handleOpenMobileMenu">
        <i class="fas fa-bars"></i>
      </button>

      <div class="nav-left">
        <router-link to="/" class="logo">
          <img v-if="$store.state.webSiteInfo.logo" :src="$store.state.webSiteInfo.logo" :alt="$store.state.webSiteInfo.name">
          <span class="logo-text">{{$store.state.webSiteInfo.name}}</span>
        </router-link>
      </div>

      <div class="nav-center">
        <router-link to="/" class="nav-link" exact-active-class="router-link-active" exact>
          <i class="fas fa-home"></i> 首页
        </router-link>
        <router-link to="/categories" class="nav-link">
          <i class="fas fa-th-large"></i> 分类
        </router-link>
        <router-link to="/archives" class="nav-link">
          <i class="fas fa-archive"></i> 归档
        </router-link>
        <router-link to="/moments" class="nav-link">
          <i class="fas fa-comment-dots"></i> 说说
        </router-link>
        
        <router-link to="/messages" class="nav-link">
          <i class="fas fa-comments"></i> 留言板
        </router-link>

        <a :href="adminUrl" target="_blank" class="nav-link">
          <i class="fas fa-cogs"></i> 后台管理
        </a>

      </div>

      <div class="nav-right">
        <!-- 桌面端搜索框 -->
        <div class="desktop-search">
          <input type="text" v-model="searchQuery" placeholder="搜索文章..." @focus="handleDesktopSearch">
          <i class="fas fa-search" @click="handleDesktopSearch"></i>
        </div>

        <!-- 主题切换按钮 -->
        <a href="javascript:void(0)" class="theme-btn" @click="toggleTheme">
          <i class="fas" :class="theme === 'dark' ? 'fa-sun' : 'fa-moon'"></i>
        </a>

        <!-- 修改消息按钮的跳转路径 -->
        <div class="message-btn-wrapper" @mouseenter="showMessageDropdown = true" @mouseleave="showMessageDropdown = false">
          <div class="message-btn">
            <i class="far fa-bell"></i>
            <span class="message-count" v-if="hasUnread" />
          </div>
          
          <div class="message-dropdown" v-show="showMessageDropdown">
            <div class="dropdown-header">
              <span>消息通知</span>
            </div>
            <div class="dropdown-content">
              <template v-if="isLoggedIn">
                <router-link to="/notifications" class="message-item" @click.native="handleReadMessage">
                  <i class="fas fa-comment-dots text-primary"></i>
                  <div class="message-info">
                    <span class="title">回复与评论</span>
                    <span class="desc">查看文章评论与回复</span>
                  </div>
                </router-link>
                <router-link to="/notifications" class="message-item" @click.native="handleReadMessage">
                  <i class="fas fa-thumbs-up text-danger"></i>
                  <div class="message-info">
                    <span class="title">点赞与收藏</span>
                    <span class="desc">有人点赞或收藏了您的文章</span>
                  </div>
                </router-link>
                <div class="dropdown-divider"></div>
                <div class="join-time-wrapper">
                  <i class="fas fa-calendar-alt"></i>
                  <span class="join-time-text">您已加入博客 {{ joinDays }} 天</span>
                </div>
              </template>
              <template v-else>
                <div class="message-item" @click="handleReadMessage">
                  <i class="fas fa-info-circle" style="color: #e6a23c;"></i>
                  <div class="message-info">
                    <span class="title">系统提示</span>
                    <span class="desc">登录后即可发表评论、点赞文章，享受更多专属功能！</span>
                  </div>
                </div>
              </template>
            </div>
          </div>
        </div>
        
        <div class="user-info">
          <div class="welcome-text">
             <span v-if="$store.state.userInfo">欢迎您 {{ $store.state.userInfo.nickname }}</span>
             <span v-else>欢迎您 游客</span>
          </div>
          <div v-if="$store.state.userInfo" class="user-section" @mouseleave="showDropdown = false">
            <div class="avatar" @mouseenter="showDropdown = true">
              <el-avatar :src="$store.state.userInfo.avatar"  />
            </div>
            <!-- 用户下拉菜单 -->
            <div class="user-dropdown" v-show="showDropdown">
              <div class="dropdown-header">
                <img :src="$store.state.userInfo.avatar" :alt="$store.state.userInfo.nickname">
                <div class="user-details">
                  <span class="username">{{ $store.state.userInfo.nickname }}</span>
                  <span class="role">{{ $store.state.userInfo.role === 'admin' ? '管理员' : '普通用户' }}</span>
                </div>
              </div>
              <div class="dropdown-divider"></div>
              <router-link to="/user/profile" class="dropdown-item">
                <i class="fas fa-user"></i>
                个人中心
              </router-link>
              <div class="dropdown-item" @click="handleLogout">
                <i class="fas fa-sign-out-alt"></i>
                退出登录
              </div>
            </div>
          </div>
          <div v-else class="avatar-container" @click="handleLogin">
            <el-tooltip content="未登录，点击登录" placement="bottom" effect="light">
              <div class="avatar">
                <el-avatar class="avatar-icon" src="/visitor.png" />
              </div>
            </el-tooltip>
          </div>
        </div>
      </div>
    </nav>
    <NoticeBar />
  </header>
</template>

<script>
import { getThemeMode, setThemeMode, themeBus } from '@/utils/theme'
import NoticeBar from '@/components/NoticeBar/index.vue'

export default {
  name: 'TheHeader',
  components: {
    NoticeBar
  },
  data() {
    return {
      theme: 'light',
      searchQuery: '',
      showSearchPanel: false,
      showMobileSearch: false,
      lastScrollTop: 0,
      isHeaderVisible: true,
      isScrolled: false,
      activeDropdown: null,
      showDropdown: false,
      showMessageDropdown: false,
      showSearch: false,
      unreadCount: 0,
      adminUrl: import.meta.env.VITE_APP_ADMIN_URL || 'http://localhost:3000'
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.userInfo && this.$store.state.token;
    },
    hasUnread() {
      return this.$store.state.isUnread;
    },
    joinDays() {
      if (!this.$store.state.userInfo || !this.$store.state.userInfo.createTime) return 0;
      const createTime = new Date(this.$store.state.userInfo.createTime).getTime();
      const now = new Date().getTime();
      const diffTime = Math.abs(now - createTime);
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
      return diffDays;
    }
  },
  methods: {
    handleReadMessage() {
      this.$store.commit('SET_UNREAD', false);
    },
    handleOpenMobileMenu() {
      this.$store.commit('SET_MOBILE_MENU_VISIBLE', true)
    },
    handleSearch() {
      this.$store.commit('SET_SEARCH_VISIBLE', true)
    },
    handleDesktopSearch() {
      this.$store.commit('SET_SEARCH_VISIBLE', true)
    },
    handleLogin() {
      this.$router.push('/login')
    },
    handleLogout() {
      this.$store.dispatch('logout')
      this.$message.success('已退出登录')
      this.showDropdown = false
    },
    handleScroll() {
      const currentScrollTop = window.pageYOffset || document.documentElement.scrollTop
      this.isScrolled = currentScrollTop > 20
    },
    toggleTheme() {
      this.theme = this.theme === 'light' ? 'dark' : 'light'
      setThemeMode(this.theme)
    }
  },
  mounted() {
    this.theme = getThemeMode()
    // 监听主题变化
    themeBus.$on('theme-change', (mode) => {
      this.theme = mode
    })
    
    window.addEventListener('scroll', this.handleScroll)
    document.addEventListener('click', (e) => {
      const userSection = this.$el.querySelector('.user-section')
      if (userSection && !userSection.contains(e.target)) {
        this.showDropdown = false
      }
    })
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.handleScroll)
    themeBus.$off('theme-change')
  }
}
</script>

<style lang="scss" scoped>
.site-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(var(--surface-rgb), 0.85);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(var(--border-color-rgb), 0.08);
  transition: all 0.3s ease;

  &.is-scrolled {
    background: rgba(var(--surface-rgb), 0.95);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  }
}

.navbar {
  padding: 0 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 80px;
  max-width: 1400px;
  margin: 0 auto;
  transition: height 0.3s ease;
}

.nav-left {
  display: flex;
  align-items: center;
  
  .logo {
    display: flex;
    align-items: center;
    text-decoration: none;
    gap: 10px;

    img {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
    }

    .logo-text {
      font-size: 1.2rem;
      font-weight: 700;
      color: var(--text-primary);
      background: linear-gradient(120deg, $primary, #8b5cf6);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
  }
}

.nav-center {
  display: flex;
  align-items: center;
  gap: 24px;
  
  .nav-item {
    position: relative;
    cursor: pointer;
    
    &:hover .dropdown-menu {
      opacity: 1;
      visibility: visible;
      transform: translateY(0);
    }
  }

  .nav-link {
    color: var(--text-secondary);
    text-decoration: none;
    font-size: 0.95rem;
    font-weight: 500;
    padding: 12px 16px;
    border-radius: 8px;
    transition: all 0.3s;
    display: flex;
    align-items: center;
    gap: 6px;
    position: relative;
    animation: navFadeIn 0.5s ease backwards;

    &:hover, &.router-link-active {
      color: $primary;
      transform: translateY(-2px);
    }

    &::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 50%;
      width: 0;
      height: 2px;
      background: $primary;
      transition: all 0.3s ease;
      transform: translateX(-50%);
    }

    &:hover::after, &.router-link-active::after {
      width: 100%;
    }

    .dropdown-icon {
      font-size: 0.8em;
      margin-left: 2px;
      transition: transform 0.3s;
    }
    
    &:hover .dropdown-icon {
      transform: rotate(180deg);
    }
  }

  .nav-link:nth-child(1) { animation-delay: 0ms; }
  .nav-link:nth-child(2) { animation-delay: 150ms; }
  .nav-link:nth-child(3) { animation-delay: 300ms; }
  .nav-link:nth-child(4) { animation-delay: 450ms; }
  .nav-link:nth-child(5) { animation-delay: 600ms; }
  .nav-link:nth-child(6) { animation-delay: 750ms; }
}

@keyframes navFadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%) translateY(10px);
  background: var(--surface);
  border-radius: 12px;
  padding: 8px;
  min-width: 160px;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
  opacity: 0;
  visibility: hidden;
  transition: all 0.2s ease;
  z-index: 100;
  border: 1px solid rgba(0,0,0,0.05);

  .dropdown-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 16px;
    color: var(--text-secondary);
    text-decoration: none;
    border-radius: 8px;
    transition: all 0.2s;
    font-size: 0.9rem;
    white-space: nowrap;

    &:hover {
      background: var(--hover-bg);
      color: $primary;
    }
    
    i {
      width: 16px;
      text-align: center;
    }
  }
}

.nav-right {
  display: flex;
  align-items: center;
  gap: 16px;

  .desktop-search {
    display: flex;
    align-items: center;
    background: var(--hover-bg);
    border-radius: 20px;
    padding: 6px 12px;
    transition: all 0.3s ease;
    
    input {
      border: none;
      background: transparent;
      outline: none;
      color: var(--text-primary);
      width: 120px;
      font-size: 0.9rem;
      transition: width 0.3s ease;
      
      &::placeholder {
        color: var(--text-secondary);
      }
      
      &:focus {
        width: 180px;
      }
    }
    
    i {
      color: var(--text-secondary);
      cursor: pointer;
      transition: color 0.3s;
      
      &:hover {
        color: $primary;
      }
    }
    
    &:focus-within {
      background: rgba(var(--primary-rgb), 0.1);
      box-shadow: 0 0 0 1px $primary;
      i {
        color: $primary;
      }
    }
  }

  .search-btn, .theme-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 6px 12px;
    border-radius: 20px;
    background: var(--hover-bg);
    color: var(--text-secondary);
    text-decoration: none;
    transition: all 0.3s;
    font-size: 0.9rem;

    &:hover {
      background: rgba($primary, 0.1);
      color: $primary;
    }
  }

  .theme-btn {
    padding: 8px; // 圆形按钮
    border-radius: 50%;
    width: 32px;
    height: 32px;
    justify-content: center;
  }

.message-btn {
    position: relative;
    padding: 8px;
    color: var(--text-secondary);
    transition: color 0.3s;
    cursor: pointer;

    &:hover {
      color: $primary;
    }

    .message-count {
      position: absolute;
      top: 4px;
      right: 4px;
      width: 8px;
      height: 8px;
      background: #ef4444;
      border-radius: 50%;
    }
  }

  .message-btn-wrapper {
    position: relative;
    
    .message-dropdown {
      position: absolute;
      top: calc(100% + 15px);
      right: -20px;
      width: 280px;
      background: var(--surface);
      border-radius: 12px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      border: 1px solid rgba(var(--border-color-rgb), 0.1);
      z-index: 1000;
      overflow: hidden;

      .dropdown-header {
        padding: 12px 16px;
        background: linear-gradient(to right, rgba(var(--primary-rgb), 0.05), transparent);
        border-bottom: 1px solid rgba(var(--border-color-rgb), 0.1);
        
        span {
          font-weight: 600;
          font-size: 14px;
          color: var(--text-primary);
        }
      }

      .dropdown-content {
        padding: 8px;

        .message-item {
          display: flex;
          align-items: center;
          gap: 12px;
          padding: 12px;
          border-radius: 8px;
          text-decoration: none;
          transition: all 0.2s;

          &:hover {
            background: var(--hover-bg);
          }

          i {
            font-size: 20px;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: rgba(var(--primary-rgb), 0.1);
          }

          .text-primary {
            color: $primary;
            background: rgba($primary, 0.1);
          }

          .text-danger {
            color: #ef4444;
            background: rgba(239, 68, 68, 0.1);
          }

          .message-info {
            display: flex;
            flex-direction: column;
            gap: 4px;

            .title {
              font-size: 14px;
              color: var(--text-primary);
              font-weight: 500;
            }

            .desc {
              font-size: 12px;
              color: var(--text-secondary);
            }
          }
        }

        .join-time-wrapper {
          display: flex;
          align-items: center;
          gap: 8px;
          padding: 12px;
          color: var(--text-secondary);
          font-size: 13px;
          justify-content: center;
          background: rgba(var(--border-color-rgb), 0.05);
          border-radius: 8px;
          margin-top: 8px;

          i {
            color: $primary;
          }
        }
      }
    }
  }
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;

  .welcome-text {
    font-size: 0.9rem;
    color: var(--text-primary);
    font-weight: 500;
  }

  .login-tip {
    font-size: 0.85rem;
    color: $primary;
    margin-right: 8px;
    cursor: pointer;
    font-weight: 600;
    
    &:hover {
      text-decoration: underline;
    }
  }

  .avatar-container {
    display: flex;
    align-items: center;
    cursor: pointer;
  }

  .avatar {
    cursor: pointer;
    border: 2px solid transparent;
    border-radius: 50%;
    transition: all 0.3s;
    
    &:hover {
      border-color: $primary;
    }
  }
  
  .user-dropdown {
    position: absolute;
    top: 60px;
    right: 20px;
    width: 260px;
    background: var(--surface);
    border-radius: 16px;
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    overflow: hidden;
    padding: 0;
    
    .dropdown-header {
      padding: 20px;
      background: linear-gradient(135deg, $primary, #8b5cf6);
      display: flex;
      align-items: center;
      gap: 15px;
      color: white;
      
      img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        border: 2px solid rgba(255,255,255,0.5);
      }
      
      .user-details {
        display: flex;
        flex-direction: column;
        
        .username {
          font-weight: 600;
          font-size: 1.1rem;
        }
        
        .role {
          font-size: 0.8rem;
          opacity: 0.8;
          margin-top: 2px;
          background: rgba(0,0,0,0.2);
          padding: 2px 8px;
          border-radius: 10px;
          width: fit-content;
        }
      }
    }
    
    .dropdown-item {
      padding: 12px 20px;
      display: flex;
      align-items: center;
      gap: 12px;
      color: var(--text-primary);
      text-decoration: none;
      transition: background 0.2s;
      cursor: pointer;
      
      &:hover {
        background: var(--hover-bg);
        color: $primary;
      }
    }
  }
}

.menu-btn, .mobile-search-btn {
  display: none;
  background: none;
  border: none;
  font-size: 1.2rem;
  color: var(--text-primary);
  cursor: pointer;
}

@media (max-width: 1024px) {
  .nav-center {
    display: none;
  }
  
  .desktop-search {
    display: none !important;
  }
  
  .menu-btn, .mobile-search-btn {
    display: block;
  }
  
  .search-btn {
    display: none !important;
  }
}
</style>
