<template>
  <div class="navbar-container">
    <div class="navbar-left">
      <el-icon class="collapse-btn" @click="toggleCollapse">
        <Fold v-if="!isCollapse" />
        <Expand v-else />
      </el-icon>

      <Breadcrumb />
    </div>

    <!-- 顶部时间与问候组件 -->
    <div class="navbar-center">
      <div class="time-left">
        <div class="greeting">{{ greeting }}，欢迎回来！</div>
        <div class="date-info">{{ currentDate }} {{ currentWeek }}</div>
      </div>
      <div class="time-right">
        <div class="current-time">{{ currentTime }}</div>
      </div>
    </div>

    <div class="navbar-right">
      <!-- 菜单全局搜索 -->
      <global-search/>
      <!-- 夜间模式切换 -->
      <el-tooltip :content="settingsStore.theme === 'dark' ? '切换亮色模式' : '切换夜间模式'" placement="bottom">
        <el-icon class="setting-icon theme-toggle" @click="toggleTheme">
          <Moon v-if="settingsStore.theme === 'light'" />
          <Sunny v-else />
        </el-icon>
      </el-tooltip>


      <!-- 通知中心 -->
      <el-tooltip content="通知中心" placement="bottom">  
        <notification />
      </el-tooltip>
      <!-- 用户信息 -->
        <user-tool @lock="handleLock" />
    </div>

    <!-- 添加锁屏组件 -->
    <lock-screen ref="lockScreenRef" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useSettingsStore } from '@/store/modules/settings'
import GlobalSearch from '@/components/GlobalSearch/index.vue'
import Breadcrumb from './Breadcrumb/index.vue'
import UserTool from './UserTool/index.vue'
import LockScreen from '@/components/LockScreen/index.vue'
import Notification from './Notification/index.vue'
import { Moon, Sunny, Fold, Expand } from '@element-plus/icons-vue'
import dayjs from 'dayjs'

const settingsStore = useSettingsStore()
const lockScreenRef = ref()

// 时间与问候逻辑
const greeting = ref('')
const currentDate = ref('')
const currentWeek = ref('')
const currentTime = ref('')
let timer: any = null

const updateTime = () => {
  const now = dayjs()
  const hour = now.hour()
  
  if (hour < 6) greeting.value = '凌晨好'
  else if (hour < 9) greeting.value = '早上好'
  else if (hour < 12) greeting.value = '上午好'
  else if (hour < 14) greeting.value = '中午好'
  else if (hour < 18) greeting.value = '下午好'
  else if (hour < 22) greeting.value = '晚上好'
  else greeting.value = '夜深了'

  currentDate.value = now.format('YYYY年MM月DD日')
  const weeks = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  currentWeek.value = weeks[now.day()]
  currentTime.value = now.format('HH:mm:ss')
}

onMounted(() => {
  updateTime()
  timer = setInterval(updateTime, 1000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

defineProps({
  isCollapse: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits(['toggle-collapse'])

const toggleCollapse = () => {
  emit('toggle-collapse')
}

const handleLock = () => {
  lockScreenRef.value?.lock()
}

const toggleTheme = () => {
  const newTheme = settingsStore.theme === 'light' ? 'dark' : 'light'
  settingsStore.saveSettings({ theme: newTheme })
  localStorage.setItem('blog_admin_theme', newTheme)
}
</script>

<style lang="scss" scoped>
.navbar-container {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0;
  position: relative;
  
  .navbar-left {
    display: flex;
    align-items: center;

    
    .collapse-btn {
      font-size: 20px;
      cursor: pointer;
      margin-right: 16px;
      color: #606266;
      transition: all 0.3s;
      
      &:hover {
        color: v-bind('settingsStore.themeColor');
      }
    }
  }

  .navbar-center {
    display: flex;
    align-items: center;
    gap: 20px;
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    background: linear-gradient(135deg, var(--el-color-primary-light-9) 0%, transparent 100%);
    padding: 4px 20px;
    border-radius: 8px;

    .time-left {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      gap: 2px;
      
      .greeting {
        font-size: 16px;
        font-weight: bold;
        color: var(--el-color-primary);
        letter-spacing: 1px;
      }
      
      .date-info {
        font-size: 12px;
        color: var(--el-text-color-secondary);
      }
    }

    .time-right {
      .current-time {
        font-size: 24px;
        font-weight: bold;
        font-family: 'Courier New', Courier, monospace;
        background: linear-gradient(to right, var(--el-color-primary), var(--el-color-success));
        -webkit-background-clip: text;
        color: transparent;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
      }
    }
  }
  
  .navbar-right {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-left: auto;
    padding-right: 8px;
    position: absolute;
    right: 0;
    height: 100%;
    
    .setting-icon {
      font-size: 20px !important;
      cursor: pointer;
      padding: 6px;
      border-radius: 50%;
      transition: all 0.3s;
      color: #606266;
      
      &:hover {
        background-color: v-bind('`${settingsStore.themeColor}1a`');
        color: v-bind('settingsStore.themeColor');
      }
    }

  }
}
</style>
