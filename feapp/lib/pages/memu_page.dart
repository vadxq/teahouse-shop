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
      appBar: AppBar(
        automaticallyImplyLeading: false, //左边按钮
        centerTitle: true,
        title: new Text(
          '清竹茶馆菜单',
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: getBody(),
      ),
    );
  }

  getBody() {
    if (menuItemList.length != 0) {
      return RefreshIndicator(
        child: ListView.builder(
            itemCount: currentPage <= pages? menuItemList.length + 1: menuItemList.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              if (index == menuItemList.length) { //是否滑动到底部
                if (currentPage == pages) {
                  return Center(child: Text('~~~到底了哟~~~'),);
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
                // fontFamily: 'Courier',
                // decorationStyle: TextDecorationStyle.dashed
              ),
            ),
            content: Row(
              children: [
                Text('${subject['title']}：${subject['cart']}份'),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('添加'),
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
  
  _addItem(data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

class LoadMoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Row(children: <Widget>[
          new CircularProgressIndicator(),
          Padding(padding: EdgeInsets.all(10)),
          Text('加载中...')
        ], mainAxisAlignment: MainAxisAlignment.center,),
      ),
    ), color: Colors.white70,);
  }

}