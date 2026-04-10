import request from '@/utils/request'

// 获取作者列表
export function listAuthorApi(query: any) {
  return request({
    url: '/sys/author/list',
    method: 'get',
    params: query
  })
}

// 新增作者
export function addAuthorApi(data: any) {
  return request({
    url: '/sys/author/add',
    method: 'post',
    data: data
  })
}

// 修改作者
export function updateAuthorApi(data: any) {
  return request({
    url: '/sys/author/update',
    method: 'put',
    data: data
  })
}

// 删除作者
export function deleteAuthorApi(ids: any) {
  return request({
    url: `/sys/author/delete/${ids}`,
    method: 'delete'
  })
}