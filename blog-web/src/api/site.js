import request from '@/utils/request'


export function getWebConfigApi() {
    return request({
        url: '/api/webConfig',
        method: 'get'
    })
}


export function getNoticeApi() {
    return request({
        url: '/api/notice/list',
        method: 'get'
    })
}
export function reportApi() {
    return request({
        url: '/api/report',
        method: 'get'
    })
}

export function checkAdminOnlineApi() {
    return request({
        url: '/api/adminIsOnline',
        method: 'get'
    })
}