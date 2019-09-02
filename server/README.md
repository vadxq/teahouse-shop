# teshouse清竹茶馆后端

一个 eggjs server 项目。teshouse清竹茶馆后端

## 目录架构
```
week1/
  |
  ├──app/                     * egg代码主目录
  │   │
  │   │──controller/          * 控制器主要代码
  │   │   │
  │   │   └──v1/              * 当前v1版本api控制器
  │   │ 
  │   │──core/                * 控制器封装核心
  │   │ 
  │   │──middleware/          * egg中间件
  │   │ 
  │   │──model/               * 数据库schema
  │   │ 
  │   │──public/              * egg默认静态文件目录
  │   │ 
  │   │──service/             * 服务代码主目录
  │   │ 
  │   └──router.js            * egg路由文件
  │
  ├──config/
  │   │ 
  │   │──config.default.js    * egg默认配置文件
  │   │ 
  │   │──port.js              * egg生产环境配置文件,详情见port.sample.js
  │   │ 
  │   └──plugin.js            * egg插件配置
  │
  ├──test/                    * egg测试目录
  │
  ├──.autod.conf.js           * autod配置文件
  │
  ├──.eslintignore            * Eslint忽略文件配置
  │
  ├──.eslintrc                * Eslint文件配置
  │
  ├──.gitignore               * Git忽略文件配置
  │
  ├──.travis.yml              * travis文件配置
  │
  ├──appveyor.yml             * appveyor文件配置
  │
  ├──docker-compose.yml       * docker-compose配置
  │
  ├──Dockerfile               * Docker配置
  │
  ├──jsconfig.json            * jsconfig配置
  │
  ├──package.json             * 包信息
  │
  ├──package-lock.json        * 包信息
  │
  └──README.md                * readme

```

## 使用

本地开发
```
npm run serve
```
部署
```
npm run start || npm start    // 127.0.0.1:7001
```
关闭服务
```
npm run stop
```

## 文档

[APIdoc](server/APIdoc.md)
