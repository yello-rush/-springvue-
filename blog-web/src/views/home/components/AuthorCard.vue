<template>
  <el-card class="author-card" v-if="webSiteInfo">
    <div class="floating-cards">
      <span v-for="n in 12" :key="n" class="card-particle"></span>
    </div>
    <div class="card-header">
      <div class="author-avatar">
        <el-avatar class="avatar" :src="webSiteInfo.authorAvatar || '/avatar/blogger.jpg'" alt="作者头像" icon="el-icon-user-solid" />
      </div>
      <div class="status-badge" :class="{ offline: !isBloggerOnline }">
        <span>{{ isBloggerOnline ? '在线' : '离线' }}</span>
      </div>
    </div>
    <div class="author-info">
      <h3>{{ webSiteInfo.author || '习习中' }}</h3>
      <p class="bio">{{ webSiteInfo.authorInfo || 'Welcome to my blog' }}</p>
    </div>
    
    <!-- 关于我 -->
    <div class="about-me-container" v-if="webSiteInfo.aboutMe">
      <div class="about-me-header" @click="isAboutMeExpanded = !isAboutMeExpanded">
        <div class="about-title">
          <i class="fas fa-quote-left quote-icon"></i>
          <span class="custom-font">关于我</span>
        </div>
        <i class="fas fa-chevron-down expand-icon" :class="{ 'rotated': isAboutMeExpanded }"></i>
      </div>
      <el-collapse-transition>
        <div v-show="isAboutMeExpanded" class="about-content-wrapper">
          <div class="about-content" v-html="webSiteInfo.aboutMe"></div>
        </div>
      </el-collapse-transition>
    </div>

    <!-- 社交按钮组 -->
    <div class="social-links">
      <div v-for="item in socialLinks" :key="item.type" class="social-item">
        <el-tooltip placement="top" :content="item.tooltip">
          <div class="social-btn" :class="item.type" @click="handleSocialClick(item)">
            <i :class="item.icon"></i>
          </div>
        </el-tooltip>
      </div>
    </div>

    <!-- 弹窗模态框 -->
    <el-dialog
      :visible.sync="dialogVisible"
      :title="currentSocial.title"
      width="360px"
      :close-on-click-modal="true"
      :close-on-press-escape="true"
      append-to-body
      custom-class="social-dialog"
    >
      <div class="dialog-content">
        <!-- 微信弹窗内容 -->
        <div v-if="currentSocial.type === 'wechat'" class="wechat-content">
          <img :src="webSiteInfo.weixinImage || (webSiteInfo.wechat ? 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=' + webSiteInfo.wechat : '')" alt="微信二维码" class="qr-code">
          <p class="wechat-id" v-if="webSiteInfo.wechat">
            微信号: <span>{{ webSiteInfo.wechat }}</span>
            <i class="el-icon-document-copy copy-icon" @click="copyText(webSiteInfo.wechat)" title="点击复制"></i>
          </p>
          <p v-else>暂无微信号</p>
        </div>

        <!-- QQ弹窗内容 -->
        <div v-if="currentSocial.type === 'qq'" class="qq-content">
          <i class="fab fa-qq qq-large-icon"></i>
          <p class="qq-number" v-if="webSiteInfo.qqNumber">QQ: {{ webSiteInfo.qqNumber }}</p>
          <p v-else>暂无QQ号</p>
          <el-button v-if="webSiteInfo.qqNumber" type="primary" size="small" @click="openLink(getQQLink())">一键加好友</el-button>
        </div>
      </div>
    </el-dialog>
  </el-card>
</template>

<script>
import { checkAdminOnlineApi } from '@/api/site'

