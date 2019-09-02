# teahouse-shop
qing zhu teahouse shop project
- 展示页面：https://teahouse.vadxq.com
- 移动端app下载：https://down.vadxq.com/

## 功能分析
<table class="confluenceTable"><tbody><tr><th class="confluenceTh">功能模块</th><th class="confluenceTh">功能子模块（具体功能）</th></tr><tr><td rowspan="6" class="confluenceTd">用户信息</td><td class="confluenceTd">会员注册/登陆（signUp/signIn）</td></tr><tr><td colspan="1" class="confluenceTd">会员密码修改</td></tr><tr><td class="confluenceTd">会员端用户信息修改</td></tr><tr><td class="confluenceTd">管理端禁用与恢复</td></tr><tr><td colspan="1" class="confluenceTd">用户权限role</td></tr><tr><td colspan="1" class="confluenceTd">会员等级制度（与积分挂钩）</td></tr><tr><td rowspan="4" class="confluenceTd">商品信息</td><td colspan="1" class="confluenceTd"><p>新增商品</p></td></tr><tr><td colspan="1" class="confluenceTd">修改商品信息</td></tr><tr><td colspan="1" class="confluenceTd">上架/下架商品</td></tr><tr><td colspan="1" class="confluenceTd">获取商品列表</td></tr><tr><td rowspan="5" class="confluenceTd">订单系统<p>&nbsp;</p><p>&nbsp;</p></td><td colspan="1" class="confluenceTd">用户端创建订单</td></tr><tr><td colspan="1" class="confluenceTd"><p>用户端支付，取消，确认收货</p></td></tr><tr><td colspan="1" class="confluenceTd">管理端接单，发货</td></tr><tr><td colspan="1" class="confluenceTd">管理端查询订单</td></tr><tr><td colspan="1" class="confluenceTd">管理端修改订单信息</td></tr><tr><td rowspan="2" class="confluenceTd">积分系统</td><td colspan="1" class="confluenceTd">累计积分与等级</td></tr><tr><td colspan="1" class="confluenceTd">积分与福利</td></tr></tbody></table>

## 技术选型

- 后端

Eggjs

MongoDB

Ubuntu18.04

Nginx

Docker

[APIdoc](server/APIdoc.md)

[具体查看后端readme](server/README.md)

- 管理后台前端

Vue

Webpack

Ant Design For Vue

[具体查看管理后台前端readme](cmsclient/README.md)

- 移动端

Dart

Flutter

[具体查看移动端readme](feapp/README.md)


##### 有疑问或者建议欢迎提issue哟

##### license：Apache License Version 2.0