<template>
  <FloatingCheckInCalendar
    ref="floatingCalendar"
    v-if="calendarMounted"
    :visible="calendarVisible"
    :signed-days="signInDays"
    :sign-in-status="signInStatus"
    :sign-in-stats="signInStats"
    :check-in-loading="signInLoading"
    :expand-from-target="calendarExpandFromTarget"
    @check-in="handleSignIn"
    @collapse-finish="handleCalendarCollapseFinish"
    @expand-finish="calendarExpandFromTarget = false"
  />
</template>

<script>
import FloatingCheckInCalendar from '@/components/FloatingCheckInCalendar/index.vue'
import { signInApi, getSignInStatusApi, getSignInStatsApi, getSignInDaysApi } from '@/api/user'
import { themeBus } from '@/utils/theme'

export default {
  name: 'GlobalCheckInCalendarHost',
  components: { FloatingCheckInCalendar },
  data() {
    return {
      signInDays: [],
      signInStatus: false,
      signInStats: {
        continuousDays: 0,
        totalDays: 0
      },
      signInLoading: false,
      calendarMounted: false,
      calendarVisible: false,
      calendarExpandFromTarget: false
    }
  },
  computed: {
    isLoggedIn() {
      return Boolean(this.$store.state.token)
    }
  },
  watch: {
    isLoggedIn: {
      immediate: true,
      handler(val) {
        if (!val) {
          this.resetCalendarData()
          this.updateBadge(false)
          return
        }
        this.refreshSignInInfo()
      }
    }
  },
  created() {
    themeBus.$on('floating-calendar-toggle', this.handleHeaderCalendarToggle)
  },
  beforeDestroy() {
    themeBus.$off('floating-calendar-toggle', this.handleHeaderCalendarToggle)
  },
  methods: {
    getTodayDateStr() {
      const now = new Date()
      const year = now.getFullYear()
      const month = String(now.getMonth() + 1).padStart(2, '0')
      const day = String(now.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    },
    markTodaySignedOptimistically() {
      const today = this.getTodayDateStr()
      if (!Array.isArray(this.signInDays)) {
        this.signInDays = [today]
      } else if (!this.signInDays.includes(today)) {
        this.signInDays = [...this.signInDays, today]
      }
      if (typeof this.signInStatus === 'boolean') {
        this.signInStatus = true
      } else {
        this.signInStatus = {
          ...(this.signInStatus || {}),
          hasSignedIn: true
        }
      }
    },
    resetCalendarData() {
      this.signInDays = []
      this.signInStatus = false
      this.signInStats = { continuousDays: 0, totalDays: 0 }
      this.calendarMounted = false
      this.calendarVisible = false
    },
    parseSignDone() {
      if (typeof this.signInStatus === 'boolean') return this.signInStatus
      return Boolean(this.signInStatus && this.signInStatus.hasSignedIn)
    },
    updateBadge(show) {
      localStorage.setItem('calendar-reminder-dot', String(Boolean(show)))
      themeBus.$emit('calendar-reminder-update', Boolean(show))
    },
    refreshSignInInfo() {
      return Promise.all([
        getSignInStatusApi().then(res => {
          this.signInStatus = (res && res.data) || false
        }),
        getSignInStatsApi().then(res => {
          this.signInStats = (res && res.data) || { continuousDays: 0, totalDays: 0 }
        }),
        getSignInDaysApi().then(res => {
          this.signInDays = (res && res.data && res.data.dateList) || []
        })
      ]).then(() => {
        this.updateBadge(!this.parseSignDone())
      }).catch(() => {
        this.updateBadge(false)
      })
    },
    handleHeaderCalendarToggle() {
      if (!this.isLoggedIn) {
        this.$message.warning('请先登录后再签到')
        this.$router.push('/login')
        return
      }
      if (this.calendarMounted && this.calendarVisible) {
        const ref = this.$refs.floatingCalendar
        if (ref && typeof ref.handleCollapseClick === 'function') {
          ref.handleCollapseClick()
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
      this.refreshSignInInfo()
    },
    handleCalendarCollapseFinish() {
      this.calendarMounted = false
      this.calendarVisible = false
    },
    handleSignIn() {
      if (this.signInLoading || this.parseSignDone()) return
      this.signInLoading = true
      signInApi().then(res => {
        const payload = res && res.data
        const explicitFailed = payload && (
          payload.status === 'fail' ||
          payload.status === 'error' ||
          payload.success === false
        )
        const isSuccess = res && res.code === 200 && !explicitFailed
        if (!isSuccess) {
          throw new Error((res && res.message) || '签到失败')
        }
        this.markTodaySignedOptimistically()
        this.$message.success('签到成功！')
        this.updateBadge(false)
        return this.refreshSignInInfo()
      }).catch(err => {
        this.$message.error((err && err.message) || '签到失败')
      }).finally(() => {
        this.signInLoading = false
      })
    }
  }
}
</script>
