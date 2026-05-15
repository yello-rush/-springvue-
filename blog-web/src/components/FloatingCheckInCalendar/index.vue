<template>
  <div v-if="visible" class="floating-checkin-shell">
    <section ref="card" class="floating-checkin-card" :class="{ animating, success: successAnimating }">
      <div class="compact-row">
        <button
          class="checkin-btn"
          :disabled="buttonDisabled"
          @click="handleCheckInClick"
        >
          {{ hasSignedInToday ? "已签到" : "签到" }}
        </button>

        <div class="status-chip">
          <i class="status-dot" :class="{ done: hasSignedInToday }"></i>
          <span>{{ hasSignedInToday ? "今日已签到" : "今日未签到" }}</span>
        </div>

        <div class="meta-item">连签 {{ signInStats.continuousDays || 0 }} 天</div>

        <button class="collapse-btn" :disabled="animating" @click="handleCollapseClick" aria-label="收起日历">×</button>
      </div>

      <div class="calendar-head">
        <button class="nav-btn" :disabled="animating" @click="changeMonth(-1)" aria-label="上个月">‹</button>
        <span class="month-title">{{ calendarTitle }}</span>
        <button class="nav-btn" :disabled="animating" @click="changeMonth(1)" aria-label="下个月">›</button>
      </div>

      <div class="week-row">
        <span v-for="day in weekDays" :key="day">{{ day }}</span>
      </div>

      <div class="day-grid">
        <button
          v-for="day in dayCells"
          :key="day.key"
          class="day-cell"
          :class="{
            out: !day.isCurrentMonth,
            today: day.isToday,
            signed: day.isSigned,
            selected: day.dateStr === selectedDate
          }"
          @click="selectDay(day)"
        >
          {{ day.day }}
        </button>
      </div>

    </section>
  </div>
</template>

