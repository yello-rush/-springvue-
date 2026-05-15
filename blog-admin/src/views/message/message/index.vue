<template>
    <div class="app-container">
      <el-card v-permission="['sys:message:send']" class="box-card" style="margin-bottom: 16px;">
        <template #header>
          <div class="card-header">
            <span>系统消息推送</span>
          </div>
        </template>
        <el-form :model="systemForm" label-width="88px" inline>
          <el-form-item label="消息标题">
            <el-input v-model="systemForm.title" placeholder="请输入系统消息标题" style="width: 260px;" maxlength="60" show-word-limit />
          </el-form-item>
          <el-form-item label="跳转链接">
            <el-input v-model="systemForm.link" placeholder="可选，例：https://xxx.com" style="width: 320px;" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" :loading="sendLoading" @click="handleSendSystemMessage">向全体用户发送</el-button>
          </el-form-item>
        </el-form>
        <el-input
          v-model="systemForm.content"
          type="textarea"
          :rows="3"
          maxlength="500"
          show-word-limit
          placeholder="请输入系统消息内容"
        />
      </el-card>
 
  
      <!-- 操作按钮区域 -->
      <el-card class="box-card">
        <template #header>
          <div class="card-header">
            <ButtonGroup>
              <el-button
                v-permission="['sys:message:delete']"
                type="danger"
                icon="Delete"
                :disabled="selectedIds.length === 0"
                @click="handleBatchDelete"
              >批量删除</el-button>
            </ButtonGroup>
          </div>
        </template>
  
        <!-- 数据表格 -->
        <el-table
          v-loading="loading"
          :data="messageList"
          style="width: 100%"
          @selection-change="handleSelectionChange"
        >
          <el-table-column type="selection"  width="55" align="center" />
          <el-table-column label="用户头像" align="center" prop="name" show-overflow-tooltip>
            <template #default="scope">
                <el-image :src="scope.row.avatar" style="width: 30px; height: 30px; border-radius: 50%;" />
            </template>
          </el-table-column>
          <el-table-column label="IP" align="center" prop="ip" show-overflow-tooltip />
          <el-table-column label="IP来源" align="center" prop="source" show-overflow-tooltip />
          <el-table-column label="留言内容" width="300" align="center" prop="content" show-overflow-tooltip>
            <template #default="scope">
                <span v-html="scope.row.content"></span>
            </template>
          </el-table-column>
          <el-table-column label="创建时间" align="center" prop="createTime" width="180" />
          <el-table-column label="操作" align="center" width="280" fixed="right">
            <template #default="scope">
              <el-button
                v-permission="['sys:message:delete']"
                type="danger"
                link
                icon="Delete"
                @click="handleDelete(scope.row)"
              >删除</el-button>
            </template>
          </el-table-column>
        </el-table>
  
        <!-- 分页组件 -->
        <div class="pagination-container">
          <el-pagination
            v-model:current-page="queryParams.pageNum"
            v-model:page-size="queryParams.pageSize"
            :page-sizes="[10, 20, 30, 50]"
            :total="total"
            :background="true"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>
      </el-card>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ElMessage, ElMessageBox } from 'element-plus'
  import {
    getMessageListApi,
    deleteMessageApi,
    sendSystemMessageApi
  } from '@/api/message/message'
  
  // 查询参数
  const queryParams = reactive({
    pageNum: 1,
    pageSize: 10,
    name: null
  })
  
  const loading = ref(false)
  const sendLoading = ref(false)
  const total = ref(0)
  const messageList = ref([])
  const systemForm = reactive({
    title: '',
    content: '',
    link: ''
  })
  
  // 选中项数组
  const selectedIds = ref<string[]>([])
  
  // 获取标签列表
  const getList = async () => {
    loading.value = true
    try {
      const { data } = await getMessageListApi(queryParams)
      messageList.value = data.records
      total.value = data.total
    } catch (error) {
    }
    loading.value = false
  }
  
  // 表格选择项变化
  const handleSelectionChange = (selection: any[]) => {
    selectedIds.value = selection.map(item => item.id)
  }
  
  // 批量删除
  const handleBatchDelete = () => {
    if (selectedIds.value.length === 0) return
    
    ElMessageBox.confirm(`是否确认删除 ${selectedIds.value.length} 条留言?`, '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(async () => {
      try {
        await deleteMessageApi(selectedIds.value)
        ElMessage.success('批量删除成功')
        getList()
        selectedIds.value = []
      } catch (error) {
      }
    })
  }
  
  // 删除
  const handleDelete = (row: any) => {
    ElMessageBox.confirm(`是否确认删除 ${row.nickname} 的留言?`, '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(async () => {
      try {
        await deleteMessageApi(row.id)
        ElMessage.success('删除成功')
        getList()
      } catch (error) {
      }
    })
  }

  const handleSendSystemMessage = async () => {
    if (!systemForm.title.trim()) {
      ElMessage.warning('请输入消息标题')
      return
    }
    if (!systemForm.content.trim()) {
      ElMessage.warning('请输入消息内容')
      return
    }
    sendLoading.value = true
    try {
      await sendSystemMessageApi(systemForm)
      ElMessage.success('系统消息已发送至全体用户')
      systemForm.title = ''
      systemForm.content = ''
      systemForm.link = ''
    } catch (error) {
    } finally {
      sendLoading.value = false
    }
  }

  // 搜索
  const handleQuery = () => {
    queryParams.pageNum = 1
    getList()
  }
  
  
  // 分页大小改变
  const handleSizeChange = (val: number) => {
    queryParams.pageSize = val
    getList()
  }
  
  // 页码改变
  const handleCurrentChange = (val: number) => {
    queryParams.pageNum = val
    getList()
  }
  
  // 初始化
  onMounted(() => {
    getList()
  })
  </script>
  
