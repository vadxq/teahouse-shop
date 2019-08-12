import axios from '../../lib/axios'
// initial state
const state = {
  members: [],
  pages: 1,
  currentPage: 1
}

// getters
const getters = {}

// actions
const actions = {
  async getMember({
    commit
  }, payload) {
    let res = await axios.get(`/api/v1/admin/users/${payload.sort}?page=${payload.page}&limit=${payload.limit}`)
    if (res.data.status) {
      commit('setMember', res.data.data)
    }
  },
  // async changeMemberItem({ commit }, payload) {
  //   console.log(payload)
  //   let 
  // }
}

// mutations
const mutations = {
  setMember(state, member) {
    state.members = member.data,
    state.pages = member.pages,
    state.currentPage = member.currentPage
  },
  changeMember(state, member) {
    let index = state.member.findIndex((element) => {
      return element.uid = member.uid
    })
    state.member[index] = member
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}