<template>
  <div class="hot-rank-root" ref="root">
    <button
      ref="toggleBtn"
      class="hot-rank-btn"
      :class="{ active: visible }"
      aria-label="文章热榜"
      title="文章热榜"
      @click.stop="handleToggleClick"
    >
      <i class="el-icon-trophy"></i>
    </button>

    <transition name="hot-rank-panel">
      <section
        v-if="visible"
        ref="panel"
        class="hot-rank-panel"
        role="dialog"
        aria-label="文章热榜"
        :style="panelStyle"
        @mousedown.stop
      >
        <header class="panel-header" @mousedown="startDrag">
          <div class="panel-title">
            <i class="el-icon-trophy"></i>
            <span>文章热榜</span>
          </div>
          <button class="close-btn" aria-label="关闭热榜" @click.stop="requestClose">×</button>
        </header>

        <div class="panel-content" v-loading="loading">
          <div v-if="!loading && list.length === 0" class="empty">暂无热榜数据</div>
          <div
            v-for="(item, index) in list"
            :key="item.id"
            class="rank-item"
            tabindex="0"
            @click="goToPost(item.id)"
            @keydown.enter="goToPost(item.id)"
          >
            <span class="rank-no">{{ index + 1 }}</span>
            <span class="rank-title" :title="item.title">{{ item.title }}</span>
            <span class="rank-views">
              <i class="el-icon-view"></i>
              {{ formatNumber(getViewCount(item)) }}
            </span>
          </div>
        </div>
      </section>
    </transition>
  </div>
</template>

<script>
import ArticleService from '@/services/articleService'
import { getViewCount } from '@/utils/article'

export default {
  name: 'HotArticleList',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    onToggle: {
      type: Function,
      default: null
    }
  },
  data() {
    return {
      list: [],
      loading: false,
      hasLoaded: false,
      currentTab: 'day',
      orderBy: 'views',
      panelOffsetX: 0,
      panelOffsetY: 0,
      dragging: false,
      dragStartX: 0,
      dragStartY: 0,
      dragBaseX: 0,
      dragBaseY: 0
    }
  },
  computed: {
    panelStyle() {
      const baseLeft = window.innerWidth <= 768 ? 12 : 24
      const baseTop = window.innerWidth <= 768 ? 126 : 148
      return {
        left: `${baseLeft + this.panelOffsetX}px`,
        top: `${baseTop + this.panelOffsetY}px`
      }
    }
  },
  watch: {
    visible: {
      immediate: true,
      handler(val) {
        if (val) {
          this.ensureDataLoaded()
          this.bindDismissListeners()
          return
        }
        this.unbindDismissListeners()
      }
    }
  },
  beforeDestroy() {
    this.unbindDismissListeners()
    this.stopDrag()
  },
  methods: {
    getViewCount,
    handleToggleClick() {
      this.emitToggle(!this.visible)
    },
    emitToggle(nextVisible) {
      if (typeof this.onToggle === 'function') {
        this.onToggle(nextVisible)
      }
      this.$emit('toggle', nextVisible)
    },
    requestClose() {
      if (!this.visible) return
      this.emitToggle(false)
    },
    bindDismissListeners() {
      document.addEventListener('mousedown', this.handleDocumentMousedown)
      document.addEventListener('keydown', this.handleDocumentKeydown)
    },
    unbindDismissListeners() {
      document.removeEventListener('mousedown', this.handleDocumentMousedown)
      document.removeEventListener('keydown', this.handleDocumentKeydown)
    },
    handleDocumentMousedown(event) {
      const panel = this.$refs.panel
      const button = this.$refs.toggleBtn
      if (!panel || !button) return
      if (panel.contains(event.target) || button.contains(event.target)) return
      this.requestClose()
    },
    handleDocumentKeydown(event) {
      if (event.key === 'Escape') {
        this.requestClose()
      }
    },
    async ensureDataLoaded() {
      if (this.hasLoaded || this.loading) return
      await this.loadData()
      this.hasLoaded = true
    },
    async loadData() {
      if (this.loading) return
      this.loading = true
      try {
        const res = await ArticleService.getHotArticles(this.currentTab, false, 0, 10, 'views')
        this.list = Array.isArray(res?.data) ? res.data.slice(0, 10) : []
      } catch (error) {
        this.list = []
      } finally {
        this.loading = false
      }
    },

    startDrag(event) {
      if (event.button !== 0) return
      this.dragging = true
      this.dragStartX = event.clientX
      this.dragStartY = event.clientY
      this.dragBaseX = this.panelOffsetX
      this.dragBaseY = this.panelOffsetY
      document.addEventListener('mousemove', this.onDragMove)
      document.addEventListener('mouseup', this.stopDrag)
    },
    onDragMove(event) {
      if (!this.dragging) return
      this.panelOffsetX = this.dragBaseX + (event.clientX - this.dragStartX)
      this.panelOffsetY = this.dragBaseY + (event.clientY - this.dragStartY)
    },
    stopDrag() {
      this.dragging = false
      document.removeEventListener('mousemove', this.onDragMove)
      document.removeEventListener('mouseup', this.stopDrag)
    },
    goToPost(id) {
      this.$router.push(`/post/${id}`)
      this.requestClose()
    },
    formatNumber(num) {
      const val = Number(num)
      if (Number.isNaN(val)) return 0
      if (val >= 100000000) return `${(val / 100000000).toFixed(1)}亿`
      if (val >= 10000) return `${(val / 10000).toFixed(1)}w`
      return val
    }
  }
}
</script>

