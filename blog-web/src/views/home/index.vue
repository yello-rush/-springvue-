<template>
  <div class="home">
    <div class="home-container">
      
      <!-- Layout: Left Main (Carousel + Articles), Right Sidebar -->
      <div class="main-content-wrapper">
        
        <!-- Left Column -->
        <div class="left-column">
          <!-- Carousel Area -->
          <div class="carousel-section" v-if="carouselItems && carouselItems.length > 0">
             <Carousel :slides="carouselItems" @click="goToPost" />
          </div>

          <!-- Article Filter -->
          <div class="category-filter">
            <el-radio-group v-model="activeName" @input="handleCategoryChange" size="small">
              <el-radio-button label="all" class="category-btn">全部</el-radio-button>
              <el-radio-button 
                v-for="category in categories" 
                :key="category.id" 
                :label="String(category.id)"
                class="category-btn"
              >
                {{ category.name }}
              </el-radio-button>
            </el-radio-group>
          </div>

          <!-- Article List -->
          <ArticleList
            :articles="articleList"
            :loading="loading"
            :total="total"
            :params="params"
            @article-click="goToPost"
            @page-change="changePage"
            class="article-list"
          />
        </div>

        <!-- Right Column (Sidebar) -->
        <div class="right-column">
          <AuthorCard />
          <Sidebar />
          <div class="sticky-sidebar">
            <HotArticleList dock />
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script>
import ArticleList from "@/components/ArticleList/index.vue";
import Sidebar from "@/components/Sidebar/index.vue";
import AuthorCard from "./components/AuthorCard.vue";
import Carousel from "./components/carousel.vue";
import {
  getArticlesApi,
  getAllCategoriesApi,
  getCarouselArticlesApi
} from "@/api/article";
import HotArticleList from "./components/HotArticleList.vue";
import { normalizeImageUrl } from "@/utils/url";

export default {
  name: "Home",
  components: {
    ArticleList,
    Sidebar,
    HotArticleList,
    AuthorCard,
    Carousel
  },
  data() {
    return {
      total: 0,
      params: {
        pageNum: 1,
        pageSize: 10, 
        categoryId: null
      },
      articleList: [],
      loading: false,
      activeName: "all",
      categories: [],
      carouselItems: [],
      carouselTimer: null,
      activeCarouselIndex: 0
    };
  },
  methods: {
    normalizeImageUrl,
    getCoverBg(cover) {
      const url = normalizeImageUrl(cover);
      return url ? `url(${url})` : '';
    },
    onCarouselChange(cur) {
      this.activeCarouselIndex = cur;
    },
    handleCategoryChange(val) {
      this.params.categoryId = val === "all" ? null : val;
      this.params.pageNum = 1;
      this.getArticleList();
    },
    goToPost(id) {
      this.$router.push(`/post/${id}`);
    },
    changePage(page) {
      this.params.pageNum = page;
      this.getArticleList();
      window.scrollTo({ top: 400, behavior: 'smooth' });
    },
    getArticleList() {
      this.loading = true;
      getArticlesApi(this.params)
        .then((res) => {
          if (res && res.data && res.data.records) {
            this.articleList = res.data.records;
            this.total = res.data.total;
          } else {
            this.articleList = [];
            this.total = 0;
          }
        })
        .catch((error) => {
          console.error("Failed to fetch articles:", error);
          this.articleList = [];
          this.total = 0;
        })
        .finally(() => {
          this.loading = false;
        });
    },
    fetchCarouselData() {
      // 获取轮播图数据
      getCarouselArticlesApi().then(res => {
        if (res && res.data && res.data.length > 0) {
          this.carouselItems = res.data.map((item) => ({
            ...item,
            image_url: this.normalizeImageUrl(item.cover),
            link: `/post/${item.id}`,
            title: item.title,
            summary: item.summary
          }));
        } else {
          this.carouselItems = [];
        }
      }).catch(err => {
        console.error("Failed to fetch carousel:", err);
      });
    },
    getAllCategories() {
      getAllCategoriesApi().then((res) => {
        this.categories = res.data;
      });
    },
  },
  created() {
    this.getArticleList();
    this.getAllCategories();
    this.fetchCarouselData();
    // Poll carousel data every 30 seconds
    this.carouselTimer = setInterval(this.fetchCarouselData, 30000);
  },
  beforeDestroy() {
    if (this.carouselTimer) {
      clearInterval(this.carouselTimer);
    }
  }
};
</script>

