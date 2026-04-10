<template>
  <div class="notification-container" v-click-outside="closeNotification">
    <el-badge 
      :value="totalUnread" 
      :max="99" 
      :hidden="!totalUnread"
      class="notification-badge"
    >
      <el-icon class="notification-icon" @click="toggleNotification">
        <Bell />
      </el-icon>
    </el-badge>

    <transition name="dropdown">
      <div v-show="isOpen" class="notification-dropdown">
        <div class="dropdown-header">
          <span>数据中心</span>
          <div class="header-actions">
            <el-button type="primary" link @click="fetchData">
              刷新
            </el-button>
          </div>
        </div>

        <el-tabs v-model="activeTab" class="notification-tabs" @tab-change="handleTabChange">
          <el-tab-pane label="用户数据" name="users">
            <div class="tab-content-wrap">
              <div class="stats-card">
                <div class="stat-item">
                  <span class="stat-title">今日新增用户</span>
                  <span class="stat-value">{{ notificationData.todayNewUsers }}</span>
                </div>
              </div>
              <div class="chart-container" ref="chartRef"></div>
            </div>
          </el-tab-pane>

          <el-tab-pane label="互动数据" name="interactions">
            <div class="interaction-list tab-content-wrap">
              <div class="interaction-item" @click="goTo('/message/comment')">
                <el-icon class="icon comment"><ChatLineRound /></el-icon>
                <div class="info">
                  <div class="title">新增评论</div>
                  <div class="desc">自上次登录新增 {{ notificationData.newComments }} 条</div>
                </div>
                <el-icon class="arrow"><ArrowRight /></el-icon>
              </div>
              
              <div class="interaction-item" @click="goTo('/message/message')">
                <el-icon class="icon like"><Pointer /></el-icon>
                <div class="info">
                  <div class="title">新增点赞</div>
                  <div class="desc">自上次登录新增 {{ notificationData.newLikes }} 次</div>
                </div>
                <el-icon class="arrow"><ArrowRight /></el-icon>
              </div>
              
              <div class="interaction-item" @click="goTo('/article/article')">
                <el-icon class="icon favorite"><Star /></el-icon>
                <div class="info">
                  <div class="title">新增收藏</div>
                  <div class="desc">自上次登录新增 {{ notificationData.newFavorites }} 次</div>
                </div>
                <el-icon class="arrow"><ArrowRight /></el-icon>
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, nextTick, shallowRef } from 'vue'
import { Bell, ChatLineRound, Pointer, Star, ArrowRight } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import * as echarts from 'echarts'
import { useSettingsStore } from '@/store/modules/settings'
import { getNotificationsApi } from '@/api/system'

const settingsStore = useSettingsStore()
const router = useRouter()

const isOpen = ref(false)
const activeTab = ref('users')
const chartRef = ref<HTMLElement>()
const chartInstance = shallowRef<echarts.ECharts | null>(null)

const notificationData = ref({
  todayNewUsers: 0,
  weeklyUserTrend: [] as any[],
  newComments: 0,
  newLikes: 0,
  newFavorites: 0
})

const totalUnread = computed(() => {
  return notificationData.value.todayNewUsers + 
         notificationData.value.newComments + 
         notificationData.value.newLikes + 
         notificationData.value.newFavorites
})

const toggleNotification = () => {
  isOpen.value = !isOpen.value
  if (isOpen.value) {
    fetchData()
    if (activeTab.value === 'users') {
      nextTick(() => {
        initChart()
      })
    }
  }
}

const handleTabChange = () => {
  if (activeTab.value === 'users') {
    nextTick(() => {
      initChart()
    })
  }
}

const goTo = (path: string) => {
  isOpen.value = false
  router.push(path)
}

const initChart = () => {
  if (!chartRef.value) return
  if (!chartInstance.value) {
    chartInstance.value = echarts.init(chartRef.value)
  }
  
  const dates = notificationData.value.weeklyUserTrend.map(item => item.date)
  const counts = notificationData.value.weeklyUserTrend.map(item => item.count)
  
  const option = {
    tooltip: {
      trigger: 'axis'
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      top: '10%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: dates,
      axisLabel: {
        fontSize: 10
      }
    },
    yAxis: {
      type: 'value',
      minInterval: 1
    },
    series: [
      {
        name: '注册用户',
        type: 'line',
        smooth: true,
        data: counts,
        areaStyle: {
          opacity: 0.2
        },
        itemStyle: {
          color: settingsStore.themeColor
        }
      }
    ]
  }
  
  chartInstance.value.setOption(option)
}

let timer: any = null

const fetchData = () => {
  getNotificationsApi(Date.now()).then(res => {
    if (res.code === 200) {
      notificationData.value = res.data
      if (isOpen.value && activeTab.value === 'users') {
        nextTick(() => initChart())
      }
    }
  })
}

