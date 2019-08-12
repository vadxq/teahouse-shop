'use strict';

/** @type Egg.EggPlugin */
module.exports = {
  // had enabled by egg
  // static: {
  //   enable: true,
  // }
  // egg mongoose
  mongoose: {
    enable: true,
    package: 'egg-mongoose',
  },
  // egg jwt
  jwt: {
    enable: true,
    package: 'egg-jwt',
  },
};
