import 'package:flutter/material.dart';
import 'package:feapp/service/service_methods.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:feapp/provides/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String homePageContent = '正在获取数据';
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1794)..init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(222, 222, 222, 0.6),
      body: new Container(
          child: new Column(children: [
        new Container(
          child: _swiperContainer(),
          height: ScreenUtil().setWidth(800),
        ),
        new Container(
          child: Text(
            '新品推荐',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil.getInstance().setWidth(38),
              height: 1.2,
            ),
          ),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 8),
        ),
        _newContainer(),
      ])),
    );
  }

  List _newDataList = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  // 获取新品推荐数据
  Future<Null> _loadData() async {
    await Future.delayed(Duration(seconds: 2), () {
      getHomePageNew().then((data) => setState(() {
            _newDataList.clear();
            for (var item in data['data']) {
              item['cart'] = 1;
            }
            _newDataList = data['data'];
          }));
    });
  }

  // 修改商品数量
  _changeCount(index, cart) {
    setState(() {
      _newDataList[index]['cart'] = cart;
    });
  }

  // 轮播图
  Widget _swiperContainer() {
    return FutureBuilder(
      future: getHomePageContent(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map> swiperDataList =
              (snapshot.data['data']['slides'] as List).cast();
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                height: ScreenUtil().setWidth(800),
                width: ScreenUtil().setWidth(1068.6),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network('${swiperDataList[index]['image']}',
                        fit: BoxFit.fill);
                  },
                  itemCount: swiperDataList.length,
                  pagination: new SwiperPagination(),
                  autoplay: true,
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text(
              '加载中...',
              style: TextStyle(
                fontSize: ScreenUtil.getInstance().setWidth(38),
              ),
            ),
          );
        }
      },
    );
  }

  // 新品推荐
  Widget _newContainer() {
    if (_newDataList.length != 0) {
      return new Expanded(
          child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              shrinkWrap: true,
              itemCount: _newDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return _getItem(_newDataList[index], index);
              }));
    } else {
      // 加载菊花
      return CupertinoActivityIndicator();
    }
  }

  // 新品推荐-列表
  _getItem(subject, index) {
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
                        height: 1.4,
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
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setWidth(36),
                      ),
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
                            icon: Icon(
                              Icons.remove,
                              size: ScreenUtil.getInstance().setWidth(44),
                            ),
                            onPressed: () {
                              if (subject['cart'] != 1) {
                                print(subject['cart']);
                                int cart = subject['cart'] - 1;
                                _changeCount(index, cart);
                              }
                            },
                          ),
                          Text(
                            '${subject['cart']} 份',
                            style: TextStyle(
                              fontSize: ScreenUtil.getInstance().setWidth(36),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.add,
                              size: ScreenUtil.getInstance().setWidth(44),
                            ),
                            onPressed: () {
                              subject['cart'] += 1;
                              _changeCount(index, subject['cart']);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  ' 加入 ',
                                  style: TextStyle(
                                    color: Color.fromARGB(222, 0, 0, 0),
                                    fontSize:
                                        ScreenUtil.getInstance().setWidth(40),
                                    // height: 1.4,
                                  ),
                                ),
                                Icon(
                                  Icons.add_shopping_cart,
                                  size: ScreenUtil.getInstance().setWidth(44),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showDialogWidget(subject, index);
                            },
                          ),
                        ],
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
          ScreenUtil.getInstance().setWidth(34),
          ScreenUtil.getInstance().setWidth(24),
          ScreenUtil.getInstance().setWidth(34),
          ScreenUtil.getInstance().setWidth(24)),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
        new Radius.circular(ScreenUtil.getInstance().setWidth(40)),
      )),
    );
  }

  // 新品推荐-加入购物车弹窗
  Future<void> showDialogWidget(subject, index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text(
              '请确认',
              style: TextStyle(
                fontSize: ScreenUtil.getInstance().setWidth(38),
              ),
            ),
            content: Row(
              children: [
                Text(
                  '${subject['title']}： ${subject['cart']}份',
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setWidth(38)),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '取消',
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setWidth(38)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(
                  '添加',
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setWidth(38)),
                ),
                onPressed: () async {
                  _addItem(subject);
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  // 添加购物车
  _addItem(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('uid'));
    if (prefs.getString('uid') != null) {
      data['count'] = data['cart'];
      data['uid'] = prefs.getString('uid');
      var res = await addShoppingCart(data);
      if (res['success']) {
        Fluttertoast.showToast(msg: '添加成功~');
        getShoppingCartList(context);
      } else {
        Fluttertoast.showToast(msg: '添加失败~');
      }
    } else {
      Fluttertoast.showToast(msg: '请登录~');
      Provider.of<AppState>(context).updateIsLogin(false);
    }
  }
}
