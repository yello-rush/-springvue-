<template>
  <div class="profile-container">
    <!-- 左侧固定导航 -->
    <div class="profile-sidebar" role="complementary">
      <!-- 导航菜单 -->
      <el-menu class="nav-menu" :default-active="currentTab" @select="currentTab = $event" role="navigation">
        <el-menu-item v-for="tab in tabs" :key="tab.key" :index="tab.key" :aria-label="tab.label">
          <i :class="tab.icon"></i>
          <span>{{ tab.label }}</span>
        </el-menu-item>
      </el-menu>
    </div>

    <!-- 右侧内容区 -->
    <main class="content-area" role="main">
      <!-- 个人资料 -->
      <div v-if="currentTab === 'profile'" class="content-section">
        <h2 class="section-title">个人资料</h2>
        <div class="profile-live-preview">
          <div class="preview-avatar" @click="showCropper = true">
            <el-avatar :size="84" :src="userInfo.avatar || profileForm.avatar" alt="头像预览"></el-avatar>
            <span>点击更换头像</span>
          </div>
          <div class="preview-signature">
            <h3>{{ profileForm.nickname || userInfo.nickname || '未命名用户' }}</h3>
            <p>{{ profileForm.signature || '这个人很懒，还没有写简介...' }}</p>
          </div>
        </div>
        <el-form ref="profileForm" :model="profileForm" :rules="profileRules" label-width="80px" class="profile-form"
          @submit.prevent="submitProfile">
          <el-form-item label="昵称" prop="nickname">
            <el-input v-model="profileForm.nickname" placeholder="请输入昵称" aria-label="昵称输入框"></el-input>
          </el-form-item>
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="profileForm.email" placeholder="请输入邮箱" aria-label="邮箱输入框"></el-input>
          </el-form-item>
          <el-form-item label="安全码" prop="securityCode">
            <el-tooltip effect="dark" content="安全码用于找回密码，请牢记（4位数字）" placement="top">
              <el-input v-model.trim="profileForm.securityCode" maxlength="4" placeholder="请输入4位数字安全码"></el-input>
            </el-tooltip>
          </el-form-item>
          <el-form-item label="个人简介">
            <el-input type="textarea" v-model="profileForm.signature" :rows="4" placeholder="介绍一下自己吧..."></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="submitProfile" :loading="loading" icon="el-icon-edit"
              size="small">保存修改</el-button>
            <el-button size="small" @click="resetProfile" icon="el-icon-refresh">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 浏览历史 -->
      <div v-if="currentTab === 'history'" class="content-section">
        <h2 class="section-title">浏览历史</h2>
        <div v-if="myHistory.length" v-loading="loading">
          <el-card v-for="item in myHistory" :key="item.id" class="post-item">
            <div class="post-content">
              <h3 class="post-title" @click="viewPost(item.id)">{{ item.title }}</h3>
              <p class="post-excerpt">{{ item.summary }}</p>
              <div class="post-meta">
                <el-tag size="small"><i class="el-icon-user"></i>{{ item.author }}</el-tag>
                <el-tag size="small"><i class="el-icon-date"></i>{{ item.createTime }}</el-tag>
                <el-tag size="small" type="info"><i class="el-icon-view"></i>{{ item.quantity }} 阅读</el-tag>
              </div>
            </div>
            <div class="post-actions">
              <el-button type="text" icon="el-icon-view" @click="viewPost(item.id)">查看</el-button>
            </div>
          </el-card>

          <div class="pagination-box">
            <el-pagination background @current-change="handleHistoryPageChange" :current-page="params.pageNum"
              :page-size="params.pageSize" :total="total" layout="prev, pager, next" class="pagination"></el-pagination>
          </div>
        </div>
        <el-empty v-else description="暂无浏览记录"></el-empty>
      </div>

      <!-- 我的收藏 -->
      <div v-if="currentTab === 'favorites'" class="content-section">
        <h2 class="section-title">我的收藏</h2>
        <div v-if="myFavorites.length" v-loading="loading">
          <el-card v-for="item in myFavorites" :key="item.id" class="post-item">
            <div class="post-content">
              <h3 class="post-title" @click="viewPost(item.id)">{{ item.title }}</h3>
              <p class="post-excerpt">{{ item.summary }}</p>
              <div class="post-meta">
                <el-tag size="small"><i class="el-icon-user"></i>{{ item.author }}</el-tag>
                <el-tag size="small"><i class="el-icon-date"></i>{{ item.createTime }}</el-tag>
                <el-tag size="small" type="info"><i class="el-icon-view"></i>{{ item.quantity }} 阅读</el-tag>
              </div>
            </div>
            <div class="post-actions">
              <el-button type="text" icon="el-icon-view" @click="viewPost(item.id)">查看</el-button>
              <el-button type="text" icon="el-icon-star-off" class="delete" @click="cancelFavorite(item.id)">取消收藏</el-button>
            </div>
          </el-card>

          <div class="pagination-box">
            <el-pagination background @current-change="handleFavoritesPageChange" :current-page="params.pageNum"
              :page-size="params.pageSize" :total="total" layout="prev, pager, next" class="pagination"></el-pagination>
          </div>
        </div>
        <el-empty v-else description="暂无收藏记录"></el-empty>
      </div>

      <!-- 我的评论 -->
      <div v-if="currentTab === 'comments'" class="content-section">
        <h2 class="section-title">我的评论</h2>
        <div v-if="myComments.length" v-loading="loading">
          <el-card v-for="comment in myComments" :key="comment.id" class="comment-item">
            <div class="comment-actions">
              <p class="comment-text" v-html="parseContent(comment.content)"></p>
              <el-button type="text" icon="el-icon-delete" class="delete"
                @click="deleteComment(comment.id)">删除</el-button>
            </div>
            <div class="comment-meta">
              <el-link type="primary" @click="viewPost(comment.articleId)">文章：{{ comment.articleTitle }}</el-link>
              <el-tag size="small">
                <i class="el-icon-time"></i>
                {{ comment.createTime }}
              </el-tag>
              <el-tag size="small" type="success"><i class="el-icon-thumb"></i>{{ comment.likeCount ?
                comment.likeCount : 0 }} 赞</el-tag>
            </div>
          </el-card>
          <div class="pagination-box">
            <el-pagination background v-if="myComments.length" @current-change="handlePageChange"
              :current-page="params.pageNum" :page-size="params.pageSize" layout="prev, pager, next" :total="total">
            </el-pagination>
          </div>
        </div>
        <el-empty v-else description="暂无评论数据"></el-empty>
      </div>

      <!-- 我的点赞 -->
      <div v-if="currentTab === 'likes'" class="content-section">
        <h2 class="section-title">我的点赞</h2>
        <div v-if="myLikes.length" v-loading="loading">
          <el-card v-for="like in myLikes" :key="like.id" class="like-item">
            <div class="like-content">
              <div class="comment-actions">
                <el-link class="article-title" @click="viewPost(like.id)">{{ like.title }}</el-link>
                <el-button type="text" icon="el-icon-thumb" class="delete"
                  @click="cancelLike(like.id)">取消点赞</el-button>
              </div>
              <div class="like-meta">
                <!-- <el-tag size="small"><i class="el-icon-user"></i>{{ like.author }}</el-tag> -->
                <el-tag size="small">
                  <i class="el-icon-time"></i>
                  {{ like.createTime }}
                </el-tag>
              </div>
            </div>
          </el-card>
          <div class="pagination-box">
            <el-pagination background v-if="myLikes.length" @current-change="handleLikePageChange"
              :current-page="params.pageNum" :page-size="params.pageSize" layout="prev, pager, next" :total="total">
            </el-pagination>
          </div>
        </div>

        <el-empty v-else description="暂无点赞数据"></el-empty>
      </div>

      <!-- 修改密码 -->
      <div v-if="currentTab === 'security'" class="content-section">
        <h2 class="section-title">修改密码</h2>
        <el-form ref="passwordForm" :model="passwordForm" :rules="passwordRules" label-width="100px"
          class="security-form">
          <el-form-item label="当前密码" prop="oldPassword">
            <el-input type="password" v-model="passwordForm.oldPassword" show-password placeholder="请输入当前密码"></el-input>
          </el-form-item>
          <el-form-item label="新密码" prop="newPassword">
            <el-input type="password" v-model="passwordForm.newPassword" show-password placeholder="请输入新密码"></el-input>
          </el-form-item>
          <el-form-item label="确认新密码" prop="confirmPassword">
            <el-input type="password" v-model="passwordForm.confirmPassword" show-password
              placeholder="请再次输入新密码"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button size="small" type="primary" @click="submitPasswordChange" icon="el-icon-edit"
              :loading="loading">确认修改</el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 反馈 -->
      <div v-if="currentTab === 'feedback'" class="content-section">
        <h2 class="section-title">意见反馈</h2>
        <el-tabs v-model="feedbackActiveTab">
          <el-tab-pane label="提交反馈" name="submit">
            <el-form ref="feedbackForm" :model="feedbackForm" :rules="feedbackRules" label-width="100px"
              class="feedback-form">
              <el-form-item label="反馈类型" prop="feedbackType">
                <el-select v-model="feedbackForm.feedbackType" placeholder="请选择反馈类型">
                  <el-option v-for="item in feedbackTypes" :key="item.value" :label="item.label" :value="item.value"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="反馈内容" prop="content">
                <el-input type="textarea" v-model="feedbackForm.content" :rows="5"
                  placeholder="请详细描述您的问题或建议..."></el-input>
              </el-form-item>
              <el-form-item label="联系邮箱" prop="email">
                <el-input v-model="feedbackForm.email" placeholder="请留下您的联系邮箱，方便我们回复您"></el-input>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="submitFeedback" icon="el-icon-check"
                  :loading="loading">提交反馈</el-button>
              </el-form-item>
            </el-form>
          </el-tab-pane>

          <el-tab-pane label="我的反馈" name="list">
            <div class="feedback-list">
              <div v-loading="loading" v-if="myFeedbacks.length">
                <el-card v-for="feedback in myFeedbacks" :key="feedback.id" class="feedback-item">
                  <div class="feedback-header">
                    <div class="feedback-info">
                      <el-tag v-if="item.value === feedback.feedbackType" v-for="item in feedbackTypes" :key="item.value" :type="item.style">
                        {{ item.label }}
                      </el-tag>
                      <span class="feedback-time">
                        <i class="far fa-clock"></i>
                        {{ feedback.createTime }}
                      </span>
                    </div>
                    <el-tag v-if="item.value === String(feedback.status)" v-for="item in feedbackStatus" :key="item.value"
                      :type="item.style">
                      {{ item.label }}
                    </el-tag>
                  </div>
                  <div class="feedback-content">
                    <p>{{ feedback.content }}</p>
                  </div>
                  <div class="feedback-reply" v-if="feedback.replyContent">
                    <div class="reply-title">
                      <i class="el-icon-chat-line-round"></i> 管理员回复：
                    </div>
                    <p class="reply-content">{{ feedback.replyContent }}</p>
                  </div>
                </el-card>
                <div class="pagination-box" v-if="myFeedbacks.length">
                  <el-pagination background @current-change="handleFeedbackPageChange" :current-page="params.pageNum"
                    :page-size="params.pageSize" layout="prev, pager, next" :total="total">
                  </el-pagination>
                </div>
              </div>
              <el-empty v-else description="暂无反馈记录"></el-empty>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>

    </main>

    <AvatarCropper 
      :visible.sync="showCropper"
      :user="userInfo"
      @update-avatar="handleAvatarUpdate"
    />
  </div>
