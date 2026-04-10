<template>
  <div class="tag-wall">
    <div class="tag-container">
      <div
        v-for="(item, index) in data"
        :key="index"
        class="tag-item"
        :style="{ backgroundColor: getRandomColor() }"
        @click="clickTag(item)"
      >
        {{ item.name }}
      </div>
    </div>
  </div>
</template>

<script>
import { getTagsApi } from '@/api/tags'

export default {
  data() {
    return {
      data: [],
      colors: [
        '#ec407a', '#ab47bc', '#42a5f5', '#26c6da', '#26a69a',
        '#66bb6a', '#ffa726', '#ff7043', '#8d6e63', '#78909c'
      ]
    };
  },
  mounted() {
    getTagsApi().then(res => {
      this.data = res.data
    })
  },
  methods: {
    clickTag(item) {
      this.$router.push({
        path: '/tags',
        query: {
          tagId: item.id,
          tagName: item.name
        }
      })
    },
    getRandomColor() {
      return this.colors[Math.floor(Math.random() * this.colors.length)];
    }
  },
};
</script>

<style lang="scss" scoped>
.tag-wall {
  padding: 10px;
}

.tag-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.tag-item {
  padding: 6px 12px;
  border-radius: 6px;
  color: white;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  opacity: 0.85;

  &:hover {
    opacity: 1;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
  }
}
</style>
