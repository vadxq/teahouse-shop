'use strict';

const Service = require('egg').Service;

class ProductAdminService extends Service {
  /**
   * add product
   * @param {Object} req - { title, desc, cover, detail, total, price, new, recommend }
   * @return {Object} - return data
   */
  async addProduct(req) {
    if (req.title.length === 0) return { status: 0, res: '请提交商品名称' };
    if (req.price.length === 0 || isNaN(+req.price)) return { status: 0, res: '价格格式错误' };
    if (req.cover.length === 0) return { status: 0, res: '请提交商品封面图' };
    if (req.desc.length === 0) return { status: 0, res: '请提交商品描述' };
    const product = this.ctx.model.Product({
      title: req.title,
      desc: req.desc,
      cover: req.cover,
      price: req.price,
      new: req.new,
      recommend: req.recommend,
    });
    const res = await product.save();
    if (res) {
      return {
        status: 1,
        res,
      };
    }
    return {
      status: 0,
      res: '添加失败',
    };
  }

  /**
   * add product
   * @param {Object} req - { title, desc, cover, detail, total, price, new, recommend, pid }
   * @return {Object} - return data
   */
  async changeProduct(req) {
    const product = await this.ctx.model.Product.findOne({ pid: req.pid });
    req.count = req.total - product.sale;
    const res = await this.ctx.model.Product.findOneAndUpdate({ pid: req.pid }, {
      title: req.title,
      desc: req.desc,
      cover: req.cover,
      detail: req.detail,
      total: req.total,
      price: req.price,
      new: req.new,
      recommend: req.recommend,
      count: req.count,
      check: req.check,
    });
    if (res) {
      return {
        status: 1,
        res,
      };
    }
    return {
      status: 0,
      res: '修改失败',
    };
  }

  /**
   * delete product
   * @param {Object} pid - { pid }
   * @return {Object} - return data
   */
  async deleteProduct(pid) {
    const res = await this.ctx.model.Product.findOneAndUpdate({ pid }, { dele: true });
    if (res) {
      return {
        status: 1,
        res,
      };
    }
    return {
      status: 0,
      res: '删除失败',
    };
  }

  /**
   * check product
   * @param {Object} req - { pid }
   * @return {Object} - return data
   */
  async checkProduct(req) {
    const product = await this.ctx.model.Product.findOne({ pid: req.pid });
    const res = await this.ctx.model.Product.findOneAndUpdate({ pid: req.pid }, { check: !product.check });
    console.log(res);
    if (res) {
      if (res.check) {
        return {
          status: 1,
          res: '上架成功',
        };
      }
      return {
        status: 1,
        res: '下架成功',
      };
    }
    return {
      status: 0,
      res: '操作失败',
    };
  }
}

module.exports = ProductAdminService;
