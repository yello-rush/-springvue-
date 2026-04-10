<template>
  <div 
    v-if="slides && slides.length > 0"
    class="focus" 
    ref="focusRef"
    @mouseenter="onMouseEnter"
    @mouseleave="onMouseLeave"
    @touchstart="onTouchStart"
    @touchmove="onTouchMove"
    @touchend="onTouchEnd"
  >
    <a href="javascript:;" class="arrow-l arrow" @click.stop="prevSlide" v-if="slides.length > 1">&lt;</a>
    <a href="javascript:;" class="arrow-r arrow" @click.stop="nextSlide" v-if="slides.length > 1">&gt;</a>
    
    <ul 
      class="slide-list" 
      ref="ulRef" 
      :style="{ width: `${displaySlides.length * 100}%`, transform: `translateX(-${currentIndex * 100 / displaySlides.length}%)`, transition: isTransitioning ? 'transform 0.6s ease-in-out' : 'none' }"
      @transitionend="onTransitionEnd"
    >
      <!-- Slides -->
      <li 
        v-for="(slide, index) in displaySlides" 
        :key="index"
        :style="{ width: `${100 / displaySlides.length}%` }"
        @click.stop="goToLink(slide.link)"
      >
        <picture>
          <source v-if="slide.image_url && slide.image_url.match(/\.(jpg|png|jpeg)$/i)" type="image/webp" :srcset="getWebpSrcset(slide.image_url)" sizes="100vw">
          <img 
            :loading="index === 0 ? 'eager' : 'lazy'" 
            :fetchpriority="index === 0 ? 'high' : 'auto'"
            :src="slide.image_url" 
            :alt="slide.title" 
            style="width: 100%; height: 100%; object-fit: cover; display: block; border-radius: 8px;"
            @error="handleImageError"
          >
        </picture>
        <div class="slide-content">
          <h3>{{ slide.title }}</h3>
          <p class="summary" v-if="slide.summary">{{ slide.summary }}</p>
        </div>
      </li>
    </ul>

    <ol class="circle" v-if="slides.length > 1">
      <li 
        v-for="(slide, index) in slides" 
        :key="index"
        :class="{ current: index === currentDot }"
        @click.stop="goToSlide(index)"
      ></li>
    </ol>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'

const props = defineProps({
  slides: {
    type: Array,
    default: () => []
  }
})

const focusRef = ref(null)
const ulRef = ref(null)

const currentIndex = ref(0)
const currentDot = ref(0)
const isTransitioning = ref(true)
let timer = null
let touchStartX = 0
let touchEndX = 0

const displaySlides = computed(() => {
  if (!props.slides || props.slides.length === 0) return []
  // Only clone if there is more than 1 slide to make infinite loop work visually smoothly
  if (props.slides.length === 1) return props.slides
  return [...props.slides, props.slides[0]]
})

const getWebpSrcset = (url) => {
  if (!url) return ''
  
  // 处理外部图片链接（如 picsum.photos）或无扩展名的情况
  if (!url.match(/\.(jpg|png|jpeg)$/i)) {
    return '' // 没有匹配到扩展名的不生成 srcset，直接让 img 的 src 去处理
  }
  
  // Simulate multi-resolution by appending suffixes. In production, these should be real paths.
  const base = url.replace(/\.(jpg|png|jpeg)$/i, '')
  return `${base}_720p.webp 720w, ${base}_1080p.webp 1080w, ${base}_2x.webp 2000w`
}

const emit = defineEmits(['click'])

const handleImageError = (e) => {
  // If image fails to load, try to use a fallback or hide it
  e.target.style.display = 'none';
}

const goToLink = (link) => {
  if (link && link.startsWith('/post/')) {
    const id = link.split('/').pop()
    emit('click', id)
  } else if (link && link !== '/') {
    window.open(link, '_blank')
  }
}

const startAutoPlay = () => {
  if (timer) clearInterval(timer)
  if (props.slides.length <= 1) return
  timer = setInterval(() => {
    nextSlide()
  }, 4000) // 延迟4秒
}

const stopAutoPlay = () => {
  if (timer) clearInterval(timer)
}

