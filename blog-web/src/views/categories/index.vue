<template>
    <div class="categories-page">
      <div class="content-layout">
        <main class="main-content">
          <div class="content-card">
            <div class="categories-nav">
              <div 
                v-for="category in categories"
                :key="category.name"
                class="category-tab"
                :class="{ active: activeCategory === category.name }"
                @click="scrollToCategory(category.name)"
              >
                <i class="fas fa-folder-open"></i>
                <span>{{ category.name }}</span>
              </div>
            </div>
  
            <div class="categories-list">
              <transition name="fade-transform" mode="out-in">
                <div 
                  v-if="currentCategory"
                  :key="currentCategory.name"
                  class="category-group"
                >
                  <div class="category-header">
                    <h2 class="category-name">
                      <i class="fas fa-folder-open"></i>
                      {{ currentCategory.name }}
                      <span class="post-count">{{ currentCategory.posts.length }} 篇文章</span>
                    </h2>
                  </div>
                  <div v-if="currentCategory.loading" class="loading-state">
                    <i class="fas fa-spinner fa-spin"></i>
                    加载中...
                  </div>
                  <div v-else-if="currentCategory.posts.length === 0" class="empty-state">
                    暂无文章
                  </div>
                  <div v-else class="posts-list">
                    <div 
                      v-for="post in currentCategory.posts" 
                      :key="post.id"
                      class="post-item"
                      @click="goToPost(post.id)"
                    >
                      <div class="post-cover">
                        <img :src="normalizeImageUrl(post.cover) || `/gallery/article-${post.id}.jpg`" alt="文章封面">
                      </div>
                      <div class="post-info">
                        <h3 class="post-title">{{ post.title }}</h3>
                      </div>
                    </div>
                  </div>
                </div>
              </transition>
            </div>
  
            <div v-if="loading" class="loading-state">
              <i class="fas fa-spinner fa-spin"></i>
              加载中...
            </div>
          </div>
        </main>
        <Sidebar />
      </div>
    </div>
  </template>
  
  <script>
  import gsap from 'gsap'
  import ScrollTrigger from 'gsap/ScrollTrigger'
  import Sidebar from '@/components/Sidebar/index.vue'
  import { getAllCategoriesApi, getArticlesApi } from '@/api/article'
  import { normalizeImageUrl } from '@/utils/url'

  gsap.registerPlugin(ScrollTrigger)
  
  export default {
    name: 'Categories',
    components: {
      Sidebar
    },

    data() {
      return {
        activeCategory: null,
        categories:[],
        loading:false
      }
    },
    computed: {
      currentCategory() {
        return this.categories.find(c => c.name === this.activeCategory) || null;
      }
    },
    methods: {
      normalizeImageUrl,
      async ensureCategoryLoaded(category) {
        if (!category || category.loaded || category.loading) return
        category.loading = true
        try {
          const res = await getArticlesApi({
            categoryId: category.id,
            pageNum: 1,
            pageSize: 1000
          })
          const posts = (res.data && res.data.records) ? res.data.records : ((res.data && res.data.rows) ? res.data.rows : (Array.isArray(res.data) ? res.data : []))
          this.$set(category, 'posts', posts)
          this.$set(category, 'loaded', true)
        } finally {
          this.$set(category, 'loading', false)
        }
      },
      goToPost(id) {
        this.$router.push(`/post/${id}`)
      },
 
      scrollToCategory(categoryName) {
        const category = this.categories.find(c => c.name === categoryName)
        this.activeCategory = categoryName
        this.ensureCategoryLoaded(category)
        // 移除滚动定位逻辑
      }
    },
    async created() {
      this.loading = true
      try {
        const res = await getAllCategoriesApi()
        this.categories = (res.data || []).map(c => ({
          id: c.id,
          name: c.name,
          posts: [],
          loaded: false,
          loading: false
        }))
        if (this.categories.length > 0) {
          this.activeCategory = this.categories[0].name
          // Load all categories initially instead of just the first one
          for (const category of this.categories) {
            this.ensureCategoryLoaded(category)
          }
        }
      } finally {
        this.loading = false
      }
    },
    mounted() {
      // 移除滚动监听
    },
    beforeDestroy() {
      // 移除滚动监听
    }
  }
  </script>
  
  <style lang="scss" scoped>
  .fade-transform-enter-active,
  .fade-transform-leave-active {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .fade-transform-enter {
    opacity: 0;
    transform: translateX(20px);
  }
  .fade-transform-leave-to {
    opacity: 0;
    transform: translateX(-20px);
  }

  .categories-page {
    max-width: 1400px;
    margin: 0 auto;
  }
  
  .content-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 320px;
    gap: $spacing-xl * 2;
    padding: $spacing-lg;
    min-height: calc(100vh - 80px);
    align-items: start;
    
    @include responsive(lg) {
      grid-template-columns: 1fr;
      padding: $spacing-lg;
    }
    
    @include responsive(md) {
      padding: $spacing-md;
    }
  }
  
  .main-content {
    min-width: 0;
    height: 100%;
  }
  
  .content-card {
    background: var(--card-bg);
    border-radius: $border-radius-lg;
    box-shadow: $shadow-md;
    padding: $spacing-lg;
  }
  
  .categories-nav {
    position: sticky;
    top: 80px;
    z-index: 10;
    background: var(--card-bg);
    margin: -$spacing-lg;
    margin-bottom: $spacing-lg;
    padding: $spacing-md $spacing-lg;
    border-bottom: 1px solid var(--border-color);
    display: flex;
    gap: $spacing-sm;
    overflow-x: auto;
    scrollbar-width: none;
    -ms-overflow-style: none;
    border-top-left-radius: $border-radius-lg;
    border-top-right-radius: $border-radius-lg;

    &::-webkit-scrollbar {
      display: none;
    }
  
    .category-tab {
      padding: $spacing-xs $spacing-md;
      border-radius: $border-radius-lg;
      background: var(--hover-bg);
      color: var(--text-secondary);
      cursor: pointer;
      transition: all 0.3s ease;
      white-space: nowrap;
      display: flex;
      align-items: center;
      gap: $spacing-xs;
      font-size: 0.9em;
  
      i {
        font-size: 0.9em;
      }
  
      &:hover {
        transform: translateY(-2px);
      }
  
      &.active {
        background: $primary;
        color: white;
      }
    }
  }
  
  .category-group {
    margin-bottom: $spacing-xl * 2;
    scroll-margin-top: 100px;
  
    &:last-child {
      margin-bottom: 0;
    }
  }
  
  .category-header {
    margin-bottom: $spacing-lg;
    padding-bottom: $spacing-sm;
    border-bottom: 2px solid rgba($primary, 0.1);
    position: relative;
  
    &::after {
      content: '';
      position: absolute;
      bottom: -2px;
      left: 0;
      width: 50px;
      height: 2px;
      background: $primary;
    }
  
    .category-name {
      font-size: 1.5em;
      color: var(--text-primary);
      display: flex;
      align-items: center;
      gap: $spacing-sm;
  
      i {
        color: $primary;
        font-size: 1em;
        width: 24px;
        text-align: center;
        opacity: 0.8;
      }
  
      .post-count {
        font-size: 0.5em;
        color: var(--text-secondary);
        margin-left: auto;
        padding: $spacing-xs $spacing-sm;
        background: var(--hover-bg);
        border-radius: $border-radius-lg;
      }
    }
  }
  
  .post-item {
    display: flex;
    align-items: center;
    gap: $spacing-xl;
    padding: $spacing-md;
    border-radius: $border-radius-md;
    cursor: pointer;
    transition: all 0.3s ease;
  
    &:hover {
      background: var(--hover-bg);
      transform: translateX(10px);
  
      .post-cover {
        img {
          transform: scale(1.1);
        }
      }
    }
  
    .post-cover {
      width: 60px;
      height: 45px;
      border-radius: $border-radius-sm;
      overflow: hidden;
      flex-shrink: 0;
      
      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
      }
    }
  
    .post-info {
      flex: 1;
      min-width: 0;
  
      .post-title {
        color: var(--text-primary);
        font-size: 1em;
        margin-bottom: 0;
        transition: color 0.3s ease;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
  
        &:hover {
          color: $primary;
        }
      }
    }
  }
  
  .loading-state {
    text-align: center;
    padding: $spacing-xl;
    color: var(--text-secondary);
    font-size: 1.1em;
  
    i {
      margin-right: $spacing-sm;
    }
  }

  .empty-state {
    text-align: center;
    padding: $spacing-lg;
    color: var(--text-secondary);
  }
  
  @include responsive(md) {
    .categories-page {
      padding: $spacing-lg;
    }
  
    .content-card {
      padding: $spacing-lg;
    }
  
    .categories-nav {
      top: 64px;
      margin: -$spacing-lg;
      margin-bottom: $spacing-lg;
      padding: $spacing-sm $spacing-lg;
    }
  }
  
  @include responsive(sm) {
    .categories-page {
      padding: $spacing-md;
    }
  
    .content-card {
      padding: $spacing-md;
      border-radius: 0;
      margin: -$spacing-md;
    }
  
    .post-item {
      gap: $spacing-md;
  
      .post-cover {
        width: 50px;
        height: 38px;
      }
    }
  
    .categories-nav {
      margin: -$spacing-md;
      margin-bottom: $spacing-md;
      padding: $spacing-sm;
      
      .category-tab {
        padding: $spacing-xs $spacing-sm;
        font-size: 0.85em;
      }
    }
  }
  </style> 
  
