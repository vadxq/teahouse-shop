<template>
  <a-layout-sider width="200" style="background: #fff">
    <a-menu
      mode="inline"
      :defaultOpenKeys="[defaultRoute.openKey]"
      :defaultSelectedKeys="[defaultRoute.selectKey]"
      :inlineCollapsed="true"
      :inlineIndent="24"
      style="height: 100%"
    >
      <a-menu-item key="/">
        <router-link to="/">
          <a-icon type="home" />首页
        </router-link>
      </a-menu-item>
      <a-sub-menu key="sub2">
        <span slot="title">
          <a-icon type="laptop" />商品管理
        </span>
        <a-menu-item key="product">
          <router-link to="product">商品列表</router-link>
        </a-menu-item>
        <a-menu-item key="new">
          <router-link to="new">添加商品</router-link>
        </a-menu-item>
      </a-sub-menu>
      <a-sub-menu key="sub3">
        <span slot="title">
          <a-icon type="notification" />订单管理
        </span>
        <a-menu-item key="order">
          <router-link to="order">订单列表</router-link>
        </a-menu-item>
        <a-menu-item key="search">
          <router-link to="search">搜索订单</router-link>
        </a-menu-item>
      </a-sub-menu>
      <a-sub-menu key="sub4">
        <span slot="title">
          <a-icon type="user" />用户管理
        </span>
        <a-menu-item key="member">
          <router-link to="member">会员管理</router-link>
        </a-menu-item>
        <a-menu-item key="worker">
          <router-link to="worker">工作人员</router-link>
        </a-menu-item>
        <a-menu-item key="profile">
          <router-link to="profile">个人中心</router-link>
        </a-menu-item>
      </a-sub-menu>
    </a-menu>
  </a-layout-sider>
</template>

<script>
export default {
  data() {
    return {
    };
  },
  computed: {
    // 默认初始路由，nav对应
    defaultRoute() {
      if (this.$route.path === '/product') return { selectKey: 'product', openKey: 'sub2' };
      if (this.$route.path === '/new') return { selectKey: 'new', openKey: 'sub2' };
      if (this.$route.path === '/order') return { selectKey: 'order', openKey: 'sub3' };
      if (this.$route.path === '/search') return { selectKey: 'search', openKey: 'sub3' };
      if (this.$route.path === '/member') return { selectKey: 'member', openKey: 'sub4' };
      if (this.$route.path === '/worker') return { selectKey: 'worker', openKey: 'sub4' };
      if (this.$route.path === '/profile') return { selectKey: 'profile', openKey: 'sub4' };
      return { selectKey: '/', openKey: '' };
    }
  },
};
</script>