<script>
export default {
  name: 'FloatingCheckInCalendar',
  props: {
    visible: {
      type: Boolean,
      default: true
    },
    signedDays: {
      type: Array,
      default: () => []
    },
    signInStatus: {
      type: [Boolean, Object],
      default: false
    },
    signInStats: {
      type: Object,
      default: () => ({})
    },
    checkInLoading: {
      type: Boolean,
      default: false
    },
    targetSelector: {
      type: String,
      default: '.calendar-toggle-btn'
    },
    expandFromTarget: {
      type: Boolean,
      default: false
    },
    onCollapse: {
      type: Function,
      default: null
    },
    onCheckInSuccess: {
      type: Function,
      default: null
    }
  },
  data() {
    return {
      animating: false,
      successAnimating: false,
      displayMonth: new Date(),
      selectedDate: ''
    }
  },
  computed: {
    hasSignedInToday() {
      if (typeof this.signInStatus === 'boolean') return this.signInStatus
      return Boolean(this.signInStatus && this.signInStatus.hasSignedIn)
    },
    buttonDisabled() {
      return this.animating || this.hasSignedInToday || this.checkInLoading
    },
    calendarTitle() {
      try {
        return new Intl.DateTimeFormat(undefined, {
          year: 'numeric',
          month: 'long'
        }).format(this.displayMonth)
      } catch (error) {
        const y = this.displayMonth.getFullYear()
        const m = this.displayMonth.getMonth() + 1
        return `${y}-${String(m).padStart(2, '0')}`
      }
    },
    weekDays() {
      try {
        // 以周日为起点，保证与日历网格对齐
        const base = new Date(2026, 0, 4)
        return Array.from({ length: 7 }, (_, i) =>
          new Intl.DateTimeFormat(undefined, { weekday: 'short' }).format(
            new Date(base.getFullYear(), base.getMonth(), base.getDate() + i)
          )
        )
      } catch (error) {
        return ['日', '一', '二', '三', '四', '五', '六']
      }
    },
    dayCells() {
      const firstDay = new Date(this.displayMonth.getFullYear(), this.displayMonth.getMonth(), 1)
      const startOffset = firstDay.getDay()
      const gridStart = new Date(firstDay)
      gridStart.setDate(firstDay.getDate() - startOffset)
      return Array.from({ length: 42 }, (_, idx) => {
        const current = new Date(gridStart)
        current.setDate(gridStart.getDate() + idx)
        const dateStr = this.toDateStr(current)
        return {
          key: `${dateStr}-${idx}`,
          day: current.getDate(),
          dateStr,
          isCurrentMonth: current.getMonth() === this.displayMonth.getMonth(),
          isToday: dateStr === this.todayStr(),
          isSigned: this.isSignedDate(dateStr)
        }
      })
    }
  },
  watch: {
    expandFromTarget(val) {
      if (val) {
        this.runExpandAnimation()
      }
    },
    signInStatus: {
      handler(newVal, oldVal) {
        const prev = this.parseSignedStatus(oldVal)
        const next = this.parseSignedStatus(newVal)
        if (!prev && next) {
          this.successAnimating = true
          window.setTimeout(() => {
            this.successAnimating = false
          }, 500)
        }
      }
    }
  },
  mounted() {
    this.selectedDate = this.todayStr()
    if (this.expandFromTarget) {
      this.runExpandAnimation()
    }
  },
  methods: {
    toDateStr(date) {
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    },
    parseDateStr(dateStr) {
      if (!dateStr) return null
      const [year, month, day] = dateStr.split('-').map(Number)
      if (!year || !month || !day) return null
      return new Date(year, month - 1, day)
    },
    todayStr() {
      return this.toDateStr(new Date())
    },
    isSignedDate(dateStr) {
      return Array.isArray(this.signedDays) && this.signedDays.includes(dateStr)
    },
    parseSignedStatus(val) {
      if (typeof val === 'boolean') return val
      return Boolean(val && val.hasSignedIn)
    },
    changeMonth(step) {
      const next = new Date(this.displayMonth)
      next.setMonth(next.getMonth() + step)
      this.displayMonth = next
    },
    selectDay(day) {
      this.selectedDate = day.dateStr
      this.$emit('date-select', day.dateStr)
    },
    handleCheckInClick() {
      if (this.buttonDisabled) return
      this.$emit('check-in')
    },
    getTargetOffset() {
      const card = this.$refs.card
      const target = document.querySelector(this.targetSelector)
      if (!card || !target) return null

      const cardRect = card.getBoundingClientRect()
      const targetRect = target.getBoundingClientRect()
      return {
        dx: targetRect.left + targetRect.width / 2 - (cardRect.left + cardRect.width / 2),
        dy: targetRect.top + targetRect.height / 2 - (cardRect.top + cardRect.height / 2)
      }
    },
    playMotion({ reverse = false, done }) {
      const card = this.$refs.card
      const offset = this.getTargetOffset()
      if (!card || !offset || !card.animate) {
        done && done()
        return
      }

      this.animating = true
      const midX = offset.dx * 0.58
      const midY = offset.dy * 0.55 - 24
      const fromFrames = [
        { transform: 'translate3d(0, 0, 0) scale(1)', opacity: 1 },
        { offset: 0.65, transform: `translate3d(${midX}px, ${midY}px, 0) scale(0.58)`, opacity: 0.86 },
        { transform: `translate3d(${offset.dx}px, ${offset.dy}px, 0) scale(0.1)`, opacity: 0.05 }
      ]
      const frames = reverse ? [...fromFrames].reverse() : fromFrames
      const animation = card.animate(frames, {
        duration: 300,
        easing: 'cubic-bezier(0.16, 1, 0.3, 1)',
        fill: 'forwards'
      })
      animation.onfinish = () => {
        this.animating = false
        card.style.transform = ''
        card.style.opacity = ''
        done && done()
      }
      animation.oncancel = () => {
        this.animating = false
      }
    },
    handleCollapseClick() {
      this.playMotion({
        reverse: false,
        done: () => {
          this.$emit('collapse-finish')
          if (typeof this.onCollapse === 'function') {
            this.onCollapse()
          }
        }
      })
    },
    runExpandAnimation() {
      this.$nextTick(() => {
        this.playMotion({
          reverse: true,
          done: () => {
            this.$emit('expand-finish')
          }
        })
      })
    }
  }
}
</script>

