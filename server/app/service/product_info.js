'use strict';

const Service = require('egg').Service;

class ProductInfoService extends Service {
  /**
   * check product
   * @param {Object} pid - { pid }
   * @return {Object} - return data
   */
  async getProductDetail(pid) {
    let product;
    if (this.ctx.current_user) {
      if (this.ctx.current_user.role > 10) {
        // admin
        product = await this.ctx.model.Product.findOne({ pid, dele: false }, {
          pid: 1,
          title: 1,
          desc: 1,
          cover: 1,
          detail: 1,
          sale: 1,
          price: 1,
          total: 1,
          count: 1,
          check: 1,
          recommend: 1,
          new: 1,
          createAt: 1,
          updateAt: 1,
        });
      } else if (this.ctx.current_user.role === 10) {
        // 工作人员
        product = await this.ctx.model.Product.findOne({ pid, dele: false, check: true }, {
          pid: 1,
          title: 1,
          desc: 1,
          cover: 1,
          detail: 1,
          sale: 1,
          price: 1,
          total: 1,
          count: 1,
          recommend: 1,
          new: 1,
          createAt: 1,
          updateAt: 1,
        });
      } else {
        // 会员
        product = await this.ctx.model.Product.findOne({ pid, dele: false, check: true }, {
          pid: 1,
          title: 1,
          desc: 1,
          cover: 1,
          detail: 1,
          sale: 1,
          price: 1,
          total: 1,
          count: 1,
          createAt: 1,
          updateAt: 1,
        });
      }
    } else {
      // 非会员
      product = await this.ctx.model.Product.findOne({ pid, dele: false, check: true }, {
        pid: 1,
        title: 1,
        desc: 1,
        cover: 1,
        detail: 1,
        sale: 1,
        price: 1,
        total: 1,
        count: 1,
        createAt: 1,
        updateAt: 1,
      });
    }
    console.log(product);
    if (product) {
      return {
        status: 1,
        res: product,
      };
    }
    return {
      status: 0,
      res: '操作失败',
    };
  }

  /**
   * get product list
   * @param {Object} req - { page, limit }
   * @return {Object} - return data
   */
  async getProductList(req) {
    let product;
    const pages = await this.ctx.model.Product.find({ dele: false, check: true }).count() / req.limit;
    if (this.ctx.current_user) {

      if (this.ctx.current_user.role > 10) {
        // admin
        product = await this.ctx.model.Product.find({ dele: false }, {
          pid: 1,
          title: 1,
          desc: 1,
          cover: 1,
          detail: 1,
          sale: 1,
          price: 1,
          total: 1,
          count: 1,
          check: 1,
          recommend: 1,
          new: 1,
          createAt: 1,
          updateAt: 1,
        })
          .skip((+req.page - 1) * +req.limit)
          .limit(+req.limit)
          .sort({ pid: -1 });
        const adminPages = await this.ctx.model.Product.find({ dele: false }).count() / req.limit;
        if (product) {
          return {
            status: 1,
            res: {
              data: product,
              pages: Math.ceil(adminPages),
              currentPage: +req.page,
            },
          };
        }
      } else if (this.ctx.current_user.role === 10) {
        // 工作人员
        product = await this.ctx.model.Product.find({ dele: false, check: true }, {
          pid: 1,
          title: 1,
          desc: 1,
          cover: 1,
          detail: 1,
          sale: 1,
          price: 1,
          total: 1,
          count: 1,
          recommend: 1,
          new: 1,
          createAt: 1,
          updateAt: 1,
        })
          .skip((+req.page - 1) * +req.limit)
          .limit(+req.limit)
          .sort({ pid: -1 });
      } else {
        // 会员
        product = await this.ctx.model.Product.find({ dele: false, check: true }, {
          pid: 1,
          title: 1,
          desc: 1,
          cover: 1,
          detail: 1,
          sale: 1,
          price: 1,
          total: 1,
          count: 1,
          createAt: 1,
          updateAt: 1,
        })
          .skip((+req.page - 1) * +req.limit)
          .limit(+req.limit)
          .sort({ pid: -1 });
      }
    } else {
      // 非会员
      product = await this.ctx.model.Product.find({ dele: false, check: true }, {
        pid: 1,
        title: 1,
        desc: 1,
        cover: 1,
        detail: 1,
        sale: 1,
        price: 1,
        total: 1,
        count: 1,
        createAt: 1,
        updateAt: 1,
      })
        .skip((+req.page - 1) * +req.limit)
        .limit(+req.limit)
        .sort({ pid: -1 });
    }
    console.log(product);
    if (product) {
      return {
        status: 1,
        res: {
          data: product,
          pages: Math.ceil(pages),
          currentPage: +req.page,
        },
      };
    }
    return {
      status: 0,
      res: '操作失败',
    };
  }

  /**
   * 推荐新品商品列表
   * @param {Object} req - { new, recommend }
   * @return {Object} - return data
   */
  async postProductList(req) {
    const product = await this.ctx.model.Product.find({ dele: false, check: true, $or: [{ new: req.new }, { recommend: req.recommend }] }, {
      pid: 1,
      title: 1,
      desc: 1,
      cover: 1,
      detail: 1,
      sale: 1,
      price: 1,
      total: 1,
      count: 1,
      createAt: 1,
      updateAt: 1,
    })
      .sort({ pid: -1 });
    if (product) {
      return {
        status: 1,
        res: product,
      };
    }
    return {
      status: 0,
      res: '操作失败',
    };
  }
}

module.exports = ProductInfoService;
