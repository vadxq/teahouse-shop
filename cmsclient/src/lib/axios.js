import axios from 'axios'
import router from '../router'
import { message } from 'ant-design-vue'

message.config({
  duration: 4,
});

// axios 配置
axios.defaults.timeout = 5000

// http request 拦截器
axios.interceptors.request.use(
  config => {
    if (localStorage.token) {
      config.headers.Authorization = `bearer ${localStorage.token}`
    }
    return config
  },
  err => {
    return Promise.reject(err)
  },
)

// http response 拦截器
axios.interceptors.response.use(
  response => {
    let data = response.data
    switch (data.status) {
      case 401:
        // 401 清除token信息并跳转到登录页面
        localStorage.removeItem('token')
        
        // 只有在当前路由不是登录页面才跳转
        router.currentRoute.path !== 'login' &&
          router.replace({
            path: 'login',
            query: { redirect: router.currentRoute.path },
          })
          message.error(response.data.message)
        break
      case 403:
        localStorage.removeItem('token')
        
        // 只有在当前路由不是登录页面才跳转
        router.currentRoute.path !== 'login' &&
          router.replace({
            path: 'login',
            query: { redirect: router.currentRoute.path },
          })
          message.error(response.data.message)
        break
    }
    return response
  },
  error => {
    if (error.response) {
      switch (error.response.status) {
        case 401:
          // 401 清除token信息并跳转到登录页面
          localStorage.removeItem('token')
          
          // 只有在当前路由不是登录页面才跳转
          router.currentRoute.path !== 'login' &&
            router.replace({
              path: 'login',
              query: { redirect: router.currentRoute.path },
            })
          break
        case 403:
          localStorage.removeItem('token')
          
          // 只有在当前路由不是登录页面才跳转
          router.currentRoute.path !== 'login' &&
            router.replace({
              path: 'login',
              query: { redirect: router.currentRoute.path },
            })
      }
    }
    message.error(error.response.data.message)
    return error.response
  },
)

export default axios