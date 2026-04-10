<template>
  <div class="transition-loader" :style="{ '--transition-duration': duration + 'ms' }">
    <transition name="fade-loader" mode="out-in">
      <div v-if="loading" class="loader-skeleton" key="skeleton">
        <div class="skeleton-grid">
          <div v-for="i in skeletonCount" :key="i" class="skeleton-card">
            <div class="skeleton-cover"></div>
            <div class="skeleton-content">
              <div class="skeleton-meta">
                <div class="skeleton-text short"></div>
                <div class="skeleton-text very-short"></div>
              </div>
              <div class="skeleton-title"></div>
              <div class="skeleton-summary">
                <div class="skeleton-text"></div>
                <div class="skeleton-text"></div>
                <div class="skeleton-text medium"></div>
              </div>
              <div class="skeleton-footer">
                <div class="skeleton-author">
                  <div class="skeleton-avatar"></div>
                  <div class="skeleton-text short"></div>
                </div>
                <div class="skeleton-stats">
                  <div class="skeleton-text very-short"></div>
                  <div class="skeleton-text very-short"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="loader-content" key="content">
        <slot></slot>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'TransitionLoader',
  props: {
    loading: {
      type: Boolean,
      required: true
    },
    duration: {
      type: Number,
      default: 500 // 默认动画时长500ms
    },
    skeletonCount: {
      type: Number,
      default: 6
    }
  }
}
</script>

<style lang="scss" scoped>
.transition-loader {
  position: relative;
  width: 100%;
  min-height: 200px;
}

.fade-loader-enter-active,
.fade-loader-leave-active {
  transition: opacity var(--transition-duration) ease;
}

.fade-loader-enter,
.fade-loader-leave-to {
  opacity: 0;
}

.skeleton-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  
  @media (max-width: 640px) {
    grid-template-columns: 1fr;
  }
}

.skeleton-card {
  background: var(--surface, #ffffff);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 10px 30px -10px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
  height: 100%;
}

.skeleton-cover {
  width: 100%;
  padding-top: 60%;
  background: linear-gradient(90deg, #f0f2f5 25%, #e6e8eb 37%, #f0f2f5 63%);
  background-size: 400% 100%;
  animation: skeleton-loading 1.4s ease infinite;
}

.skeleton-content {
  padding: 24px;
  display: flex;
  flex-direction: column;
  flex: 1;
}

.skeleton-meta {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12px;
}

.skeleton-title {
  height: 24px;
  width: 80%;
  border-radius: 4px;
  margin-bottom: 16px;
  background: linear-gradient(90deg, #f0f2f5 25%, #e6e8eb 37%, #f0f2f5 63%);
  background-size: 400% 100%;
  animation: skeleton-loading 1.4s ease infinite;
}

.skeleton-summary {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 20px;
  flex: 1;
}

.skeleton-text {
  height: 14px;
  width: 100%;
  border-radius: 4px;
  background: linear-gradient(90deg, #f0f2f5 25%, #e6e8eb 37%, #f0f2f5 63%);
  background-size: 400% 100%;
  animation: skeleton-loading 1.4s ease infinite;
  
  &.medium { width: 60%; }
  &.short { width: 40%; }
  &.very-short { width: 20%; }
}

.skeleton-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20px;
  border-top: 1px solid var(--border-color, #eee);
}

.skeleton-author {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 50%;
}

.skeleton-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: linear-gradient(90deg, #f0f2f5 25%, #e6e8eb 37%, #f0f2f5 63%);
  background-size: 400% 100%;
  animation: skeleton-loading 1.4s ease infinite;
}

.skeleton-stats {
  display: flex;
  gap: 15px;
  width: 30%;
  justify-content: flex-end;
}

@keyframes skeleton-loading {
  0% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0 50%;
  }
}
</style>
