'use strict';

const Controller = require('../../core/base_controller');

class ShoppingCartController extends Controller {
  /**
   * 生成订单
   * { item: [{pid, title, desc, cover, price, count, sale }], count, sale, price }
   */
  async addOrderItem() {
    const reqData = this.ctx.request.body;
    const uid = this.ctx.current_user.uid;
    if (!reqData.hasOwnProperty('item') || !reqData.hasOwnProperty('count') || !reqData.hasOwnProperty('price') || !reqData.hasOwnProperty('sale') || !uid) {
      this.fail(400, '订单信息错误');
    } else {
      const resData = await this.ctx.service.order.addOrderItem(reqData, uid);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  /**
   * 接订单/消费了，积分，商品
   * oid, uid, count, sale, price, item
   */
  async makeOrderItem() {
    const reqData = this.ctx.request.body;
    if (!reqData.hasOwnProperty('item') || !reqData.hasOwnProperty('uid') || !reqData.hasOwnProperty('oid') || !reqData.hasOwnProperty('sale')) {
      this.fail(400, '订单信息错误');
    } else {
      const resData = await this.ctx.service.order.makeOrderItem(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  /**
   * 查询订单，通过订单号/uid
   * sort, id
   */
  async getOrderItem() {
    const req = this.ctx.request.body;
    if (!req) {
      this.fail(400, '信息错误');
    } else {
      const resData = await this.ctx.service.order.getOrderItem(req);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  /**
   * 查询订单列表
   * oid
   */
  async getOrderList() {
    // page: 页数;limit
    const reqData = this.ctx.request.query;
    console.log(reqData);
    if (!reqData.hasOwnProperty('page') || !reqData.hasOwnProperty('limit')) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.order.getOrderList(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  /**
   * 删除订单
   * oid
   */
  async delOrderItem() {
    const { oid } = this.ctx.params;
    if (!oid) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.order.delOrderItem(oid);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  /**
   * 获取我的订单
   * oid
   */
  async getMyOrder() {
    const { uid } = this.ctx.params;
    console.log(uid);
    if (!uid) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.order.getMyOrder(uid);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }
}

module.exports = ShoppingCartController;
