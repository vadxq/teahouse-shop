import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    _animation = Tween(begin: 0.50, end: 1.0).animate(_controller);

    /*动画事件监听器，
    它可以监听到动画的执行状态，
    我们这里只监听动画是否结束，
    如果结束则执行页面跳转动作。 */
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushNamedAndRemoveUntil(
            context, "IndexPage", (router) => router == null);
      }
    });
    //播放动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          child: Image.network(
              'https://qnimg.vadxq.com/luckyshop/startup-img.jpg',
              width: MediaQuery.of(context).size.width *
                  MediaQuery.of(context).devicePixelRatio,
              height: MediaQuery.of(context).size.height *
                  MediaQuery.of(context).devicePixelRatio,
              fit: BoxFit.fill),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 30),
          child: Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              child: new RaisedButton(
                child: Text('跳过'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'IndexPage', (router) => router == null);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
