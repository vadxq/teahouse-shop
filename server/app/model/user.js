'use strict';

/**
 * @param app.mongoose mongodb Model
 */

module.exports = app => {
  const mongoose = app.mongoose;
  const Schema = mongoose.Schema;

  const UserSchema = new Schema({
    uid: { type: String, index: true }, // 账户
    phone: { type: String }, // 电话
    email: { type: String }, // 邮箱
    username: { type: String }, // 昵称
    address: { type: String }, // 收货地址
    password: { type: String }, // 密码
    avtor: { type: String, default: 'https://qnimg.vadxq.com/blog/2016/blogheadimg20160517.jpg' }, // 头像
    score: { type: Number, default: 0 }, // 积分
    // total_score: { type: Number }, // 累计积分
    role: { type: Number, default: 0 }, // 权限;0,普通用户;10,工作人员;100,超级管理员
    status: { type: Boolean, default: true }, // 账号是否可用
    registerAt: { type: Date, default: Date.now() }, // 注册时间
    updateAt: { type: Date, default: Date.now() }, // 更新时间
    shoppingCart: [{
      type: Schema.Types.ObjectId,
      ref: 'ShoppingCarts',
    }],
    order: [{
      type: Schema.Types.ObjectId,
      ref: 'Orders',
    }],
  }, { versionKey: false });

  // 不支持箭头函数
  UserSchema.pre('save', function newDate(next) {
    if (this.isNew) {
      this.registerAt = this.updateAt = Date.now();
    } else {
      this.updateAt = Date.now();
    }
    next();
  });

  UserSchema.pre('update', function updateTime() {
    this.updateAt = Date.now();
  });

  return mongoose.model('User', UserSchema);
};
