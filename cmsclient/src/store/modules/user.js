import axios from '../../lib/axios'
// initial state
const state = {
  uid: '',
  username: '',
  role: '',
  phone: '',
  score: '',
  address: '',
  avtor: '',
  email: ''
}

// getters
const getters = {}

// actions
const actions = {
  async getUserInfo({
    commit
  }){
    let res = await axios.get(`/api/v1/user/info`)
    if (res.data.status) {
      commit('setUserInfo', res.data.data)
    }
  },
  // async getUserProfile({ commit }){
  //   let res = await axios.get(`/api/v1/user`)
  // }
}

// mutations
const mutations = {
  setUserInfo (state, data) {
    state.uid = data.uid
    state.username = data.username
    state.role = data.role
    state.phone = data.phone,
    state.score = data.score,
    state.email = data.email,
    state.avtor = data.avtor
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}