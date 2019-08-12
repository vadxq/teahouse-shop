import Vue from 'vue'
import Vuex from 'vuex'
import products from './modules/products'
import upload from './modules/upload'
import user from './modules/user'
import members from './modules/members'
import orders from './modules/orders'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

export default new Vuex.Store({
  modules: {
    products,
    upload,
    user,
    members,
    orders,
  },
  strict: debug,
})