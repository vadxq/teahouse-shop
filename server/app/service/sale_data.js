'use strict';

const Service = require('egg').Service;

class SaleDataService extends Service {
  /**
   * getSaleData
   * @return {Object} - return data
   */
  async getSaleData() {
    const user = await this.ctx.model.User.find().count();
    const order = await this.ctx.model.Order.find().count();
    const todayUser = await this.ctx.model.User.find({ registerAt: { $gte: new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate()) } }).count();
    const todayOrder = await this.ctx.model.Order.find({ createAt: { $gte: new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate()) } }).count();
    const productList = await this.ctx.model.Product.find();
    const product = productList.map(e => {
      return {
        pid: e.pid,
        销量: e.count,
        销售额: e.sale,
        title: e.title,
        单价: e.price,
      };
    });
    if (user && order && productList) {
      return {
        status: 1,
        res: {
          user,
          product,
          order,
          todayUser,
          todayOrder,
        },
      };
    }
    return {
      status: 0,
      res: '查询失败',
    };
  }
}

module.exports = SaleDataService;
