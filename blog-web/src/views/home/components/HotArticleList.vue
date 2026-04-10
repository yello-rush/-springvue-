<template>
  <div class="hot-article-list" :class="{ 'is-dock': dock && dockEnabled, 'is-open': !collapsed }" :style="dock && dockEnabled ? dockStyle : null">
    <div
      v-if="dock && dockEnabled"
      class="dock-fab"
      @click.stop="toggleCollapse"
      :title="collapsed ? '展开热榜' : '收起热榜'"
    >
      <i class="el-icon-trophy"></i>
    </div>
    <div class="list-header">
      <h3 class="title">
        <i class="el-icon-trophy"></i>
        <span v-show="!collapsed">文章热榜</span>
        <el-button
          type="text"
          :icon="collapsed ? 'el-icon-plus' : 'el-icon-minus'"
          class="collapse-btn"
          @click.stop="toggleCollapse"
          :title="collapsed ? '展开热榜' : '收起热榜'"
        ></el-button>
        <el-button 
          type="text" 
          icon="el-icon-refresh" 
          class="refresh-btn" 
          :class="{'is-loading': loading}"
          @click="loadData(true)"
          title="强制刷新"
          v-show="!collapsed"
        ></el-button>
      </h3>
      <div class="order-tabs" role="tablist" v-show="!collapsed">
        <span 
          class="order-tab" 
          role="tab"
          :aria-selected="orderBy === 'likes'"
          tabindex="0"
          :class="{ active: orderBy === 'likes' }" 
          @click="changeOrderBy('likes')"
          @keydown.enter="changeOrderBy('likes')"
        >点赞榜</span>
        <span 
          class="order-tab" 
          role="tab"
          :aria-selected="orderBy === 'views'"
          tabindex="0"
          :class="{ active: orderBy === 'views' }" 
          @click="changeOrderBy('views')"
          @keydown.enter="changeOrderBy('views')"
        >阅读榜</span>
      </div>
    </div>
    <div
      class="collapsible"
      ref="collapsible"
      :style="{ maxHeight: collapsibleMaxHeight + 'px', opacity: collapsibleOpacity }"
      @transitionend="onCollapsibleTransitionEnd"
    >
      <div class="collapsible-inner" ref="collapsibleInner">
        <div class="list-tabs">
          <div class="tabs" role="tablist">
            <span 
              v-for="tab in tabs" 
              :key="tab.value" 
              role="tab"
              :aria-selected="currentTab === tab.value"
              tabindex="0"
              :class="{ active: currentTab === tab.value }"
              @click="changeTab(tab.value)"
              @keydown.enter="changeTab(tab.value)"
            >
              {{ tab.label }}
            </span>
          </div>
        </div>
        
        <div class="list-content" v-loading="loading" @scroll="handleScroll" ref="scrollContainer">
          <el-empty v-if="!loading && list.length === 0" description="暂无数据"></el-empty>
          <div v-for="(item, index) in list" :key="item.id" class="list-item" @click="goToPost(item.id)" tabindex="0" @keydown.enter="goToPost(item.id)">
            <div class="rank" :class="'rank-' + (index + 1)">{{ index + 1 }}</div>
            <div class="info">
              <h4 class="item-title" :title="item.title">{{ item.title }}</h4>
              <div class="meta">
                <span class="meta-item" aria-label="阅读量"><i class="el-icon-view" aria-hidden="true"></i> {{ formatNumber(getViewCount(item)) }}</span>
                <span class="meta-item" aria-label="点赞数"><i class="far fa-heart" aria-hidden="true"></i> {{ formatNumber(getLikeCount(item)) }}</span>
              </div>
            </div>
            <div class="thumb" v-if="item.cover || true">
              <img :src="normalizeImageUrl(item.cover) || `/gallery/article-${item.id}.jpg`" loading="lazy" :alt="item.title" width="64" height="48">
            </div>
          </div>
          <div v-if="loading" class="loading-text">加载中...</div>
          <div v-if="noMore && list.length > 0" class="no-more">到底啦 ~</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ArticleService from '@/services/articleService'
import { getViewCount, getLikeCount } from "@/utils/article";
import { normalizeImageUrl } from "@/utils/url";

