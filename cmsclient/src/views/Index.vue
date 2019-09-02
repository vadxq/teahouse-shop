<template>
  <div class="index-div">
    <div class="time">
      <a-timeline>
        <a-timeline-item>欢迎来到清竹茶馆管理后台~</a-timeline-item>
        <a-timeline-item>请整理着装，清洁手</a-timeline-item>
        <a-timeline-item>面带笑容</a-timeline-item>
        <a-timeline-item>感谢你的辛苦劳动</a-timeline-item>
      </a-timeline>
      <div class="sales">
        <h4>总会员数</h4>
        <p>{{$store.state.indexdata.user}} 人</p>
        <h4>今日新增会员数</h4>
        <p>{{$store.state.indexdata.todayUser}} 人</p>
      </div>
      <div class="sales">
       <h4>订单数</h4>
        <p>{{$store.state.indexdata.order}} 单</p>
        <h4>今日新增订单数</h4>
        <p>{{$store.state.indexdata.todayOrder}} 单</p>
      </div>
    </div>
    <div>
      <ve-bar :data="chartData"></ve-bar>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      // chartData: {
      //   columns: ["产品名称", "销售额", "销量", "单价"],
      //   rows: [
      //   ]
      // }
    };
  },
  computed: {
    chartData() {
      return {
        columns: ["title", "销售额", "销量", "单价"],
        rows: this.$store.state.indexdata.product
      }
    }
  },
  methods: {
    getData() {
      setInterval(() => {
        if (this.$route.path === '/') {
          this.$store.dispatch('indexdata/getData')
        }
      }, 10000)
    }
  },
  mounted() {
    this.$store.dispatch('indexdata/getData')
    this.getData()
  }
};
</script>

<style scoped>
.index-div {
  margin: 40px;
}
.time {
  display: flex;
  justify-content: space-between;
}
.sales {
  background-color: #1890ff;
  padding: 20px;
  margin: 0 3vw 30px 3vw;
  color: #fff;
  flex: 1;
}
.sales h4, .sales p {
  color: #fff;
}
</style>