<style scoped lang="scss">
.floating-checkin-shell {
  position: fixed;
  top: 92px;
  right: 24px;
  transform: none;
  z-index: 2000;
  width: min(360px, calc(100vw - 24px));
}

.floating-checkin-card {
  width: 100%;
  min-height: 46px;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.26);
  background: linear-gradient(90deg, rgba(59, 130, 246, 0.96), rgba(99, 102, 241, 0.96));
  color: #f8fafc;
  box-shadow: 0 10px 22px rgba(15, 23, 42, 0.22);
  overflow: visible;
  will-change: transform, opacity;
  padding: 10px;


  &.success {
    animation: checkin-success 0.5s ease;
  }
}

.compact-row {
  display: flex;
  align-items: center;
  gap: 6px;
  white-space: normal;
  min-height: 30px;
  flex-wrap: wrap;
}

.checkin-btn {
  width: 80px;
  min-width: 80px;
  height: 30px;
  border: none;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.2);
  color: #fff;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover:not(:disabled) {
    background: rgba(255, 255, 255, 0.3);
  }

  &:disabled {
    background: rgba(255, 255, 255, 0.22);
    cursor: not-allowed;
  }
}

.status-chip {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.92);
  min-width: 92px;
  flex: 1 1 110px;

  span {
    white-space: nowrap;
  }
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #fbbf24;
  flex-shrink: 0;

  &.done {
    background: #22c55e;
  }
}

.meta-item {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  flex: 0 0 auto;
  white-space: nowrap;
}

.collapse-btn {
  width: 18px;
  min-width: 18px;
  height: 18px;
  border: 1px solid rgba(255, 255, 255, 0.35);
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.12);
  color: #fff;
  line-height: 1;
  cursor: pointer;
  padding: 0;
  margin-left: auto;
}

.calendar-head {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  margin-top: 6px;
}

.month-title {
  font-size: 11px;
  font-weight: 600;
  color: #fff;
  min-width: 120px;
  text-align: center;
}

.nav-btn {
  width: 18px;
  min-width: 18px;
  height: 18px;
  border: 1px solid rgba(255, 255, 255, 0.35);
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.1);
  color: #fff;
  line-height: 1;
  cursor: pointer;
  padding: 0;
}

.week-row {
  margin-top: 5px;
  display: grid;
  grid-template-columns: repeat(7, minmax(0, 1fr));
  gap: 2px;
  font-size: 10px;
  color: rgba(255, 255, 255, 0.78);
  text-align: center;
}

.day-grid {
  margin-top: 3px;
  display: grid;
  grid-template-columns: repeat(7, minmax(0, 1fr));
  gap: 2px;
}

.day-cell {
  height: 18px;
  border: 0;
  border-radius: 2px;
  background: transparent;
  font-size: 11px;
  color: rgba(255, 255, 255, 0.95);
  padding: 0;
  cursor: pointer;
  line-height: 18px;

  &.out {
    color: rgba(255, 255, 255, 0.46);
  }

  &.today {
    border: 1px solid rgba(255, 255, 255, 0.9);
    line-height: 16px;
  }

  &.signed {
    background: rgba(34, 197, 94, 0.95);
    color: #fff;
  }

  &.selected {
    box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.9);
  }
}

@keyframes checkin-success {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.03);
    opacity: 0.86;
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

@media (max-width: 320px) {
  .floating-checkin-shell {
    right: 8px;
    top: auto;
    bottom: 8px;
    transform: scale(0.9);
    transform-origin: right bottom;
  }

  .compact-row {
    gap: 4px;
  }

  .checkin-btn {
    width: 72px;
    min-width: 72px;
    font-size: 11px;
  }

  .status-chip,
  .meta-item {
    font-size: 11px;
  }

  .month-title {
    min-width: 102px;
    font-size: 10px;
  }

  .day-cell {
    font-size: 9px;
  }
}

@media (max-width: 768px) {
  .floating-checkin-shell {
    right: 12px;
    top: auto;
    bottom: 12px;
    transform: none;
    width: min(360px, calc(100vw - 24px));
  }
}
</style>
