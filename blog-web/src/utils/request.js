import axios from 'axios'
import { getToken,removeToken } from '@/utils/cookie'
import store from '@/store'
import router from '@/router'
import { Message } from 'element-ui'

const service = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_API,
  timeout: 10000
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 可以在这里添加请求头等配置
    const token = getToken()
    if (token) {
      config.headers['Authorization'] = token
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code === 200) {
      return res
    } else if(res.code === 404){
      return Promise.reject(new Error('请求路径不存在'))
    }else if(res.code === 401){
      const requestUrl = response.config?.url || ''
      const isLoginRequest = requestUrl.includes('/auth/login')
      const backendMsg = res.message || res.extra?.errorDetail || '未授权访问'
      const hasToken = !!getToken()

      // 只有在“已登录态访问非登录接口”时，才按会话过期处理
      if (hasToken && !isLoginRequest) {
        removeToken()
        // 这里获取不到this，所以需要使用全局变量
        store.commit('SET_USER_INFO', null)
        if (router.currentRoute.path !== '/login') {
          router.push('/login')
        }
        return Promise.reject(new Error('当前登录已过期，请重新登录'))
      }

      // 登录接口返回401时，保留后端真实原因，避免误判成“登录过期”
      return Promise.reject(new Error(backendMsg))
    }else {
      const alertMessage = res.extra?.alertMessage || '错误了，请联系管理员'
      const errorDetail = res.extra?.errorDetail || res.message || '请求失败'
      Message({
        message: `${alertMessage}：${errorDetail}`,
        type: 'error',
        duration: 5 * 1000
      })
      return Promise.reject(new Error(errorDetail))
    }
  },
  error => {
    console.error('API Request Error:', error)
    Message({
      message: error.message || '网络请求异常，请稍后重试',
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service
