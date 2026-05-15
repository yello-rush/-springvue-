<template>
  <div class="notifications-page">
    <div class="notifications-header">
      <h1>消息中心</h1>
      <div class="header-actions">
        <el-select v-model="currentCategory" size="small" style="width: 140px" @change="switchCategory">
          <el-option v-for="category in categories" :key="category.type" :label="category.name" :value="category.type" />
        </el-select>
        <el-button type="primary" plain size="small" :loading="markAllLoading" @click="markAllAsRead" :disabled="!hasUnread">
          <i class="fas fa-check-double"></i>
          全部标记已读
        </el-button>
      </div>
    </div>

    <div class="notifications-columns" v-loading="loading">
      <section class="column-card">
        <div class="column-header">
          <span>未读消息</span>
          <el-tag type="danger" size="small">{{ unreadNotifications.length }}</el-tag>
        </div>
        <div v-if="unreadNotifications.length" class="column-list">
          <div v-for="notification in unreadNotifications" :key="notification.id" class="notification-item unread">
            <div class="notification-icon">
              <i :class="getNotificationIcon(notification.type)"></i>
            </div>
            <div class="notification-body" @click="handleNotificationClick(notification)">
              <div class="notification-title-row">
                <div class="notification-title">{{ notification.title }}</div>
                <el-tag size="mini" type="danger">未读</el-tag>
              </div>
              <div class="notification-message">{{ getNotificationText(notification) }}</div>
              <div class="notification-footer">
                <span class="notification-time">{{ formatDisplayTime(notification.createTime) }}</span>
              </div>
            </div>
            <div class="notification-actions">
              <el-button
                type="primary"
                link
                size="small"
                :loading="isActionLoading(notification.id)"
                @click.stop="markAsRead(notification.id)"
              >
                标为已读
              </el-button>
              <el-button type="danger" link size="small" @click.stop="deleteNotification(notification.id)">删除</el-button>
            </div>
          </div>
        </div>
        <div v-else class="empty-state">
          <i class="fas fa-check-circle"></i>
          <p>暂无未读消息</p>
        </div>
      </section>

      <section class="column-card">
        <div class="column-header">
          <span>已读消息</span>
          <el-tag size="small">{{ readNotifications.length }}</el-tag>
        </div>
        <div v-if="readNotifications.length" class="column-list">
          <div v-for="notification in readNotifications" :key="notification.id" class="notification-item">
            <div class="notification-icon">
              <i :class="getNotificationIcon(notification.type)"></i>
            </div>
            <div class="notification-body" @click="handleNotificationClick(notification)">
              <div class="notification-title-row">
                <div class="notification-title">{{ notification.title }}</div>
                <el-tag size="mini">已读</el-tag>
              </div>
              <div class="notification-message">{{ getNotificationText(notification) }}</div>
              <div class="notification-footer">
                <span class="notification-time">{{ formatDisplayTime(notification.createTime) }}</span>
              </div>
            </div>
            <div class="notification-actions">
              <el-button type="danger" link size="small" @click.stop="deleteNotification(notification.id)">删除</el-button>
            </div>
          </div>
        </div>
        <div v-else class="empty-state">
          <i class="fas fa-inbox"></i>
          <p>暂无已读消息</p>
        </div>
      </section>
    </div>

    <div class="pagination-box">
      <el-pagination
        background
        v-if="filteredNotifications.length"
        @current-change="handlePageChange"
        :current-page="params.pageNum"
        :page-size="params.pageSize"
        layout="prev, pager, next"
        :total="total"
      />
    </div>

    <el-dialog
      custom-class="notification-detail-dialog"
      :visible.sync="detailVisible"
      :fullscreen="isMobileDialog"
      :width="isMobileDialog ? '100%' : '680px'"
      :append-to-body="true"
      :destroy-on-close="false"
      @closed="handleDialogClosed"
    >
      <template slot="title">
        <div class="detail-title-wrap">
          <span>{{ activeNotification ? activeNotification.title : '消息详情' }}</span>
          <el-tag v-if="activeNotification" :type="activeNotification.isRead ? '' : 'danger'" size="mini">
            {{ activeNotification.isRead ? '已读' : '未读' }}
          </el-tag>
        </div>
      </template>

      <div v-if="activeNotification" class="detail-content" v-loading="detailLoading">
        <div class="detail-meta">
          <span>类型：{{ activeNotification.type === 'system' ? '系统消息' : '点赞消息' }}</span>
          <span>发布时间：{{ formatDisplayTime(activeNotification.createTime) }}</span>
        </div>
        <div class="detail-message">{{ getNotificationText(activeNotification) }}</div>
      </div>

      <span slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button
          v-if="activeNotification && !activeNotification.isRead"
          type="primary"
          :loading="isActionLoading(activeNotification.id)"
          @click="markCurrentAsRead"
        >
          标记为已读
        </el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {
  getNotificationsApi,
  markNotificationAsReadApi,
  markAllNotificationsAsReadApi,
  getUnreadNotificationsCountApi,
  deleteNotificationApi
} from '@/api/message'
import { formatTime } from '@/utils/time'

