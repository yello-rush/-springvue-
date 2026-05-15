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
        
        <!-- 悬浮简介面板 -->
        <div class="site-info-hover">
          <div class="info-content">
            <p>{{ $store.state.webSiteInfo.summary || '这是一个基于Spring+Vue的个人博客系统' }}</p>
          </div>
        </div>
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

        <a href="javascript:void(0)" class="calendar-toggle-btn" @click="toggleCalendarPanel" aria-label="打开签到日历">
          <svg class="calendar-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
            <line x1="8" y1="2" x2="8" y2="6"></line>
            <line x1="16" y1="2" x2="16" y2="6"></line>
            <line x1="3" y1="10" x2="21" y2="10"></line>
          </svg>
          <span v-if="showCalendarBadge" class="calendar-badge"></span>
        </a>

        <!-- 修改消息按钮的跳转路径 -->
        <div class="message-btn-wrapper" @mouseleave="handleMessageMouseLeave" @mouseenter="cancelMessageAutoClose">
          <button class="message-btn" type="button" @click.stop="toggleMessageDropdown" aria-label="消息通知">
            <i class="far fa-bell"></i>
            <span class="message-count" v-if="unreadCount > 0">{{ unreadCount > 99 ? '99+' : unreadCount }}</span>
          </button>
          <transition name="dropdown-fade">
            <div class="message-dropdown" v-show="showMessageDropdown" @mouseenter="cancelMessageAutoClose">
              <div class="dropdown-header">
                <span>消息通知</span>
              </div>
              <div class="dropdown-content">
                <template v-if="isLoggedIn">
                  <div v-if="unreadLikeCount > 0" class="message-item" @click="openMessagePanel('like')">
                    <i class="fas fa-thumbs-up text-danger"></i>
                    <div class="message-info">
                      <span class="title">未读点赞</span>
                      <span class="desc">有人点赞了你的评论（{{ unreadLikeCount }}）</span>
                    </div>
                  </div>
                  <div v-if="unreadSystemCount > 0" class="message-item" @click="openMessagePanel('system')">
                    <i class="fas fa-bullhorn text-primary"></i>
                    <div class="message-info">
                      <span class="title">系统消息</span>
                      <span class="desc">未读系统通知（{{ unreadSystemCount }}）</span>
                    </div>
                  </div>
                  <div v-if="unreadCount === 0" class="message-item" @click="openMessagePanel('all')">
                    <i class="fas fa-history text-primary"></i>
                    <div class="message-info">
                      <span class="title">历史消息</span>
                      <span class="desc">当前无未读消息，点击查看历史消息记录</span>
                    </div>
                  </div>
                </template>
                <template v-else>
                  <div class="message-item" @click="handleLogin">
                    <i class="fas fa-info-circle" style="color: #e6a23c;"></i>
                    <div class="message-info">
                      <span class="title">系统提示</span>
                      <span class="desc">登录后即可发表评论、点赞文章，享受更多专属功能！</span>
                    </div>
                  </div>
                </template>
              </div>
            </div>
          </transition>
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
    <transition name="message-panel-fade">
      <section
        v-if="messagePanelVisible"
        ref="messagePanel"
        class="message-float-shell"
        :class="{ mobile: isMobile }"
      >
        <div class="message-float-card">
          <div class="float-head">
            <div class="head-title">
              <i class="fas fa-bell"></i>
              <span>{{ messagePanelTitle }}</span>
            </div>
            <div class="head-actions">
              <button class="head-action-btn" title="全部已读" @click="markAllAsRead" v-if="messagePanelList.some(item => !item.isRead)">
                <i class="fas fa-check-double"></i>
              </button>
              <button class="head-close" @click="messagePanelVisible = false" aria-label="关闭消息浮窗">×</button>
            </div>
          </div>
          <div class="message-panel" v-loading="messagePanelLoading">
            <div v-if="messagePanelList.length">
              <div
                v-for="item in messagePanelList"
                :key="item.id"
                class="message-panel-item"
                :class="{ unread: !item.isRead }"
              >
                <div class="item-head">
                  <span class="item-title">{{ item.title || (item.type === 'system' ? '系统消息' : '点赞通知') }}</span>
                  <el-tag size="mini" :type="item.isRead ? 'info' : 'danger'" effect="plain">{{ item.isRead ? '已读' : '未读' }}</el-tag>
                </div>
                <div class="item-content">{{ getPanelMessageText(item) }}</div>
                <div class="item-foot">
                  <span class="item-time">{{ formatPanelTime(item.createTime) }}</span>
                  <el-button
                    v-if="!item.isRead"
                    type="primary"
                    size="mini"
                    plain
                    :loading="messageActionLoadingIds.includes(String(item.id))"
                    @click="markPanelMessageRead(item.id)"
                  >
                    标记已读
                  </el-button>
                  <el-button
                    v-else
                    type="danger"
                    size="mini"
                    plain
                    @click="deletePanelMessage(item.id)"
                  >
                    删除记录
                  </el-button>
                </div>
              </div>
            </div>
            <el-empty v-else description="暂无消息"></el-empty>
          </div>
        </div>
      </section>
    </transition>
    <NoticeBar />
  </header>
