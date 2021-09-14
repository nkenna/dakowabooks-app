import 'dart:io';

import 'package:dakowabook/projectcolors.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/landing/authorsscreen.dart';
import 'package:dakowabook/screens/landing/genresscreen.dart';
import 'package:dakowabook/screens/landing/homescreen.dart';
import 'package:dakowabook/screens/landing/libraryscreen.dart';
import 'package:dakowabook/screens/landing/mescreen.dart';
import 'package:dakowabook/screens/search/searchauthorscreen.dart';
import 'package:dakowabook/screens/search/searchbookscreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LandingScreen extends StatefulWidget {
  int? screen = 0;

  LandingScreen({this.screen = 0});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<Widget> _screens = [
    HomeScreen(),
    AuthorsScreen(),
    GenresScreen(),
    LibraryScreen(),
    MeScreen()
  ];

  int _screen = 0;

  List<String> _titles = [
    "Home", "Authors", "Genres", "Library", "Me"
  ];


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        initData()
    );
  }

  initData() async {
    changeScreen(widget.screen!);
    Provider.of<AuthProvider>(context, listen: false).getUserProfile(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
    Provider.of<LiteratureProvider>(context, listen: false).allCategories();
    Provider.of<LiteratureProvider>(context, listen: false).dashboardData();
    FirebaseMessaging.instance.getToken()
        .then((value) {
      print(value);
      String? userId = Provider.of<AuthProvider>(context, listen: false).profile! != null
      ? Provider.of<AuthProvider>(context, listen: false).profile!.id! : null;
      if(userId != null && userId.isNotEmpty){
        if(value != null && value.isNotEmpty){
          AuthHttpService().updateDeviceRequest(
              value,
              "",
              Platform.isAndroid ? "android" : "ios",
              userId
          );
        }
      }

    });
    //Provider.of<LiteratureProvider>(context, listen: false).allCategories();
  }

  void changeScreen(int scr){
    _screen = scr;
    setState(() {});
  }

  Widget mainTopBar(){
    return Container(
        width: Get.width,
        height: kToolbarHeight + 10,
        //color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              AnimatedOpacity(
                  opacity: _screen == 4 ? 0 : 1,
                  duration: Duration(seconds: 1),
                  child: CachedNetworkImage(
                  imageUrl: AuthHttpService.baseUrl + "${Provider.of<AuthProvider>(context, listen: false).profile!.avatar}",
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 30,
                    backgroundImage: imageProvider,
                  ),
                  //placeholder: (context, url) => CircularProgressIndicator(),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) =>
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/images/logored.png"),
                      ),

                ),
              ),



              Text("${_titles[_screen]}", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 16, color: mainTextColor),),

              InkWell(
                onTap: (){
                  if(_screen == 1){
                    Get.to(() => SearchAuthorScreen());
                  }else{
                    Get.to(() => SearchBookScreen());
                  }
                },
                child: Container(
                  width: (MediaQuery.of(context).padding.top + kToolbarHeight) - 50,
                  height: (MediaQuery.of(context).padding.top + kToolbarHeight) - 50,
                  decoration: BoxDecoration(
                    color: Color(0xffeedcec),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Icon(Icons.search_rounded, size: 30, color: mainColor,), //Color(0xff77198c)
                ),
              )
            ],
          ),
        ),
      );
  }

  Widget menuItem(Color color, IconData cd, String title, VoidCallback callback){
    return InkWell(
      onTap: callback,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(cd, size: 30, color: color,),
          Text(title, style: TextStyle(color: color, fontSize: 14, fontFamily: 'SofiaProSemiBold'),)
        ],
      ),
    );
  }

  Widget mainBottomBar(){
    return Container(
      width: Get.width,
      height: MediaQuery.of(context).padding.top + kToolbarHeight,
      color: mainColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            menuItem(_screen == 0 ? Color(0xffeedcec) : Colors.white, Icons.home_outlined, "Home", () {
              changeScreen(0);
            }),
            menuItem(_screen == 1 ? Color(0xffeedcec) : Colors.white, Icons.people_outline_rounded, "Authors", () {changeScreen(1); }),
            menuItem(_screen == 2 ? Color(0xffeedcec) : Colors.white, Icons.library_books, "Genres", () { changeScreen(2);}),
            menuItem(_screen == 3 ? Color(0xffeedcec) : Colors.white, Icons.book_online_rounded, "Library", () {changeScreen(3); }),
            menuItem(_screen == 4 ? Color(0xffeedcec) : Colors.white, Icons.person_outline_rounded, "Me", () { changeScreen(4);}),
          ],
        ),
      ),
    );
  }

  Widget mainContainer(){
    return Container(
      width: Get.width,
      height: Get.height,
      child: Column(
        children: [
          mainTopBar(),

          Expanded(
              child: _screens[_screen]
          ),

          mainBottomBar()


        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: mainContainer(),
        )
    );
  }
}
