<template>
  <a-layout>
    <router-view></router-view>
  </a-layout>
</template>

<script>
// import NavBar from './components/NavBar.vue'

export default {
  name: 'app',
  // components: {
  //   NavBar
  // },
  data() {
    return {
    }
  },
  mounted() {
    this.$store.dispatch('user/getUserInfo')
  },
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
