<template>
  <div class="moments-container">
    <div class="header-title">
      <i class="el-icon-chat-dot-round"></i> 碎碎念
    </div>
    <div class="moment-item" v-for="item in list" :key="item.id">
      <div class="avatar">
        <el-avatar :size="50" :src="item.avatar || defaultAvatar"></el-avatar>
      </div>
      <div class="content-wrapper">
        <div class="header">
          <span class="nickname">{{ item.nickname || '匿名用户' }}</span>
          <span class="time">{{ item.createTime | timeAgo }}</span>
        </div>
        <div class="content-bubble">
          <div class="text" v-html="item.content"></div>
          <div class="images" v-if="item.images">
            <el-image 
              v-for="(img, idx) in splitImages(item.images)" 
              :key="idx" 
              :src="img" 
              :preview-src-list="splitImages(item.images)"
              class="moment-img"
            ></el-image>
          </div>
        </div>
        <div class="actions">
          <span class="action-item" @click="handleLike(item)" :class="{ 'liked': item.isLiked }">
            <i class="el-icon-thumb"></i> {{ item.likeCount || 0 }}
          </span>
        </div>
      </div>
    </div>
    
    <div class="load-more" v-if="hasMore" @click="loadMore">
      加载更多
    </div>
    <div class="no-more" v-else>
      没有更多说说了...
    </div>
  </div>
</template>

<script>
import { getMoments, likeMoment } from '@/api/moments'

export default {
  name: "Moments",
  data() {
    return {
      list: [],
      page: 1,
      size: 10,
      total: 0,
      defaultAvatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
    };
  },
  computed: {
    hasMore() {
      return this.list.length < this.total;
    }
  },
  created() {
    this.fetchData();
  },
  filters: {
    timeAgo(time) {
      if (!time) return '';
      const date = new Date(time);
      const now = new Date();
      const diff = (now - date) / 1000;
      if (diff < 60) return '刚刚';
      if (diff < 3600) return Math.floor(diff / 60) + '分钟前';
      if (diff < 86400) return Math.floor(diff / 3600) + '小时前';
      return Math.floor(diff / 86400) + '天前';
    }
  },
  methods: {
    fetchData() {
      getMoments({ pageNum: this.page, pageSize: this.size }).then(res => {
        if (res.data && res.data.records) {
          const newRecords = res.data.records.map(item => ({
            ...item,
            isLiked: false // Initialize local state
          }));
          if (this.page === 1) {
            this.list = newRecords;
          } else {
            this.list = [...this.list, ...newRecords];
          }
          this.total = res.data.total;
        }
      });
    },
    loadMore() {
      this.page++;
      this.fetchData();
    },
    splitImages(images) {
      if (!images) return [];
      return images.split(',');
    },
    handleLike(item) {
      if (item.isLiked) return;
      likeMoment(item.id).then(() => {
        item.likeCount = (item.likeCount || 0) + 1;
        item.isLiked = true; 
        this.$message.success('点赞成功');
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.moments-container {
  max-width: 800px;
  margin: 20px auto;
  padding: 20px;
  background: transparent;
}

.header-title {
  font-size: 1.5rem;
  font-weight: bold;
  color: var(--primary);
  margin-bottom: 30px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.moment-item {
  display: flex;
  margin-bottom: 30px;
  animation: slideIn 0.5s ease;
  
  .avatar {
    margin-right: 20px;
  }
  
  .content-wrapper {
    flex: 1;
    
    .header {
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      
      .nickname {
        font-weight: bold;
        font-size: 16px;
        color: var(--text-primary);
        margin-right: 10px;
      }
      
      .time {
        font-size: 12px;
        color: var(--text-secondary);
      }
    }
    
    .content-bubble {
      background: var(--surface);
      padding: 15px 20px;
      border-radius: 0 12px 12px 12px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.05);
      position: relative;
      border: 1px solid var(--border-color);
      
      &::before {
        content: '';
        position: absolute;
        top: 0;
        left: -8px;
        width: 0;
        height: 0;
        border-style: solid;
        border-width: 0 8px 12px 0;
        border-color: transparent var(--surface) transparent transparent;
      }
      
      .text {
        font-size: 15px;
        line-height: 1.6;
        color: var(--text-primary);
        margin-bottom: 10px;
        white-space: pre-wrap;
        word-break: break-all;
        
        ::v-deep p {
          margin: 0;
          padding: 0;
        }
      }
      
      .images {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        
        .moment-img {
          width: 120px;
          height: 120px;
          border-radius: 8px;
          object-fit: cover;
          cursor: pointer;
          transition: transform 0.3s;
          
          &:hover {
            transform: scale(1.05);
          }
        }
      }
    }
    
    .actions {
      margin-top: 10px;
      display: flex;
      justify-content: flex-end;
      
      .action-item {
        cursor: pointer;
        color: var(--text-secondary);
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 5px;
        transition: color 0.3s;
        
        &:hover {
          color: var(--primary);
        }
        
        &.liked {
          color: var(--primary);
          animation: pulse 0.5s;
        }
      }
    }
  }
}

.load-more {
  text-align: center;
  padding: 12px;
  cursor: pointer;
  color: var(--primary);
  background: var(--surface);
  border-radius: 8px;
  margin-top: 20px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  transition: all 0.3s;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(0,0,0,0.1);
  }
}

.no-more {
  text-align: center;
  padding: 20px;
  color: var(--text-secondary);
}

@keyframes slideIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); }
}
</style>