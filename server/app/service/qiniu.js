'use strict';

const Service = require('egg').Service;
const qiniu = require('qiniu');
const config = require('../../config/port');

class QiniuService extends Service {
  /**
   * addShopItem
   * @param {String} bucket - bucket
   * @return {Object} - return data
   */
  async getToken(bucket) {
    const mac = new qiniu.auth.digest.Mac(config.accessKey, config.secretKey);
    const options = {
      scope: bucket,
      expires: 7200,
    };
    const putPolicy = new qiniu.rs.PutPolicy(options);
    const uploadToken = putPolicy.uploadToken(mac);
    if (uploadToken) {
      return {
        status: 1,
        res: uploadToken,
      };
    }
    return {
      status: 0,
      res: '生成token失败',
    };
  }
}

module.exports = QiniuService;
