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
          height: ScreenUtil().setHeight(620),
        ),
        new Container(
          child: Text(
            '新品推荐',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
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
    loadData();
  }

  // 获取新品推荐数据
  Future<Null> loadData() async {
    await Future.delayed(Duration(seconds: 2), () {
      getHomePageNew().then((data) => setState(() {
            _newDataList.clear();
            // var res = data['data']['data'];
            for (var item in data['data']['data']) {
              item['cart'] = 1;
            }
            _newDataList = data['data']['data'];
          }));
    });
  }

  // 修改商品数量
  changeCount(index, cart) {
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
                height: ScreenUtil().setHeight(620),
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
            child: Text('加载中...'),
          );
          // return CupertinoActivityIndicator();
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
              // scrollDirection: Axis.vertical,
              itemCount: _newDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return getItem(_newDataList[index], index);
              }));
    } else {
      // 加载菊花
      return CupertinoActivityIndicator();
    }
  }

  // 新品推荐-列表
  getItem(subject, index) {
    var row = Container(
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
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
                        // padding: EdgeInsets.fromLTRB(30, 3, 30, 3),
                        // color: Color.fromARGB(21, 0, 0, 0),
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
                                if (subject['cart'] != 1) {
                                  print(subject['cart']);
                                  int cart = subject['cart'] - 1;
                                  changeCount(index, cart);
                                }
                              },
                            ),
                            Text('${subject['cart']} 份'),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.add),
                              onPressed: () {
                                subject['cart'] += 1;
                                changeCount(index, subject['cart']);
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
                                      fontSize: 16,
                                      // height: 1.4,
                                    ),
                                  ),
                                  Icon(
                                    Icons.add_shopping_cart,
                                    size: 18,
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
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: new Radius.circular(10.0),
          topRight: new Radius.circular(10.0),
        )
      ),
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
                fontSize: 16.0,
                height: 1.2,
              ),
            ),
            content: Row(
              children: [
                Text('${subject['title']}： ${subject['cart']}份'),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('添加'),
                onPressed: () async{
                  // ... 执行删除操作
                  _addItem(subject);
                  
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  _addItem(data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('uid'));
    if(prefs.getString('uid') != null) {
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
