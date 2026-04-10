<template>
  <div class="message-board">
    <!-- Danmaku Background Area -->
    <div class="danmaku-container" :style="coverStyle">
       <!-- Overlay Mask -->
       <div class="overlay"></div>

       <!-- Content -->
       <div class="content-wrapper">
          <h1 class="title">留言板</h1>
          <p class="subtitle">Message Board</p>
          
          <div class="input-area">
             <input 
               v-model="content" 
               class="message-input" 
               placeholder="写下你的留言..." 
               @keyup.enter="sendMessage"
             />
             <button class="send-btn" @click="sendMessage">
               <i class="fas fa-paper-plane"></i> 发送
             </button>
          </div>
          <div style="margin-top: 20px;">
             <button class="view-all-btn" @click="showAllMessages = true">
               <i class="fas fa-list"></i> 查看所有留言
             </button>
          </div>
       </div>

       <!-- Vue Danmaku Component -->
       <vue-danmaku
          ref="danmaku"
          class="danmaku-stage"
          :danmus="barrageList"
          :speeds="100"
          :channels="8"
          useSlot
          randomChannel
          loop
          :debounce="100"
          isSuspend
        >
          <template v-slot:dm="{ danmu }">
            <div class="danmaku-item" :class="{'is-me': danmu.isMe}">
              <img :src="danmu.avatar" class="avatar" />
              <div class="info">
                 <span class="name">{{ danmu.nickname }}:</span>
                 <span class="text">{{ danmu.content }}</span>
              </div>
            </div>
          </template>
        </vue-danmaku>
    </div>

    <!-- All Messages Modal -->
    <el-dialog
      title="所有留言"
      v-model="showAllMessages"
      width="80%"
      custom-class="all-messages-dialog"
      append-to-body
    >
      <div class="top-message" v-if="topMessage">
        <div class="message-card top-card">
          <div class="badge">置顶最高赞</div>
          <div class="card-header">
            <img :src="topMessage.avatar" class="avatar" />
            <div class="user-info">
              <span class="name">{{ topMessage.nickname }}</span>
              <span class="time">{{ topMessage.createTime }}</span>
            </div>
          </div>
          <div class="card-body">
            {{ topMessage.content }}
          </div>
          <div class="card-footer">
            <button class="like-btn" :class="{'liked': topMessage.isLiked}" @click="likeMessage(topMessage)">
              <i class="fas fa-heart"></i> {{ topMessage.likeCount || 0 }}
            </button>
          </div>
        </div>
      </div>
      
      <div class="messages-grid">
        <div v-for="msg in sortedMessages" :key="msg.id" class="message-card">
          <div class="card-header">
            <img :src="msg.avatar" class="avatar" />
            <div class="user-info">
              <span class="name">{{ msg.nickname }}</span>
              <span class="time">{{ msg.createTime }}</span>
            </div>
          </div>
          <div class="card-body">
            {{ msg.content }}
          </div>
          <div class="card-footer">
            <button class="like-btn" :class="{'liked': msg.isLiked}" @click="likeMessage(msg)">
              <i class="fas fa-heart"></i> {{ msg.likeCount || 0 }}
            </button>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getMessagesApi, addMessageApi, likeMessageApi } from "@/api/message";
import VueDanmaku from 'vue-danmaku';

