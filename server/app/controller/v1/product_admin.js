'use strict';

const Controller = require('../../core/base_controller');

class Product_adminController extends Controller {
  // 添加商品
  async addProduct() {
    // title, desc, cover, detail, total, price, new, recommend
    const reqData = this.ctx.request.body;
    if (reqData.hasOwnProperty('title')
      && reqData.hasOwnProperty('desc')
      && reqData.hasOwnProperty('cover')
      // && reqData.hasOwnProperty('detail')
      // && reqData.hasOwnProperty('total')
      && reqData.hasOwnProperty('price')
      && reqData.hasOwnProperty('new')
      && reqData.hasOwnProperty('recommend')) {
      const resData = await this.ctx.service.productAdmin.addProduct(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    } else {
      this.fail(400, '输入错误');
    }
  }

  // 商品修改
  async changeProduct() {
    // title, desc, cover, detail, total, price, new, recommend, pid
    const reqData = this.ctx.request.body;
    if (reqData.hasOwnProperty('title')
      && reqData.hasOwnProperty('desc')
      && reqData.hasOwnProperty('cover')
      // && reqData.hasOwnProperty('detail')
      // && reqData.hasOwnProperty('total')
      && reqData.hasOwnProperty('price')
      && reqData.hasOwnProperty('pid')
      && reqData.hasOwnProperty('new')
      && reqData.hasOwnProperty('recommend')
      && reqData.hasOwnProperty('check')) {
      const resData = await this.ctx.service.productAdmin.changeProduct(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    } else {
      this.fail(400, '输入错误');
    }
  }

  // 删除商品
  async deleteProduct() {
    const { pid } = this.ctx.params;
    if (pid) {
      const resData = await this.ctx.service.productAdmin.deleteProduct(pid);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    } else {
      this.fail(400, '输入错误');
    }
  }

  // 商品上架下架
  async checkProduct() {
    const reqData = this.ctx.request.body;
    if (reqData.hasOwnProperty('pid')) {
      const resData = await this.ctx.service.productAdmin.checkProduct(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    } else {
      this.fail(400, '输入错误');
    }
  }
}

module.exports = Product_adminController;
