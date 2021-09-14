import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/book/buybookscreen.dart';
import 'package:dakowabook/screens/common/addliteraturereviewscreen.dart';
import 'package:dakowabook/screens/library/openbookscreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class ReadBookScreen extends StatefulWidget {
  @override
  _ReadBookScreenState createState() => _ReadBookScreenState();
}

class _ReadBookScreenState extends State<ReadBookScreen> {
  var currencyFormat = new NumberFormat.currency(locale: "en_US", symbol: "\u{020A6} ");
  int? totalPages = 0;
  int? currentPage = 0;
  bool? _fileExist = false;

  bool downloading = false;
  var progressString = "";


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        checkForFile()
    );

  }

  checkForFile() async{
    var literature = Provider.of<LiteratureProvider>(context, listen: false).selectedLibraryLiterature;
    print(literature!.bookFile);
    if(literature != null){
      // get book file name
      var dir = await getApplicationDocumentsDirectory();
      var bookDir = "dakowabooks";
      File('${dir.path}/${bookDir}/${literature.id}.pdf').exists()
      .then((exists) {
        print(exists);
        if(exists == false){
          _fileExist = false;
          setState(() {});
        }else{
          _fileExist = true;
          setState(() {});
        }
      });

      //Directory('${dir.path}/${bookDir}')
    }
  }

  Future<void> downloadFile() async {
    downloading = true;

    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path: ${dir.path}/dakowabooks/${Provider.of<LiteratureProvider>(context, listen: false).selectedLibraryLiterature!.id}.pdf");
      await dio.download(
          Provider.of<LiteratureProvider>(context, listen: false).selectedLibraryLiterature!.bookFile!,
          "${dir.path}/dakowabooks/${Provider.of<LiteratureProvider>(context, listen: false).selectedLibraryLiterature!.id}.pdf",
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total");

            setState(() {
              //downloading = true;
              progressString = "${rec/1000}kb";

            });
          });
    } catch (e) {
      downloading = false;
      setState(() {});
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    var literature = Provider.of<LiteratureProvider>(context, listen: true).selectedLibraryLiterature;
    print(literature!.id);
    print(literature.bookFile);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.height * 0.5,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/read.jpg"),
                                  colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.85), BlendMode.screen),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              CachedNetworkImage(
                                imageUrl: "${literature.coverPic}",
                                imageBuilder: (context, imageProvider) => Container(
                                  width: Get.width * 0.32,
                                  height: Get.height * 0.25,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill
                                      )
                                  ),
                                ),


                                //placeholder: (context, url) => CircularProgressIndicator(),
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Container(
                                      width: 100,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/logored.png"),
                                              fit: BoxFit.fill
                                          )
                                      ),
                                    ),
                              ),

                              SizedBox(height: 15,),

                              Text("${literature.title}".capitalize!, style: TextStyle(color: mainTextColor, fontFamily: 'MonumentRegular', fontSize: 14, height: 2),),

                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RatingBarIndicator(
                                      rating: literature.avgRating!,
                                      itemBuilder: (context, index) => Icon(Icons.star,
                                        color: mainColor,
                                      ),
                                      itemCount: 5,
                                      itemSize: 30.0,
                                      unratedColor: mainColor.withAlpha(50),
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(width: 10,),
                                    Text("${literature.avgRating}", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),)
                                  ],
                                ),
                              ),

                              SizedBox(height: 15,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${literature.views!.length} Views", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                  Text(" | "),
                                  Text("${literature.ratingCount} Reviews", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                  Text(" | "),
                                 Text("${literature.category!.name}".capitalize!, style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                ],
                              ),


                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Synopsis", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),

                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: Text("${literature.synopsis}".capitalizeFirst!, textAlign: TextAlign.left, style: TextStyle(fontSize: 16, height: 1.5, fontFamily: 'SofiaProRegular'),)),
                      ],
                    ),

                  ),

                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: Get.width,
                            height: 60,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0xffe6d0cd)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  )),
                                ),
                                onPressed: (){
                                  Get.dialog(AddLiteratureReviewScreen());
                                },
                                child: Text("Rate", style: TextStyle(fontSize: 16, color: mainColor),)
                            ),
                          ),
                          SizedBox(height: 10,),

                          literature.isFile!
                          ? Container()
                          : SizedBox(
                            width: Get.width,
                            height: 60,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  )),
                                ),
                                onPressed: (){
                                  Get.to(() => BuyBookScreen());
                                },
                                child: Text("Read", style: TextStyle(fontSize: 16, ),)
                            ),
                          ),

                          SizedBox(height: 10,),

                          _fileExist!
                          ? Container()
                          : SizedBox(
                            width: Get.width,
                            height: 60,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  )),
                                ),
                                onPressed: (){
                                  downloadFile()
                                      .then((value) => {
                                    checkForFile()
                                  });
                                  //Get.to(() => BuyBookScreen());
                                },
                                child: downloading
                                ? Text("${progressString}" , style: TextStyle(fontSize: 16, ),)
                               : Text("Save to Device" , style: TextStyle(fontSize: 16, ),)
                            ),
                          ),

                          SizedBox(height: 10,),

                          literature.isFile! && _fileExist!
                          ? SizedBox(
                            width: Get.width,
                            height: 60,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  )),
                                ),
                                onPressed: () async{
                                  var dd = await getApplicationDocumentsDirectory();
                                  var pp = dd.path + "/dakowabooks/${Provider.of<LiteratureProvider>(context, listen: false).selectedLibraryLiterature!.id}.pdf";
                                  Get.to(() => OpenBookScreen(
                                    bookPath: pp,
                                  ),
                                  );
                                },
                                child: Text("Read", style: TextStyle(fontSize: 16, ),)
                            ),
                          )
                              : Container()
                        ],
                      )

                  ),


                ],
              ),
            ),
          ),
        )
    );
  }
}