</template>

<script>
import { themeBus } from '@/utils/theme'
import NoticeBar from '@/components/NoticeBar/index.vue'
import { getUnreadNotificationsCountApi, getNotificationsApi, markNotificationAsReadApi, deleteNotificationApi, markAllNotificationsAsReadApi } from '@/api/message'
import { formatTime } from '@/utils/time'

export default {
  name: 'TheHeader',
  components: {
    NoticeBar
  },
  data() {
    return {
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
      unreadLikeCount: 0,
      unreadSystemCount: 0,
      messageCloseTimer: null,
      showCalendarBadge: localStorage.getItem('calendar-reminder-dot') !== 'false',
      adminUrl: import.meta.env.VITE_APP_ADMIN_URL || 'http://localhost:3000',
      messagePanelVisible: false,
      messagePanelType: 'system',
      messagePanelLoading: false,
      messagePanelList: [],
      messageActionLoadingIds: [],
      viewportWidth: typeof window !== 'undefined' ? window.innerWidth : 1200
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.userInfo && this.$store.state.token;
    },
    hasUnread() {
      return this.$store.state.isUnread;
    },
    messagePanelTitle() {
      if (this.messagePanelType === 'like') return '点赞消息'
      if (this.messagePanelType === 'all') return '历史消息'
      return '系统消息'
    },
    isMobile() {
      return this.viewportWidth <= 768
    }
  },
  methods: {
    handleReadMessage() {
      this.$store.commit('SET_UNREAD', false);
      this.showMessageDropdown = false
    },
    handleCalendarReminderUpdate(status) {
      this.showCalendarBadge = Boolean(status)
      localStorage.setItem('calendar-reminder-dot', String(this.showCalendarBadge))
    },
    toggleCalendarPanel() {
      themeBus.$emit('floating-calendar-toggle')
    },
    formatPanelTime(time) {
      return formatTime(time)
    },
    getPanelMessageText(item) {
      if (item.type === 'like') {
        return item.articleTitle ? `有人点赞了你的评论：${item.articleTitle}` : (item.message || '有人点赞了你的评论')
      }
      return item.message || ''
    },
    async openMessagePanel(type = 'system') {
      this.showMessageDropdown = false
      this.messagePanelType = type
      this.messagePanelVisible = true
      await this.fetchMessagePanelList()
    },
    async fetchMessagePanelList() {
      this.messagePanelLoading = true
      try {
        const { data } = await getNotificationsApi({
          pageNum: 1,
          pageSize: 20,
          type: this.messagePanelType === 'all' ? '' : this.messagePanelType
        })
        this.messagePanelList = ((data && data.records) || []).map(item => ({
          ...item,
          isRead: Boolean(item.isRead)
        }))
      } catch (error) {
        this.messagePanelList = []
        this.$message.error('消息加载失败，请稍后重试')
      } finally {
        this.messagePanelLoading = false
      }
    },
    async markPanelMessageRead(id) {
      const key = String(id)
      if (this.messageActionLoadingIds.includes(key)) return
      this.messageActionLoadingIds.push(key)
      try {
        await markNotificationAsReadApi(id)
        this.messagePanelList = this.messagePanelList.map(item =>
          String(item.id) === key ? { ...item, isRead: true } : item
        )
        await this.fetchUnreadCount()
      } catch (error) {
        this.$message.error('标记已读失败')
      } finally {
        this.messageActionLoadingIds = this.messageActionLoadingIds.filter(item => item !== key)
      }
    },
    async markAllAsRead() {
      try {
        await markAllNotificationsAsReadApi()
        this.messagePanelList = this.messagePanelList.map(item => ({ ...item, isRead: true }))
        this.$message.success('已全部标记为已读')
        this.fetchUnreadCount()
      } catch (error) {
        this.$message.error('操作失败')
      }
    },
    async deletePanelMessage(id) {
      try {
        await deleteNotificationApi(id)
        this.messagePanelList = this.messagePanelList.filter(item => String(item.id) !== String(id))
        this.$message.success('删除成功')
      } catch (error) {
        this.$message.error('删除失败')
      }
    },
    async fetchUnreadCount() {
      if (!this.isLoggedIn) {
        this.unreadCount = 0
        this.unreadLikeCount = 0
        this.unreadSystemCount = 0
        return
      }
      try {
        const { data } = await getUnreadNotificationsCountApi()
        this.unreadLikeCount = data?.like?.num || 0
        this.unreadSystemCount = data?.system?.num || 0
        this.unreadCount = this.unreadLikeCount + this.unreadSystemCount
        this.$store.commit('SET_UNREAD', this.unreadCount > 0)
      } catch (error) {
        this.unreadCount = 0
      }
    },
    toggleMessageDropdown() {
      this.cancelMessageAutoClose()
      this.showMessageDropdown = !this.showMessageDropdown
      this.fetchUnreadCount()
    },
    handleMessageMouseLeave() {
      this.cancelMessageAutoClose()
      this.messageCloseTimer = window.setTimeout(() => {
        this.showMessageDropdown = false
      }, 180)
    },
    cancelMessageAutoClose() {
      if (this.messageCloseTimer) {
        window.clearTimeout(this.messageCloseTimer)
        this.messageCloseTimer = null
      }
    },
    handleDocumentClick(e) {
      const userSection = this.$el.querySelector('.user-section')
      const messageSection = this.$el.querySelector('.message-btn-wrapper')
      const messagePanel = this.$refs.messagePanel
      const clickedInPanel = Boolean(messagePanel && messagePanel.contains(e.target))
      const clickedInMessageTrigger = Boolean(messageSection && messageSection.contains(e.target))
      if (userSection && !userSection.contains(e.target)) {
        this.showDropdown = false
      }
      if (!clickedInMessageTrigger && !clickedInPanel) {
        this.showMessageDropdown = false
      }
      if (this.messagePanelVisible && !clickedInPanel && !clickedInMessageTrigger) {
        this.messagePanelVisible = false
      }
    },
    handleResize() {
      this.viewportWidth = window.innerWidth
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
    }
  },
  mounted() {
    this.fetchUnreadCount()
    themeBus.$on('calendar-reminder-update', this.handleCalendarReminderUpdate)
    
    window.addEventListener('scroll', this.handleScroll)
    document.addEventListener('click', this.handleDocumentClick)
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.handleScroll)
    document.removeEventListener('click', this.handleDocumentClick)
    window.removeEventListener('resize', this.handleResize)
    themeBus.$off('calendar-reminder-update', this.handleCalendarReminderUpdate)
    this.cancelMessageAutoClose()
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
  position: relative;
  
  .logo {
    display: flex;
    align-items: center;
    text-decoration: none;
    gap: 12px;
    padding: 5px 0;
    
    img {
      height: 36px;
      width: 36px;
      border-radius: 50%;
      object-fit: cover;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      transition: transform 0.5s ease;
    }
    
    .logo-text {
      font-size: 1.4rem;
      font-weight: 600;
      color: var(--text-primary);
      font-family: "LXGW WenKai", sans-serif;
      background: linear-gradient(120deg, $primary, #8b5cf6);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    &:hover img {
      transform: rotate(360deg);
    }
  }

  /* 悬浮简介面板样式 */
  &:hover .site-info-hover {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
  }

  .site-info-hover {
    position: absolute;
    top: 100%;
    left: 0;
    width: max-content;
    max-width: 300px;
    margin-top: 15px;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 1010;

    /* 顶部的小三角 */
    &::before {
      content: '';
      position: absolute;
      top: -6px;
      left: 25px;
      width: 12px;
      height: 12px;
      background: var(--surface);
      transform: rotate(45deg);
      border-left: 1px solid rgba(var(--border-color-rgb), 0.1);
      border-top: 1px solid rgba(var(--border-color-rgb), 0.1);
      z-index: 1;
    }

    .info-content {
      position: relative;
      background: var(--surface);
      border-radius: 12px;
      padding: 16px 20px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      border: 1px solid rgba(var(--border-color-rgb), 0.1);
      z-index: 2;

      p {
        margin: 0;
        font-size: 0.95rem;
        color: var(--text-secondary);
        line-height: 1.6;
        font-family: "LXGW WenKai", sans-serif;
        word-break: break-all;
      }
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

  .search-btn, .calendar-toggle-btn {
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

  .calendar-toggle-btn {
    position: relative;
    padding: 8px;
    border-radius: 50%;
    width: 32px;
    height: 32px;
    justify-content: center;
  }

  .calendar-icon {
    display: block;
  }

  .calendar-badge {
    position: absolute;
    top: 6px;
    right: 6px;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: #ff4d4f;
  }

.message-btn {
    position: relative;
    padding: 8px;
    border: none;
    background: transparent;
    color: var(--text-secondary);
    transition: color 0.3s;
    cursor: pointer;

    &:hover {
      color: $primary;
    }

    .message-count {
      position: absolute;
      top: -2px;
      right: -6px;
      min-width: 16px;
      height: 16px;
      padding: 0 4px;
      background: #ef4444;
      border-radius: 8px;
      color: #fff;
      font-size: 11px;
      line-height: 16px;
      text-align: center;
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
      transform-origin: top right;

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

        .message-empty {
          text-align: center;
          font-size: 12px;
          color: var(--text-secondary);
          padding: 14px 10px;
        }

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

      }
    }
  }
}

.dropdown-fade-enter-active,
.dropdown-fade-leave-active {
  transition: opacity 0.22s ease, transform 0.22s ease;
}

.dropdown-fade-enter,
.dropdown-fade-leave-to {
  opacity: 0;
  transform: translateY(-8px) scale(0.98);
}

.message-panel-fade-enter-active,
.message-panel-fade-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.message-panel-fade-enter,
.message-panel-fade-leave-to {
  opacity: 0;
  transform: translateY(-8px) scale(0.98);
}

.message-float-shell {
  position: fixed;
  top: 92px;
  right: 24px;
  z-index: 1900;
  width: min(360px, calc(100vw - 24px));
}

.message-float-card {
  border-radius: 14px;
  border: 1px solid rgba(var(--border-color-rgb), 0.25);
  background: rgba(var(--surface-rgb), 0.97);
  backdrop-filter: blur(8px);
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.18);
  overflow: hidden;
}

.float-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 12px;
  border-bottom: 1px solid rgba(var(--border-color-rgb), 0.18);
  background: linear-gradient(to right, rgba(var(--primary-rgb), 0.1), transparent);
}

.head-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.head-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.head-action-btn {
  background: none;
  border: none;
  color: var(--text-secondary);
  cursor: pointer;
  font-size: 1rem;
  padding: 4px;
  border-radius: 4px;
  transition: all 0.3s;
  
  &:hover {
    color: $primary;
    background: var(--hover-bg);
  }
}

.head-close {
  width: 24px;
  height: 24px;
  border: 1px solid rgba(var(--border-color-rgb), 0.6);
  border-radius: 6px;
  background: var(--surface);
  color: var(--text-secondary);
  cursor: pointer;
  line-height: 1;
  padding: 0;
  transition: all 0.3s;

  &:hover {
    color: var(--text-primary);
    background: var(--hover-bg);
  }
}

.message-panel {
  max-height: min(56vh, 430px);
  overflow-y: auto;
  padding: 10px;
}

.message-panel-item {
  border: 1px solid rgba(var(--border-color-rgb), 0.2);
  border-radius: 10px;
  padding: 10px;
  margin-bottom: 8px;
  background: var(--surface);
}

.message-panel-item.unread {
  border-color: rgba(var(--primary-rgb), 0.45);
  background: rgba(var(--primary-rgb), 0.05);
}

.item-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.item-title {
  font-size: 13px;
  font-weight: 600;
  color: var(--text-primary);
}

.item-content {
  margin-top: 6px;
  font-size: 12px;
  color: var(--text-secondary);
  line-height: 1.6;
  white-space: pre-wrap;
  word-break: break-word;
}

.item-foot {
  margin-top: 8px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.item-time {
  font-size: 12px;
  color: var(--text-secondary);
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
    width: 40px;
    height: 40px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    cursor: pointer;
    border: 2px solid transparent;
    border-radius: 50%;
    transition: all 0.3s;

    :deep(.el-avatar) {
      width: 100%;
      height: 100%;
      border-radius: 50%;
      display: block;
    }

    :deep(.el-avatar > img) {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    
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

@media (max-width: 768px) {
  .message-float-shell {
    right: 12px;
    top: auto;
    bottom: 12px;
    width: min(360px, calc(100vw - 24px));
  }

  .message-panel {
    max-height: min(52vh, 380px);
  }
}
</style>