export default {
  name: 'AuthorCard',
  data() {
    return {
      isAboutMeExpanded: false,
      dialogVisible: false,
      currentSocial: {},
      adminOnline: false,
      socialLinks: [
        {
          type: 'wechat',
          icon: 'fab fa-weixin',
          title: '微信联系',
          tooltip: '添加微信好友'
        },
        {
          type: 'qq',
          icon: 'fab fa-qq',
          title: 'QQ联系',
          tooltip: '添加QQ好友'
        }
      ]
    }
  },
  computed: {
    webSiteInfo() {
      return this.$store.state.webSiteInfo || {};
    },
    isBloggerOnline() {
      return this.adminOnline;
    }
  },
  created() {
    this.checkOnlineStatus();
  },
  methods: {
    async checkOnlineStatus() {
      try {
        const res = await checkAdminOnlineApi();
        if (res.code === 200) {
          this.adminOnline = res.data;
        }
      } catch (e) {
        console.error('获取博主在线状态失败', e);
      }
    },
    handleSocialClick(item) {
      this.currentSocial = item;
      this.dialogVisible = true;
    },
    copyText(text) {
      if (!text) return;
      navigator.clipboard.writeText(text).then(() => {
        this.$message.success('复制成功');
      }).catch(() => {
        this.$message.error('复制失败，请手动复制');
      });
    },
    openLink(url) {
      if (url) {
        window.open(url, '_blank');
      } else {
        this.$message.warning('暂无链接');
      }
    },
    getQQLink() {
        if (!this.webSiteInfo.qqNumber) return '';
        // PC/Mobile compatible QQ link
        return `tencent://AddContact/?fromId=45&fromSubId=1&subcmd=all&uin=${this.webSiteInfo.qqNumber}`;
    }
  }
}
</script>

