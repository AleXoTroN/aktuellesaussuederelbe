import 'dart:async';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:suederelbe/detailview.dart';
import 'package:suederelbe/noInternetScreen.dart';
import 'package:theme_provider/theme_provider.dart';

RssFeed feed;


ThemeData lightTheme = new ThemeData(
              iconTheme: IconThemeData(
                  color: Colors.grey[700],
                ),
              disabledColor: Colors.black26,
              canvasColor: Colors.white,
              
              shadowColor: Colors.black,
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.grey[800],
                ),
                elevation: 0,
                shadowColor: Colors.black26,
                color: Colors.white54,
                brightness: Brightness.light,
                textTheme: TextTheme(
                  headline6: GoogleFonts.montserrat(
                    
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.grey[800],),
                )
              ),
              highlightColor: Colors.black.withOpacity(0.05),
              splashColor: Colors.black.withOpacity(0.05),
              splashFactory: InkRipple.splashFactory,
              primaryColorDark: Color(0xff092e43),
              primaryColor: Color(0xff1b98e0),
              accentColor: Color(0xff1b98e0),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Color(0xff092e43),
                focusColor: Color(0xff007cba),
                hoverColor: Color(0xff007cba),
                splashColor: Color(0xff007cba),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            
  );

  ThemeData darkTheme = new ThemeData(
    brightness: Brightness.dark,
              cardColor: Colors.grey[800],
              iconTheme: IconThemeData(
                
                  color: Colors.white,
                ),
              disabledColor: Colors.white10,
              canvasColor: Color(0xff1a2026),
              shadowColor: Colors.black,
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                elevation: 0,
                shadowColor: Colors.black,
                color: Colors.grey.withOpacity(0.54),
                brightness: Brightness.dark,
                textTheme: TextTheme(
                  headline6: GoogleFonts.montserrat(
                    
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: Colors.white,),
                )
              ),
              highlightColor: Colors.black.withOpacity(0.05),
              splashColor: Colors.white.withOpacity(0.05),
              splashFactory: InkRipple.splashFactory,
              primaryColor: Color(0xff62A4CA),
              accentColor: Color(0xff62A4CA),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Color(0xff2d6586),
                focusColor: Color(0xff5084A2),
                hoverColor: Color(0xff5084A2),
                splashColor: Color(0xff5084A2),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            
  );


