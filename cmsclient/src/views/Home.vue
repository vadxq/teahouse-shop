<template >
  <a-layout>
    <a-layout-header class="header" style="background: #fff">
      <div class="tab-nav">
        <a-col  >
          <img style="width: 40px;margin-right: 20px;" src="https://qnimg.vadxq.com/blog/2017/logo.jpg" />
          <span style="font-size: 16px; font-weight: bold;">清竹茶馆</span> -
          <span>管理后台</span>
        </a-col>
        <a-col >
          <a-dropdown style="display: inline-block; height: 100%; vertical-align: initial;margin-right: 30px;" >
          <span style="cursor: pointer">
            <a-avatar class="avatar" size="small" shape="circle" src="https://qnimg.vadxq.com/blog/2017/logo.jpg"/>
            <span> vadxq</span>
          </span>
          <a-menu style="width: 110px" slot="overlay">
            <a-menu-item>
              <router-link to="/profile">
                <a-icon type="user" />
                <span> 个人中心</span>
              </router-link>
            </a-menu-item>
            <a-menu-divider />
            <a-menu-item @click="clearLogin()">
              <router-link :to="toUrl">
                <a-icon type="poweroff" />
                <span> 退出登录</span>
              </router-link>
            </a-menu-item>
          </a-menu>
        </a-dropdown>
        </a-col>
      </div>
    </a-layout-header>
    <a-layout-content style="padding: 10px 30px">
      <a-layout style="padding: 24px 0; background: #fff">
        <NavBar />
        <a-layout-content :style="{ padding: '0 24px', minHeight: '280px' }">
          <router-view></router-view>
        </a-layout-content>
      </a-layout>
    </a-layout-content>
    <a-layout-footer style="text-align: center">
      ©2019 Created by
      <a href="https://blog.vadxq.com">xianlin.dong</a>
    </a-layout-footer>
  </a-layout>
</template>

<script>
import NavBar from '../components/NavBar.vue';

export default {
  components: {
    NavBar
  },
  data() {
    return {};
  },
  methods: {
    clearLogin() {
      localStorage.removeItem('token')
      localStorage.removeItem('uid')
      localStorage.removeItem('id')
    }
  },
  computed: {
    toUrl() {
      return `/login?redirect=${this.$route.path}`
    }
  },
  mounted() {
    // console.log(this.$http.get())
  }
};
</script>

<style scoped>
 .tab-nav {
   display: flex;
   flex-direction: row;
   justify-content: space-between;
   
 }
</style>
