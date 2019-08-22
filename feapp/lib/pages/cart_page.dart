import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feapp/service/service_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feapp/provides/app_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool get wantKeepAlive => true;
  List menuItemList = [];
  int pages = 0;
  bool isLogin = false;
  int money = 0;

  @override
  void initState() {
    // 初始化获取数据
    loadData();
    super.initState();
  }

  // 获取数据
  Future<Null> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('uid'));
    if (prefs.getString('uid') != null) {
      var res = await getShoppingCartList(context);
      if (res['success']) {
        getShoppingCartList(context);
      } else {
        Fluttertoast.showToast(msg: '获取失败~');
      }
    } else {
      setState(() {
        isLogin = false;
      });
      Provider.of<AppState>(context).updateShoppingCart([]);
    }
  }

  // 修改商品数量
  _changeCount(subject) async {
    var res = await putShoppingCart(
        {'scid': subject['scid'], 'count': subject['count']}, context);
    if (res['success']) {
      getShoppingCartList(context);
    } else {
      Fluttertoast.showToast(msg: '修改失败~');
    }
  }

  // 生成订单
  Future<Null> _makeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {
      'price': Provider.of<AppState>(context).totalPrice, // 总价格 num
      'sale': Provider.of<AppState>(context).totalSale, // 打折后
      'count': Provider.of<AppState>(context).total,
      'item': Provider.of<AppState>(context).value,
      'uid': prefs.getString('uid'),
    };
    if (data['count'] == 0) {
      Fluttertoast.showToast(msg: '暂无商品~');
    } else {
      await makeOrderItem(data, context);
    }
  }

  // 判断是否登陆
  _isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('uid') == null || prefs.getString('token') == null) {
      Provider.of<AppState>(context).updateIsLogin(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(ScreenUtil.getInstance().setWidth(145)),
          child: AppBar(
            automaticallyImplyLeading: false, //左边按钮
            centerTitle: true,
            title: new Text(
              Provider.of<AppState>(context).total > 0
                  ? '购物车(' +
                      Provider.of<AppState>(context).total.toString() +
                      ')'
                  : '购物车',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil.getInstance().setWidth(48)),
            ),
            backgroundColor: Colors.lightBlueAccent,
          )),
      body: _getIsLoginBody(),
    );
  }

  // 列表容器
  _getIsLoginBody() {
    _isLogin();
    if (Provider.of<AppState>(context).isLogin) {
      return new Column(
        children: <Widget>[
          new Expanded(
              child: Container(
            child: _getBody(),
            width: double.infinity,
            color: Color.fromRGBO(222, 222, 222, 0.6),
          )),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "合计: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil.getInstance().setWidth(38)),
                    ),
                    Text(
                      " ￥",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: ScreenUtil.getInstance().setWidth(38)),
                    ),
                    Text(
                      Provider.of<AppState>(context).totalSale.toStringAsFixed(2) + ' ',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: ScreenUtil.getInstance().setWidth(42),
                      ),
                    ),
                    Text(
                      Provider.of<AppState>(context).totalPrice.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                        fontSize: ScreenUtil.getInstance().setWidth(32),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(78)),
                      color: Colors.red,
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(50, 13, 50, 13),
                        child: Text(
                          '结算',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil.getInstance().setWidth(44),
                          ),
                        ),
                        onPressed: () {
                          _showDialogWidget();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return Center(
        child: FlatButton(
          padding: EdgeInsets.all(0),
          color: Colors.lightBlueAccent,
          child: Text(
            '登陆/注册',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.getInstance().setWidth(38),
            ),
          ),
          onPressed: () {
            _outLogin();
          },
        ),
      );
    }
  }

  // 展示支付方式
  Future<void> _showDialogWidget() async {
    if (Provider.of<AppState>(context).totalPrice == 0) {
      Fluttertoast.showToast(msg: '暂无商品~');
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: Text(
                '请选择支付方式',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setWidth(38),
                  height: 1.2,
                ),
              ),
              content: new SingleChildScrollView(
                  child: Column(
                children: [
                  Text(
                    '总计支付￥：' +
                        Provider.of<AppState>(context).totalSale.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setWidth(38)),
                  ),
                  Container(
                    height: ScreenUtil.getInstance().setWidth(88),
                    margin: EdgeInsets.only(
                        top: ScreenUtil.getInstance().setWidth(48)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          color: Colors.blue,
                          child: Text(
                            '支付宝',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.getInstance().setWidth(38),
                              // height: 1.4,
                            ),
                          ),
                          onPressed: () {
                            launch('alipays://');
                            _makeOrder();
                            Navigator.of(context).pop(true);
                          },
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          color: Colors.green,
                          child: Text(
                            '微信',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.getInstance().setWidth(38),
                              // height: 1.4,
                            ),
                          ),
                          onPressed: () {
                            launch('weixin://');
                            _makeOrder();
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    '取消',
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setWidth(36)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          });
    }
  }

  // 登陆
  _outLogin() async {
    Navigator.pushNamedAndRemoveUntil(
        context, "SignPage", (router) => router == null);
  }

  _getBody() {
    return Consumer<AppState>(builder: (context, cart, child) {
      if (cart.value.length != 0) {
        return RefreshIndicator(
          child: ListView.builder(
              itemCount: cart.value.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == cart.value.length) {
                  //是否滑动到底部
                  return Center(
                    child: Text(
                      '~~~到底了哟~~~',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setWidth(38)),
                    ),
                  );
                } else {
                  return getItem(cart.value[index], index);
                }
              }),
          onRefresh: loadData,
        );
      } else {
        return Center(
          child: Text(
            '~~~暂无商品哟~~~',
            style: TextStyle(fontSize: ScreenUtil.getInstance().setWidth(38)),
          ),
        );
      }
    });
  }

  // 菜单-列表
  getItem(subject, index) {
    var row = Container(
        child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil.getInstance().setWidth(25),
                  ScreenUtil.getInstance().setWidth(18),
                  ScreenUtil.getInstance().setWidth(18),
                  ScreenUtil.getInstance().setWidth(18)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                  subject['cover'],
                  width: ScreenUtil.getInstance().setWidth(230),
                  height: ScreenUtil.getInstance().setWidth(230),
                  fit: BoxFit.fill,
                  scale: 1.2,
                ),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil.getInstance().setWidth(28),
                  ScreenUtil.getInstance().setWidth(28),
                  ScreenUtil.getInstance().setWidth(28),
                  ScreenUtil.getInstance().setWidth(28)),
              height: ScreenUtil.getInstance().setWidth(300),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(subject['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                          fontSize: ScreenUtil.getInstance().setWidth(38),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(
                    '￥ ' + subject['price'].toString(),
                    style: TextStyle(
                      height: 1.2,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil.getInstance().setWidth(36),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    subject['desc'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setWidth(36),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            )),
            Container(
                height: 100,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.remove,
                              size: ScreenUtil.getInstance().setWidth(44)),
                          onPressed: () {
                            if (subject['count'] != 1) {
                              print(subject['count']);
                              subject['count'] = subject['count'] - 1;
                              _changeCount(subject);
                            }
                          },
                        ),
                        Text(
                          '${subject['count']} 份',
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setWidth(36),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.add,
                              size: ScreenUtil.getInstance().setWidth(44)),
                          onPressed: () {
                            subject['count'] += 1;
                            _changeCount(subject);
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(0),
                      width: ScreenUtil.getInstance().setWidth(200),
                      height: ScreenUtil.getInstance().setWidth(100),
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        color: Colors.redAccent,
                        child: Text(
                          '删除',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil.getInstance().setWidth(38),
                          ),
                        ),
                        onPressed: () async {
                          var res = await deleteShoppingCart(
                              subject['scid'], context);
                          if (res['success']) {
                            Fluttertoast.showToast(msg: res['message']);
                          }
                        },
                      ),
                    )
                  ],
                ))
          ],
        ),
      ],
    ));
    return Card(
      child: row,
      margin: EdgeInsets.fromLTRB(
          ScreenUtil.getInstance().setWidth(30),
          ScreenUtil.getInstance().setWidth(42),
          ScreenUtil.getInstance().setWidth(30),
          ScreenUtil.getInstance().setWidth(0)),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
        new Radius.circular(ScreenUtil.getInstance().setWidth(40)),
      )),
    );
  }
}