</template>

<script>
import {
  getUserInfoApi, updateProfileApi, updatePasswordApi,
  getMyCommentApi, delMyCommentApi, getMyLikeApi, getMyFeedbackApi, addFeedbackApi,
  signInApi, getSignInStatusApi, getSignInStatsApi, getSignInDaysApi, getMyHistoryApi, getMyFavoritesApi
} from '@/api/user'
import { likeArticleApi } from '@/api/article'
import AvatarCropper from '@/components/common/AvatarCropper.vue'
import { themeBus } from '@/utils/theme'

import { marked } from "marked";

const DEFAULT_FEEDBACK_TYPES = [
  { label: '功能建议', value: 'function_suggestion', style: 'primary' },
  { label: 'Bug反馈', value: 'bug_report', style: 'danger' },
  { label: '性能问题', value: 'performance_issue', style: 'warning' },
  { label: '界面优化', value: 'ui_optimization', style: 'success' },
  { label: '其他', value: 'other', style: 'info' }
]

const DEFAULT_FEEDBACK_STATUS = [
  { label: '待处理', value: '0', style: 'warning' },
  { label: '处理中', value: '1', style: 'primary' },
  { label: '已处理', value: '2', style: 'success' }
]
export default {
  name: 'Profile',
  components: {
    AvatarCropper
  },
  data() {
    // 密码确认验证规则
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }

    return {
      userInfo: {},
      editForm: {
        username: '',
        email: '',
        signature: ''
      },
      passwordForm: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      signInDays: [],
      calendarVisible: true,
      calendarMounted: true,
      calendarExpandFromTarget: false,
      showCalendarBadge: false,
      midnightTimer: null,
      currentTab: 'profile',
      tabs: [
        { key: 'profile', label: '个人资料', icon: 'fas fa-user' },
        { key: 'history', label: '浏览历史', icon: 'fas fa-history' },
        { key: 'favorites', label: '我的收藏', icon: 'fas fa-star' },
        { key: 'comments', label: '我的评论', icon: 'fas fa-comments' },
        { key: 'likes', label: '我的点赞', icon: 'fas fa-heart' },
        { key: 'security', label: '修改密码', icon: 'fas fa-lock' },
        { key: 'feedback', label: '反馈', icon: 'fas fa-comment-dots' }
      ],
      myHistory: [],
      myFavorites: [],
      myComments: [],
      myLikes: [],
      passwordRules: {
        oldPassword: [
          { required: true, message: '请输入当前密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能小于6位', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能小于6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认新密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      },
      // 个人资料表单
      profileForm: {
        nickname: '',
        email: '',
        securityCode: '',
        signature: ''
      },
      profileRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
        ],
        securityCode: [
          { required: true, message: '请输入安全码', trigger: 'blur' },
          { pattern: /^\d{4}$/, message: '安全码必须是4位数字', trigger: 'blur' }
        ]
      },
      params: {
        pageNum: 1,
        pageSize: 10,
      },
      total: 0,
      loading: false,
      // 添加反馈列表相关数据
      feedbackTypes: [],
      feedbackStatus: [],
      feedbackForm: {
        feedbackType: 'function_suggestion',
        content: '',
        email: ''
      },
      feedbackActiveTab: 'submit',
      myFeedbacks: [],
      feedbackDictLoaded: false,
      feedbackRules: {
        feedbackType: [
          { required: true, message: '请选择反馈类型', trigger: 'blur' },
        ],
        content: [
          { required: true, message: '请输入反馈内容', trigger: 'blur' },
        ],
        email: [
          { required: false, message: '请输入联系邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' },
        ],
      },
      signInStatus: false,
      signInStats: {
        continuousDays: 0,
        totalDays: 0
      },
      signInLoading: false,
      showCropper: false,
    }
  },

  watch: {
    '$store.state.userInfo': {
      handler(newVal, oldVal) {
        if (!newVal) {
          this.$router.push('/')
        }
      },
      deep: true
    },
    currentTab(newVal, oldVal) {
      switch (newVal) {
        case 'history':
          this.params.pageNum = 1
          this.getMyHistory()
          break
        case 'favorites':
          this.params.pageNum = 1
          this.getMyFavorites()
          break
        case 'comments':
          this.params.pageNum = 1
          this.getMyComment()
          break
        case 'likes':
          this.params.pageNum = 1
          this.getMyLikes()
          break
        case 'feedback':
          this.params.pageNum = 1
          this.ensureFeedbackDict().finally(() => {
            this.getMyFeedbacks()
          })
          break
        default:
          break
      }
    },
  },
  created() {
    const tab = this.$route?.query?.tab
    if (tab && this.tabs.some(item => item.key === tab)) {
      this.currentTab = tab
    }

    getUserInfoApi().then(res => {
      this.userInfo = res.data
      Object.assign(this.profileForm, res.data)
    })

    this.refreshSignInInfo()
    this.scheduleMidnightCheck()
  },
  beforeDestroy() {
    if (this.midnightTimer) {
      clearTimeout(this.midnightTimer)
      this.midnightTimer = null
    }
  },
  methods: {
    /**
     * 获取反馈类型字典
     */
    getFeedbackDict() {
      this.feedbackTypes = DEFAULT_FEEDBACK_TYPES
      this.feedbackStatus = DEFAULT_FEEDBACK_STATUS
      return Promise.resolve()
    },
    ensureFeedbackDict() {
      if (this.feedbackDictLoaded) {
        return Promise.resolve()
      }
      return this.getFeedbackDict().finally(() => {
        if (!this.feedbackForm.feedbackType && this.feedbackTypes.length) {
          this.feedbackForm.feedbackType = this.feedbackTypes[0].value
        }
        this.feedbackDictLoaded = true
      })
    },
    /**
     * 获取我的评论
     */
    getMyComment() {
      this.loading = true
      getMyCommentApi(this.params).then(res => {
        this.myComments = res.data.records
        this.total = res.data.total
      }).finally(() => {
        this.loading = false
      })
    },
    /**
     * 解析评论内容
     */
    parseContent(content) {
      return marked(content || "");
    },
    /**
     * 分页
     * @param val
     */
    handlePageChange(val) {
      this.params.pageNum = val
      this.getMyComment()
    },

    getMyHistory() {
      this.loading = true
      getMyHistoryApi(this.params).then(res => {
        this.myHistory = res.data.records
        this.total = res.data.total
      }).finally(() => {
        this.loading = false
      })
    },
    handleHistoryPageChange(val) {
      this.params.pageNum = val
      this.getMyHistory()
    },

    getMyFavorites() {
      this.loading = true
      getMyFavoritesApi(this.params).then(res => {
        const payload = res?.data
        if (Array.isArray(payload)) {
          this.myFavorites = payload
          this.total = payload.length
          return
        }
        this.myFavorites = payload?.records || payload?.list || []
        this.total = payload?.total || this.myFavorites.length
      }).finally(() => {
        this.loading = false
      })
    },
    handleFavoritesPageChange(val) {
      this.params.pageNum = val
      this.getMyFavorites()
    },

    /**
     * 跳转文章详情
     * @param id
     */
    viewPost(id) {
      this.$router.push(`/post/${id}`)
    },
    /**
     * 删除评论
     */
    deleteComment(id) {
      this.$confirm('此操作会把该评论下的子评论也一并删除，是否继续？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        delMyCommentApi(id).then(res => {
          this.$message.success('删除成功')
          this.getMyComment()
        })
      }).catch(() => { })
    },
    /**
     * 取消点赞
     * @param id
     */
    cancelLike(id) {
      this.$confirm('确定要取消点赞吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        likeArticleApi(id).then(res => {
          this.$message.success('已取消点赞')
          this.getMyLikes()
        })
      }).catch(() => { })
    },
    
    cancelFavorite(id) {
      this.$confirm('确定要取消收藏吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        import('@/api/article').then(({ collectArticleApi }) => {
          collectArticleApi(id).then(res => {
            this.$message.success('已取消收藏')
            this.getMyFavorites()
          })
        })
      }).catch(() => { })
    },

    /**
     * 添加反馈
     */
    submitFeedback() {
      this.$refs.feedbackForm.validate(valid => {
        if (valid) {
          this.loading = true
          addFeedbackApi(this.feedbackForm).then(res => {
            this.$message.success('感谢您的反馈！')
            this.feedbackForm = {
              feedbackType: this.feedbackTypes[0]?.value || 'function_suggestion',
              content: '',
              email: ''
            }
            this.feedbackActiveTab = 'list'
            this.params.pageNum = 1
            this.getMyFeedbacks()
            this.$nextTick(() => {
              this.$refs.feedbackForm && this.$refs.feedbackForm.clearValidate()
            })
          }).finally(() => {
            this.loading = false
          })
        }
      })

    },
    // 提交密码修改
    submitPasswordChange() {
      this.$refs.passwordForm.validate(valid => {
        if (valid) {
          this.loading = true
          updatePasswordApi(this.passwordForm).then(res => {
            this.$message.success('密码修改成功！')
            this.$refs.passwordForm.resetFields()
          }).catch(err => {
            this.$message.error(err.message)
          }).finally(() => {
            this.loading = false

          })
        }
      })
    },
    // 提交个人资料
    submitProfile() {
      this.$refs.profileForm.validate(valid => {
        if (!valid) return
        this.loading = true
        updateProfileApi(this.profileForm).then(res => {
          const mergedUser = {
            ...this.userInfo,
            ...this.profileForm
          }
          this.userInfo = mergedUser
          this.$store.commit('SET_USER_INFO', {
            ...this.$store.state.userInfo,
            ...this.profileForm
          })
          this.$message.success('个人资料更新成功！')
        }).catch(err => {
          this.$message.error(err.message)
        }).finally(() => {
          this.loading = false
        })
      })
    },
    // 重置个人资料
    resetProfile() {
      this.profileForm = { ...this.userInfo }
    },
    /**
     * 获取我的点赞
     */
    getMyLikes() {
      this.loading = true
      getMyLikeApi(this.params).then(res => {
        this.myLikes = res.data.records
        this.total = res.data.total
      }).finally(() => {
        this.loading = false
      })
    },
    /**
     * 点赞分页
     */
    handleLikePageChange(val) {
      this.params.pageNum = val
      this.getMyLikes()
    },
    /**
     * 获取我的反馈列表
     */
    getMyFeedbacks() {
      this.loading = true
      let params = {
        ...this.params,
        source: 'PC'
      }
      getMyFeedbackApi(params).then(res => {
        this.myFeedbacks = res.data.records
        this.total = res.data.total
      }).finally(() => {
        this.loading = false
      })
    },

    /**
     * 反馈列表分页
     */
    handleFeedbackPageChange(val) {
      this.params.pageNum = val
      this.getMyFeedbacks()
    },
    /**
     * 获取签到状态
     */
    getSignInStatus() {
      return getSignInStatusApi().then(res => {
        this.signInStatus = res.data || false
        this.syncCalendarBadge()
      })
    },

    /**
     * 获取签到统计
     */
    getSignInStats() {
      return getSignInStatsApi().then(res => {
        this.signInStats = res.data
      })
    },
    getSignInDays() {
      return getSignInDaysApi().then(res => {
        const records = res.data?.dateList || []
        this.signInDays = records
      })
    },
    extractSignInDone() {
      if (typeof this.signInStatus === 'boolean') return this.signInStatus
      return Boolean(this.signInStatus && this.signInStatus.hasSignedIn)
    },
    syncCalendarBadge() {
      this.showCalendarBadge = !this.extractSignInDone()
      localStorage.setItem('calendar-reminder-dot', String(this.showCalendarBadge))
      themeBus.$emit('calendar-reminder-update', this.showCalendarBadge)
    },
    refreshSignInInfo() {
      return Promise.all([
        this.getSignInStatus(),
        this.getSignInStats(),
        this.getSignInDays()
      ])
    },
    scheduleMidnightCheck() {
      if (this.midnightTimer) {
        clearTimeout(this.midnightTimer)
      }
      const now = new Date()
      const nextMidnight = new Date(now)
      nextMidnight.setHours(24, 0, 0, 0)
      const delay = nextMidnight.getTime() - now.getTime()
      this.midnightTimer = setTimeout(() => {
        this.refreshSignInInfo().finally(() => {
          this.scheduleMidnightCheck()
        })
      }, delay)
    },
    handleHeaderCalendarToggle() {
      if (this.calendarMounted && this.calendarVisible) {
        const calendarRef = this.$refs.floatingCalendar
        if (calendarRef && typeof calendarRef.handleCollapseClick === 'function') {
          calendarRef.handleCollapseClick()
        } else {
          this.handleCalendarCollapseFinish()
        }
        return
      }
      if (!this.calendarMounted) {
        this.calendarMounted = true
      }
      this.calendarVisible = true
      this.calendarExpandFromTarget = true
    },
    handleCalendarCollapsed() {
      this.calendarVisible = false
    },
    handleCalendarCollapseFinish() {
      this.calendarMounted = false
      this.calendarVisible = false
    },
    handleCheckInSuccess() {
      this.showCalendarBadge = false
      themeBus.$emit('calendar-reminder-update', false)
    },

    /**
     * 签到
     */
    handleSignIn() {
      if (this.signInLoading || this.extractSignInDone()) return
      this.signInLoading = true
      signInApi().then(res => {
        const payload = res?.data
        const explicitFailed = payload?.status === 'fail' || payload?.status === 'error' || payload?.success === false
        const isSuccess = res?.code === 200 && !explicitFailed
        if (!isSuccess) {
          throw new Error((res && res.message) || '签到失败')
        }
        this.$message.success('签到成功！')
        this.handleCheckInSuccess()
        return this.refreshSignInInfo()
      }).catch(err => {
        this.$message.error(err.message || '签到失败')
      }).finally(() => {
        this.signInLoading = false
      })
    },

    /**
     * 更新头像
     */
    handleAvatarUpdate(newAvatarUrl) {
      this.userInfo.avatar = newAvatarUrl
      this.$store.commit('SET_USER_INFO', { ...this.$store.state.userInfo, avatar: newAvatarUrl })
    },
  },
}
</script>

