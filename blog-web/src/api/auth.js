import request from '@/utils/request'

/**
 * 登录
 * @param {*} data 
 * @returns 
 */
export function loginApi(data) {
  return request({
    url: '/auth/login',
    method: 'post',
    data
  })
}

/**
 * 退出登录
 * @returns 
 */
export function logoutApi() {
  return request({
    url: '/auth/logout',
    method: 'post'
  })
}

/**
 * 获取用户信息
 */
export function getUserInfoApi() {
  return request({
    url: `/auth/info`,
    method: 'get',
    params:{
        source:'web'
    }
  })
} 

/**
 * 发送邮箱验证吗
 */
export function sendEmailCodeApi(email) {
  return request({
    url: `/api/sendEmailCode`,
    method: 'get',
    params:{
        email:email
    }
  })
} 

/**
 * 注册
 */
export function registerApi(data) {
  return request({
    url: `/api/email/register`,
    method: 'post',
    data
  })
}

/**
 * 忘记密码
 */
export function forgotPasswordApi(data) {
    return request({
      url: `/api/email/forgot`,
      method: 'post',
      data
    })
  }

// 获取验证码
export function getCaptchaApi() {
  return request({
    url: '/auth/getCaptcha',
    method: 'get'
  })
}
