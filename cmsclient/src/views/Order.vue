<template>
  <section>
    <div v-if="loding" style="text-align: center;margin-top:30px;">
      <a-spin >
      </a-spin>
    </div>
    <div v-if="!loding">
      <a-table :dataSource="activeList" :scroll="{ x: 800, }" @change="onChange" :pagination="false">
        <a-table-column
          title="订单号"
          dataIndex="oid"
          key="oid"
          fixed="left"
        />
        <a-table-column
          title="商品"
          dataIndex="item"
          key="item"
        >
          <template slot-scope="item">
            <span>
              <a-tag v-for="tag in item" color="blue" :key="tag">{{tag.title}}：{{tag.count}}份</a-tag>
            </span>
          </template>
        </a-table-column>
        <a-table-column
          title="总价"
          dataIndex="price"
          key="price"
        />
        <a-table-column
          title="实付款"
          dataIndex="sale"
          key="sale"
        />
        <a-table-column
          title="数量"
          dataIndex="count"
          key="count"
        />
        <a-table-column
          title="用户"
          dataIndex="uid"
          key="uid"
        />
        <a-table-column
          title="操作"
          v-if="$store.state.user.role > 9"
        >
          <template slot-scope="text, record">
            <span>
              <a slot="action" v-if="record.status === 1" @click="changeStatus(record)">接单</a>
              <a class="del-red-button" slot="action" v-if="record.status === 2 && $store.state.user.role === 100" @click="delOrder(record.oid)">删除</a>
            </span>
          </template>
        </a-table-column>
      </a-table>
      <div class="pagination-container" v-if="$store.state.orders.pages > 1">
        <a-button-group v-if="$store.state.orders.pages > 0">
          <a-button
            :disabled="$store.state.orders.currentPage === 1"
            type="primary"
            size="small"
            @click="changePage(+$store.state.orders.currentPage - 1)">
            <a-icon type="left" />
          </a-button>
          <a-button size="small" disabled="true">{{$store.state.orders.currentPage}} / {{$store.state.orders.pages}}</a-button>
          <a-button
            :disabled="$store.state.orders.pages === $store.state.orders.currentPage"
            type="primary"
            size="small"
            @click="changePage($store.state.orders.currentPage + 1)">
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
      ordersPayload: {
        page: 1,
        limit: 10,
      },
    }
  },
  computed: {
    activeList() {
      return this.$store.state.orders.orders || []
    }
  },
  methods: {
    // 切换页面
    changePage(page) {
      this.loding = true
      this.ordersPayload.page = page
      this.$store.dispatch('orders/getOrders', this.ordersPayload)
      setTimeout(() => {
          this.loding = false
        }, 1000)
    },
    // 接单
    async changeStatus(req) {
      let res = await this.$http.post('/api/v1/admin/order', req)
      if (res.data.success) {
        this.$store.dispatch('orders/getOrders', { page: this.$store.state.orders.currentPage, limit: 10 })
        this.$message.success('接单成功')
      } else {
        this.$message.error(res.data.message)
      }
    },
    // 删除订单
    async delOrder(oid) {
      let res = await this.$http.delete(`/api/v1/admin/order/:${oid}`)
      if (res.data.success) {
        this.$store.dispatch('orders/getOrders', { page: this.$store.state.orders.currentPage, limit: 10 })
        this.$message.success('设置成功')
      } else {
        this.$message.error(res.data.message)
      }
    },
    // 获取新订单，轮询
    getNewOrder(){
      setInterval(() => {
        if (this.$route.path === '/order') {
          this.$store.dispatch('orders/getOrders', { page: this.$store.state.orders.currentPage, limit: 10 })
        }
      }, 10000)
    }
  },
  mounted() {
    this.$store.dispatch('orders/getOrders', this.ordersPayload)
    this.getNewOrder()
    setTimeout(() => {
      this.loding = false
    }, 1000);
  },
  beforeDestroy() {
    clearInterval(this.getNewOrder)
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
.del-red-button {
  background-color: red;
  color: #fff;
  padding: 0 3px;
  border-radius: 5px;
}
</style>
