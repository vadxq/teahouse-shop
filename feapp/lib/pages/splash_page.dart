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

    // 监听动画
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushNamedAndRemoveUntil(
            context, 'IndexPage', (router) => router == null);
      }
    });

    // 播放动画
    _controller.forward();
  }

  // 销毁
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
            child: Container(
              width: 60,
              height: 30,
              child: new RaisedButton(
                color: Colors.white30,
                padding: EdgeInsets.all(0),
                child: Text(
                  '跳过',
                  style: TextStyle(
                    color: Color.fromARGB(222, 0, 0, 0),
                    fontSize: 12,
                    // height: 1.4,
                  ),
                ),
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
