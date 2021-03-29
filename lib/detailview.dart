import 'dart:async';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:dart_rss/domain/rss_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suederelbe/linkview.dart';
import 'package:suederelbe/main.dart';
import 'package:theme_provider/theme_provider.dart';

class NewScreen extends StatelessWidget {
  NewScreen({Key key, this.item, this.title, this.text}) : super(key: key);

  final RssItem item;
  final String title;
  final String text;
  RssFeed comments;


  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(
            double.infinity,
            56.0,
          ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              elevation: 0,
              backgroundColor: ThemeProvider.themeOf(context).data.canvasColor.withOpacity(0.6),
              actions: [
                IconButton(icon: Icon(Icons.bookmark_border), onPressed: (){

                }),
                IconButton(icon: Icon(Icons.share_outlined), onPressed: (){

                }),
                IconButton(icon: Icon(Icons.more_vert), onPressed: (){

                })
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
            ),
          ),
        ),
      ),
      extendBody: false,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
          child: Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16, top: 128),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context).data.accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16, bottom: 4, right: 16),
                    child: Text(
                    item.categories.first.value.toString(),
                    style: TextStyle(
                      color: Colors.white
                      ),
                      ),

                                    )
                                    ),
            Padding(
              padding: EdgeInsets.only(bottom: 16, top: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                    fadeInCurve: Curves.easeInOutCirc,
                    placeholderFadeInDuration: Duration(milliseconds: 400),
                    imageUrl: item.media.contents.first.url,
                    placeholder: (context, url) => Stack(
          alignment: Alignment.center,
          children: [
          ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                          child: Container(

                              height: 240,
                  color: Colors.black12,

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

                              height: 240,
                  color: Colors.black26,


              ),
          ),
          Icon(Icons.error_outline, color: Colors.black26, size: 64,),
          ]),
     ),
              ),
            ),
            Text(convertToDateTime(item.pubDate, false), style: GoogleFonts.montserrat(
              fontSize: 16),
            ),

            SizedBox(height: 4,),

            Text(title, style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 24),
            ),

            SizedBox(height: 16,),
            new Html(
              onLinkTap: (url, rcontext, map, element){
                print(url);
                print(map);
                print(element);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LinkView(initUrl: url,)),
                );
              },
              shrinkWrap: false,
         data: text,

          style: {
           "p": Style(
             fontSize: FontSize(18),
             fontFamily: GoogleFonts.montserrat(
               fontSize: 20).fontFamily
           )}

       ),
              SizedBox(height: 16,),
              CommentSection(item: item,)


          ],),
        ),
      )
    );
  }
}

class CommentSection extends StatefulWidget{
  CommentSection({Key key, this.item}) : super(key: key);

  final RssItem item;

  @override
  State<StatefulWidget> createState() => CommentSectionState(item);


}

class CommentSectionState extends State<CommentSection>{
CommentSectionState(this.item);
  final RssItem item;
  bool isAnswer;
  bool isLoading = false;
  RssFeed comments;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
      var client = new http.Client();
      await client.get(Uri.parse(item.comments.toString())).then((response) {
        return response.body;
      }).then((bodyString) {
        setState(() {
          comments = new RssFeed.parse(bodyString.toString());
          isLoading = false;
        });
        return comments;
      }).onError((error, stackTrace){
        print(error);
        return comments;
      });
      // I am connected to a mobile network.






  }

  @override
  Widget build(BuildContext context) {
    print(comments.toString());
    // TODO: implement build
    return Container(

      width: MediaQuery.of(context).size.width,
      child: ExpansionTile(
        trailing: !isLoading ? null : Container(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
        initiallyExpanded: true,
        title: Text("Kommentare  " + (comments != null ? comments.items.length.toString() : ""), style: TextStyle(
          fontWeight: FontWeight.bold

        ),), children: [
        if (comments != null) ListView.builder(
          reverse: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.items.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index){
              if(comments.items[index].content.value.contains("Als Antwort auf")){
                isAnswer = true;
              }else{
                isAnswer = false;
              }
              return Padding(
                padding: isAnswer ? const EdgeInsets.only(left: 16) : EdgeInsets.zero,
                child: ListTile(
                  dense: isAnswer,
                  key: new Key(item.title),
                  title: Text(comments.items[index].title.replaceAll("Von: ", ""),
                  style: TextStyle(
                    color: ThemeProvider.themeOf(context).data.primaryColor,
                    fontWeight: FontWeight.bold
                  ),),
                  subtitle: new Html(data: comments.items[index].content.value),
                ),
              );

            }),
        if (comments == null) Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Keine Kommentare vorhanden"),
        )
      ],),
    );
  }
}