//hello

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, 
    statusBarBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark
  ));

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    var client = new http.Client();
    await client.get(Uri.parse("https://aktuelles-aus-suederelbe.de/feed")).then((response) {
      return response.body;
    }).then((bodyString) {
      feed = new RssFeed.parse(bodyString);
      print("PRINTR: " + feed.title.toString());
      return feed;
    });
    // I am connected to a mobile network.
  }else if(connectivityResult == ConnectivityResult.none){
    feed = null;
  }

  

  
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      loadThemeOnInit: true,
      saveThemesOnChange: true,
      onThemeChanged: (oldTheme, newTheme){
        if(newTheme.id == "light"){
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent, // navigation bar color
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.dark
          ));
        }else{
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor: newTheme.data.canvasColor, // navigation bar color
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,

              systemNavigationBarIconBrightness: Brightness.light
          ));
        }
    },
      themes: [
        AppTheme(
          id: "light",
          description: "Light theme", 
          data: lightTheme),
        AppTheme(
          id: "dark", 
          description: "Dark theme",
          data: darkTheme),
      ],
          child: ThemeConsumer(
            child: Builder(
              builder: (themeCcontext) =>
                MaterialApp(
            
            title: 'Aktuelles aus Süderelbe',
            theme: ThemeProvider.themeOf(themeCcontext).data,
            
            home: feed != null ? MyHomePage(title: 'Aktuelles aus Süderelbe') : NoInternetScreen(),
          ),
              
              
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  var drawerListIconSize = 22.0;
  TextStyle drawerListTextStyle = GoogleFonts.montserrat(fontSize: 14, letterSpacing: 1.5, fontWeight: FontWeight.bold);
  int _counter = 0;

  StreamSubscription<ConnectivityResult> subscription;

  Future<void> loadItems() async {
    var client = new http.Client();
    await client.get(Uri.parse("https://aktuelles-aus-suederelbe.de/feed")).then((response) {
      return response.body;
    }).then((bodyString) {
      feed = new RssFeed.parse(bodyString);
      print("PRINTR: " + feed.title.toString());
      return feed;
    });
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
        var client = new http.Client();
        await client.get(Uri.parse("https://aktuelles-aus-suederelbe.de/feed")).then((response) {
          return response.body;
        }).then((bodyString) {
          feed = new RssFeed.parse(bodyString);
          print("PRINTR: " + feed.title.toString());
          setState(() {
            return feed;
          });
        });
      }else{

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

    if (feed == null){

    }
    
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        semanticLabel: "Menü",
    child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        
        child: Image.asset("assets/logo.jpg", width: 104,),
        decoration: BoxDecoration(
          color: Colors.white
        ),
      ),
      
      ListTile(
        dense: true,
        leading: Icon(Icons.location_on_outlined, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
        title: Text('Lokales', style: drawerListTextStyle),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.sports, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
        title: Text('Sport', style: drawerListTextStyle),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.theater_comedy, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
        title: Text('Kultur', style: drawerListTextStyle),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.how_to_vote_rounded, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
        title: Text('Politik', style: drawerListTextStyle),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.emoji_nature_rounded, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
        title: Text('Umwelt', style: drawerListTextStyle),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.attach_money_rounded, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
        title: Text('Wirtschaft', style: drawerListTextStyle),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      Divider(),
      ExpansionTile(
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.05),
        leading: Icon(Icons.event, size: drawerListIconSize),
        title: Text('Termine', style: drawerListTextStyle),
        children: [
          ListTile(
            dense: true,
            leading: Icon(Icons.event_note, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
            title: Text('Alle Termine', style: drawerListTextStyle),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.person_outline_rounded, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
            title: Text('Veranstalter', style: drawerListTextStyle),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.add_circle_outline_rounded, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
            title: Text('Veranstaltung hinzufügen', style: drawerListTextStyle),
            onTap: () {},
          ),
        ],
      ),
      ExpansionTile(
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.05),
        leading: Icon(Icons.local_offer_outlined, size: drawerListIconSize, ),
        title: Text('Kleinanzeigen', style: drawerListTextStyle),
        children: [
          ListTile(
            dense: true,
            leading: Icon(Icons.local_offer_outlined, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
            title: Text('Alle Kleinanzeigen', style: drawerListTextStyle),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.local_offer_outlined, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
            title: Text('Meine Kleinanzeigen', style: drawerListTextStyle),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.local_offer_outlined, size: drawerListIconSize, color: Theme.of(context).iconTheme.color,),
            title: Text('Kleinanzeige hinzufügen', style: drawerListTextStyle),
            onTap: () {},
          ),
        ],
      ),
      ListTile(
            dense: true,
            leading: Icon(Icons.category_outlined, size: drawerListIconSize),
            title: Text('Themen', style: drawerListTextStyle),
            trailing: Icon(Icons.expand_more),
            enabled: false,
          ),
    ],
  ),// Populate the Drawer in the next step.
  ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size(
            double.infinity,
            56.0,
          ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: ThemeProvider.themeOf(context).data.canvasColor.withOpacity(0.7),
              actions: [
                IconButton(icon: Icon(ThemeProvider.controllerOf(context).currentThemeId == "light" ? Icons.wb_incandescent : Icons.wb_incandescent_outlined), onPressed: (){

                  ThemeProvider.controllerOf(context).nextTheme();


                }),
                IconButton(icon: Icon(Icons.bookmarks_outlined),),
                IconButton(icon: Icon(Icons.more_vert),),
              ],

              /*leading: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: IconButton(
                  highlightColor: Theme.of(context).accentColor.withOpacity(0.2),
                  focusColor: Theme.of(context).accentColor.withOpacity(0.2),
                  hoverColor: Theme.of(context).accentColor.withOpacity(0.2),
                  splashColor: Theme.of(context).accentColor.withOpacity(0.2),
                  icon: Icon(Icons.menu_rounded), onPressed: (){

                }),
              ),*/
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Lokales"),
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 128, 16, 16),
          itemCount: feed.items.length,
          itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.only(top: index != 0 ? 16 : 0),
            child: AnimatedSize(
              curve: Curves.easeInOutCirc,
              duration: Duration(milliseconds: 400),
              vsync: this,
               child: InkWell(
                 onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewScreen(title: feed.items[index].title, item: feed.items[index], text: feed.items[index].content.value,)),
                  );
                },
                 child: Container(
                   child: Card(
                     margin: EdgeInsets.all(0),
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(16)
                    ),
                     child: Stack(
                      alignment: Alignment.center,
                      children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        height: 240,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        fadeInCurve: Curves.easeInOutCirc,
                        placeholderFadeInDuration: Duration(milliseconds: 400),

                            color: Colors.black54,
                            colorBlendMode: BlendMode.srcOver,
        imageUrl: feed.items[index].media.contents.first.url,
        placeholder: (context, url) => Stack(
            alignment: Alignment.center,
            children: [
            ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                              child: Container(

                                  height: 240,
                    color: Colors.black26,

                ),
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.black.withOpacity(0.025),
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black.withOpacity(0.025)),
            ),
            ]),
        errorWidget: (context, url, error) => Stack(
            alignment: Alignment.center,
            children: [
            ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                              child: Container(

                                  height: 180,
                    color: Colors.black26,


                ),
            ),
            Icon(Icons.error_outline, color: Colors.black12, size: 32,),
            ]),
     ),
                        ),
                      Positioned(
                                top: 16,
                                left: 16,
                                child: DecoratedBox(


                                    decoration: BoxDecoration(
                                      color: ThemeProvider.themeOf(context).data.accentColor,
                                      borderRadius: BorderRadius.all(Radius.circular(16))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
                                      child: Text(
                                        feed.items[index].categories.first.value.toString(),
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),

                                    )
                                    ),
                            ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                                          child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(

                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                    getTimeDifference(convertToDateTime(feed.items[index].pubDate, true)),
                                    style: GoogleFonts.montserrat(

                                      color: Colors.white,
                                      fontSize: 12),),
                                      SizedBox(height: 8,),
                              Text(
                                    '${feed.items[index].title.toString()}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 24),),
                            ],
                          ),
                        ),
                      ),
                    ],),
                   ),
                 ),
               ),
              ),
          );
          },
        )),
      drawerScrimColor: Colors.black.withOpacity(0.3),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



