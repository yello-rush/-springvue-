<template>
  <div class="app-container">
    <el-card class="box-card mb-10">
      <el-form :inline="true" :model="queryParams" class="demo-form-inline">
        <el-form-item label="作者名称">
          <el-input v-model="queryParams.name" placeholder="请输入作者名称" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <ButtonGroup>
            <el-button type="primary" icon="Plus" @click="handleAdd" v-permission="['sys:author:add']">新增</el-button>
            <el-button type="danger" icon="Delete" :disabled="selectedIds.length === 0" @click="handleBatchDelete" v-permission="['sys:author:delete']">批量删除</el-button>
          </ButtonGroup>
        </div>
      </template>

      <el-table v-loading="loading" :data="authorList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="头像" align="center" width="100">
          <template #default="scope">
            <el-avatar :src="scope.row.avatar" />
          </template>
        </el-table-column>
        <el-table-column label="名称" align="center" prop="name" />
        <el-table-column label="个人简介" align="center" prop="description" show-overflow-tooltip />
        <el-table-column label="创建时间" align="center" prop="createTime" width="180" />
        <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-permission="['sys:author:update']">修改</el-button>
            <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)" v-permission="['sys:author:delete']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-container">
        <el-pagination v-model:current-page="queryParams.pageNum" v-model:page-size="queryParams.pageSize"
          :page-sizes="[10, 20, 30, 50]" :total="total" :background="true"
          layout="total, sizes, prev, pager, next, jumper" @size-change="getList"
          @current-change="getList" />
      </div>
    </el-card>

    <el-dialog :title="title" v-model="open" width="500px" append-to-body destroy-on-close>
      <el-form ref="authorRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入作者名称" />
        </el-form-item>
        <el-form-item label="头像" prop="avatar">
          <UploadImage v-model="form.avatar" :limit="1" />
        </el-form-item>
        <el-form-item label="简介" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listAuthorApi, addAuthorApi, updateAuthorApi, deleteAuthorApi } from '@/api/site/author'
import UploadImage from '@/components/Upload/Image.vue'

const loading = ref(true)
const authorList = ref([])
const total = ref(0)
const selectedIds = ref<number[]>([])
const open = ref(false)
const title = ref('')
const authorRef = ref()

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  name: ''
})

const form = reactive<any>({
  id: undefined,
  name: '',
  avatar: '',
  description: ''
})

const rules = {
  name: [{ required: true, message: '名称不能为空', trigger: 'blur' }],
  avatar: [{ required: true, message: '头像不能为空', trigger: 'change' }]
}

const getList = async () => {
  loading.value = true
  try {
    const res = await listAuthorApi(queryParams)
    authorList.value = res.data.records || res.data.list || res.data
    total.value = res.data.total
  } finally {
    loading.value = false
  }
}

const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

const resetQuery = () => {
  queryParams.name = ''
  handleQuery()
}

const handleSelectionChange = (selection: any[]) => {
  selectedIds.value = selection.map(item => item.id)
}

const reset = () => {
  form.id = undefined
  form.name = ''
  form.avatar = ''
  form.description = ''
  if (authorRef.value) {
    authorRef.value.resetFields()
  }
}

const handleAdd = () => {
  reset()
  open.value = true
  title.value = '添加作者'
}

const handleUpdate = (row: any) => {
  reset()
  Object.assign(form, row)
  open.value = true
  title.value = '修改作者'
}

const submitForm = () => {
  authorRef.value?.validate(async (valid: boolean) => {
    if (valid) {
      if (form.id) {
        await updateAuthorApi(form)
        ElMessage.success('修改成功')
      } else {
        await addAuthorApi(form)
        ElMessage.success('添加成功')
      }
      open.value = false
      getList()
    }
  })
}

const handleDelete = (row: any) => {
  ElMessageBox.confirm(`是否确认删除名称为"${row.name}"的数据项?`, '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    await deleteAuthorApi(row.id)
    ElMessage.success('删除成功')
    getList()
  })
}

const handleBatchDelete = () => {
  if (selectedIds.value.length === 0) return
  ElMessageBox.confirm(`是否确认删除选中的 ${selectedIds.value.length} 条数据?`, '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    await deleteAuthorApi(selectedIds.value.join(','))
    ElMessage.success('删除成功')
    getList()
  })
}

const cancel = () => {
  open.value = false
  reset()
}

onMounted(() => {
  getList()
})
</script>