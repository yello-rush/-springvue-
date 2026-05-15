<template>
  <aside class="sidebar">
    <el-card class="section announcement" v-if="announcements.length">
      <h3>
        <i class="fas fa-bullhorn"></i>
        公告
      </h3>
      <div class="announcement-content">
        <div class="announcement-item" v-for="(item, index) in announcements" :key="index">
          <!-- <i :class="item.icon"></i> -->
          <span v-html="item.content"></span>
        </div>
      </div>
    </el-card>

    <el-card class="section">
      <h3>
        <i class="fas fa-tags"></i>
        标签云
      </h3>
      <Tag />
    </el-card>
  </aside>
</template>

<script>
import Tag from './components/tagCloud.vue'

export default {
  name: 'Sidebar',
  components: {
    Tag
  },
  data() {
    return {
      announcements: []
    }
  },
  watch: {
    '$store.state.notice'(val) {
      if (val && val.right) {
        this.announcements = val.right
      }
    } 
  },
  mounted() {
    // 初始化公告数据
    if (this.$store.state.notice && this.$store.state.notice.right) {
      this.announcements = this.$store.state.notice.right
    }
  },
  methods: {
    /**
     * 处理图片加载失败
     */
    handleImageError(e) {
      e.target.src = this.$store.state.defaultImage
      e.target.classList.add('fallback')
    }
  }
}
</script>

<style lang="scss" scoped>
.sidebar {
  width: 100%;
  max-width: 320px;
}

.section {
  margin-bottom: $spacing-lg;

  h3 {
    font-size: 1.1rem;
    font-weight: 600;
    color: #6366f1;
    margin-bottom: 16px;
    padding-bottom: 12px;
    border-bottom: 2px solid rgba(99, 102, 241, 0.1);

    &::before {
      content: '';
      display: inline-block;
      width: 4px;
      height: 16px;
      background: linear-gradient(to bottom, #6366f1, #8b5cf6);
      margin-right: 8px;
      border-radius: 2px;
      vertical-align: middle;
      transform: translateY(-1px);
    }
  }


}

.announcement {
  h3 {
    i {
      margin-right: 8px;
      color: #f59e0b;
      animation: shake 1.5s ease-in-out infinite;
    }
  }

  .announcement-content {
    .announcement-item {
      display: flex;
      align-items: flex-start;
      gap: 12px;
      padding: 12px 0;
      border-bottom: 1px dashed rgba(99, 102, 241, 0.1);

      &:last-child {
        border-bottom: none;
        padding-bottom: 0;
      }

      &:first-child {
        padding-top: 0;
      }

      i {
        font-size: 1rem;
        color: #6366f1;
        flex-shrink: 0;
        margin-top: 3px;
      }

      span {
        font-size: 0.9rem;
        color: var(--text-secondary);
        line-height: 1.6;
      }

      &:hover {
        i {
          transform: scale(1.1);
        }

        span {
          color: var(--text-primary);
        }
      }

      i,
      span {
        transition: all 0.3s ease;
      }
    }
  }
}

@media (prefers-color-scheme: dark) {
  .sidebar {
    .section {

    }
  }
}

@include responsive(lg) {
  .sidebar {
    display: none;
  }
}

@keyframes float {
  0% {
    transform: translateY(0px);
  }

  50% {
    transform: translateY(-5px);
  }

  100% {
    transform: translateY(0px);
  }
}

.author-avatar img {
  animation: float 3s ease-in-out infinite;
}

@keyframes fall {
  0% {
    transform: translateY(-20px) rotate(0deg);
    opacity: 0;
  }

  20% {
    opacity: 0.8;
  }

  80% {
    opacity: 0.8;
  }

  100% {
    transform: translateY(300px) rotate(360deg);
    opacity: 0;
  }
}

@keyframes shake {
  0% {
    transform: rotate(0deg);
  }

  25% {
    transform: rotate(-10deg);
  }

  75% {
    transform: rotate(10deg);
  }

  100% {
    transform: rotate(0deg);
  }
}



.fa-tags {
  color: #e329d3;
}
</style>