<style scoped lang="scss">
:deep(input[aria-hidden=true]) {
  display: none !important;
}

.delete {
  color: red;
}

.profile-container {
  display: flex;
  gap: 20px;
  padding: 20px;
  min-height: 100vh;
}

.profile-sidebar {
  position: sticky;
  top: 80px;
  height: fit-content;
  width: 220px;
  flex-shrink: 0;


  @include responsive(sm) {
    position: unset;

    .el-dialog {
      width: 95% !important;
    }
  }
}

.profile-live-preview {
  display: flex;
  align-items: center;
  gap: 18px;
  padding: 16px;
  border-radius: 12px;
  background: var(--hover-bg);
  margin-bottom: 20px;
}

.preview-avatar {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  cursor: pointer;

  span {
    font-size: 12px;
    color: var(--text-secondary);
  }
}

.preview-signature {
  h3 {
    margin: 0 0 8px;
    color: var(--text-primary);
    font-size: 18px;
  }

  p {
    margin: 0;
    color: var(--text-secondary);
    line-height: 1.6;
  }
}



.user-card {
  text-align: center;
  background: var(--card-bg);
  border: var(--border-color);

  .avatar-section {
    margin-bottom: 16px;
  }

  .avatar-wrapper {
    width: 100px;
    height: 100px;
    margin: 0 auto;
    position: relative;
    cursor: pointer;
    border-radius: 50%;
    overflow: hidden;

    .upload-overlay {
      position: absolute;
      inset: 0;
      background: rgba(0, 0, 0, 0.5);
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      transition: opacity 0.3s;

      i {
        font-size: 24px;
        color: white;
      }
    }

    &:hover .upload-overlay {
      opacity: 1;
    }
  }

  .username {
    font-size: 18px;
    font-weight: 600;
    margin: 0 0 8px;
    color: var(--text-primary);
  }

  .signature {
    color: var(--text-secondary);
    font-size: 14px;
    margin: 0 0 16px;
    line-height: 1.5;
  }

}
.el-menu-item{
  color: var(--text-secondary) !important;
}
.nav-menu {
  border-radius: 8px;
  background: var(--card-bg);
  border-right: none;
  margin-top: $spacing-md;


  .is-active {
    background: var(--hover-bg);
    color: $primary;
  }

  :deep(.el-menu-item) {
    height: 48px;
    line-height: 48px;

    &:hover {
      background: var(--hover-bg);
      color: $primary;
    }

    i {
      margin-right: 12px;
    }
  }
}

