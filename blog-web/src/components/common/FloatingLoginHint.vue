<template>
  <div v-if="!isLoggedIn" class="notification-container" v-click-outside="closeNotification">
    <el-badge :hidden="true" class="notification-badge">
      <div class="notification-icon-wrapper" @click="toggleNotification">
        <i class="far fa-bell notification-icon"></i>
      </div>
    </el-badge>

    <transition name="dropdown">
      <div v-show="isOpen" class="notification-dropdown">
        <div class="dropdown-header">
          <span>解锁完整体验</span>
        </div>
        <div class="dropdown-content">
          <div class="hint-icon">
            <i class="fas fa-user-circle"></i>
          </div>
          <p class="hint-desc">登录后即可发表评论、点赞文章，享受更多专属功能！</p>
          <button class="login-btn" @click="handleLogin">立即登录</button>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'FloatingLoginHint',
  data() {
    return {
      isOpen: false
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.userInfo && this.$store.state.token;
    }
  },
  methods: {
    toggleNotification() {
      this.isOpen = !this.isOpen;
    },
    closeNotification() {
      this.isOpen = false;
    },
    handleLogin() {
      this.$router.push('/login');
      this.isOpen = false;
    }
  },
  directives: {
    clickOutside: {
      bind(el, binding) {
        el._clickOutside = (event) => {
          if (!(el === event.target || el.contains(event.target))) {
            binding.value(event);
          }
        };
        document.addEventListener('click', el._clickOutside);
      },
      unbind(el) {
        document.removeEventListener('click', el._clickOutside);
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.notification-container {
  position: relative;
  display: flex;
  align-items: center;
  margin-right: 10px;
}

.notification-badge {
  .notification-icon-wrapper {
    cursor: pointer;
    padding: 6px;
    border-radius: 50%;
    transition: all 0.3s;
    color: var(--text-secondary);
    display: flex;
    align-items: center;
    justify-content: center;
    width: 32px;
    height: 32px;
    
    .notification-icon {
      font-size: 18px;
      transition: all 0.3s;
    }

    &:hover {
      background-color: rgba(var(--primary-rgb), 0.1);
      color: var(--primary);
      
      .notification-icon {
        transform: rotate(15deg);
      }
    }
  }
}

.notification-dropdown {
  position: absolute;
  top: calc(100% + 15px);
  right: -10px;
  width: 300px;
  background: var(--surface);
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  z-index: 2000;
  overflow: hidden;
  border: 1px solid rgba(var(--border-color-rgb), 0.1);
}

.dropdown-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid rgba(var(--border-color-rgb), 0.1);
  background: linear-gradient(to right, rgba(var(--primary-rgb), 0.05), transparent);
  
  span {
    font-size: 16px;
    font-weight: 600;
    background: linear-gradient(120deg, var(--primary), #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
}

.dropdown-content {
  padding: 24px 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  background: var(--surface);

  .hint-icon {
    font-size: 48px;
    color: var(--primary);
    margin-bottom: 16px;
    opacity: 0.8;
  }

  .hint-desc {
    font-size: 14px;
    color: var(--text-secondary);
    margin-bottom: 20px;
    line-height: 1.6;
  }

  .login-btn {
    background: var(--primary);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 10px 24px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;
    width: 80%;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(var(--primary-rgb), 0.3);
    }
  }
}

.dropdown-enter-active,
.dropdown-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.dropdown-enter,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-12px) scale(0.95);
}

/* 适配暗黑模式 */
[data-theme='dark'] {
  .notification-dropdown {
    background: var(--surface);
    border-color: rgba(255, 255, 255, 0.05);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
  }
}
</style>
