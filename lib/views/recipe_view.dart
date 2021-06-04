import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_project/views/home.dart';

int favouritesInt = 0;

class RecipeView extends StatefulWidget {
  final String postUrl;
  //need for favourites
  final String title, desc, imgUrl;

  RecipeView({@required this.postUrl, this.title, this.desc, this.imgUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  String finalUrl ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalUrl = widget.postUrl;
    if(widget.postUrl.contains('http://')){
      finalUrl = widget.postUrl.replaceAll("http://","https://");
      print(finalUrl + "this is final url");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 60, right: 24,left: 24,bottom: 16),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          const Color(0xff213A50),
                          const Color(0xff071930)
                        ],
                        begin: FractionalOffset.topRight,
                        end: FractionalOffset.bottomLeft)),
                child:  Row(
                  mainAxisAlignment: kIsWeb
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Recipe",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Overpass'),
                    ),
                    Text(
                      "Cookbook",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontFamily: 'Overpass'),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - (Platform.isIOS ? 104 : 30),
                width: MediaQuery.of(context).size.width,
                child: WebView(
                  onPageFinished: (val){
                    print(val);
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: finalUrl,
                  onWebViewCreated: (WebViewController webViewController){
                    setState(() {
                      _controller.complete(webViewController);
                    });
                  },
                ),
              ),
            ],
          ),
        ),

      //Add to favourites button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _read();
          _save2(postUrl2, title2, desc2, imgUrl2);
        },
        child: Icon(Icons.favorite),
        backgroundColor: Colors.red,
      ),
    );
  }
}
//favourites
_read() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'favouritesInt';//number of saved favourites
  final value = prefs.getInt(key) ?? 0;
  favouritesInt = value;
  await _saveInt(0);//initialize saved favourites as zero
  print(' read() saved favourites: $value');
}

_saveInt(int i) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'favouritesInt';
  final value = i;
  prefs.setInt(key, value);
  print(' save() saved favourites: $value');
}
_save2(String postUrl, String title, String desc, String imgUrl) async {
  final prefs = await SharedPreferences.getInstance();
  favouritesInt++;
  _saveInt(favouritesInt);
  final key = 'stringKey$favouritesInt';
  final value = [postUrl, title, desc, imgUrl];
  prefs.setStringList(key, value);
  print(' save() saved favourites : $key $value');
}