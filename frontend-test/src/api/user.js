import request from '@/utils/request'

// 用户注册
export function register(data) {
  return request({
    url: '/user/register',
    method: 'post',
    data
  })
}

// 用户登录
export function login(data) {
  return request({
    url: '/user/login',
    method: 'post',
    data
  })
}

// 修改用户名
export function updateUsername(data) {
  return request({
    url: '/user/updateUsername',
    method: 'post',
    data
  })
}

// 修改手机号
export function updatePhone(data) {
  return request({
    url: '/user/updatePhone',
    method: 'post',
    data
  })
}

// 修改密码
export function updatePassword(data) {
  return request({
    url: '/user/updatePassword',
    method: 'post',
    data
  })
}

// 重置密码
export function resetPassword(data) {
  return request({
    url: '/user/resetPassword',
    method: 'post',
    data
  })
} 