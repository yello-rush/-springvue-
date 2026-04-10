import request from '@/utils/request'

// 获取说说列表
export function getMoments(params) {
  return request({
    url: '/api/moment/list',
    method: 'get',
    params
  })
}

// 点赞说说
export function likeMoment(id) {
  return request({
    url: `/api/moment/like/${id}`,
    method: 'put'
  })
}
