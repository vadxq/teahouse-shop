'use strict';

const Controller = require('../../core/base_controller');

class ShoppingCartController extends Controller {
  /**
   * 购物车添加商品
   * { item: {pid, title, desc, cover, price, count }, uid: uid }
   */
  async addShopItem() {
    const reqData = this.ctx.request.body;
    const uid = this.ctx.current_user.uid;
    if (!reqData || !uid) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.shoppingCart.addShopItem(reqData, uid);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  /**
   * 购物车获取商品
   */
  async getShoppingCartList() {
    const reqData = this.ctx.current_user.uid;
    console.log(reqData);
    if (!reqData) {
      this.fail(400, '用户信息错误');
    } else {
      const resData = await this.ctx.service.shoppingCart.getShoppingCartList(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  /**
   * 购物车删除商品
   */
  async delShopItem() {
    const { scid } = this.ctx.params;
    console.log(scid);
    if (!scid) {
      this.fail(400, '用户信息错误');
    } else {
      const resData = await this.ctx.service.shoppingCart.delShopItem(scid);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  /**
   * 购物车修改商品
   * scic, count
   */
  async changeShopItem() {
    const reqData = this.ctx.request.body;
    if (!reqData.hasOwnProperty('scid') || !reqData.hasOwnProperty('count')) {
      this.fail(400, '用户输入错误');
    } else {
      const resData = await this.ctx.service.shoppingCart.changeShopItem(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }
}

module.exports = ShoppingCartController;
