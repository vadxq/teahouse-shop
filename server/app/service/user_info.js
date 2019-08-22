'use strict';

const Service = require('egg').Service;
const crypto = require('crypto');

class UserInfoService extends Service {
  /**
   * getUserInfo
   * @param {String} uid - old password and new password
   * @return {Object} - return data
   */
  async getUserInfo(uid) {
    const user = await this.ctx.model.User.findOne({ uid, status: true });
    if (user) {
      return {
        status: 1,
        res: user,
      };
    }
    return {
      status: 0,
      res: '获取个人信息失败',
    };
  }

  /**
   * change password
   * @param {Object} req - old password and new password
   * @return {Object} - return data
   */
  async changePassword(req) {
    if (req.oldPassword !== '' && /[\u4e00-\u9fa5]/.test(req.oldPassword)) {
      return {
        status: 0,
        res: '旧密码格式错误',
      };
    }
    if (req.newPassword !== '' && /[\u4e00-\u9fa5]/.test(req.newPassword)) {
      return {
        status: 0,
        res: '新密码格式错误',
      };
    }
    const user = await this.ctx.model.User.findOne({ uid: this.ctx.current_user.uid });
    if (user.password === crypto.createHash('md5').update(req.oldPassword).digest('hex')) {
      const res = await this.ctx.model.User.findOneAndUpdate({
        uid: this.ctx.current_user.uid }, {
        password: crypto.createHash('md5').update(req.newPassword).digest('hex'),
      });
      if (res) {
        return {
          status: 1,
          res: '修改成功',
        };
      }
      return {
        status: 0,
        res: '修改失败',
      };
    }
    return {
      status: 0,
      res: '密码错误',
    };
  }

  /**
   * change user Info
   * @param {Object} req - phone, email, nickname, address, avtor
   * @return {Object} - return data
   */
  async changeUserInfo(req) {
    if (req.email === ''
      || !/^([\w-_]+(?:\.[\w-_]+)*)@((?:[a-z0-9]+(?:-[a-zA-Z0-9]+)*)+\.[a-z]{2,6})$/i.test(req.email)
    ) {
      return {
        status: 0,
        res: '邮箱格式错误',
      };
    }
    if (req.phone === ''
      || !/^[1]([3-9])[0-9]{9}$/.test(req.phone)
    ) {
      return {
        status: 0,
        res: '手机号格式错误',
      };
    }
    if (req.username === '') {
      return {
        status: 0,
        res: '用户名格式错误',
      };
    }
    const res = await this.ctx.model.User.findOneAndUpdate({ uid: this.ctx.current_user.uid }, {
      phone: req.phone,
      username: req.username,
      email: req.email,
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
}

module.exports = UserInfoService;
