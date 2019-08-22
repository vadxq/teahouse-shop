'use strict';

/**
 * @param app.mongoose mongodb Model
 */

module.exports = app => {
  const mongoose = app.mongoose;
  const Schema = mongoose.Schema;

  const ShoppingCartSchema = new Schema({
    scid: { type: Schema.Types.ObjectId, auto: true, index: true }, // 购物车id
    uid: { type: String }, // 用户id
    pid: { type: String }, // 商品id
    title: { type: String }, // 商品名称
    desc: { type: String }, // 描述
    cover: { type: String, default: 'https://qnimg.vadxq.com/blog/2016/blogheadimg20160517.jpg' }, // 封面图
    price: { type: Number, default: 0 }, // 单价
    count: { type: Number, default: 0 }, // 数量
    sale: { type: Number, default: 0 }, // 总价
    status: { type: Number, default: 1 }, // 0：删除，1：购物车，2：结单
    createAt: { type: Date, default: Date.now() }, // 创建时间
    updateAt: { type: Date, default: Date.now() }, // 更新时间
  }, { versionKey: false });

  // 不支持箭头函数
  ShoppingCartSchema.pre('save', function newDate(next) {
    if (this.isNew) {
      this.createAt = this.updateAt = Date.now();
    } else {
      this.updateAt = Date.now();
    }
    next();
  });

  ShoppingCartSchema.pre('update', function updateTime() {
    this.updateAt = Date.now();
  });

  return mongoose.model('ShoppingCart', ShoppingCartSchema);
};
