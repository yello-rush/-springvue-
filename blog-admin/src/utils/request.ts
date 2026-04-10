import axios from 'axios'
import { ElMessage,ElMessageBox } from 'element-plus'
import { getToken } from '@/utils/auth'
import { useUserStore } from '@/store/modules/user'

let isRelogin = { show: false }; // 是否显示弹框

const service = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_API,
  timeout: 5000,
  headers: { "Content-Type": "application/json;charset=utf-8" },
})

service.interceptors.request.use(
  (config) => {
    const token = getToken()
    if (token) {
      config.headers['Authorization'] = token
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

service.interceptors.response.use(
  (response) => {
    const res = response.data
    // 二进制数据则直接返回
    // if (res.request.responseType ===  'blob' || res.request.responseType ===  'arraybuffer') {
    //   return res.data
    // }
    if (res.code !== 200) {
      const alertMessage = res.extra?.alertMessage || '错误了，请联系管理员'
      const errorDetail = res.extra?.errorDetail || res.message || '请求错误'
      ElMessage.error(`${alertMessage}：${errorDetail}`)
      if (res.code === 401) {
  
        ElMessageBox.confirm("当前页面已失效，请重新登录", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        })
        .then(() => {
          const userStore = useUserStore()
          userStore.logout()
        })
      }
      return Promise.reject(new Error(errorDetail))
    }
    
    return res
  },
  (error) => {
    if (error.response?.status === 401) {
      const userStore = useUserStore()
      userStore.logout()
    }else if (error.response?.status === 500) {
      ElMessage.error('后端接口连接异常')
    }else{
      ElMessage.error('请求错误')
    }
    return Promise.reject(error)
  }
)

// 导出文件
export function download(url: string, params: any, filename: string) {
  return service.post(url, params, {
    responseType: 'blob',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
  }).then((data: any) => {
    const content = data
    const blob = new Blob([content])
    if ('download' in document.createElement('a')) {
      const elink = document.createElement('a')
      elink.download = filename
      elink.style.display = 'none'
      elink.href = URL.createObjectURL(blob)
      document.body.appendChild(elink)
      elink.click()
      URL.revokeObjectURL(elink.href)
      document.body.removeChild(elink)
    }
  }).catch((r) => {
    console.error(r)
  })
}

export default service 