<style lang="scss" scoped>
.hot-rank-root {
  position: relative;
}

.hot-rank-btn {
  position: fixed;
  left: 24px;
  top: 92px;
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
  border: 1px solid rgba(0, 0, 0, 0.05);
  z-index: 1500;

  &:hover,
  &.active {
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
    color: var(--primary);
  }

  i {
    font-size: 1.1rem;
  }
}

.hot-rank-panel {
  position: fixed;
  width: 320px;
  max-height: 400px;
  background: #ffffff;
  border: 1px solid var(--border-color);
  border-radius: 2px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.12);
  z-index: 1500;
  overflow: hidden;
}

.panel-header {
  height: 44px;
  padding: 0 12px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: move;
  border-bottom: 1px solid var(--border-color);
  user-select: none;
}

.panel-title {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  font-weight: 600;
  color: #1f2d3d;

  i {
    color: #f59e0b;
  }
}

.close-btn {
  width: 24px;
  height: 24px;
  border: 1px solid #dcdfe6;
  border-radius: 2px;
  background: #fff;
  cursor: pointer;
  color: #909399;
}

.panel-content {
  max-height: 356px;
  overflow-y: auto;
  padding: 8px 10px;
}

.empty {
  padding: 16px 0;
  text-align: center;
  color: #909399;
  font-size: 13px;
}

.rank-item {
  min-height: 38px;
  display: grid;
  grid-template-columns: 28px 1fr auto;
  align-items: center;
  gap: 8px;
  padding: 6px 4px;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.2s ease;

  &:hover {
    background: rgba(24, 144, 255, 0.08);
  }
}

.rank-no {
  font-weight: 700;
  color: #606266;
}

.rank-title {
  font-size: 13px;
  color: #303133;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.rank-views {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: #909399;
}



.hot-rank-panel-enter-active,
.hot-rank-panel-leave-active {
  transition: opacity 300ms ease, transform 300ms ease;
}

.hot-rank-panel-enter,
.hot-rank-panel-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

@media (max-width: 768px) {
  .hot-rank-btn {
    top: 72px;
    left: 12px;
    width: 44px;
    height: 44px;
  }

  .hot-rank-panel {
    width: min(320px, calc(100vw - 24px));
  }
}
</style>
