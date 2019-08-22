import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    { // 根路由
      path: '/',
      component: () => import('./views/Home.vue'),
      children: [
        { // 首页
          path: '',
          name: 'index',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Index.vue')
        },
        { // 商品列表
          path: '/product',
          name: 'product',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Product.vue')
        },
        { // 添加商品
          path: '/new',
          name: 'newProduct',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/New.vue')
        },
        { // 订单列表
          path: '/order',
          name: 'order',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Order.vue')
        },
        { // 搜索订单
          path: '/search',
          name: 'search',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Search.vue')
        },
        { // 会员管理
          path: '/member',
          name: 'member',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Member.vue')
        },
        { // 工作人员
          path: '/worker',
          name: 'worker',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Worker.vue')
        },
        { // 个人中心
          path: '/profile',
          name: 'profile',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Profile.vue')
        }
      ]
    },
    { // 登陆注册
      path: '/login',
      name: 'login',
      component: () => import('./views/Login.vue')
    }
  ]
})