export default {
  name: "HotArticleList",
  props: {
    dock: { type: Boolean, default: false }
  },
  data() {
    return {
      collapsed: localStorage.getItem('hotArticleCollapsed') === '1',
      dockEnabled: false,
      dockWidth: 320,
      currentTab: "day",
      orderBy: localStorage.getItem('hotArticleOrderBy') || 'likes',
      tabs: [
        { label: "日榜", value: "day" },
        { label: "周榜", value: "week" },
        { label: "月榜", value: "month" }
      ],
      list: [],
      loading: false,
      offset: 0,
      limit: 10,
      noMore: false,
      collapsibleMaxHeight: 0,
      collapsibleOpacity: 0,
      isCollapsibleAnimating: false,
      collapseTarget: null
    };
  },
  computed: {
    dockStyle() {
      return {
        width: this.dockWidth + 'px',
        '--dock-width': this.dockWidth + 'px'
      }
    }
  },
  mounted() {
    this.loadData();
    if (this.dock) {
      this.updateDockPlacement();
      window.addEventListener('resize', this.updateDockPlacement, { passive: true });
    }
    this.$nextTick(() => {
      this.syncCollapsibleImmediate();
    });
  },
  beforeDestroy() {
    if (this.dock) {
      window.removeEventListener('resize', this.updateDockPlacement);
    }
  },
  methods: {
    normalizeImageUrl,
    getViewCount,
    getLikeCount,
    handleDockClick() {
      if (this.dock && this.collapsed) {
        this.toggleCollapse()
      }
    },
    toggleCollapse() {
      if (this.isCollapsibleAnimating) return
      if (this.collapsed) {
        this.collapsed = false
        localStorage.setItem('hotArticleCollapsed', '0')
        this.$nextTick(() => {
          this.expandCollapsible()
          if (this.list.length === 0) this.loadData()
        })
        return
      }
      this.collapseTarget = true
      this.collapseCollapsible()
    },
    updateDockPlacement() {
      if (!this.dock) {
        this.dockEnabled = false
        return
      }
      if (typeof window === 'undefined') return
      if (window.innerWidth <= 1024) {
        this.dockEnabled = false
        return
      }
      this.dockEnabled = true
      const container = document.querySelector('.home-container')
      const rect = container ? container.getBoundingClientRect() : null
      const contentRight = rect ? rect.right : Math.floor(window.innerWidth * 0.7)
      const gutter = Math.max(0, window.innerWidth - contentRight)
      const maxWidth = 320
      const minWidth = 260
      const available = gutter - 32
      this.dockWidth = Math.min(maxWidth, Math.max(minWidth, Math.floor(available)))
    },
    syncCollapsibleImmediate() {
      if (this.collapsed) {
        this.collapsibleMaxHeight = 0
        this.collapsibleOpacity = 0
        return
      }
      const inner = this.$refs.collapsibleInner
      if (!inner) return
      const height = inner.getBoundingClientRect().height
      this.collapsibleMaxHeight = Math.ceil(height)
      this.collapsibleOpacity = 1
    },
    expandCollapsible() {
      const inner = this.$refs.collapsibleInner
      if (!inner) return
      this.isCollapsibleAnimating = true
      this.collapseTarget = false
      this.collapsibleMaxHeight = 0
      this.collapsibleOpacity = 0
      requestAnimationFrame(() => {
        const height = inner.getBoundingClientRect().height
        this.collapsibleMaxHeight = Math.ceil(height)
        this.collapsibleOpacity = 1
      })
    },
    collapseCollapsible() {
      const inner = this.$refs.collapsibleInner
      if (!inner) return
      this.isCollapsibleAnimating = true
      const height = inner.getBoundingClientRect().height
      this.collapsibleMaxHeight = Math.ceil(height)
      this.collapsibleOpacity = 1
      requestAnimationFrame(() => {
        this.collapsibleMaxHeight = 0
        this.collapsibleOpacity = 0
      })
    },
    onCollapsibleTransitionEnd(e) {
      if (e.target !== this.$refs.collapsible) return
      if (e.propertyName !== 'max-height') return
      if (!this.isCollapsibleAnimating) return
      if (this.collapseTarget) {
        this.collapsed = true
        localStorage.setItem('hotArticleCollapsed', '1')
        this.collapseTarget = null
      }
      this.isCollapsibleAnimating = false
    },
    handleScroll(e) {
      const { scrollTop, scrollHeight, clientHeight } = e.target;
      if (scrollTop + clientHeight >= scrollHeight - 10) {
        this.loadData();
      }
    },
    changeTab(tab) {
      if (this.currentTab === tab) return;
      this.currentTab = tab;
      this.list = [];
      this.offset = 0;
      this.noMore = false;
      this.loadData();
    },
    changeOrderBy(order) {
      if (this.orderBy === order) return;
      this.orderBy = order;
      localStorage.setItem('hotArticleOrderBy', order);
      this.list = [];
      this.offset = 0;
      this.noMore = false;
      this.loadData();
    },
    loadData(forceRefresh = false) {
      if (this.loading || (this.noMore && !forceRefresh)) return;
      if (forceRefresh) {
        this.offset = 0;
        this.list = [];
        this.noMore = false;
      }
      this.loading = true;
      ArticleService.getHotArticles(this.currentTab, forceRefresh, this.offset, this.limit, this.orderBy).then(res => {
        const data = res.data || [];
        if (data.length > 0) {
          this.list = [...this.list, ...data];
          this.$store.commit('SET_HOT_ARTICLES', { period: this.currentTab, data: this.list });
          this.offset += data.length;
          if (data.length < this.limit) {
            this.noMore = true;
          }
          if (forceRefresh) {
            this.$message.success('热榜数据已更新');
          }
        } else {
          this.noMore = true;
        }
      }).catch(err => {
        console.error("Failed to load hot articles:", err);
      }).finally(() => {
        this.loading = false;
        if (!this.collapsed) {
          this.$nextTick(() => {
            if (!this.isCollapsibleAnimating) this.syncCollapsibleImmediate()
          })
        }
      });
    },
    goToPost(id) {
      this.$router.push(`/article/${id}`);
    },
    formatNumber(num) {
      const val = Number(num);
      if (isNaN(val)) return 0;
      if (val >= 100000000) return (val / 100000000).toFixed(1) + '亿';
      if (val >= 10000) return (val / 10000).toFixed(1) + 'w';
      return val;
    }
  }
};
</script>

