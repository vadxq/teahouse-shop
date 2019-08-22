<template>
  <section>
    <div class="loading" v-if="loding" style="text-align: center;margin-top:30px;">
      <a-spin >
      </a-spin>
    </div>
    <a-card :body-style="{padding: '24px 32px'}" :bordered="false">
      <a-form>
        <a-form-item label="商品名称" :labelCol="{span: 7}" :wrapperCol="{span: 10}">
          <a-input placeholder="给商品起个名字" v-model="product.title"/>
        </a-form-item>
        <a-form-item label="商品单价" :labelCol="{span: 7}" :wrapperCol="{span: 10}">
          <a-input placeholder="给商品设定个单价" type="number" v-model="product.price" />
        </a-form-item>
        <a-form-item label="商品描述" :labelCol="{span: 7}" :wrapperCol="{span: 10}">
          <a-textarea rows="4" placeholder="请输入商品描述介绍一下" v-model="product.desc" />
        </a-form-item>
        <a-form-item label="商品封面" :labelCol="{span: 7}" :wrapperCol="{span: 10}">
          <img :src="coverUrl.fileUrl" width="50%"/>
          <p>{{coverUrl.fileName}}</p>
          <Upload />
        </a-form-item>
        <a-form-item label="是否推荐" :labelCol="{span: 7}" :wrapperCol="{span: 10}" >
          <a-checkbox v-model="product.recommend">推荐</a-checkbox>
        </a-form-item>
        <a-form-item label="是否新品" :labelCol="{span: 7}" :wrapperCol="{span: 10}" >
          <a-checkbox v-model="product.new">推荐</a-checkbox>
        </a-form-item>
        <a-form-item  >
        <a-button
          style="width: 100%;margin-top: 15px"
          size="large"
          type="primary"
          :disabled="addDisabled"
          @click="pushShopItem()"
          >
          添加</a-button>
        </a-form-item>
      </a-form>
    </a-card>
  </section>
</template>

<script>
import Upload from "../components/upload";
export default {
  name: 'new',
  components: {
    Upload
  },
  data() {
    return {
      loding: true,
      product: {
        title: '', // 标题
        price: 0, // 单价
        cover: '', // 封面图
        recommend: false, // 是否推荐
        new: false, // 是否新品
        desc: '', // 描述
      }
    };
  },
  computed: {
    coverUrl() {
      return this.$store.state.upload
    },
    addDisabled() {
      return this.product.title === ''
        || this.product.price === 0
        || this.coverUrl.fileUrl === ''
        || this.product.desc === ''
        || isNaN(+this.product.price)
        || this.product.price === '0'
    }
  },
  methods: {
    // 添加商品
    async pushShopItem() {
      if (isNaN(+this.product.price)) {
        this.$message.error('价格格式错误')
      } else if (this.addDisabled) {
        this.$message.error('请填写完整')
      } else {
        this.loding = false
        this.product.cover = this.coverUrl.fileUrl
        this.product.price = +this.product.price
        let res = await this.$http.post('/api/v1/admin/product', this.product)
        if (res.data.success) {
          this.$router.push('/product')
          this.$message.success('接添加成功')
          this.product = {
            title: '',
            price: 0,
            cover: '',
            recommend: false,
            new: false,
            desc: '',
          }
        } else {
          this.$message.error(res.data.message)
        }
        this.loding = true
      }
    }
  },
  mounted() {}
};
</script>

<style scoped>
.loading {
  text-align: center;
  margin-top:30px;
  position: fixed;
}
</style>