export default {
  name: 'Notifications',
  data() {
    return {
      currentCategory: 'all',
      categories: [
        { type: 'all', name: '全部类型', icon: 'fas fa-bell', unread: 0 },
        { type: 'system', name: '系统消息', icon: 'fas fa-cog', unread: 0 },
        { type: 'like', name: '点赞消息', icon: 'fas fa-heart', unread: 0 }
      ],
      notifications: [],
      params: {
        pageNum: 1,
        pageSize: 10,
        type: null
      },
      total: 0,
      loading: false,
      detailVisible: false,
      detailLoading: false,
      activeNotification: null,
      actionLoadingIds: [],
      markAllLoading: false,
      viewportWidth: typeof window !== 'undefined' ? window.innerWidth : 1200
    }
  },
  computed: {
    filteredNotifications() {
      const source = this.notifications.filter(item => ['like', 'system'].includes(item.type))
      if (this.currentCategory === 'all') return source
      return source.filter(item => item.type === this.currentCategory)
    },
    unreadNotifications() {
      return this.filteredNotifications.filter(item => !item.isRead)
    },
    readNotifications() {
      return this.filteredNotifications.filter(item => item.isRead)
    },
    hasUnread() {
      return this.unreadNotifications.length > 0
    },
    isMobileDialog() {
      return this.viewportWidth <= 768
    }
  },
  methods: {
    switchCategory(type) {
      this.currentCategory = type
      this.params.type = type === 'all' ? null : type
      this.params.pageNum = 1
      this.fetchNotifications()
    },
    getNotificationIcon(type) {
      const category = this.categories.find(c => c.type === type)
      return category ? category.icon : 'fas fa-bell'
    },
    getNotificationText(notification) {
      if (notification.type === 'system') return notification.message
      if (notification.type === 'like') {
        return notification.articleTitle ? `有人点赞了你的评论：${notification.articleTitle}` : '有人点赞了你的评论'
      }
      return notification.message || ''
    },
    formatDisplayTime(time) {
      return formatTime(time)
    },
    isActionLoading(id) {
      return this.actionLoadingIds.includes(String(id))
    },
    setActionLoading(id, loading) {
      const key = String(id)
      if (loading && !this.actionLoadingIds.includes(key)) {
        this.actionLoadingIds.push(key)
      }
      if (!loading) {
        this.actionLoadingIds = this.actionLoadingIds.filter(item => item !== key)
      }
    },
    handleArticleClick(id) {
      this.$router.push(`/post/${id}`)
    },
    extractCommentAnchor(notification) {
      return (
        notification.commentId ||
        notification.parentCommentId ||
        notification.sourceId ||
        notification.targetId ||
        notification.fromCommentId ||
        ''
      )
    },
    handleCommentJump(notification) {
      const commentId = this.extractCommentAnchor(notification)
      if (!notification.articleId) {
        this.openNotificationDialog(notification)
        return
      }
      this.$router.push({
        path: `/post/${notification.articleId}`,
        query: commentId ? { commentId: String(commentId), highlight: '1' } : {}
      })
    },
    handleNotificationClick(notification) {
      if (notification.type === 'system') {
        this.openNotificationDialog(notification)
        return
      }

      if (notification.type === 'like') {
        this.handleCommentJump(notification)
        return
      }

      this.openNotificationDialog(notification)
    },
    openNotificationDialog(notification) {
      this.activeNotification = { ...notification }
      this.detailVisible = true
    },
    updateLocalReadState(id, isRead = true) {
      const targetId = String(id)
      this.notifications = this.notifications.map(item => {
        if (String(item.id) === targetId) {
          return { ...item, isRead }
        }
        return item
      })
      if (this.activeNotification && String(this.activeNotification.id) === targetId) {
        this.activeNotification = { ...this.activeNotification, isRead }
      }
      this.updateUnreadCount()
    },
    handleDialogClosed() {
      this.activeNotification = null
      this.detailLoading = false
    },
    handleResize() {
      this.viewportWidth = window.innerWidth
    },
    updateUnreadCount(all = false) {
      this.categories.forEach(category => {
        if (all) {
          category.unread = 0
          return
        }
        if (category.type === 'all') {
          category.unread = this.notifications.filter(n => !n.isRead).length
        } else {
          category.unread = this.notifications.filter(n => n.type === category.type && !n.isRead).length
        }
      })
    },
    async fetchNotifications() {
      this.loading = true
      try {
        const { data } = await getNotificationsApi(this.params)
        this.notifications = ((data && data.records) || []).map(item => ({
          ...item,
          isRead: Boolean(item.isRead)
        }))
        this.total = (data && data.total) || 0
        this.updateUnreadCount()
      } catch (error) {
        this.notifications = []
        this.total = 0
        this.$message.error('获取消息通知失败')
      } finally {
        this.loading = false
      }
    },
    handlePageChange(page) {
      this.params.pageNum = page
      this.fetchNotifications()
    },
    async markAllAsRead() {
      if (this.markAllLoading) return
      this.markAllLoading = true
      try {
        await markAllNotificationsAsReadApi()
        this.updateUnreadCount(true)
        await this.fetchNotifications()
        this.$message.success('已将所有消息标记为已读')
      } catch (error) {
        this.$message.error('操作失败')
      } finally {
        this.markAllLoading = false
      }
    },
    async markAsRead(id) {
      if (this.isActionLoading(id)) return
      this.setActionLoading(id, true)
      try {
        await markNotificationAsReadApi(id)
        this.updateLocalReadState(id, true)
        await this.getUnreadNotificationsCount()
        this.$message.success('已标记为已读')
      } catch (error) {
        this.$message.error('标记已读失败')
      } finally {
        this.setActionLoading(id, false)
      }
    },
    async markCurrentAsRead() {
      if (!this.activeNotification || this.activeNotification.isRead) return
      await this.markAsRead(this.activeNotification.id)
    },
    async deleteNotification(id) {
      this.$confirm('确定要删除这条消息吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
        .then(async () => {
          await deleteNotificationApi(id)
          await this.fetchNotifications()
          this.$message.success('删除成功')
        })
        .catch(() => {})
    },
    async getUnreadNotificationsCount() {
      const { data } = await getUnreadNotificationsCountApi()
      let unreadCount = 0
      this.categories.forEach(category => {
        if (category.type !== 'all') {
          category.unread = data[category.type]?.num || 0
          unreadCount += category.unread
        }
      })
      const allCategory = this.categories.find(c => c.type === 'all')
      if (allCategory) allCategory.unread = unreadCount
    }
  },
  created() {
    if (!this.$store.state.userInfo) {
      this.$router.push('/login')
      return
    }
    const { type } = this.$route.query || {}
    if (type && ['all', 'system', 'like'].includes(type)) {
      this.currentCategory = type
      this.params.type = type === 'all' ? null : type
    }
    this.fetchNotifications()
    this.getUnreadNotificationsCount()
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>

<style lang="scss" scoped>
.notifications-page {
  max-width: 1360px;
  margin: 0 auto;
  padding: 20px;
  min-height: calc(100vh - 64px);
}

.notifications-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;

  h1 {
    margin: 0;
    font-size: 20px;
    color: var(--text-primary);
  }

  .header-actions {
    display: flex;
    align-items: center;
    gap: 10px;
  }
}

.notifications-columns {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.column-card {
  background: var(--card-bg);
  border-radius: 12px;
  border: 1px solid rgba(var(--border-color-rgb), 0.2);
  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.08);
  min-height: 360px;
  display: flex;
  flex-direction: column;
}

.column-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 14px;
  border-bottom: 1px solid var(--border-color);
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.column-list {
  padding: 8px;
}

.notification-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 12px;
  border-radius: 10px;
  transition: all 0.2s ease;

  &:hover {
    background: rgba($primary, 0.05);
  }

  &.unread {
    background: rgba($primary, 0.08);
  }
}

.notification-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: rgba($primary, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;

  i {
    font-size: 14px;
    color: $primary;
  }
}

.notification-body {
  flex: 1;
  min-width: 0;
  cursor: pointer;
}

.notification-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.notification-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 4px;
}