<style lang="scss" scoped>
.hot-article-list.is-dock {
  position: fixed;
  right: calc(-1 * var(--dock-width, 320px));
  top: 30%;
  width: var(--dock-width, 320px);
  z-index: 9999;
  margin-bottom: 0;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 12px 0 0 12px;
  border-right: none;
}

.hot-article-list.is-dock.is-open {
  right: 0;
}

.dock-fab {
  position: absolute;
  left: -44px;
  top: 20px;
  width: 44px;
  height: 44px;
  border-radius: 10px 0 0 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  background: rgba(var(--surface-rgb), 0.55);
  border: 1px solid rgba(var(--border-color-rgb), 0.16);
  border-right: none;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  box-shadow: -4px 0 8px rgba(0,0,0,0.05);
  color: var(--text-primary);
  user-select: none;
  font-size: 1.2rem;
}

.dock-fab i {
  transition: transform 0.3s;
}
.hot-article-list.is-dock.is-open .dock-fab i {
  transform: rotate(180deg);
}

.collapse-btn {
  margin-left: 6px;
  padding: 0;
  color: var(--text-secondary);
  &:hover {
    color: var(--primary-color);
  }
}

.refresh-btn {
  margin-left: 10px;
  padding: 0;
  color: var(--text-secondary);
  &:hover {
    color: var(--primary-color);
  }
  &.is-loading i {
    animation: rotating 2s linear infinite;
  }
}
@keyframes rotating {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
.hot-article-list {
  background: rgba(var(--surface-rgb), 0.42);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(var(--border-color-rgb), 0.12);
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
  margin-bottom: 20px;
  position: relative;
}

.collapsible {
  max-height: 0;
  opacity: 0;
  overflow: hidden;
  transition: max-height 300ms ease-in-out, opacity 300ms ease-in-out;
  will-change: max-height, opacity;
}

.collapsible-inner {
  padding-top: 0;
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;

  .title {
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0;
    display: flex;
    align-items: center;
    
    i {
      color: #f59e0b;
      margin-right: 5px;
    }
  }

  .order-tabs {
    display: flex;
    gap: 10px;
    
    .order-tab {
      font-size: 12px;
      color: var(--text-secondary);
      cursor: pointer;
      transition: all 0.2s;
      
      &:hover {
        color: #1890ff;
      }
      
      &:focus-visible {
        outline: 2px solid #1890ff;
        border-radius: 2px;
      }
      
      &.active {
        color: #1890ff;
        font-weight: 600;
      }
    }
  }
}

.list-tabs {
  margin-bottom: 15px;
  
  .tabs {
    display: flex;
    gap: 15px;
    border-bottom: 1px solid var(--border-color);
    padding-bottom: 10px;

    span {
      font-size: 0.9rem;
      color: var(--text-secondary);
      cursor: pointer;
      position: relative;
      transition: color 0.3s;
      
      &:focus-visible {
        outline: 2px solid #1890ff;
        border-radius: 2px;
      }

      &.active {
        color: var(--theme-color, #1890ff);
        font-weight: 600;

        &::after {
          content: '';
          position: absolute;
          bottom: -11px;
          left: 0;
          width: 100%;
          height: 2px;
          background: var(--theme-color, #1890ff);
          border-radius: 2px;
        }
      }
    }
  }
}

.list-content {
  max-height: 450px;
  overflow-y: auto;
  padding-right: 5px;
  
  /* 自定义滚动条 */
  &::-webkit-scrollbar {
    width: 4px;
  }
  &::-webkit-scrollbar-thumb {
    background: rgba(0, 0, 0, 0.1);
    border-radius: 4px;
  }
  &::-webkit-scrollbar-track {
    background: transparent;
  }

  .loading-text {
    text-align: center;
    padding: 10px;
    font-size: 0.8rem;
    color: var(--text-secondary);
  }

  .empty {
    text-align: center;
    color: var(--text-secondary);
    padding: 30px 0;
    font-size: 0.9rem;
  }

  .list-item {
    display: flex;
    align-items: center;
    padding: 12px 0;
    border-bottom: 1px solid var(--border-color);
    cursor: pointer;
    transition: all 0.3s;
    
    &:last-child {
      border-bottom: none;
    }
    
    .rank {
      width: 24px;
      height: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 0.9rem;
      border-radius: 4px;
      background: var(--bg-color-page);
      color: var(--text-secondary);
      margin-right: 12px;
      flex-shrink: 0;
      
      &.rank-1 {
        background: #ff4d4f;
        color: #fff;
      }
      
      &.rank-2 {
        background: #ff7a45;
        color: #fff;
      }
      
      &.rank-3 {
        background: #ffa940;
        color: #fff;
      }
    }
    
    .info {
      flex: 1;
      min-width: 0; // Fix text overflow
      margin-right: 10px;
      
      .item-title {
        font-size: 0.95rem; /* 稍微缩小文章标题以适应小空间 */
        line-height: 1.5;
        color: var(--text-primary);
        margin-bottom: 6px;
        white-space: normal; /* 允许换行，避免标题被截断 */
        display: -webkit-box;
        -webkit-line-clamp: 2; /* 最多显示两行 */
        -webkit-box-orient: vertical;
        overflow: hidden;
        font-weight: 500;
        transition: color 0.3s ease;
      }
      
      .meta {
        display: flex;
        gap: 12px;
        font-size: 0.8rem;
        color: var(--text-secondary);
        
        .meta-item {
          display: flex;
          align-items: center;
          gap: 4px;
          
          i {
            font-size: 0.85rem;
            color: #909399;
          }
        }
      }
    }
    
    .thumb {
      width: 64px;
      height: 48px;
      border-radius: 6px;
      overflow: hidden;
      flex-shrink: 0;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      
      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
      }
    }
    
    &:hover {
      background: linear-gradient(to right, rgba(24, 144, 255, 0.05), transparent);
      padding-left: 8px; // Slide effect
      border-radius: 8px;
      
      .item-title {
        color: #1890ff;
      }
      .thumb img {
        transform: scale(1.05);
      }
    }
    
    &:focus-visible {
      outline: 2px solid #1890ff;
      outline-offset: -2px;
      border-radius: 8px;
      background: rgba(24, 144, 255, 0.05);
    }
  }
  
  .no-more {
    text-align: center;
    padding: 15px 0 5px;
    color: var(--text-secondary);
    font-size: 0.8rem;
    opacity: 0.7;
  }
}
</style>
