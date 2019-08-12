import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)


export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: () => import('./views/Home.vue'),
      children: [
        {
          path: '',
          name: 'index',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Index.vue')
        },
        {
          path: '/product',
          name: 'product',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Product.vue')
        },
        {
          path: '/new',
          name: 'newProduct',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/New.vue')
        },
        {
          path: '/order',
          name: 'order',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Order.vue')
        },
        {
          path: '/search',
          name: 'search',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Search.vue')
        },
        {
          path: '/member',
          name: 'member',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Member.vue')
        },
        {
          path: '/worker',
          name: 'worker',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Worker.vue')
        },
        {
          path: '/profile',
          name: 'profile',
          meta: {
            requireAuth: true,
          },
          component: () => import('./views/Profile.vue')
        }
      ]
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('./views/Login.vue')
    }
  ]
})