.content-area {
  flex: 1;
  min-width: 0;
  background: var(--card-bg);
  border-radius: 12px;
  padding: 24px;
}

.section-title {
  font-size: 20px;
  font-weight: 600;
  margin: 0 0 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border-color);
  color: var(--text-primary);
}

.profile-form,
.security-form,
.feedback-form {
  max-width: 600px;
}

.post-item {
  margin-bottom: 16px;

  .post-content {
    margin-bottom: 16px;
  }

  .post-title {
    font-size: 18px;
    color: var(--text-secondary);
    margin: 0 0 12px;
    cursor: pointer;

    &:hover {
      color: $primary;
    }
  }

  .post-excerpt {
    color: var(--text-secondary);
    margin: 0 0 12px;
    line-height: 1.5;
  }

  .post-meta {
    display: flex;
    gap: 12px;
    margin-bottom: 16px;

    .el-tag {
      display: flex;
      align-items: center;
      gap: 4px;
    }
  }

  .post-actions {
    display: flex;
    gap: 16px;
    justify-content: flex-end;
    padding-top: 16px;
    border-top: 1px solid var(--border-color);
  }
}

.comment-item,
.reply-item,
.like-item {
  margin-bottom: 16px;

  .comment-actions,
  .reply-actions,
  .like-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;

    .article-title {
      font-size: 18px;
      font-weight: 700;
    }
  }

  .comment-text,
  .reply-text {
    color: var(--text-secondary);
    margin: 0 0 12px;
    line-height: 1.5;

    :deep(img) {
      max-width: 200px !important;
      max-height: 200px !important;
    }
  }

  .comment-meta,
  .reply-meta,
  .like-meta {
    display: flex;
    gap: 12px;
    align-items: center;
  }
}



