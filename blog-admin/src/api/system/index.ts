import request from '@/utils/request'

/**
 * 获取dashboard数据
 */
export function getDashboardDataApi() {
  return request({
    url: '/sys/dashboard',
    method: 'get'
  })
}

// 获取文章统计数据
export function getBottomDataApi() {
  return request({
    url: '/sys/dashboard/bottom',
    method: 'get'
  })
}

// 获取顶部通知数据
export function getNotificationsApi(timestamp?: number) {
  return request({
    url: '/sys/dashboard/notifications',
    method: 'get',
    params: { t: timestamp }
  })
}
