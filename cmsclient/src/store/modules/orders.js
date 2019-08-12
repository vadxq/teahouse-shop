import axios from '../../lib/axios'
// initial state
const state = {
  orders: [],
  pages: 1,
  currentPage: 1,
  search: {
    orders: [],
    pages: 1,
    currentPage: 1,
  }
}

// getters
const getters = {}

// actions
const actions = {
  async getOrders({
    commit
  }, payload) {
    let res = await axios.get(`/api/v1/admin/orders?page=${payload.page}&limit=${payload.limit}`)
    if (res.data.status) {
      commit('setOrders', res.data.data)
    }
  },
  async searchOrders( { commit }, payload) {
    let res = await axios.post(`/api/v1/admin/orders`, payload)
    if (res.data.status) {
      commit('setSearchOrders', res.data.data)
    }
  }
}

// mutations
const mutations = {
  setOrders(state, order) {
    state.orders = order.data,
    state.pages = order.pages,
    state.currentPage = order.currentPage
  },
  setSearchOrders(state, order) {
    state.search.orders = order.data;
    if (order.hasOwnProperty('page') || order.hasOwnProperty('currentPage')) {
      state.search.pages = order.pages,
      state.search.currentPage = order.currentPage
    }
  },
  changeOrder(state, order) {
    let index = state.orders.findIndex((element) => {
      return element.uid = order.uid
    })
    state.orders[index] = order
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}