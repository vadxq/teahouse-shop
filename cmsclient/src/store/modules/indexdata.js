import axios from '../../lib/axios'
// initial state
const state = {
  user: 0,
  product: [],
  todayUser: 0,
  todayOrder: 0,
  order: 0,
}

// getters
const getters = {}

// actions
const actions = {
  async getData({
    commit
  }) {
    let res = await axios.get(`/api/v1/admin/saledata`)
    if (res.data.status) {
      commit('setData', res.data.data)
    }
  },
}

// mutations
const mutations = {
  setData(state, member) {
    state.product = member.product,
    state.todayUser = member.todayUser,
    state.todayOrder = member.todayOrder,
    state.user = member.user
    state.order = member.order
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}