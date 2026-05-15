<template>
  <div v-if="shouldRender" class="notice-bar" role="status" aria-live="polite">
    <div class="notice-icon">
      <i class="fas fa-bullhorn"></i>
    </div>
    <div class="notice-content">
      <div v-if="status === 'loading'" class="notice-state">公告加载中...</div>
      <div v-else-if="status === 'error'" class="notice-state error">{{ errorMessage }}</div>
      <div v-else-if="status === 'empty'" class="notice-state">暂无公告</div>
      <div
        v-else
        class="marquee"
        @click="handleClick(activeNotice)"
        :title="displayText"
      >
        <div class="marquee-track">
          <span class="marquee-text">{{ displayText }}</span>
          <span class="marquee-text">{{ displayText }}</span>
        </div>
      </div>
    </div>
    <button class="notice-close" type="button" aria-label="关闭公告" @click="close">
      <i class="fas fa-times"></i>
    </button>
  </div>
</template>

<script>
import { getNoticeApi } from '@/api/site'

export default {
  name: 'NoticeBar',
  data() {
    return {
      visible: true,
      status: 'loading',
      errorMessage: '公告加载失败，请稍后重试',
      activeNotice: null
    }
  },
  computed: {
    shouldRender() {
      return this.visible
    },
    displayText() {
      if (!this.activeNotice) return ''
      const title = this.activeNotice.title ? `【${this.activeNotice.title}】` : ''
      const content = this.activeNotice.content || ''
      const publishTime = this.activeNotice.createTime ? `发布时间：${this.activeNotice.createTime}` : ''
      return [title, content, publishTime].filter(Boolean).join(' ')
    }
  },
  created() {
    this.fetchNotice()
  },
  methods: {
    normalizeNoticeList(payload) {
      if (Array.isArray(payload)) return payload
      if (payload && Array.isArray(payload.top)) return payload.top
      return []
    },
    pickLatestValidNotice(notices) {
      const valid = notices.filter(item => item && item.isShow !== 0)
      if (!valid.length) return null
      const topNotices = valid.filter(item => item.position === 'top')
      const source = topNotices.length ? topNotices : valid
      return source.sort((a, b) => {
        const aTime = new Date(a.createTime || 0).getTime()
        const bTime = new Date(b.createTime || 0).getTime()
        if (aTime !== bTime) return bTime - aTime
        return (b.id || 0) - (a.id || 0)
      })[0]
    },
    async fetchNotice() {
      this.status = 'loading'
      try {
        const res = await getNoticeApi()
        const noticeList = this.normalizeNoticeList(res.data)
        const latest = this.pickLatestValidNotice(noticeList)
        if (!latest) {
          this.status = 'empty'
          return
        }
        this.activeNotice = latest
        this.status = 'ready'
        this.visible = true
      } catch (e) {
        this.status = 'error'
      }
    },
    handleClick(notice) {
      if (notice && notice.url) {
        window.open(notice.url, '_blank')
      }
    },
    close() {
      this.visible = false
    }
  }
}
</script>

<style lang="scss" scoped>
.notice-bar {
  position: fixed;
  top: 86px;
  left: 50%;
  transform: translateX(-50%);
  width: min(760px, calc(100% - 24px));
  margin: 0;
  display: flex;
  align-items: center;
  height: 42px;
  padding: 0 14px;
  background: linear-gradient(90deg, rgba(59, 130, 246, 0.96), rgba(99, 102, 241, 0.96));
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.24);
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.16);
  z-index: 1001;
}

.notice-icon {
  width: 24px;
  margin-right: 10px;
  text-align: center;
  flex-shrink: 0;

  i {
    font-size: 14px;
  }
}

.notice-content {
  flex: 1;
  overflow: hidden;
  min-width: 0;
}

.notice-state {
  font-size: 13px;
  white-space: nowrap;
  opacity: 0.95;
}

.notice-state.error {
  color: #fee2e2;
}

.marquee {
  width: 100%;
  overflow: hidden;
  cursor: pointer;
}

.marquee-track {
  display: inline-flex;
  align-items: center;
  min-width: 200%;
  animation: marqueeScroll 18s linear infinite;
}

.marquee:hover .marquee-track {
  animation-play-state: paused;
}

.marquee-text {
  display: inline-block;
  white-space: nowrap;
  padding-right: 64px;
  font-size: 13px;
  opacity: 0.98;
}

.notice-close {
  width: 24px;
  height: 24px;
  margin-left: 8px;
  border: none;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  color: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: background 0.2s ease;

  &:hover {
    background: rgba(255, 255, 255, 0.35);
  }

  i {
    font-size: 12px;
  }
}

@keyframes marqueeScroll {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-50%);
  }
}

@media (max-width: 768px) {
  .notice-bar {
    width: calc(100% - 12px);
    top: 74px;
    height: 38px;
    padding: 0 8px;
    border-radius: 8px;
  }

  .marquee-text,
  .notice-state {
    font-size: 12px;
  }

  .marquee-track {
    animation-duration: 20s;
  }

  .marquee-text {
    padding-right: 36px;
  }

  .notice-close {
    width: 24px;
    height: 24px;
  }
}
</style>
