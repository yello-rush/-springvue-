<template>
  <div class="app-container">
    <el-card>
      <div class="header-box">
        <el-button type="primary" @click="handleAdd">新增轮播图</el-button>
      </div>
      
      <el-table :data="tableData" v-loading="loading" border style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column label="图片" width="200" align="center">
          <template #default="scope">
            <el-image 
              :src="scope.row.image_url" 
              :preview-src-list="[scope.row.image_url]"
              fit="cover"
              style="width: 160px; height: 90px; border-radius: 4px;"
            />
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" align="center" />
        <el-table-column prop="link" label="跳转链接" align="center" />
        <el-table-column prop="position" label="排序" width="150" align="center">
          <template #default="scope">
            <el-input-number 
              v-model="scope.row.position" 
              :min="0" 
              size="small" 
              @change="handlePositionChange(scope.row)" 
              style="width: 100px" 
            />
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template #default="scope">
            <el-switch
              v-model="scope.row.status"
              :active-value="1"
              :inactive-value="0"
              @change="handleStatusChange(scope.row)"
            />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" align="center">
          <template #default="scope">
            <el-button type="primary" link @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <el-pagination
        v-model:current-page="queryParams.pageNum"
        v-model:page-size="queryParams.pageSize"
        :total="total"
        @current-change="getList"
        layout="prev, pager, next"
        class="pagination"
      />
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="图片链接" prop="image_url">
          <el-input v-model="form.image_url" placeholder="请输入图片链接" />
        </el-form-item>
        <el-form-item label="跳转链接" prop="link">
          <el-input v-model="form.link" placeholder="请输入跳转链接" />
        </el-form-item>
        <el-form-item label="排序" prop="position">
          <el-input-number v-model="form.position" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue"
import { ElMessage, ElMessageBox } from "element-plus"
import request from "@/utils/request"

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const queryParams = ref({
  pageNum: 1,
  pageSize: 10
})

const dialogVisible = ref(false)
const dialogTitle = ref("")
const formRef = ref()
const form = ref({
  id: undefined,
  title: "",
  image_url: "",
  link: "",
  position: 0,
  status: 1
})

const rules = {
  image_url: [{ required: true, message: "请输入图片链接", trigger: "blur" }]
}

const getList = () => {
  loading.value = true
  request({
    url: "/sys/slide/list",
    method: "get",
    params: queryParams.value
  }).then(res => {
    tableData.value = res.data.records
    total.value = res.data.total
  }).finally(() => {
    loading.value = false
  })
}

const handleAdd = () => {
  form.value = {
    id: undefined,
    title: "",
    image_url: "",
    link: "",
    position: 0,
    status: 1
  }
  dialogTitle.value = "新增轮播图"
  dialogVisible.value = true
}

const handleEdit = (row) => {
  form.value = { ...row }
  dialogTitle.value = "修改轮播图"
  dialogVisible.value = true
}

const submitForm = () => {
  formRef.value.validate(valid => {
    if (valid) {
      if (form.value.id) {
        request({
          url: "/sys/slide/update",
          method: "put",
          data: form.value
        }).then(() => {
          ElMessage.success("修改成功")
          dialogVisible.value = false
          getList()
        })
      } else {
        request({
          url: "/sys/slide/add",
          method: "post",
          data: form.value
        }).then(() => {
          ElMessage.success("新增成功")
          dialogVisible.value = false
          getList()
        })
      }
    }
  })
}

const handleDelete = (row) => {
  ElMessageBox.confirm("确认删除该轮播图?", "警告", {
    type: "warning"
  }).then(() => {
    request({
      url: `/sys/slide/delete/${row.id}`,
      method: "delete"
    }).then(() => {
      ElMessage.success("删除成功")
      getList()
    })
  })
}

const handleStatusChange = (row) => {
  request({
    url: "/sys/slide/update",
    method: "put",
    data: { id: row.id, status: row.status }
  }).then(() => {
    ElMessage.success("状态修改成功")
  }).catch(() => {
    row.status = row.status === 1 ? 0 : 1
  })
}

const handlePositionChange = (row) => {
  request({
    url: "/sys/slide/update",
    method: "put",
    data: { id: row.id, position: row.position }
  }).then(() => {
    ElMessage.success("排序修改成功")
    getList()
  })
}

onMounted(() => {
  getList()
})
</script>

<style scoped>
.header-box {
  margin-bottom: 20px;
}
.pagination {
  margin-top: 20px;
  justify-content: flex-end;
}
</style>