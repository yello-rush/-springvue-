<template>
  <div class="search-box-container" :class="{ 'is-focused': isFocused }">
    <div class="search-input-wrapper">
      <i class="fas fa-search search-icon"></i>
      <input 
        type="text" 
        class="search-input" 
        v-model="searchQuery" 
        placeholder="搜索文章..."
        @focus="handleFocus"
        @blur="handleBlur"
        @input="handleInput"
        @keyup.enter="goToSearch"
      >
      <i class="fas fa-times clear-icon" v-show="searchQuery" @click="clearSearch"></i>
    </div>
    
    <!-- 实时下拉提示 -->
    <transition name="slide-fade">
      <div class="search-dropdown" v-if="isFocused && (searchResults.length > 0 || isSearching)">
        <div class="search-loading" v-if="isSearching">
          <i class="fas fa-spinner fa-spin"></i> 搜索中...
        </div>
        <div class="search-results" v-else-if="searchResults.length > 0">
          <div class="result-item" v-for="item in searchResults" :key="item.id" @mousedown.prevent="goToArticle(item.id)">
            <div class="result-title" v-html="highlightKeyword(item.title)"></div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { searchArticlesApi } from '@/api/article';

export default {
  name: 'SearchBox',
  data() {
    return {
      searchQuery: '',
      isFocused: false,
      isSearching: false,
      searchResults: [],
      debounceTimer: null
    }
  },
  methods: {
    handleFocus() {
      this.isFocused = true;
      if (this.searchQuery) {
        this.doSearch();
      }
    },
    handleBlur() {
      this.isFocused = false;
    },
    handleInput() {
      clearTimeout(this.debounceTimer);
      if (!this.searchQuery.trim()) {
        this.searchResults = [];
        this.isSearching = false;
        return;
      }
      this.isSearching = true;
      this.debounceTimer = setTimeout(() => {
        this.doSearch();
      }, 300);
    },
    async doSearch() {
      if (!this.searchQuery.trim()) return;
      try {
        const res = await searchArticlesApi(this.searchQuery);
        this.searchResults = res.data.slice(0, 5) || [];
      } catch (err) {
        console.error('Search failed', err);
      } finally {
        this.isSearching = false;
      }
    },
    clearSearch() {
      this.searchQuery = '';
      this.searchResults = [];
      // Keep focus
      this.$el.querySelector('.search-input').focus();
    },
    goToArticle(id) {
      this.$router.push(`/article/${id}`);
    },
    goToSearch() {
      if (this.searchQuery.trim()) {
        // Maybe navigate to search page, or use global search modal
        this.$store.commit('SET_SEARCH_VISIBLE', true);
        this.$emit('search', this.searchQuery);
        this.$el.querySelector('.search-input').blur();
      }
    },
    highlightKeyword(text) {
      if (!this.searchQuery) return text;
      const regex = new RegExp(`(${this.searchQuery.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
      return text.replace(regex, '<mark>$1</mark>');
    }
  }
}
</script>

<style lang="scss" scoped>
.search-box-container {
  position: relative;
  margin-bottom: 20px;
  width: 100%;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  
  &.is-focused {
    transform: scale(1.02);
    z-index: 10;
    
    .search-input-wrapper {
      box-shadow: 0 8px 20px rgba(99, 102, 241, 0.15);
      border-color: #6366f1;
    }
    
    .search-icon {
      color: #6366f1;
    }
  }
}

.search-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  background: var(--card-bg, #fff);
  border-radius: 24px;
  padding: 0 16px;
  height: 48px;
  border: 1px solid var(--border-color, #e5e7eb);
  transition: all 0.3s ease;
  
  .search-icon {
    color: #9ca3af;
    font-size: 16px;
    transition: color 0.3s ease;
  }
  
  .search-input {
    flex: 1;
    border: none;
    background: transparent;
    padding: 0 12px;
    font-size: 15px;
    color: var(--text-primary, #1f2937);
    outline: none;
    width: 100%;
    
    &::placeholder {
      color: #9ca3af;
    }
  }
  
  .clear-icon {
    color: #9ca3af;
    cursor: pointer;
    font-size: 14px;
    padding: 4px;
    
    &:hover {
      color: #6b7280;
    }
  }
}

.search-dropdown {
  position: absolute;
  top: calc(100% + 8px);
  left: 0;
  right: 0;
  background: var(--card-bg, #fff);
  border-radius: 12px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  z-index: 100;
  border: 1px solid var(--border-color, #e5e7eb);
}

.search-loading {
  padding: 16px;
  text-align: center;
  color: #6b7280;
  font-size: 14px;
}

.search-results {
  max-height: 300px;
  overflow-y: auto;
  
  .result-item {
    padding: 12px 16px;
    cursor: pointer;
    transition: background 0.2s;
    border-bottom: 1px solid var(--border-color, #f3f4f6);
    
    &:last-child {
      border-bottom: none;
    }
    
    &:hover {
      background: var(--hover-bg, #f9fafb);
    }
    
    .result-title {
      font-size: 14px;
      color: var(--text-primary, #374151);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      
      :deep(mark) {
        background-color: transparent;
        color: #6366f1;
        font-weight: 600;
        padding: 0;
      }
    }
  }
}

.slide-fade-enter-active {
  transition: all 0.3s ease;
}
.slide-fade-leave-active {
  transition: all 0.2s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}
.slide-fade-enter, .slide-fade-leave-to {
  transform: translateY(-10px);
  opacity: 0;
}
</style>