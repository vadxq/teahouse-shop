import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feapp/service/service_methods.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feapp/provides/app_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _loading = false;

@override
  void initState() {
    // 初始化获取数据
    loadData();
  }
 
  // 获取数据
  Future<Null> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('uid'));
    if(prefs.getString('uid') != null) {
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
  changeCount(subject) async{
    var res = await putShoppingCart({
      'scid': subject['scid'],
      'count': subject['count']
    }, context);
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
      'price': Provider.of<AppState>(context).totalPrice,// 总价格 num
      'sale': Provider.of<AppState>(context).totalPrice,
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
    if(prefs.getString('uid') == null || prefs.getString('token') == null) {
      Provider.of<AppState>(context).updateIsLogin(false);
    }
  } 

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: new Text(
          Provider.of<AppState>(context).total >0 ? '购物车(' + Provider.of<AppState>(context).total.toString() + ')': '购物车',
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: _getIsLoginBody(),
    );
  }

  _getIsLoginBody() {
    _isLogin();
    if (Provider.of<AppState>(context).isLogin) {
      return new Column(
        children: <Widget>[
          new Expanded(
            child: Container(
            child: getBody(),
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
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    Text(
                      " ￥",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    Text(
                      Provider.of<AppState>(context).totalPrice.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 30),
                      color: Colors.red,
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(50, 13, 50, 13),
                        child: Text(
                          '结算',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            // height: 1.4,
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
                fontSize: 14,
                // height: 1.4,
              ),
            ),
            onPressed: () {
              _outLogin();
            },
          ),
      );
    }
  }

  Future<void> _showDialogWidget() async {
    if (Provider.of<AppState>(context).totalPrice == 0) {
      Fluttertoast.showToast(msg: '暂无商品~');
      // Navigator.of(context).pop(true);
    } else {
      return showDialog(
        context: context,
        builder: (context) {
            return new AlertDialog(
              title: Text(
                '请选择支付方式',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.2,
                ),
              ),
              content: new SingleChildScrollView(
                child: Column(
                children: [
                  Text('总计支付￥：' + Provider.of<AppState>(context).totalPrice.toString()),
                  Container(
                    margin: EdgeInsets.only(top: 30),
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
                              fontSize: 14,
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
                              fontSize: 14,
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
                  child: Text('取消'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
        });

    }
  }

  _outLogin() async{
    Navigator.pushNamedAndRemoveUntil(
      context, "SignPage", (router) => router == null);
  }

  getBody() {
      return Consumer<AppState>(
        builder: (context, cart, child) {
          if (cart.value.length != 0) {
            return  RefreshIndicator(
              child: ListView.builder(
                  itemCount: cart.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == cart.value.length) { //是否滑动到底部
                        return Center(child: Text('~~~到底了哟~~~'),);
                    } else {
                      return getItem(cart.value[index], index);
                    }
                  }),
              onRefresh: loadData,
            );
          } else {
            // 加载菊花
            // return CupertinoActivityIndicator();
            return Center(child: Text('~~~暂无商品哟~~~'),);
          }});
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
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      subject['cover'],
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.fill,
                      scale: 1.2,
                    ),
                  ),

                ),
                Expanded(
                  child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 100.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          subject['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Text(
                       '￥ ' + subject['price'].toString(),
                        style: TextStyle(
                            height: 1.2,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        subject['desc'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (subject['count'] != 1) {
                                  print(subject['count']);
                                  subject['count'] = subject['count'] - 1;
                                  changeCount(subject);
                                }
                              },
                            ),
                            Text('${subject['count']} 份'),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.add),
                              onPressed: () {
                                subject['count'] += 1;
                                changeCount(subject);
                              },
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(0),
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            color: Colors.redAccent,
                            child: 
                              Text(
                                '删除',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            onPressed: () async{
                              var res = await deleteShoppingCart(subject['scid'], context);
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
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: new Radius.circular(10.0),
          topRight: new Radius.circular(10.0),
        )
      ),
    );
  }
}
