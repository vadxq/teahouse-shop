'use strict';

/**
 * @param app.mongoose mongodb Model
 */

module.exports = app => {
  const mongoose = app.mongoose;
  const Schema = mongoose.Schema;

  const OrderSchema = new Schema({
    oid: { type: Schema.Types.ObjectId, auto: true, index: true }, // 订单id
    uid: { type: String }, // 用户id
    price: { type: Number }, // 总价格
    sale: { type: Number, default: 0 }, // 实际价格
    count: { type: Number, default: 0 }, // 总数量
    item: [{
      pid: { type: String }, // 商品id
      title: { type: String }, // 商品名称
      desc: { type: String }, // 描述
      price: { type: Number }, // 单价
      count: { type: Number }, // 数量
      cover: { type: String }, // 封面
      sale: { type: Number }, // 总价
    }],
    status: { type: Number, default: 1 }, // 0,删除;1,生成;2,完成
    createAt: { type: Date, default: Date.now() }, // 创建时间
    updateAt: { type: Date, default: Date.now() }, // 更新时间
  }, { versionKey: false });

  // 不支持箭头函数
  OrderSchema.pre('save', function newDate(next) {
    if (this.isNew) {
      this.createAt = this.updateAt = Date.now();
    } else {
      this.updateAt = Date.now();
    }
    next();
  });

  OrderSchema.pre('update', function updateTime() {
    this.updateAt = Date.now();
  });

  return mongoose.model('Order', OrderSchema);
};
