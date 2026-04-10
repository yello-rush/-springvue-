<template>
  <div class="notice-bar" v-if="notices.length > 0 && visible">
    <div class="notice-icon">
      <i class="el-icon-bell"></i>
    </div>
    <div class="notice-content" @mouseenter="pause" @mouseleave="resume">
      <transition name="slide-up" mode="out-in">
        <div class="notice-item" :key="currentIndex">
          <span class="notice-title" v-if="currentNotice.title">[{{ currentNotice.title }}]</span>
          <span class="notice-text" @click="handleClick(currentNotice)">{{ currentNotice.content }}</span>
        </div>
      </transition>
    </div>
    <div class="notice-close" @click="close">
      <i class="el-icon-close"></i>
    </div>
  </div>
</template>

<script>
import { getNoticeApi } from '@/api/site'

export default {
  name: "NoticeBar",
  data() {
    return {
      notices: [],
      currentIndex: 0,
      timer: null,
      visible: true
    };
  },
  computed: {
    currentNotice() {
      return this.notices[this.currentIndex] || {};
    }
  },
  created() {
    this.fetchNotices();
  },
  methods: {
    fetchNotices() {
      getNoticeApi().then(res => {
        if (res.data && res.data.length > 0) {
          this.notices = res.data;
          this.startTimer();
        }
      });
    },
    startTimer() {
      if (this.notices.length <= 1) return;
      const duration = this.currentNotice.duration || 5000;
      this.timer = setTimeout(() => {
        this.next();
      }, duration);
    },
    next() {
      this.currentIndex = (this.currentIndex + 1) % this.notices.length;
      this.startTimer();
    },
    pause() {
      clearTimeout(this.timer);
    },
    resume() {
      this.startTimer();
    },
    handleClick(notice) {
      if (notice.url) {
        window.open(notice.url, '_blank');
      }
    },
    close() {
      this.visible = false;
    }
  },
  beforeDestroy() {
    this.pause();
  }
};
</script>

<style lang="scss" scoped>
.notice-bar {
  display: flex;
  align-items: center;
  height: 40px;
  background: rgba(230, 247, 255, 0.95);
  color: #1890ff;
  padding: 0 20px;
  border-bottom: 1px solid rgba(24, 144, 255, 0.1);
  font-size: 14px;
  position: relative;
  z-index: 999;
  backdrop-filter: blur(10px);
  
  .notice-icon {
    margin-right: 10px;
    font-size: 16px;
    animation: bell-ring 2s infinite;
  }
  
  .notice-content {
    flex: 1;
    height: 100%;
    overflow: hidden;
    position: relative;
    cursor: pointer;
  }
  
  .notice-item {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    white-space: nowrap;
    
    .notice-title {
      font-weight: bold;
      margin-right: 8px;
    }
    
    .notice-text {
      &:hover {
        text-decoration: underline;
      }
    }
  }
  
  .notice-close {
    cursor: pointer;
    margin-left: 10px;
    opacity: 0.6;
    transition: opacity 0.3s;
    &:hover {
      opacity: 1;
    }
  }
}

@keyframes bell-ring {
  0% { transform: rotate(0); }
  10% { transform: rotate(15deg); }
  20% { transform: rotate(-15deg); }
  30% { transform: rotate(10deg); }
  40% { transform: rotate(-10deg); }
  50% { transform: rotate(0); }
  100% { transform: rotate(0); }
}

.slide-up-enter-active, .slide-up-leave-active {
  transition: all 0.5s ease;
}
.slide-up-enter {
  transform: translateY(100%);
  opacity: 0;
}
.slide-up-leave-to {
  transform: translateY(-100%);
  opacity: 0;
}
</style>