export default {
  name: 'MessageBoard',
  components: {
    VueDanmaku
  },
  data() {
    return {
      content: "",
      barrageList: [],
      user: this.$store.state.userInfo,
      sending: false,
      showAllMessages: false
    };
  },
  computed: {
    coverStyle() {
      // Use a cyber/anime style background as shown in user's image
      return {
        backgroundImage: `url()`, // Placeholder, better if local asset
        backgroundSize: 'cover',
        backgroundPosition: 'center'
      }
    },
    sortedMessages() {
      const messages = [...this.barrageList].filter(msg => msg !== this.topMessage);
      return messages.sort((a, b) => new Date(b.createTime) - new Date(a.createTime));
    },
    topMessage() {
      if (!this.barrageList || this.barrageList.length === 0) return null;
      let top = this.barrageList[0];
      for (let i = 1; i < this.barrageList.length; i++) {
        if ((this.barrageList[i].likeCount || 0) > (top.likeCount || 0)) {
          top = this.barrageList[i];
        }
      }
      return (top.likeCount || 0) > 0 ? top : null;
    }
  },
  mounted() {
    this.fetchMessages();
  },
  methods: {
    fetchMessages() {
      getMessagesApi().then(res => {
        this.barrageList = res.data;
      });
    },
    sendMessage() {
      if (!this.content.trim()) {
        this.$message.warning("请输入留言内容");
        return;
      }
      
      const msg = {
        avatar: this.user ? this.user.avatar : this.$store.state.webSiteInfo.touristAvatar,
        nickname: this.user ? this.user.nickname : "游客",
        content: this.content,
        isMe: true
      };
      
      if (!this.user) {
        this.$message.warning("请先登录后留言");
        this.$router.push('/login');
        return;
      }

      addMessageApi(msg).then(() => {
        this.$refs.danmaku.add(msg);
        this.content = "";
        this.$message.success("留言成功");
        this.fetchMessages(); // Refresh messages to get the new one with ID for liking
      }).catch(() => {
        // Handle error if needed
      });
    },
    async likeMessage(msg) {
      if (!this.user) {
        this.$message.warning("请先登录");
        return;
      }
      try {
        await likeMessageApi(msg.id);
        msg.likeCount = (msg.likeCount || 0) + 1;
        msg.isLiked = true;
        this.$message.success("点赞成功");
      } catch (error) {
        this.$message.error(error.message || "点赞失败");
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.message-board {
  width: 100%;
  height: 100vh; // Full screen
  position: relative;
  overflow: hidden;
}

.danmaku-container {
  width: 100%;
  height: 100%;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  
  .overlay {
    position: absolute;
    inset: 0;
    background: rgba(0,0,0,0.4);
    z-index: 1;
  }
}

.content-wrapper {
  position: relative;
  z-index: 10;
  text-align: center;
  color: white;
  width: 100%;
  max-width: 600px;
  padding: 0 20px;

  .title {
    font-size: 3rem;
    font-weight: 700;
    margin-bottom: 10px;
    text-shadow: 0 4px 10px rgba(0,0,0,0.5);
    letter-spacing: 4px;
  }

  .subtitle {
    font-size: 1.2rem;
    opacity: 0.8;
    margin-bottom: 40px;
    text-transform: uppercase;
    letter-spacing: 2px;
  }
}

.input-area {
  display: flex;
  background: rgba(255,255,255,0.2);
  backdrop-filter: blur(10px);
  padding: 5px;
  border-radius: 50px;
  border: 1px solid rgba(255,255,255,0.3);
  box-shadow: 0 8px 32px rgba(0,0,0,0.2);
  transition: all 0.3s;
  
  &:focus-within {
    background: rgba(255,255,255,0.3);
    transform: scale(1.02);
  }

  .message-input {
    flex: 1;
    background: transparent;
    border: none;
    padding: 15px 25px;
    color: white;
    font-size: 1rem;
    outline: none;
    
    &::placeholder {
      color: rgba(255,255,255,0.6);
    }
  }

  .send-btn {
    background: #00d2ff; /* fallback for old browsers */
    background: -webkit-linear-gradient(to right, #3a7bd5, #00d2ff); /* Chrome 10-25, Safari 5.1-6 */
    background: linear-gradient(to right, #3a7bd5, #00d2ff);
    border: none;
    border-radius: 40px;
    color: white;
    padding: 0 25px;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 15px rgba(0,210,255,0.4);
    }
    
    &:active {
      transform: translateY(0);
    }
  }
}

.view-all-btn {
  background: rgba(255,255,255,0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255,255,255,0.3);
  border-radius: 20px;
  color: white;
  padding: 10px 20px;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s;
  
  &:hover {
    background: rgba(255,255,255,0.2);
    transform: translateY(-2px);
  }
}

.messages-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.message-card {
  background: var(--card-bg, #fff);
  border-radius: 12px;
  padding: 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  border: 1px solid var(--border-color, #eee);
  position: relative;
  
  &.top-card {
    border: 2px solid #ff9900;
    background: linear-gradient(to right bottom, rgba(255,153,0,0.05), transparent);
    margin-bottom: 30px;
  }
  
  .badge {
    position: absolute;
    top: -10px;
    right: 20px;
    background: #ff9900;
    color: white;
    padding: 4px 10px;
    border-radius: 12px;
    font-size: 0.8rem;
    font-weight: bold;
    box-shadow: 0 2px 8px rgba(255,153,0,0.3);
  }

  .card-header {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
    
    .avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      margin-right: 10px;
      object-fit: cover;
    }
    
    .user-info {
      display: flex;
      flex-direction: column;
      
      .name {
        font-weight: 600;
        color: var(--text-primary, #333);
        font-size: 0.95rem;
      }
      
      .time {
        font-size: 0.8rem;
        color: var(--text-secondary, #999);
      }
    }
  }
  
  .card-body {
    color: var(--text-regular, #666);
    line-height: 1.5;
    margin-bottom: 15px;
    word-break: break-word;
  }
  
  .card-footer {
    display: flex;
    justify-content: flex-end;
    border-top: 1px solid var(--border-color, #eee);
    padding-top: 10px;
    
    .like-btn {
      background: none;
      border: none;
      color: var(--text-secondary, #999);
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 5px;
      transition: color 0.2s;
      
      &:hover {
        color: #ff4757;
      }
      
      &.liked {
        color: #ff4757;
      }
    }
  }
}

:deep(.all-messages-dialog) {
  .el-dialog__body {
    background: var(--bg-color, #f5f7fa);
    max-height: 70vh;
    overflow-y: auto;
  }
}

.danmaku-stage {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 5;
  pointer-events: none; // Let clicks pass through to background/input
}

.danmaku-item {
  display: inline-flex;
  align-items: center;
  background: rgba(0,0,0,0.6);
  padding: 4px 12px 4px 4px;
  border-radius: 20px;
  color: white;
  gap: 8px;
  white-space: nowrap;
  
  &.is-me {
    border: 1px solid var(--primary);
    background: rgba(var(--primary-rgb), 0.6);
  }

  .avatar {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    border: 1px solid white;
  }
  
  .info {
    font-size: 0.9rem;
    .name {
      color: #ffd700;
      margin-right: 4px;
    }
  }
}
</style>