// 响应式设计
@media (max-width: 768px) {
  .profile-container {
    flex-direction: column;
  }

  .profile-sidebar {
    width: 100%;
  }

  .content-area {
    padding: 16px;
  }

}

.hidden-input {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

.comment-item,
.reply-item,
.like-item,
.post-item {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
}



.feedback-list {
  .feedback-item {
    margin-bottom: 16px;

    .feedback-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;

      .feedback-info {
        display: flex;
        align-items: center;
        gap: 12px;

        .feedback-time {
          display: flex;
          align-items: center;
          gap: 5px;
          color: var(--text-secondary);
          font-size: 14px;

        }
      }
    }

    .feedback-content {
      color: var(--text-primary);
      line-height: 1.6;
      margin-bottom: 16px;
    }

    .feedback-reply {
      background: var(--hover-bg);
      padding: 12px;
      border-radius: 8px;

      .reply-title {
        color: var(--text-secondary);
        font-weight: 500;
        margin-bottom: 8px;

        i {
          margin-right: 4px;
        }
      }

      .reply-content {
        color: var(--text-secondary);
        margin: 0;
        line-height: 1.6;
      }
    }
  }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 0;
  color: var(--text-secondary);

  i {
    font-size: 48px;
    margin-bottom: 16px;
  }

  p {
    margin-bottom: 24px;
  }

  .btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 8px 24px;
    border-radius: 4px;
    background: var(--hover-bg);
    color: var(--text-primary);
    text-decoration: none;
    transition: all 0.3s ease;

    &:hover {
      background: var(--hover-bg-dark);
    }

    &.primary {
      background: $primary;
      color: white;

      &:hover {
        background: darken($primary, 10%);
      }
    }
  }
}

