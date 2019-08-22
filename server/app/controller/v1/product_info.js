'use strict';

const Controller = require('../../core/base_controller');

class ProductInfoController extends Controller {
  // 获取商品详情
  async getProductDetail() {
    const { pid } = this.ctx.params;
    if (!pid) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.productInfo.getProductDetail(pid);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  // 获取商品列表
  async getProductList() {
    // page: 页数;limit
    const reqData = this.ctx.request.query;
    if (!reqData.hasOwnProperty('page') || !reqData.hasOwnProperty('limit')) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.productInfo.getProductList(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  // 新品推荐商品列表
  async postProductList() {
    const reqData = this.ctx.request.body;
    if (!reqData.hasOwnProperty('new') || !reqData.hasOwnProperty('recommend')) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.productInfo.postProductList(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }
}

module.exports = ProductInfoController;