.notification-message {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin-bottom: 4px;
  word-break: break-word;
}

.notification-footer {
  display: flex;
  justify-content: flex-end;
}

.notification-time {
  font-size: 12px;
  color: var(--text-secondary);
}

.notification-actions {
  display: flex;
  flex-direction: column;
  gap: 2px;
  flex-shrink: 0;
}

.empty-state {
  padding: 42px 14px;
  text-align: center;
  color: var(--text-secondary);

  i {
    font-size: 28px;
    margin-bottom: 10px;
  }

  p {
    margin: 0;
    font-size: 13px;
  }
}

.pagination-box {
  margin-top: 16px;
  display: flex;
  justify-content: center;
}

.detail-title-wrap {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.detail-content {
  min-height: 120px;
}

.detail-meta {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 12px;
}

.detail-message {
  border-radius: 10px;
  border: 1px solid var(--border-color);
  background: rgba(var(--primary-rgb), 0.04);
  padding: 14px;
  line-height: 1.7;
  color: var(--text-primary);
  white-space: pre-wrap;
  word-break: break-word;
}

@media screen and (max-width: 900px) {
  .notifications-columns {
    grid-template-columns: 1fr;
  }
}

@media screen and (max-width: 768px) {
  .notifications-page {
    padding: 12px;
  }

  .notifications-header {
    gap: 8px;
    flex-direction: column;
    align-items: flex-start;
  }

  .detail-meta {
    flex-direction: column;
    align-items: flex-start;
    gap: 6px;
  }
}
</style>