.sign-in-section {
  padding: 16px 0;
  border-top: 1px solid var(--border-color);
  border-bottom: 1px solid var(--border-color);
  margin: 16px 0;
  
  .sign-in-stats {
    display: flex;
    justify-content: center;
    gap: 24px;
    margin-top: 16px;
    
    .stat-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 4px;
      
      .label {
        font-size: 12px;
        color: var(--text-secondary);
      }
      
      .value {
        font-size: 16px;
        font-weight: 600;
        color: var(--primary-color);
      }
    }
  }
}

.sign-calendar {
  margin-top: 16px;
  padding: 12px;
  border-radius: 12px;
  background: linear-gradient(180deg, #f8fbff 0%, #f5f8fa 100%);
  border: 1px solid #e7edf3;

  .calendar-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 10px;
    gap: 12px;
  }

  .calendar-title-wrap {
    text-align: left;
  }

  .calendar-title {
    font-size: 14px;
    font-weight: 600;
    color: #2c3e50;
    line-height: 1.2;
  }

  .calendar-subtitle {
    margin-top: 2px;
    font-size: 12px;
    color: #7f8c8d;
  }

  .calendar-ops {
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .calendar-month {
    min-width: 86px;
    text-align: center;
    font-size: 13px;
    font-weight: 600;
    color: #34495e;
  }

  .calendar-nav-btn {
    width: 24px;
    height: 24px;
    border: 1px solid #dbe6ef;
    border-radius: 8px;
    background: #fff;
    color: #5f6c7b;
    cursor: pointer;
    line-height: 1;
  }

  :deep(.el-calendar__header) {
    display: none;
  }

  :deep(.el-calendar-table) {
    th {
      color: #8aa0b3;
      font-weight: 500;
      padding: 6px 0;
      font-size: 12px;
    }
    td {
      height: 34px;
      padding: 0;
    }
    .el-calendar-day {
      padding: 2px;
    }
  }

  .calendar-cell {
    width: 28px;
    height: 28px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    color: #4c5a67;
    font-size: 12px;
    transition: all 0.2s ease;
  }

  .calendar-cell.is-out {
    color: #c6d1db;
  }

  .calendar-cell.today {
    border: 1px solid #86b7ff;
    color: #3d7eff;
    font-weight: 600;
  }

  .calendar-cell.signed {
    background: #52c41a;
    color: #fff;
    font-weight: 700;
    border: none;
  }
}
</style>
