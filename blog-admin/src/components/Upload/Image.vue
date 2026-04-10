<template>
  <div class="upload-container">
    <div class="el-upload-list el-upload-list--picture-card">
      <div v-for="(file, index) in fileList" :key="index" class="el-upload-list__item is-success">
        <img class="el-upload-list__item-thumbnail" :src="file.url" alt="" />
        <span class="el-upload-list__item-actions">
          <span class="el-upload-list__item-preview" @click="handlePreview(file)">
            <el-icon><zoom-in /></el-icon>
          </span>
          <span class="el-upload-list__item-delete" @click="handleRemove(index)">
            <el-icon><delete /></el-icon>
          </span>
        </span>
      </div>
      <div v-if="fileList.length < limit" class="el-upload el-upload--picture-card" @click="selectorVisible = true">
        <el-icon><Plus /></el-icon>
      </div>
    </div>

    <!-- 图片选择器 -->
    <GallerySelector v-model="selectorVisible" :source="source" @select="handleSelect" />

    <!-- 图片预览对话框 -->
    <el-dialog v-model="dialogVisible" top="5vh" title="预览图片">
      <img :src="dialogImageUrl" alt="Preview Image" style="width: 100%; height: 500px; object-fit: contain;" />
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { Plus } from '@element-plus/icons-vue'
import type { UploadUserFile } from 'element-plus'
import GallerySelector from './GallerySelector.vue'
import { getToken } from '@/utils/auth'
const props = defineProps({
  modelValue: {
    type: [String, Array],
    default: ''
  },
  limit: {
    type: Number,
    default: 1
  },
  fileSize: {
    type: Number,
    default: 5
  },
  multiple: {
    type: Boolean,
    default: false
  },
  source: {
    type: String,
    default: 'default'
  }
})

const emit = defineEmits(['update:modelValue'])

// 上传地址
const uploadUrl =  `${import.meta.env.VITE_APP_BASE_API}/file/upload?source=${props.source}`

// 请求头
const headers = {
  Authorization: getToken()
}

const fileList = ref<UploadUserFile[]>([])
const dialogImageUrl = ref('')
const dialogVisible = ref(false)
const selectorVisible = ref(false)

const handleSelect = (url: string) => {
  fileList.value.push({ name: url.substring(url.lastIndexOf('/') + 1), url })
  updateModelValue()
}

// 初始化文件列表
const initFileList = () => {
  if (!props.modelValue) return
  
  if (typeof props.modelValue === 'string') {
    fileList.value = [{
      name: props.modelValue.substring(props.modelValue.lastIndexOf('/') + 1),
      url: props.modelValue
    }]
  } else if (Array.isArray(props.modelValue)) {
    fileList.value = (props.modelValue as string[]).map(url => ({
      name: url.substring(url.lastIndexOf('/') + 1),
      url: url
    }))
  }
}

// 处理图片预览
const handlePreview = (file: any) => {
  dialogImageUrl.value = file.url
  dialogVisible.value = true
}

// 处理图片删除
const handleRemove = (index: number) => {
  fileList.value.splice(index, 1)
  updateModelValue()
}

const updateModelValue = () => {
  if (props.multiple) {
    emit('update:modelValue', fileList.value.map(f => f.url))
  } else {
    emit('update:modelValue', fileList.value.length > 0 ? fileList.value[0].url : '')
  }
}



// 监听modelValue变化
watch(() => props.modelValue, () => {
  initFileList()
}, { immediate: true })
</script>

<style scoped>
.upload-container {
  .upload-tip {
    font-size: 12px;
    color: #909399;
    margin-top: 8px;
  }
}

:deep(.el-upload--picture-card) {
  --el-upload-picture-card-size: 100px;
}

:deep(.el-upload-list--picture-card) {
  --el-upload-list-picture-card-size: 100px;
}
</style> 