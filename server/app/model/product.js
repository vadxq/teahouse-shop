'use strict';

/**
 * @param app.mongoose mongodb Model
 */

module.exports = app => {
  const mongoose = app.mongoose;
  const Schema = mongoose.Schema;

  const ProductSchema = new Schema({
    pid: { type: Schema.Types.ObjectId, auto: true, index: true }, // 商品id
    title: { type: String }, // 商品名称
    desc: { type: String }, // 描述
    cover: { type: String, default: 'https://qnimg.vadxq.com/blog/2016/blogheadimg20160517.jpg' }, // 封面图
    detail: { type: String }, // 商品详情
    sale: { type: Number, default: 0 }, // 销量
    price: { type: Number, default: 0 }, // 单价
    total: { type: Number, default: 0 }, // 总量
    count: { type: Number, default: 0 }, // 售卖数量
    check: { type: Boolean, default: false }, // 上架下架
    recommend: { type: Boolean, default: false }, // 是否推荐
    new: { type: Boolean, default: false }, // 是否新品
    dele: { type: Boolean, default: false }, // 是否删除
    createAt: { type: Date, default: Date.now() }, // 创建时间
    updateAt: { type: Date, default: Date.now() }, // 更新时间
  }, { versionKey: false });

  // 不支持箭头函数
  ProductSchema.pre('save', function newDate(next) {
    if (this.isNew) {
      this.createAt = this.updateAt = Date.now();
    } else {
      this.updateAt = Date.now();
    }
    next();
  });

  ProductSchema.pre('update', function updateTime() {
    this.updateAt = Date.now();
  });

  return mongoose.model('Product', ProductSchema);
};
