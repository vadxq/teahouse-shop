// initial state
const state = {
  fileUrl: '', // 七牛文件链接
  fileName: '' // 七牛文件名称
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