



import 'package:webview_flutter/webview_flutter.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';



double progress;
bool finished = false;

class LinkView extends StatefulWidget{
  LinkView({Key key, this.initUrl}) : super(key: key);

  final String initUrl;

  @override
  State<StatefulWidget> createState() => LinkViewState(initUrl);


}

class LinkViewState extends State<LinkView> with TickerProviderStateMixin{
  AnimationController _animationController;
  Animation _colorTween;
  final String initUrl;
  @override
  void initState() {
    super.initState();


    progress = 0;
  }

  LinkViewState(this.initUrl);
  @override
  Widget build(BuildContext context) {
    _animationController =
        AnimationController(
            vsync: this, duration: Duration(milliseconds: 5000));
    _colorTween = ColorTween(begin: ThemeProvider.themeOf(context).data.floatingActionButtonTheme.backgroundColor, end: ThemeProvider.themeOf(context).data.accentColor)
        .animate(_animationController);
    _animationController.repeat(reverse: true);
    // TODO: implement build
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child){
          return FloatingActionButton(
            backgroundColor: _colorTween.value,
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Center(
              child: Icon(Icons.close),
            ),);
        },
      ),
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          allowsInlineMediaPlayback: true,
          onProgress: (prog){
            setState(() {
              progress = prog.toDouble();
              print("Progress: " + progress.toString());
            });
          },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
            _animationController.stop(canceled: false);
            setState(() {
              progress = 0;
            });

        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
            _animationController.repeat(reverse: true);
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,

          initialUrl: initUrl,
        ),
      ),
    );
  }
}