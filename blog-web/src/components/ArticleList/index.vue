<template>
  <div class="article-list-component">
    <TransitionLoader :loading="loading" :duration="500" :skeletonCount="6">
      <transition-group name="post-list" tag="div" class="posts-grid">
        <article v-for="post in articles" :key="post.id" class="post-card" @click="$emit('article-click', post.id)">
          <div class="card-cover">
            <img v-lazy="getArticleCover(post)" :key="getArticleCover(post)" :alt="post.title">
            <div class="card-category">{{ post.categoryName }}</div>
          </div>
          
          <div class="card-content">
            <h3 class="card-title">{{ post.title }}</h3>
            <p class="card-summary">{{ post.summary }}</p>
            
            <div class="card-footer">
              <div class="meta-info">
                <el-tooltip class="item" effect="dark" :content="'发布日期: ' + getPublishTime(post)" placement="top" :open-delay="300" :hide-after="150">
                  <span class="date"><i class="far fa-calendar-alt"></i> {{ getPublishTime(post) }}</span>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" :content="'预计阅读时间: ' + getEstimatedReadTime(post) + ' min'" placement="top" :open-delay="300" :hide-after="150">
                  <span class="read-time"><i class="far fa-clock"></i> {{ getEstimatedReadTime(post) }} min</span>
                </el-tooltip>
              </div>
              <div class="stats">
                <el-tooltip class="item" effect="dark" :content="'查看数: ' + getViewCount(post)" placement="top" :open-delay="300" :hide-after="150">
                  <span><i class="far fa-eye"></i> {{ getViewCount(post) }}</span>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" :content="'点赞数: ' + getLikeCount(post)" placement="top" :open-delay="300" :hide-after="150">
                  <span><i class="far fa-heart"></i> {{ getLikeCount(post) }}</span>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" :content="'收藏数: ' + getFavoriteCount(post)" placement="top" :open-delay="300" :hide-after="150">
                  <span><i class="fas fa-star"></i> {{ getFavoriteCount(post) }}</span>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" :content="'评论数: ' + (post.commentNum || 0)" placement="top" :open-delay="300" :hide-after="150">
                  <span><i class="far fa-comment"></i> {{ post.commentNum || 0 }}</span>
                </el-tooltip>
              </div>
            </div>
          </div>
        </article>
      </transition-group>

      <el-empty v-if="!loading && articles.length === 0" description="暂无文章" />

      <div class="pagination-box" v-if="articles.length">
        <el-pagination 
          background 
          @current-change="$emit('page-change', $event)"
          :current-page="params.pageNum" 
          :page-size="params.pageSize" 
          layout="prev, pager, next" 
          :total="total">
        </el-pagination>
      </div>
    </TransitionLoader>
  </div>
</template>

<script>
import { formatTime } from '@/utils/time'
import TransitionLoader from '@/components/common/TransitionLoader.vue'
import { getPublishTime, getViewCount, getEstimatedReadTime, getLikeCount, getFavoriteCount } from "@/utils/article";
import { normalizeImageUrl } from '@/utils/url'

export default {
  name: 'ArticleList',
  components: {
    TransitionLoader
  },
  props: {
    articles: {
      type: Array,
      required: true
    },
    loading: {
      type: Boolean,
      default: false
    },
    total: {
      type: Number,
      default: 0
    },
    params: {
      type: Object,
      default: () => ({
        pageNum: 1,
        pageSize: 10
      })
    }
  },
  methods: {
    getPublishTime,
    getViewCount,
    getEstimatedReadTime,
    getLikeCount,
    getFavoriteCount,
    getArticleCover(post) {
      if (post.cover) {
        return normalizeImageUrl(post.cover);
      }
      // If no cover, try to match local image by article id
      return `/gallery/article-${post.id}.jpg`;
    },
    formatTime(time) {
      if (!time) return '';
      return formatTime(time).split(' ')[0] // 只显示日期
    },
    formatDateTime(time) {
      if (!time) return '';
      // Assuming time is YYYY-MM-DD HH:mm:ss
      return time.substring(0, 16);
    }
  }
}
</script>

<style lang="scss" scoped>
.posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  
  @media (max-width: 640px) {
    grid-template-columns: 1fr;
  }
}

.post-card {
  background: var(--surface);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 10px 30px -10px rgba(0,0,0,0.05);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  height: 100%;
  display: flex;
  flex-direction: column;
  
  &:hover {
    transform: translateY(-8px);
    box-shadow: 0 20px 40px -15px rgba(0,0,0,0.1);
    
    .card-cover img {
      transform: scale(1.05);
    }
  }
}

.card-cover {
  position: relative;
  padding-top: 50%; // 2:1 aspect ratio, more compact
  overflow: hidden;
  
  img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
  }
  
  .card-category {
    position: absolute;
    top: 12px;
    left: 12px;
    background: var(--primary);
    color: white;
    padding: 4px 10px;
    border-radius: 4px;
    font-size: 0.7rem;
    font-weight: 600;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    z-index: 2;
    transition: all 0.3s;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    
    &:hover {
      transform: scale(1.05);
      background: lighten(#1a3b5d, 10%); // lighten $primary
    }
  }
}

.card-content {
  padding: 16px 20px;
  display: flex;
  flex-direction: column;
  flex: 1;
}

.card-title {
  font-size: 1.2em;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 8px;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-summary {
  color: var(--text-secondary);
  font-size: 0.9rem;
  line-height: 1.5;
  margin-bottom: 16px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  flex: 1;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid var(--border-color);
  
  .meta-info {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 0.85em;
    color: var(--text-secondary);
    
    span {
      display: flex;
      align-items: center;
      gap: 4px;
    }
  }
  
  .stats {
    display: flex;
    gap: 12px;
    font-size: 0.85em;
    color: var(--text-secondary);
    
    span {
      display: flex;
      align-items: center;
      gap: 4px;
    }
  }
}

.pagination-box {
  margin-top: 60px;
  display: flex;
  justify-content: center;
}

@include responsive(sm) {
  .posts-grid {
    grid-template-columns: 1fr;
  }
}

// Animations
.post-list-enter-active {
  transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1);
  transition-delay: calc(0.05s * var(--index));
}
.post-list-enter, .post-list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}
</style>
