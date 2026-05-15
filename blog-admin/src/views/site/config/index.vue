<template>
  <div class="app-container">
    <el-card>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
        <el-tabs v-model="activeTab">
          <!-- 基本信息 Tab -->
          <el-tab-pane name="basic">
            <template #label>
              <el-icon>
                <Setting />
              </el-icon>
              <span class="tab-label">基本信息</span>
            </template>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="网站Logo" prop="logo">
                  <upload-image v-model="form.logo" :limit="1" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="网站名称" prop="name">
                  <el-input v-model="form.name" placeholder="请输入网站名称" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="网站介绍" prop="summary">
                  <el-input v-model="form.summary" type="textarea" placeholder="请输入网站介绍" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>
        </el-tabs>

        <!-- 底部按钮 -->
        <div class="bottom-buttons">
          <el-button icon="Refresh" type="primary" v-permission="['sys:web:update']" @click="submitForm">保存配置</el-button>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ElMessage } from 'element-plus'
import type { FormInstance } from 'element-plus'
import UploadImage from '@/components/Upload/Image.vue'
import { getWebConfigApi, updateWebConfigApi } from '@/api/site/config'

const activeTab = ref('basic')
const formRef = ref<FormInstance>()
const form = ref({
  logo: '',
  name: '',
  summary: '',
  webUrl: '',
  author: '',
  authorInfo: '',
  authorAvatar: '',
  github: '',
  gitee: '',
  qqNumber: '',
  qqGroup: '',
  wechat: '',
  email: '',
  bulletin: '',
  aboutMe: '',
})

const rules = {
  name: [{ required: true, message: '请输入网站名称', trigger: 'blur' }],
  logo: [{ required: true, message: '请上传网站Logo', trigger: 'change' }],
  summary: [{ required: true, message: '请输入网站介绍', trigger: 'blur' }]
}

// 提交表单
const submitForm = async () => {
  if (!formRef.value) return
  await formRef.value.validate((valid) => {
    if (valid) {
      updateWebConfigApi(form.value).then(() => {
        ElMessage.success('保存成功')
      })
    }
  })
}

onMounted(() => {
  getWebConfigApi().then((res) => {
    form.value = res.data
  })
})
</script>

<style scoped>
.app-container {
  padding: 10px;
}

.bottom-buttons {
  margin-top: 20px;
  text-align: center;
}

.tab-label {
  margin-left: 4px;
  vertical-align: middle;
}

:deep(.el-tabs__item) {
  display: flex !important;
  align-items: center;
  justify-content: center;
}

:deep(.el-input-group__prepend) {
  padding: 0 10px;
}

.el-form-item {
  max-width: 600px;
}
</style>