const nextSlide = () => {
  if (props.slides.length <= 1) return
  if (currentIndex.value >= props.slides.length) {
    isTransitioning.value = false
    currentIndex.value = 0
    // Force reflow
    void ulRef.value.offsetWidth
  }
  if (!isTransitioning.value) isTransitioning.value = true
  currentIndex.value++
  updateDot()
}

const prevSlide = () => {
  if (props.slides.length <= 1) return
  if (currentIndex.value <= 0) {
    isTransitioning.value = false
    currentIndex.value = props.slides.length
    // Force reflow
    void ulRef.value.offsetWidth
    isTransitioning.value = true
  }
  currentIndex.value--
  updateDot()
}

const updateDot = () => {
  if (!props.slides || props.slides.length === 0) return
  if (currentIndex.value >= props.slides.length) {
    currentDot.value = 0
  } else if (currentIndex.value < 0) {
    currentDot.value = props.slides.length - 1
  } else {
    currentDot.value = currentIndex.value
  }
}

const goToSlide = (index) => {
  if (props.slides.length <= 1) return
  isTransitioning.value = true
  currentIndex.value = index
  currentDot.value = index
}

const onTransitionEnd = () => {
  if (props.slides.length <= 1) return
  if (currentIndex.value >= props.slides.length) {
    isTransitioning.value = false
    currentIndex.value = 0
    currentDot.value = 0
  }
}

const onMouseEnter = () => {
  stopAutoPlay()
}

const onMouseLeave = () => {
  startAutoPlay()
}

const onTouchStart = (e) => {
  stopAutoPlay()
  touchStartX = e.changedTouches[0].clientX
}

const onTouchMove = (e) => {
  touchEndX = e.changedTouches[0].clientX
}

const onTouchEnd = () => {
  if (props.slides.length <= 1) return
  if (touchStartX - touchEndX > 50) {
    nextSlide()
  } else if (touchEndX - touchStartX > 50) {
    prevSlide()
  }
  startAutoPlay()
}

onMounted(() => {
  if (props.slides.length > 1) {
    startAutoPlay()
  }
})

onUnmounted(() => {
  stopAutoPlay()
})

watch(() => props.slides, (newVal) => {
  if (newVal.length > 1) {
    startAutoPlay()
  } else {
    stopAutoPlay()
  }
}, { deep: true })
</script>

<style lang="scss" scoped>
.focus {
  position: relative;
  width: 100%;
  height: 400px;
  overflow: hidden;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  
  @media (max-width: 768px) {
    height: 280px;
  }
  
  &:hover .arrow {
    display: block;
  }
}

.arrow {
  display: none;
  width: 40px;
  height: 60px;
  line-height: 60px;
  text-align: center;
  background: rgba(0, 0, 0, 0.3);
  color: #fff;
  font-size: 24px;
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  z-index: 11;
  transition: background 0.3s;
  text-decoration: none;
  
  &:hover {
    background: rgba(0, 0, 0, 0.6);
  }
}

.arrow-l {
  left: 0;
  border-radius: 0 30px 30px 0;
}

.arrow-r {
  right: 0;
  border-radius: 30px 0 0 30px;
}

.slide-list {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  display: flex;
  margin: 0;
  padding: 0;
}

.slide-list li {
  height: 100%;
  position: relative;
  cursor: pointer;
  border-radius: 8px;
  overflow: hidden;
  list-style: none;
}

.slide-list li picture, .slide-list li img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.circle {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 10px;
  padding: 4px 8px;
  z-index: 10;
  margin: 0;
}

.circle li {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: #fff;
  margin: 0 5px;
  cursor: pointer;
  transition: all 0.3s;
  list-style: none;
}

.circle li.current {
  width: 20px;
  border-radius: 5px;
  background: var(--color-primary, #409EFF);
}

.slide-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 40px 20px 20px;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
  color: white;
  pointer-events: none;
  border-bottom-left-radius: 8px;
  border-bottom-right-radius: 8px;
  
  h3 {
    font-size: 24px;
    font-weight: 600;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
    margin-bottom: 10px;
  }
  
  .summary {
    font-size: 15px;
    opacity: 0.9;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    margin-bottom: 20px;
    line-height: 1.5;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
  }
}
</style> 