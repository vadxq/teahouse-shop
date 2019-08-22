<template>
  <section>
    <div v-if="loding" style="text-align: center;margin-top:30px;">
      <a-spin >
      </a-spin>
    </div>
    <div v-if="!loding">
      <a-table :dataSource="activeProductList" :scroll="{ x: 800, }" @change="onChange" :pagination="false">
        <a-table-column
          title="账号"
          dataIndex="uid"
          key="uid"
          fixed="left"
        />
        <a-table-column
          title="积分"
          dataIndex="score"
          key="score"
        />
        <a-table-column
          title="订单数"
          dataIndex="order.length"
          key="order.length"
        />
        <a-table-column
          title="用户名"
          dataIndex="username"
          key="username"
        />
        <a-table-column
          title="手机号"
          dataIndex="phone"
          key="phone"
        />
        <a-table-column
          title="邮箱"
          dataIndex="email"
          key="email"
        />
        <a-table-column
          title="操作"
          v-if="$store.state.user.role === 100"
        >
          <template slot-scope="text, record">
            <span>
              <a slot="action" v-if="record.status" @click="changeStatus(record.uid, !record.status)">禁用</a>
              <a slot="action" v-if="!record.status" @click="changeStatus(record.uid, !record.status)">恢复</a>
              <a-divider type="vertical" />
              <a slot="action" v-if="record.role === 10" @click="changeRole(record.uid, 100)">设为管理员</a>
              <a slot="action" v-if="record.role === 100" @click="changeRole(record.uid, 10)">设为工作人员</a>
              <a-divider type="vertical" />
              <a slot="action" @click="changeRole(record.uid, 1)">取消权限</a>
            </span>
          </template>
        </a-table-column>
      </a-table>
      <div class="pagination-container" v-if="$store.state.members.pages > 1">
        <a-button-group v-if="$store.state.members.pages > 0">
          <a-button
            :disabled="$store.state.members.currentPage === 1"
            type="primary"
            size="small"
            @click="changePage(+$store.state.members.currentPage - 1)">
            <a-icon type="left" />
          </a-button>
          <a-button size="small" disabled="true">{{$store.state.members.currentPage}} / {{$store.state.members.pages}}</a-button>
          <a-button
            :disabled="$store.state.members.pages === $store.state.members.currentPage"
            type="primary"
            size="small"
            @click="changePage($store.state.members.currentPage + 1)">
            <a-icon type="right" />
          </a-button>
        </a-button-group>
      </div>
    </div>
  </section>
</template>
<script>
export default {
  data() {
    return {
      loding: true,
      memberPayload: {
        sort: 'worker',
        page: 1,
        limit: 10,
      },
    }
  },
  computed: {
    activeProductList() {
      return this.$store.state.members.members || []
    }
  },
  methods: {
    // 切换页面
    changePage(page) {
      this.loding = true
      this.memberPayload.page = page
      this.$store.dispatch('members/getMember', this.memberPayload)
      setTimeout(() => {
          this.loding = false
        }, 500)
    },
    // 禁用启用账号
    async changeStatus(uid, status) {
      let res = await this.$http.post('/api/v1/admin/users/status', { uid, status })
      if (res.data.success) {
        this.$store.dispatch('members/getMember', {sort: 'worker', page: this.$store.state.members.currentPage, limit: 10})
        this.$message.success('设置成功')
      } else {
        this.$message.error(res.data.message)
      }
    },
    // 修改权限
    async changeRole(uid, role) {
      let res = await this.$http.post('/api/v1/admin/users/role', { uid, role })
      if (res.data.success) {
        this.$store.dispatch('members/getMember', {sort: 'worker', page: this.$store.state.members.currentPage, limit: 10})
        this.$message.success('设置成功')
      } else {
        this.$message.error(res.data.message)
      }
    }
  },
  mounted() {
    this.$store.dispatch('members/getMember', this.memberPayload)
    setTimeout(() => {
      this.loding = false
    }, 500);
  },
}
</script>

<style scoped>
.pagination-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
}
button[ant-click-animating-without-extra-node]:after {
  border: 0 none;
  opacity: 0;
  animation:none 0 ease 0 1 normal;
}
</style>
