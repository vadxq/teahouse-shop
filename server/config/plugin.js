'use strict';

/** @type Egg.EggPlugin */
module.exports = {
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
