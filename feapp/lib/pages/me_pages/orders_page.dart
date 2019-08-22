import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:feapp/service/service_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List ordersList = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<Null> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    await Future.delayed(Duration(seconds: 2), () {
      getMyOrderList(uid, context).then((data) => setState(() {
            ordersList.clear();
            print(data);
            ordersList.addAll(data['data']['items']);
            print(ordersList);
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1794)..init(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(ScreenUtil.getInstance().setWidth(145)),
            child: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.reply,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  );
                },
              ),
              centerTitle: true,
              title: new Text(
                '我的订单',
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil.getInstance().setWidth(48)),
              ),
              backgroundColor: Colors.lightBlueAccent,
            )),
        body: Center(
          child: _getBody(),
        ));
  }

  // body主容器
  _getBody() {
    if (ordersList.length != 0) {
      return RefreshIndicator(
        child: ListView.builder(
            itemCount: ordersList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == ordersList.length) {
                //是否滑动到底部
                return Center(
                  child: Text('~~~到底了哟~~~'),
                );
              } else {
                return _getItem(ordersList[index], index);
              }
            }),
        onRefresh: _loadData,
      );
    } else {
      // 加载菊花
      return CupertinoActivityIndicator();
    }
  }

  // 列表item
  _getItem(order, index) {
    var row = Container(
        child: Column(
      children: <Widget>[
        _buildDateAndStatusWidget(order),
        _buildGoodsInfoWidget(order['item']),
        _buildOrderStatusWidget(order),
      ],
    ));
    return Card(
      child: row,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
        new Radius.circular(10.0),
      )),
    );
  }

  // 日期 状态
  _buildDateAndStatusWidget(item) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(90),
      padding: EdgeInsets.only(
        left: ScreenUtil.getInstance().setWidth(28),
        right: ScreenUtil.getInstance().setWidth(28),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: ScreenUtil.getInstance().setWidth(2),
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '订单号: ' + item['oid'].toString(),
            style: TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontSize: ScreenUtil.getInstance().setSp(32),
            ),
          ),
          Text(
            item['status'] > 1 ? '已完成' : '待接单',
            style: TextStyle(
              color: Color.fromRGBO(128, 128, 128, 1),
              fontSize: ScreenUtil.getInstance().setSp(32),
            ),
          ),
        ],
      ),
    );
  }

  // 商品列表容器
  _buildGoodsInfoWidget(item) {
    return Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil.getInstance().setWidth(44),
          right: ScreenUtil.getInstance().setWidth(28),
        ),
        child: ListView.builder(
            itemCount: item.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _buildShopItem(item[index]);
            }));
  }

  // 商品列表
  _buildShopItem(item) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil.getInstance().setWidth(44),
        right: ScreenUtil.getInstance().setWidth(28),
      ),
      child: Container(
        height: ScreenUtil.getInstance().setHeight(150),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: ScreenUtil.getInstance().setWidth(1),
              color: Colors.black12,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: ScreenUtil.getInstance().setHeight(8),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ScreenUtil.getInstance().setWidth(4),
                  ),
                  child: Image.network(
                    item['cover'],
                    width: ScreenUtil.getInstance().setWidth(94),
                    height: ScreenUtil.getInstance().setHeight(94),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil.getInstance().setWidth(32),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(18),
                    ),
                    Text(
                      item['title'],
                      style: TextStyle(
                        color: Color.fromRGBO(80, 80, 80, 1),
                        fontSize: ScreenUtil.getInstance().setSp(32),
                      ),
                    ),
                    Text(
                      '￥ ' + item['price'].toString(),
                      style: TextStyle(
                        color: Color.fromRGBO(166, 166, 166, 1),
                        fontSize: ScreenUtil.getInstance().setSp(32),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(18),
                ),
                Text(
                  '￥' + item['sale'].toString(),
                  style: TextStyle(
                    color: Color.fromRGBO(80, 80, 80, 1),
                    fontSize: ScreenUtil.getInstance().setSp(32),
                  ),
                ),
                Text(
                  'x' + item['count'].toString(),
                  style: TextStyle(
                    color: Color.fromRGBO(166, 166, 166, 1),
                    fontSize: ScreenUtil.getInstance().setSp(32),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 实际付款容器
  _buildOrderStatusWidget(item) {
    return Container(
      padding: EdgeInsets.only(
        right: ScreenUtil.getInstance().setWidth(28),
      ),
      height: ScreenUtil.getInstance().setHeight(100),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: ScreenUtil.getInstance().setWidth(2),
            color: Colors.black12,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                '日期： ${item['createAt'].toString().split('T')[0]} ${item['createAt'].toString().split('T')[1].substring(0, 8)}',
                style: TextStyle(
                  color: Color.fromRGBO(128, 128, 128, 1),
                  fontSize: ScreenUtil.getInstance().setSp(32),
                ),
              ),
              Text(
                '共${item['count'].toString()}件商品',
                style: TextStyle(
                  color: Color.fromRGBO(56, 56, 56, 1),
                  fontSize: ScreenUtil.getInstance().setSp(32),
                ),
              ),
              SizedBox(
                width: ScreenUtil.getInstance().setWidth(20),
              ),
              Text(
                '实付金额： ￥' + item['sale'].toString(),
                style: TextStyle(
                  color: Color.fromRGBO(56, 56, 56, 1),
                  fontSize: ScreenUtil.getInstance().setSp(32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
