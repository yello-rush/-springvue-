import request from '@/utils/request'

/**
 * 获取用户信息的API函数
 */
export function getUserInfoApi() {
    return request({
        url: '/sys/user/profile',
        method: 'get'
    })
}

/**
 * 修改用户信息
 * @param {*} data 
 * @returns 
 */
export function updateProfileApi(data) {
    return request({
        url: '/protal/user/updateProfile',
        method: 'put',
        data
    })
}

/**
 * 修改密码
 */
export function updatePasswordApi(data) {
    return request({
        url: '/sys/user/updatePwd',
        method: 'put',
        data
    })
}

/**
 * 获取我的评论
 */
export function getMyCommentApi(params) {
    return request({
        url: '/protal/user/comment',
        method: 'get',
        params
    })
}

/**
 * 删除我的评论
 */
export function delMyCommentApi(id) {
    return request({
        url: `/protal/user/delMyComment/${id}`,
        method: 'delete'
    })
}

/**
 * 获取我的回复
 */
export function getMyReplyApi(params) {
    return request({
        url: '/protal/user/myReply',
        method: 'get',
        params
    })
}

/**
 * 获取浏览历史
 */
export function getMyHistoryApi(params) {
    return request({
        url: '/api/user/history',
        method: 'get',
        params
    })
}

/**
 * 获取我的收藏
 */
export function getMyFavoritesApi(params) {
    return request({
        url: '/api/user/favorites',
        method: 'get',
        params
    })
}

/**
 * 获取我的点赞
 */
export function getMyLikeApi(params) {
    return request({
        url: '/protal/user/myLike',
        method: 'get',
        params
    })
}

/**
 * 获取我的反馈
 */
export function getMyFeedbackApi(params) {
    return request({
        url: '/sys/feedback/list',
        method: 'get',
        params
    })
}

/**
 * 添加反馈
 */
export function addFeedbackApi(data) {
    return request({
        url: '/sys/feedback/add',
        method: 'post',
        data
    })
}

/**
 * 签到
 */
export function signInApi() {
    return request({
        url: '/sign/',
        method: 'get'
    })
}

/**
 * 获取签到状态
 */
export function getSignInStatusApi() {
    return request({
        url: '/sign/isSignedToday',
        method: 'get'
    })
}

/**
 * 获取签到统计
 */
export function getSignInStatsApi() {
    return request({
        url: '/sign/getSignDays',
        method: 'get'
    })
}

export function sendEmailCodeApi(email) {
    return request({
        url: '/auth/api/sendEmailCode',
        method: 'get',
        params: {
            email
        }
    })
}

/**
 * 邮箱账号注册
 */
export function registerApi(data) {
    return request({
        url: '/auth/api/email/register',
        method: 'post',
        data
    })
}

/**
 * 根据邮箱修改密码
 */
export function forgotApi(data) {
    return request({
        url: '/auth/api/email/forgot',
        method: 'post',
        data
    })
}




