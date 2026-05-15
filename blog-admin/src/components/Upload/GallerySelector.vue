<template>
  <el-dialog title="选择图片" v-model="visible" width="800px" append-to-body>
    <el-tabs v-model="activeTab">
      <el-tab-pane label="本地上传" name="upload">
        <el-upload
          class="upload-demo"
          drag
          :action="uploadUrl"
          :headers="headers"
          :on-success="handleSuccess"
          :before-upload="beforeUpload"
          multiple>
          <el-icon class="el-icon--upload"><upload-filled /></el-icon>
          <div class="el-upload__text">
            将文件拖到此处，或 <em>点击上传</em>
          </div>
        </el-upload>
      </el-tab-pane>
      <el-tab-pane label="从图库选择" name="gallery">
        <div v-if="!currentAlbumId" class="album-list">
          <div v-for="album in albumList" :key="album.id" class="album-item" @click="openAlbum(album.id)">
            <el-image :src="album.cover" class="album-cover" fit="cover" />
            <div class="album-name">{{ album.name }}</div>
          </div>
        </div>
        <div v-else class="photo-list">
          <div class="back-btn" @click="currentAlbumId = null">
            <el-button link icon="Back">返回图库</el-button>
          </div>
          <div class="photos">
            <div v-for="photo in photoList" :key="photo.id" class="photo-item" @click="selectPhoto(photo.url)" :class="{ active: selectedPhotoUrl === photo.url }">
              <el-image :src="photo.url" class="photo-img" fit="cover" />
              <div class="check-icon" v-if="selectedPhotoUrl === photo.url">
                <el-icon><Check /></el-icon>
              </div>
            </div>
          </div>
          <el-pagination
            v-model:current-page="photoParams.pageNum"
            v-model:page-size="photoParams.pageSize"
            :total="photoTotal"
            layout="prev, pager, next"
            @current-change="getPhotos"
            class="mt-4"
          />
        </div>
      </el-tab-pane>
    </el-tabs>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="visible = false">取消</el-button>
        <el-button type="primary" @click="confirmSelection">确定</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { getToken } from '@/utils/auth'
import { listAlbumApi } from '@/api/site/gallery'
import { listPhotoApi } from '@/api/site/photo'
import { ElMessage } from 'element-plus'

const props = defineProps({
  modelValue: { type: Boolean, default: false },
  source: { type: String, default: 'default' }
})
const emit = defineEmits(['update:modelValue', 'select'])

const visible = ref(false)
const activeTab = ref('upload')
const uploadUrl = `${import.meta.env.VITE_APP_BASE_API}/file/upload?source=${props.source}`
const headers = { Authorization: getToken() }

const albumList = ref<any[]>([])
const photoList = ref<any[]>([])
const currentAlbumId = ref<number | null>(null)
const selectedPhotoUrl = ref('')
const photoTotal = ref(0)
const photoParams = ref({ pageNum: 1, pageSize: 12, albumId: null as number | null })

watch(() => props.modelValue, (val) => {
  visible.value = val
  if (val) {
    getAlbums()
    activeTab.value = 'upload'
    currentAlbumId.value = null
    selectedPhotoUrl.value = ''
  }
})
watch(() => visible.value, (val) => {
  emit('update:modelValue', val)
})

const getAlbums = async () => {
  const res = await listAlbumApi({ pageNum: 1, pageSize: 100 })
  albumList.value = res.data.records || []
}

const openAlbum = async (id: number) => {
  currentAlbumId.value = id
  photoParams.value.albumId = id
  photoParams.value.pageNum = 1
  getPhotos()
}

const getPhotos = async () => {
  const res = await listPhotoApi(photoParams.value)
  photoList.value = res.data.records || []
  photoTotal.value = res.data.total || 0
}

const handleSuccess = (res: any) => {
  if (res.code === 200) {
    emit('select', res.data)
    visible.value = false
  } else {
    ElMessage.error(res.message || '上传失败')
  }
}

const beforeUpload = (file: any) => {
  const isLt2M = file.size / 1024 / 1024 < 5
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 5MB!')
  }
  return isLt2M
}

const selectPhoto = (url: string) => {
  selectedPhotoUrl.value = url
}

const confirmSelection = () => {
  if (activeTab.value === 'gallery' && selectedPhotoUrl.value) {
    emit('select', selectedPhotoUrl.value)
    visible.value = false
  } else {
    ElMessage.warning('请选择图片')
  }
}
</script>

<style scoped>
.album-list {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
}
.album-item {
  width: 120px;
  cursor: pointer;
  text-align: center;
}
.album-cover {
  width: 100px;
  height: 100px;
  border-radius: 8px;
}
.photos {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 10px;
}
.photo-item {
  position: relative;
  cursor: pointer;
  border: 2px solid transparent;
}
.photo-item.active {
  border-color: #409EFF;
}
.photo-img {
  width: 100px;
  height: 100px;
  border-radius: 4px;
}
.check-icon {
  position: absolute;
  right: 5px;
  bottom: 5px;
  color: #fff;
  background: #409EFF;
  border-radius: 50%;
  padding: 2px;
}
.mt-4 { margin-top: 16px; }
</style>