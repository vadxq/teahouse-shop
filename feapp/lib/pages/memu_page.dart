import 'package:flutter/material.dart';
import 'package:feapp/service/service_methods.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:feapp/provides/app_state.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List menuItemList = [];
  ScrollController _scrollController = new ScrollController();
  int currentPage = 1;
  int pages = 1;

  @override
  void initState() {
    super.initState();
    // 初始化获取数据
    loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  // 获取数据
  Future<Null> loadData() async {
    await Future.delayed(Duration(seconds: 2), () {
      getMenuPageList({
        'page': 1,
        'limit': 10,
      }).then((data) => setState(() {
            menuItemList.clear();
            for (var item in data['data']['data']) {
              item['cart'] = 1;
            }
            currentPage = data['data']['currentPage'];
            pages = data['data']['pages'];
            menuItemList.addAll(data['data']['data']);
          }));
    });
    print(menuItemList);
  }

  // 获取更多数据
  Future<Null> loadMoreData() async {
    if (currentPage < pages) {
      await Future.delayed(Duration(seconds: 1), () {
        getMenuPageList({
          'page': currentPage + 1,
          'limit': 10,
        }).then((data) => setState(() {
              currentPage = data['data']['currentPage'];
              pages = data['data']['pages'];
              for (var item in data['data']['data']) {
                item['cart'] = 1;
              }
              menuItemList.addAll(data['data']['data']);
            }));
      });
      print(menuItemList);
    }
  }

  // 修改商品数量
  changeCount(index, cart) {
    setState(() {
      menuItemList[index]['cart'] = cart;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1794)..init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(222, 222, 222, 0.6),
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(ScreenUtil.getInstance().setWidth(145)),
          child: AppBar(
            automaticallyImplyLeading: false, //左边按钮
            centerTitle: true,
            title: new Text(
              '清竹茶馆菜单',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil.getInstance().setWidth(48)),
            ),
            backgroundColor: Colors.lightBlueAccent,
          )),
      body: Center(
        child: getBody(),
      ),
    );
  }

  // 主容器
  getBody() {
    if (menuItemList.length != 0) {
      return RefreshIndicator(
        child: ListView.builder(
            itemCount: currentPage <= pages
                ? menuItemList.length + 1
                : menuItemList.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              if (index == menuItemList.length) {
                //是否滑动到底部
                if (currentPage == pages) {
                  return Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil.getInstance().setWidth(40),
                          bottom: ScreenUtil.getInstance().setWidth(40)),
                      child: Center(
                        child: Text(
                          '~~~到底了哟~~~',
                          style: TextStyle(
                              fontSize: ScreenUtil.getInstance().setWidth(36)),
                        ),
                      ));
                } else {
                  return LoadMoreView();
                }
              } else {
                return getItem(menuItemList[index], index);
              }
            }),
        onRefresh: loadData,
      );
    } else {
      // 加载菊花
      return CupertinoActivityIndicator();
    }
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
                          icon: Icon(
                            Icons.remove,
                            size: ScreenUtil.getInstance().setWidth(44),
                          ),
                          onPressed: () {
                            if (subject['cart'] != 1) {
                              print(subject['cart']);
                              int cart = subject['cart'] - 1;
                              changeCount(index, cart);
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
                  '${subject['title']}：${subject['cart']}份',
                  style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setWidth(38),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setWidth(38),
                    )),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('添加',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setWidth(38),
                    )),
                onPressed: () {
                  // ... 执行删除操作
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

// 加载更多
class LoadMoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              Padding(padding: EdgeInsets.all(10)),
              Text(
                '加载中...',
                style:
                    TextStyle(fontSize: ScreenUtil.getInstance().setWidth(38)),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
      color: Colors.white70,
    );
  }
}