import axios from '../../lib/axios'
// initial state
const state = {
  products: [], // 当前商品列表
  pages: 1, // 总页码
  currentPage: 1, // 当前页码
}

// getters
const getters = {}

// actions
const actions = {
  async getAllProduct({
    commit
  }, payload) {
    let res = await axios.get(`/api/v1/products/list?page=${payload.page}&limit=${payload.limit}`)
    if (res.data.status) {
      commit('setProducts', res.data.data)
    }
  }
}

// mutations
const mutations = {
  setProducts (state, products) {
    state.products = products.data,
    state.pages = products.pages,
    state.currentPage = products.currentPage
  },
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}