/* eslint valid-jsdoc: "off" */
'use strict';

const secConfig = require('./port');

/**
 * @param {Egg.EggAppInfo} appInfo app info
 */
module.exports = appInfo => {
  /**
   * built-in config
   * @type {Egg.EggAppConfig}
   **/
  const config = exports = {};

  // security
  config.security = {
    xframe: {
      enable: false,
    },
    csrf: {
      enable: false,
    },
  };
  // use for cookie sign key, should change to your own and keep security
  config.keys = appInfo.name + '_1564459858481_6938';

  // add your middleware config here
  config.middleware = [];

  // mongoose config here
  config.mongoose = {
    client: {
      // security port
      url: secConfig.url,
      options: {
        autoReconnect: true,
        reconnectTries: Number.MAX_VALUE,
        bufferMaxEntries: 0,
      },
    },
  };

  config.jwt = {
    secret: secConfig.jwtSecret,
    enable: false,
  };

  // add your user config here
  const userConfig = {
  };

  return {
    ...config,
    ...userConfig,
  };
};