<style lang="scss" scoped>
.author-card {
  padding: 0 0 20px 0; // 修改为 0，因为有顶部背景图，下面保留 padding
  margin-bottom: 20px;
  border-radius: 16px; // 增加圆角
  background: var(--card-bg);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  position: relative;
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  border: 1px solid var(--border-color, rgba(0, 0, 0, 0.05));

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1); // hover 时阴影更强
  }

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 120px; // 增加背景图高度
    background-image: url('/beijing.jpg');
    background-size: cover;
    background-position: center;
    opacity: 0.9;
    transition: opacity 0.3s ease;
    z-index: 0; // 确保在底层
  }

  &:hover::before {
    opacity: 1;
  }

  .card-header {
    position: relative;
    margin-top: 70px; // 调整头像位置，使其跨越背景图和卡片背景
    margin-bottom: 15px;
    display: flex;
    justify-content: center;
    z-index: 2; // 确保头像在背景图之上

    .author-avatar {
      width: 100px;
      height: 100px;
      padding: 4px;
      background: var(--card-bg);
      border-radius: 50%;
      position: relative;
      z-index: 2;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); // 给头像增加阴影
      transition: box-shadow 0.3s ease;

      &:hover {
         box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
      }

      @media (max-width: 768px) {
        width: 80px;
        height: 80px;
      }

      .avatar {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid var(--card-bg); // 修改为卡片背景色
        transition: transform 0.6s cubic-bezier(0.34, 1.56, 0.64, 1); // 更具弹性的旋转
        
        &:hover {
          transform: rotate(360deg) scale(1.05); // 旋转时稍微放大
        }
      }
    }

    .status-badge {
      position: absolute;
      bottom: 5px;
      right: 50%;
      transform: translateX(35px);
      background: #10b981;
      color: white;
      font-size: 10px;
      padding: 2px 10px; // 稍微增加 padding
      border-radius: 12px; // 更圆润
      z-index: 3;
      border: 2px solid var(--card-bg);
      box-shadow: 0 2px 4px rgba(0,0,0,0.1); // 给徽章加点阴影
      font-weight: bold; // 加粗字体

      &.offline {
        background: #9ca3af;
      }
    }
  }

  .author-info {
    text-align: center;
    position: relative;
    z-index: 2;
    padding: 0 20px; // 增加水平 padding

    h3 {
      font-size: 1.3rem; // 稍微调大名字
      font-weight: 800; // 加粗
      color: var(--text-primary);
      margin-bottom: 8px;
      letter-spacing: 1px; // 增加字间距
    }

    .bio {
      font-size: 0.9rem;
      color: var(--text-secondary);
      margin-bottom: 20px; // 增加与下面元素的间距
      line-height: 1.5;
      font-style: italic; // 斜体，增加文艺感
    }
  }

  .about-me-container {
    margin: 0 20px 20px 20px; // 增加左右边距，使其不贴边
    border-radius: 12px;
    background: var(--surface);
    border: 1px solid var(--border-color, #ebeef5);
    overflow: hidden;
    transition: all 0.3s ease;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);

    &:hover {
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
      border-color: rgba(var(--primary-rgb), 0.3); // hover时边框变色
    }

    .about-me-header {
      padding: 12px 16px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      cursor: pointer;
      user-select: none;
      transition: background 0.3s ease;

      &:hover {
        background: var(--hover-bg);
      }

      .about-title {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 1.05rem;
        color: var(--text-primary);
        
        .quote-icon {
          color: var(--primary, #409eff);
          font-size: 0.9rem;
          opacity: 0.8;
        }

        .custom-font {
          font-family: 'STKaiti', 'KaiTi', '楷体', 'Noto Serif SC', 'Songti SC', serif;
          font-weight: 600;
          letter-spacing: 2px;
        }
      }

      .expand-icon {
        font-size: 0.85rem;
        color: var(--text-secondary);
        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        
        &.rotated {
          transform: rotate(180deg);
        }
      }
    }

    .about-content-wrapper {
      padding: 0 16px 16px;
      
      .about-content {
        padding-top: 12px;
        border-top: 1px dashed var(--border-color, #ebeef5);
        font-size: 0.95rem;
        color: var(--text-secondary);
        line-height: 1.8;
        font-family: 'STKaiti', 'KaiTi', '楷体', 'Noto Serif SC', 'Songti SC', serif;
        
        :deep(p) {
          margin-bottom: 10px;
          text-align: justify;
          &:last-child {
            margin-bottom: 0;
          }
        }
      }
    }
  }

  .social-links {
    display: flex;
    justify-content: center;
    gap: 20px; // 增加间距
    margin-top: 15px; // 增加顶部边距
    position: relative;
    z-index: 2;

    .social-item {
      position: relative;

      .social-btn {
        width: 44px; // 增大按钮
        height: 44px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: var(--hover-bg);
        color: var(--text-secondary);
        font-size: 1.3rem; // 增大图标
        cursor: pointer;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); // 优化动画曲线
        border: 1px solid transparent; // 为hover准备边框

        &:hover {
          transform: translateY(-5px) scale(1.1); // hover时上浮并稍微放大
          color: white;
          box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15); // 增加hover阴影
        }

        &.wechat:hover { background: #07c160; color: white; border-color: #07c160; }
        &.qq:hover { background: #12b7f5; color: white; border-color: #12b7f5; }
      }
    }
  }

  // Floating particles animation
  .floating-cards {
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    pointer-events: none;
    z-index: 1;
    
    .card-particle {
      position: absolute;
      width: 6px;
      height: 6px;
      background: rgba(64, 158, 255, 0.2); // Use fixed RGB instead of var() to avoid Sass error
      border-radius: 50%;
      animation: float-up 10s infinite linear;
      
      @for $i from 1 through 12 {
        &:nth-child(#{$i}) {
          left: random(100) * 1%;
          top: random(100) * 1%;
          animation-delay: -#{random(10)}s;
          animation-duration: #{5 + random(10)}s;
        }
      }
    }
  }
}

@keyframes float-up {
  0% { transform: translateY(0) rotate(0deg); opacity: 0; }
  50% { opacity: 0.5; }
  100% { transform: translateY(-100px) rotate(360deg); opacity: 0; }
}

// Dialog Content Styles
.dialog-content {
  text-align: center;
  padding: 10px;

  .wechat-content {
    .qr-code {
      width: 180px;
      height: 180px;
      margin-bottom: 15px;
      border-radius: 8px;
    }
    .wechat-id {
      font-size: 1rem;
      color: var(--text-primary);
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      
      span { font-weight: bold; }
      
      .copy-icon {
        cursor: pointer;
        color: #409eff;
        &:hover { color: #66b1ff; }
      }
    }
  }

  .qq-content {
    .qq-large-icon {
      font-size: 4rem;
      color: #12b7f5;
      margin-bottom: 15px;
    }
    .qq-number {
      font-size: 1.2rem;
      margin-bottom: 20px;
      color: var(--text-primary);
    }
  }
}
</style>