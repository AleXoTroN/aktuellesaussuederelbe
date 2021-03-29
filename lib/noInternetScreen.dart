import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:dart_rss/domain/rss_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suederelbe/main.dart';
import 'package:theme_provider/theme_provider.dart';

bool connected = false;


Icon connectionIcon = Icon(CupertinoIcons.wifi_slash, size: 128,);
TextStyle titleTextStyle = TextStyle(
    letterSpacing: 2,
    fontSize: 24,
    fontWeight: FontWeight.bold
);

TextStyle descriptionTextStyle = TextStyle(
    letterSpacing: 2,
    fontSize: 16,
);

TextStyle buttonTextStyle = TextStyle(
    letterSpacing: 2,
    fontWeight: FontWeight.bold,
    color: Colors.white
);


Text titleText = Text("Keine Verbindung", style: titleTextStyle, textAlign: TextAlign.center,);
Text descriptionText = Text("Verbinde dich mit dem Internet, um fortzufahren.", style: descriptionTextStyle, textAlign: TextAlign.center);
Text buttonText = Text("Erneut versuchen", style: buttonTextStyle, textAlign: TextAlign.center);




class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  StreamSubscription<ConnectivityResult> subscription;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
        setState(() {
          connected = true;
          connectionIcon = Icon(CupertinoIcons.wifi, size: 128, color: Colors.green,);
          titleText = Text("Verbunden", style: titleTextStyle, textAlign: TextAlign.center);
          descriptionText = Text("Du kannst nun fortfahren.", style: descriptionTextStyle, textAlign: TextAlign.center);
          buttonText = Text("Weiter", style: buttonTextStyle, textAlign: TextAlign.center);
        });
      }else{
        setState(() {
          connected = false;
          connectionIcon = Icon(CupertinoIcons.wifi_slash, size: 128,);
          titleText = Text("Keine Verbindung", style: titleTextStyle, textAlign: TextAlign.center);
          descriptionText = Text("Verbinde dich mit dem Internet, um fortzufahren.", style: descriptionTextStyle, textAlign: TextAlign.center);
          buttonText = Text("Erneut versuchen", style: buttonTextStyle, textAlign: TextAlign.center);
        });

      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: isLoading ? CircularProgressIndicator() : MaterialButton(onPressed: () async {
        if(connected){
          setState(() {
            isLoading = true;
          });
          var client = new http.Client();
          await client.get(Uri.parse("https://aktuelles-aus-suederelbe.de/feed")).then((response) {
            return response.body;
          }).then((bodyString) {
            feed = new RssFeed.parse(bodyString);
            print("PRINTR: " + feed.title.toString());
            return feed;
          }).then((value){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(title: "Lokales",)),
            );
          });

        }
      },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: ThemeProvider.themeOf(context).data.primaryColorDark,
        child: buttonText),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(64, 128, 64, 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              connectionIcon,
              SizedBox(height: 128,),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  titleText,
                  SizedBox(height: 8,),
                  descriptionText,
                ],
              ),


            ],
          )
        ),
      ),
    );
  }
// ···
}