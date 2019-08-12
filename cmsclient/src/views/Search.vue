<template>
  <section>
    <div class="search-bottom">
      <a-select defaultValue="oid" v-model="data.sort">
        <a-select-option value="oid">通过订单号查询</a-select-option>
        <a-select-option value="uid">通过用户id查询</a-select-option>
      </a-select>
      <a-input-search
        :placeholder="placeholder"
        @search="onSearch"
        enterButton
        v-model="data.id"
      />
    </div>
    <div v-if="loding" style="text-align: center;margin-top:30px;">
      <a-spin >
      </a-spin>
    </div>
    <div v-if="activeList.length > 0 && !loding">
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
          v-if="$store.state.user.role === 100"
        >
          <template slot-scope="text, record">
            <span>
              <a slot="action" v-if="record.status === 1" @click="changeStatus(record)">接单</a>
              <a class="del-red-button" slot="action" v-if="record.status === 2 && $store.state.user.role === 100" @click="changeStatus(record.uid, !record.status)">删除</a>
            </span>
          </template>
        </a-table-column>
      </a-table>
      <div class="pagination-container" v-if="$store.state.orders.search.pages > 1">
        <a-button-group v-if="$store.state.orders.search.pages > 0">
          <a-button
            :disabled="$store.state.orders.search.currentPage === 1"
            type="primary"
            size="small"
            @click="changePage(+$store.state.orders.search.currentPage - 1)">
            <a-icon type="left" />
          </a-button>
          <a-button size="small" disabled="true">{{$store.state.orders.search.currentPage}} / {{$store.state.orders.search.pages}}</a-button>
          <a-button
            :disabled="$store.state.orders.search.pages === $store.state.orders.search.currentPage"
            type="primary"
            size="small"
            @click="changePage($store.state.orders.search.currentPage + 1)">
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
      loding: false,
      data: {
        sort: 'oid',
        id: '',
        page: 1,
        limit: 10
      }
    }
  },
  computed: {
    placeholder() {
      return this.data.selected === 'oid' ? '请输入订单号' : '请输入用户账户'
    },
    activeList() {
      return this.$store.state.orders.search.orders
    }
  },
  methods: {
    // 搜索界面
    onSearch() {
      this.loding = true
      if (this.data.sort !== 'oid' && this.data.sort !== 'uid') {
        this.$message.error('请选择查询方式')
      } else if (this.data.sort === 'oid' && this.data.id.length !== 24){
        this.$message.error('订单信息错误')
      } else if (this.data.sort === 'uid' && this.data.id.length < 4) {
        this.$message.error('用户账户错误')
      } else {
        this.$store.dispatch('orders/searchOrders', this.data)
      }
      setTimeout(() => {
        this.loding = false
      }, 1000)
    },
    // 切换页面
    changePage(page) {
      this.loding = true
      this.data.page = page
      this.$store.dispatch('orders/searchOrders', this.data)
      setTimeout(() => {
          this.loding = false
        }, 1000)
    },
    // 接单
    async changeStatus(req) {
      this.loding = true
      let res = await this.$http.post('/api/v1/admin/order', req)
      if (res.data.success) {
        this.$store.dispatch('orders/searchOrders', this.data)
        this.$message.success('接单成功')
        this.loding = false
      } else {
        this.$message.error(res.data.message)
      }
    },
    // 删除订单
    async delOrder(oid) {
      this.loding = true
      let res = await this.$http.delete(`/api/v1/admin/order/:${oid}`)
      if (res.data.success) {
        this.$store.dispatch('orders/searchOrders', this.data)
        this.$message.success('设置成功')
        this.loding = false
      } else {
        this.$message.error(res.data.message)
      }
    },
  },
  mounted() {
    
  },
}
</script>


<style scoped>
 .search-bottom {
   display: flex;
   justify-content: center;
   width: 100%;
   margin: 20px 0;
 }
</style>
