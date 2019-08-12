<template>
  <section>
    <div v-if="loding" style="text-align: center;margin-top:30px;">
      <a-spin >
      </a-spin>
    </div>
    <div v-if="!loding">
      <a-table :dataSource="activeList" :scroll="{ x: 800, }" :pagination="false">
        <a-table-column
          title="商品id"
          dataIndex="pid"
          key="pid"
          fixed="left"
        />
        <a-table-column
          title="名称"
          dataIndex="title"
          key="title"
        />
        <a-table-column
          title="销售额"
          dataIndex="sale"
          key="sale"
        />
        <a-table-column
          title="单价"
          dataIndex="price"
          key="price"
        />
        <a-table-column
          title="销量"
          dataIndex="count"
          key="count"
        />
        <a-table-column
          title="图标"
          dataIndex="cover"
          key="cover">
          <template slot-scope="text, record">
            <img :src="record.cover" width="40px;"/>

          </template>
        </a-table-column>
        <a-table-column
          title="简介"
          dataIndex="desc"
          key="desc"
        />
        <a-table-column
          title="操作"
          v-if="$store.state.user.role === 100"
        >
          <template slot-scope="text, record">
            <span>
              <a slot="action" v-if="record.recommend" @click="changeRecommend(record)">取消推荐</a>
              <a slot="action" v-if="!record.recommend" @click="changeRecommend(record)">推荐</a>
              <a-divider type="vertical" />
              <a slot="action" v-if="!record.check" @click="changeUp(record)">上架</a>
              <a slot="action" v-if="record.check" @click="changeUp(record)">下架</a>
              <a-divider type="vertical" />
              <a slot="action" v-if="!record.new" @click="changeNew(record)">设为新品</a>
              <a slot="action" v-if="record.new" @click="changeNew(record)">取消新品</a>
              <a-divider type="vertical" />
              <a class="del-red-button" slot="action" @click="delProduct(record.pid)">删除</a>
            </span>
          </template>
        </a-table-column>
      </a-table>
      <div class="pagination-container" v-if="$store.state.products.pages > 1">
        <a-button-group v-if="$store.state.products.pages > 0">
          <a-button
            :disabled="$store.state.products.currentPage === 1"
            type="primary"
            size="small"
            @click="changePage(+$store.state.products.currentPage - 1)">
            <a-icon type="left" />
          </a-button>
          <a-button size="small" disabled="true">{{$store.state.products.currentPage}} / {{$store.state.products.pages}}</a-button>
          <a-button
            :disabled="$store.state.products.pages === $store.state.products.currentPage"
            type="primary"
            size="small"
            @click="changePage($store.state.products.currentPage + 1)">
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
      payload: {
        page: 1,
        limit: 10,
      },
      activeItem: {

      }
    }
  },
  computed: {
    activeList() {
      return this.$store.state.products.products || []
    }
  },
  methods: {
    // 切换页面
    changePage(page) {
      this.loding = true
      this.payload.page = page
      this.$store.dispatch('products/getAllProduct', this.payload)
      setTimeout(() => {
          this.loding = false
        }, 1000)
    },
    // 修改商品
    async putItem(req) {
      let res = await this.$http.put('/api/v1/admin/product', req)
      if (res.data.success) {
        this.$store.dispatch('products/getAllProduct', { page: this.$store.state.products.currentPage, limit: 10 })
        this.$message.success('设置成功')
      } else {
        this.$message.error(res.data.message)
      }
    },
    // 修改推荐
    changeRecommend (req) {
      req.recommend = !req.recommend
      this.putItem(req)
    },
    // 修改上架下架
    changeUp(req) {
      req.check = !req.check
      this.putItem(req)
    },
    // 修改新品
    changeNew(req) {
      req.new = !req.new
      this.putItem(req)
    },
    async delProduct(pid) {
      let res = await this.$http.delete(`/api/v1/admin/product/:${pid}`)
      if (res.data.success) {
        this.$store.dispatch('products/getAllProduct', { page: this.$store.state.products.currentPage, limit: 10 })
        this.$message.success('删除成功')
      } else {
        this.$message.error(res.data.message)
      }
    },
  },
  mounted() {
    this.$store.dispatch('products/getAllProduct', this.payload)
    setTimeout(() => {
      this.loding = false
    }, 1000);
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