<style lang="scss" scoped>
.home {
  width: 100%;
  min-height: 100vh;
  background-color: transparent; /* Changed to transparent to show dynamic background */
  padding-top: 80px; // Space for fixed header
}

.home-container {
  max-width: 1300px;
  margin: 0 auto;
  padding: 0 20px 40px;
}

.main-content-wrapper {
  display: flex;
  gap: 25px;
}

.left-column {
  flex: 1;
  min-width: 0; // Prevent flex item overflow
}

.right-column {
  width: 320px;
  flex-shrink: 0;
  /* 移除这里的 sticky，改在内部组件按需设置，避免长侧边栏底部被截断 */
  display: flex;
  flex-direction: column;
  gap: 20px;

  .sticky-sidebar {
    position: sticky;
    top: 100px; /* 增加与 header 的距离，确保不被遮挡 */
    align-self: flex-start; /* 解决 flex 容器内 sticky 失效问题 */
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 20px;
    /* 粘性区域不再设置 overflow，让内部组件自己处理或随页面滚动 */
  }
}

/* Carousel Styles */
.carousel-section {
  margin-bottom: 30px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 8px 20px rgba(0,0,0,0.05);
  border: 1px solid var(--border-color, transparent);
}

/* Filter Styles */
.category-filter {
  margin-bottom: 25px;
  background: var(--card-bg);
  padding: 15px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 10px;
  overflow-x: auto;
  box-shadow: 0 2px 12px rgba(0,0,0,0.03);
  
  &::-webkit-scrollbar {
    height: 4px;
  }
  
  &::-webkit-scrollbar-thumb {
    background: #eee;
    border-radius: 2px;
  }
  
  :deep(.category-btn) {
    .el-radio-button__inner {
      border: none !important;
      background: transparent !important;
      padding: 8px 20px !important;
      border-radius: 20px !important;
      margin-right: 10px !important;
      box-shadow: none !important;
      color: var(--text-secondary) !important;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
      position: relative;
      overflow: hidden;
      
      &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        width: 0;
        height: 2px;
        background: #1a3b5d;
        transition: all 0.3s ease;
        transform: translateX(-50%);
      }

      &:hover {
        color: #1a3b5d !important;
        background: rgba(26, 59, 93, 0.05) !important;
        
        &::after {
          width: 40%;
        }
      }
    }
    
    &.is-active .el-radio-button__inner {
      background-color: #1a3b5d !important; // Direct use of $primary value for safety
      color: white !important;
      box-shadow: 0 4px 12px rgba(26, 59, 93, 0.2) !important;
      
      &::after {
        display: none;
      }
    }
  }
}

@media (max-width: 1200px) {
  .right-column {
    width: 280px;
  }
}

@media (max-width: 1024px) {
  .right-column {
    display: none; // Hide sidebar on tablet
  }
}

@media (max-width: 768px) {
  .home {
    padding-top: 60px;
  }

  .home-container {
    padding: 0 15px 30px;
  }
  
  .custom-carousel {
    :deep(.el-carousel__container) {
      height: 240px !important; // Increase mobile height slightly
    }
  }

  .carousel-content {
    .carousel-mask {
      padding: 15px;
      
      h3 {
        font-size: 1.1rem;
        margin-bottom: 4px;
      }
      
      p {
        font-size: 0.8rem;
        -webkit-line-clamp: 1;
        margin-bottom: 8px;
      }
      
      .el-button {
        padding: 6px 12px;
        font-size: 12px;
      }
    }
  }
}
</style>
