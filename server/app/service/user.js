'use strict';

const Service = require('egg').Service;
const crypto = require('crypto');

/**
 * @param app.Service signUp and signIn
 */
class UserService extends Service {
  /**
   * 签名
   * @param {Object} user - {}
   * @return {Object} - return data
   */
  generateToken(user) {
    return this.ctx.app.jwt.sign({ uid: user.uid, role: user.role, exp: Date.now() + 24 * 60 * 60 * 1000 }, this.ctx.app.config.jwt.secret);
  }

  /**
   * 注册
   * @param {Object} req - {}
   * @return {Object} - return data
   */
  async signUp(req) {
    if (req.uid.length < 5 || !/^[a-zA-Z0-9_-]{4,16}$/.test(req.uid)) {
      return {
        status: 0,
        res: '账户格式错误',
      };
    }
    if (!/^([\w-_]+(?:\.[\w-_]+)*)@((?:[a-z0-9]+(?:-[a-zA-Z0-9]+)*)+\.[a-z]{2,6})$/i.test(req.email)) {
      return {
        status: 0,
        res: '邮箱格式错误',
      };
    }
    if (!/^[1]([3-9])[0-9]{9}$/.test(req.phone)) {
      return {
        status: 0,
        res: '手机号格式错误',
      };
    }
    if (/[\u4e00-\u9fa5]/.test(req.password)) {
      return {
        status: 0,
        res: '密码格式错误',
      };
    }
    let user = await this.ctx.model.User.findOne({ uid: req.uid });
    if (user) {
      return {
        status: 0,
        res: '用户已存在',
      };
    }
    req.password = crypto.createHash('md5').update(req.password).digest('hex');
    user = this.ctx.model.User(req);
    const res = await user.save();
    const token = this.generateToken(res);
    return {
      status: 1,
      res: {
        token,
        data: res,
      },
    };
  }

  /**
   * 登陆
   * @param {Object} req - {}
   * @return {Object} - return data
   */
  async signIn(req) {
    const user = await this.ctx.model.User.findOne({ uid: req.uid });
    if (user) {
      if (user.status) {
        if (user.password === crypto.createHash('md5').update(req.password).digest('hex')) {
          const token = this.generateToken(user);
          return {
            status: 1,
            res: {
              token,
            },
          };
        }
      } else {
        return {
          status: 0,
          res: '账户已被禁用',
        };
      }
    }
    return {
      status: 0,
      res: '账户或密码错误',
    };
  }
}

module.exports = UserService;