String convertToDateTime(String dateInput, bool raw){
  String dateOutput;
  
  dateOutput = dateInput
  .substring(5, 22)
  .replaceAll(" ", "")
  .replaceAll(":", "")
  .replaceAll("Jan", "01")
  .replaceAll("Feb", "02")
  .replaceAll("Mar", "03")
  .replaceAll("Apr", "04")
  .replaceAll("May", "05")
  .replaceAll("Jun", "06")
  .replaceAll("Jul", "07")
  .replaceAll("Aug", "08")
  .replaceAll("Sep", "09")
  .replaceAll("Oct", "10")
  .replaceAll("Nov", "11")
  .replaceAll("Dev", "12");

  dateOutput = dateOutput.substring(4, 8).toString() + dateOutput.substring(2, 4) + dateOutput.substring(0, 2) + "T" + dateOutput.substring(8, 12);
  String day = DateTime.parse(dateOutput).day.toString();
  String month = DateTime.parse(dateOutput).month.toString();
  String year = DateTime.parse(dateOutput).year.toString();
  String hour = DateTime.parse(dateOutput).hour.toString();
  String minute = DateTime.parse(dateOutput).minute.toString();

  

  if(!raw) dateOutput = day + "." + month + "." + year + ", " + hour + ":" + minute + " Uhr";
  return dateOutput;
}


String getTimeDifference(String dateInput){
  Duration difference = DateTime.parse(dateInput).difference(DateTime.now());
  String differenceInHours;
  differenceInHours = "vor ";
  if(difference.inHours*-1 <= 23){
    String suffix;
    if(difference.inMinutes*-1 > 60){
      suffix = " Stunden";
    }else{
      suffix = " Stunde";
    }

    differenceInHours = differenceInHours + difference.inHours.toString().replaceAll("-", "") + suffix;
  }else if (difference.inHours*-1 > 23){
    String suffix;
    if(difference.inDays*-1 > 1){
      suffix = " Tagen";
    }else{
      suffix = " Tag";
    }
    differenceInHours = differenceInHours + difference.inDays.toString().replaceAll("-", "") + suffix;
  }

  return differenceInHours;
}
