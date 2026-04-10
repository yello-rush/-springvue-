<template>
  <div class="logo-wrapper">
    <img v-if="logo" :src="logo" class="sidebar-logo" />
  </div>
</template>

<script setup lang="ts">
import settings from '@/config/settings'

defineProps({
  collapse: {
    type: Boolean,
    required: true
  },
  size: {
    type: Number,
    default: 32
  },
  color: {
    type: String,
    default: ''
  }
})

const logo = import.meta.env.VITE_APP_LOGO
</script>

<style lang="scss" scoped>
.logo-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;

  .sidebar-logo {
    width: 32px;
    height: 32px;
    vertical-align: middle;
  }
}
</style>
