// initial state
const state = {
  fileUrl: '',
  fileName: ''
}

// getters
const getters = {}

// actions
const actions = {
}

// mutations
const mutations = {
  setActiveImg (state, activeImg,) {
    state.fileUrl = activeImg.fileUrl
    state.fileName = activeImg.fileName
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}