onMounted(() => {
  fetchData()
  timer = setInterval(() => {
    fetchData()
  }, 30000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
  if (chartInstance.value) {
    chartInstance.value.dispose()
  }
})

// 添加关闭通知的方法
const closeNotification = () => {
  isOpen.value = false
}

// 添加点击外部关闭指令
const vClickOutside = {
  mounted(el: any, binding: any) {
    el._clickOutside = (event: any) => {
      if (!(el === event.target || el.contains(event.target))) {
        binding.value(event)
      }
    }
    document.addEventListener('click', el._clickOutside)
  },
  unmounted(el: any) {
    document.removeEventListener('click', el._clickOutside)
  }
}
</script>

<style lang="scss" scoped>
.notification-container {
  position: relative;
  display: flex;
  align-items: center;
  margin-right: 10px;
}

.notification-badge {
  .notification-icon {
    font-size: 20px;
    cursor: pointer;
    padding: 8px;
    border-radius: 50%;
    transition: all 0.3s;
    color: #606266;
    
    &:hover {
      background-color: v-bind('`${settingsStore.themeColor}1a`');
      color: v-bind('settingsStore.themeColor');
      transform: rotate(15deg);
    }
  }
}

.notification-dropdown {
  position: absolute;
  top: calc(100% + 8px);
  right: 0;
  width: 360px;
  background: var(--el-bg-color);
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  z-index: 2000;
  overflow: hidden;
  border: 1px solid var(--el-border-color-lighter);
}

.dropdown-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid var(--el-border-color-light);
  background: linear-gradient(to right, 
    v-bind('`${settingsStore.themeColor}0a`'), 
    transparent
  );
  
  span {
    font-size: 16px;
    font-weight: 600;
    background: linear-gradient(120deg, 
      v-bind('settingsStore.themeColor'), 
      v-bind('`${settingsStore.themeColor}99`')
    );
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
}

.notification-tabs {
  :deep(.el-tabs__header) {
    margin: 0;
    padding: 0 8px;
    border-bottom: 1px solid var(--el-border-color-light);
  }
  
  :deep(.el-tabs__nav-wrap::after) {
    display: none;
  }
  
  :deep(.el-tabs__item) {
    padding: 12px 16px;
    font-size: 14px;
    
    &.is-active {
      color: v-bind('settingsStore.themeColor');
      font-weight: 500;
    }
  }
  
  :deep(.el-tabs__active-bar) {
    background-color: v-bind('settingsStore.themeColor');
    height: 3px;
    border-radius: 3px;
  }
  
  :deep(.el-tabs__content) {
    padding: 0;
  }
}

.tab-content-wrap {
  padding: 12px;
}

.stats-card {
  display: flex;
  justify-content: center;
  padding: 10px;
  background: var(--el-fill-color-light);
  border-radius: 8px;
  margin-bottom: 10px;
  
  .stat-item {
    text-align: center;
    .stat-title {
      font-size: 13px;
      color: var(--el-text-color-secondary);
      display: block;
      margin-bottom: 4px;
    }
    .stat-value {
      font-size: 24px;
      font-weight: bold;
      color: v-bind('settingsStore.themeColor');
    }
  }
}

.chart-container {
  height: 200px;
  width: 100%;
}

.interaction-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  
  .interaction-item {
    display: flex;
    align-items: center;
    padding: 12px;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s;
    background: var(--el-fill-color-light);
    
    &:hover {
      background: v-bind('`${settingsStore.themeColor}1a`');
      transform: translateX(4px);
    }
    
    .icon {
      font-size: 24px;
      padding: 10px;
      border-radius: 8px;
      margin-right: 12px;
      
      &.comment {
        color: #1890ff;
        background: rgba(24, 144, 255, 0.1);
      }
      &.like {
        color: #f5222d;
        background: rgba(245, 34, 45, 0.1);
      }
      &.favorite {
        color: #faad14;
        background: rgba(250, 173, 20, 0.1);
      }
    }
    
    .info {
      flex: 1;
      .title {
        font-size: 14px;
        font-weight: 500;
        color: var(--el-text-color-primary);
        margin-bottom: 4px;
      }
      .desc {
        font-size: 12px;
        color: var(--el-text-color-secondary);
      }
    }
    
    .arrow {
      color: var(--el-text-color-secondary);
    }
  }
}

// 添加下拉动画
.dropdown-enter-active,
.dropdown-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-12px) scale(0.95);
}

// 暗色主题适配
:root[data-theme='dark'] {
  .notification-dropdown {
    background: var(--el-bg-color-overlay);
    border-color: var(--el-border-color-darker);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
  }
  
  .dropdown-header {
    border-color: var(--el-border-color-darker);
  }
  
  .stats-card, .interaction-item {
    background: var(--el-fill-color-darker);
    
    &:hover {
      background: v-bind('`${settingsStore.themeColor}1a`');
    }
  }
}
</style> 