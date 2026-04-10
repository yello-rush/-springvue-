<template>
  <div class="revision-history">
    <el-card>
      <div slot="header" class="clearfix">
        <el-button type="text" icon="el-icon-back" @click="$router.back()">返回文章</el-button>
        <span class="title">文章修订记录</span>
      </div>

      <el-row :gutter="20">
        <!-- 左侧：版本列表 -->
        <el-col :span="8">
          <div class="history-list">
            <h3 class="list-title"><i class="el-icon-time"></i> 版本历史</h3>
            <div class="timeline-container" v-loading="loading">
              <el-empty v-if="!loading && historyList.length === 0" description="暂无历史版本" />
              <el-timeline v-else>
                <el-timeline-item
                  v-for="(item, index) in historyList"
                  :key="item.id"
                  :timestamp="item.createTime"
                  :type="selectedVersion && selectedVersion.id === item.id ? 'primary' : 'info'"
                  placement="top"
                >
                  <el-card 
                    class="version-card" 
                    :class="{ active: selectedVersion && selectedVersion.id === item.id }"
                    @click.native="selectVersion(item, index)"
                  >
                    <h4>V{{ item.version }}</h4>
                    <p class="summary">{{ item.summary || '无摘要' }}</p>
                    <p class="author">修改人: {{ item.createBy || '系统' }}</p>
                  </el-card>
                </el-timeline-item>
              </el-timeline>
            </div>
          </div>
        </el-col>

        <!-- 右侧：差异对比 -->
        <el-col :span="16">
          <div class="diff-viewer" v-loading="diffLoading">
            <h3 class="list-title">
              <i class="el-icon-document"></i> 版本对比
              <span v-if="selectedVersion" class="compare-info">
                ( V{{ selectedVersion.version }} 与 当前最新 )
              </span>
            </h3>
            <div v-if="!selectedVersion" class="empty-diff">
              <el-empty description="请在左侧选择要对比的版本" />
            </div>
            <div v-else class="diff-content" v-html="diffHtml"></div>
          </div>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import request from '@/utils/request'
import { createPatch } from 'diff'
import * as Diff2Html from 'diff2html'
import 'diff2html/bundles/css/diff2html.min.css'

export default {
  name: 'ArticleRevision',
  data() {
    return {
      articleId: this.$route.params.id,
      currentArticle: null,
      historyList: [],
      selectedVersion: null,
      loading: false,
      diffLoading: false,
      diffHtml: ''
    }
  },
  created() {
    this.fetchCurrentArticle();
    this.fetchHistoryList();
  },
  methods: {
    async fetchCurrentArticle() {
      try {
        const res = await request({
          url: `/api/article/detail/${this.articleId}`,
          method: 'get'
        });
        if (res.code === 200) {
          this.currentArticle = res.data;
        }
      } catch (e) {
        console.error(e);
      }
    },
    async fetchHistoryList() {
      this.loading = true;
      try {
        const res = await request({
          url: `/api/article/history/list/${this.articleId}`,
          method: 'get'
        });
        if (res.code === 200) {
          this.historyList = res.data || [];
        }
      } catch (e) {
        console.error(e);
      } finally {
        this.loading = false;
      }
    },
    async selectVersion(item, index) {
      if (this.selectedVersion && this.selectedVersion.id === item.id) return;
      this.selectedVersion = item;
      await this.generateDiff(item);
    },
    async generateDiff(versionItem) {
      this.diffLoading = true;
      try {
        // 获取完整版本详情
        const res = await request({
          url: `/api/article/history/${versionItem.id}`,
          method: 'get'
        });
        
        if (res.code === 200) {
          const oldText = res.data.contentMd || '';
          const newText = this.currentArticle ? (this.currentArticle.contentMd || '') : '';
          
          const diffStr = createPatch(
            '文章内容',
            oldText,
            newText,
            `版本 V${versionItem.version}`,
            '当前最新'
          );

          this.diffHtml = Diff2Html.html(diffStr, {
            drawFileList: false,
            matching: 'lines',
            outputFormat: 'side-by-side',
          });
        }
      } catch (e) {
        console.error(e);
        this.$message.error('获取版本详情失败');
      } finally {
        this.diffLoading = false;
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.revision-history {
  max-width: 1200px;
  margin: 20px auto;
  padding: 0 20px;
}

.title {
  font-size: 1.2rem;
  font-weight: bold;
  margin-left: 10px;
}

.list-title {
  margin-top: 0;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid var(--border-color, #eee);
  color: var(--text-primary, #333);
}

.timeline-container {
  max-height: 600px;
  overflow-y: auto;
  padding-right: 10px;
  
  &::-webkit-scrollbar {
    width: 6px;
  }
  &::-webkit-scrollbar-thumb {
    background: #ccc;
    border-radius: 3px;
  }
}

.version-card {
  cursor: pointer;
  transition: all 0.3s;
  
  &:hover {
    border-color: #409EFF;
    box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
  }
  
  &.active {
    border-color: #409EFF;
    background-color: #f0f7ff;
  }
  
  h4 {
    margin: 0 0 10px;
    color: #409EFF;
  }
  
  .summary {
    font-size: 0.9rem;
    color: #666;
    margin-bottom: 8px;
  }
  
  .author {
    font-size: 0.8rem;
    color: #999;
    margin: 0;
  }
}

.diff-viewer {
  border-left: 1px solid var(--border-color, #eee);
  padding-left: 20px;
  height: 100%;
}

.compare-info {
  font-size: 0.9rem;
  color: #666;
  font-weight: normal;
  margin-left: 10px;
}

.diff-content {
  max-height: 600px;
  overflow-y: auto;
  border: 1px solid #ddd;
  border-radius: 4px;
}

:deep(.d2h-file-header) {
  display: none;
}
</style>