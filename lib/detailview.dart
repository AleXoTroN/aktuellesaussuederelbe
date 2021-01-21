import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_rss/domain/rss_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suederelbe/main.dart';

class NewScreen extends StatelessWidget {
  NewScreen({Key key, this.item, this.title, this.text}) : super(key: key);

  final RssItem item;
  final String title;
  final String text;
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back),
      elevation: 8,
      
      ),
      extendBody: false,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 80, right: 16, top: 64),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue,
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
                  fadeInCurve: Curves.easeInOutCirc,
                  placeholderFadeInDuration: Duration(milliseconds: 400),
                  imageUrl: item.media.contents.first.url,
                  placeholder: (context, url) => Stack(
          alignment: Alignment.center,
          children: [
          ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                        child: Container(
                          
                            height: 180,
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
                          
                            height: 180,
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
              shrinkWrap: false,
         data: text,

          style: {
           "p": Style(
             fontSize: FontSize(18),
             fontFamily: GoogleFonts.montserrat(
               fontSize: 20).fontFamily
           )}

       ),
            

          ],),
        ),
      )
    );
  }
}