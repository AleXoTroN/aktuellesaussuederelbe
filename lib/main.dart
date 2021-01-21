import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:suederelbe/detailview.dart';

RssFeed feed;

//hello

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, 
    statusBarBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark
  ));
  var client = new http.Client();
  await client.get("https://aktuelles-aus-suederelbe.de/feed").then((response) {
    return response.body;
  }).then((bodyString) {
    feed = new RssFeed.parse(bodyString);
    print("PRINTR: " + feed.title.toString());
    return feed;
  });
  

  
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Aktuelles aus Süderelbe',
      theme: ThemeData(
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
          elevation: 10,
          shadowColor: Colors.black26,
          color: Colors.white,
          brightness: Brightness.light,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 24,
              color: Colors.grey[600]
            )
          )
        ),
        highlightColor: Colors.black.withOpacity(0.05),
        splashColor: Colors.black.withOpacity(0.05),
        splashFactory: InkRipple.splashFactory,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color(0xff1b98e0),
        accentColor: Color(0xff1b98e0),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          focusColor: Color(0xff007cba),
          hoverColor: Color(0xff007cba),
          splashColor: Color(0xff007cba),
        ),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Aktuelles aus Süderelbe'),
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

  

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
  /*  client.get("https://aktuelles-aus-suederelbe.de/feed/")
      .then((response) {
    return response.body;
  }).then((bodyString) {
    var channel = new AtomFeed.parse(bodyString);
    print(channel);
    return channel;
  });
  */
  
    

    
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
      appBar: AppBar(
        
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
        title: Text("Lokales", style: GoogleFonts.montserrat(letterSpacing: 1.5, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: feed.items.length,
          itemBuilder: (context, index){
          return AnimatedSize(
            curve: Curves.easeInOutCirc,
            duration: Duration(milliseconds: 400),
            vsync: this,
             child: OpenContainer(
               
               closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
               transitionType: ContainerTransitionType.fadeThrough,
               closedElevation: 0.0,
               openElevation: 4.0,
               transitionDuration: Duration(milliseconds: 400),
               openBuilder: (BuildContext context, VoidCallback _) => NewScreen(item: feed.items[index], title: feed.items[index].title.toString(), text: feed.items[index].content.value.toString(),),
               closedBuilder: (BuildContext _, VoidCallback openContainer) {
                 return Card(
                   margin: EdgeInsets.only(top: index != 0 ? 16 : 0),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(16)
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
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
                          
                            height: 180,
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
                                  color: Colors.blue,
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
                
                                                        );}
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
    differenceInHours = differenceInHours + difference.inHours.toString().replaceAll("-", "") + " Stunden";
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
