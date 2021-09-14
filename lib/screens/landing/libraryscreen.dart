import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/library.dart';
//import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/library/readbookscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';
import 'package:permission_handler/permission_handler.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        initData()
    );
  }

  initData() async {
    Provider.of<LiteratureProvider>(context, listen: false).myLibraryRequest(
        Provider.of<AuthProvider>(context, listen: false).profile!.id!
    );
    getPermissionData();


  }

  getPermissionData() async{
    //MediaBarDatabase appDB = Provider.of<MediaBarDatabase>(context, listen: false);
    print("PERMISSION DATA :::::");
    print(await Permission.storage.status.isGranted);
    if(await Permission.storage.status.isLimited == PermissionStatus.limited.isLimited){
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      if(await Permission.storage.status.isGranted == PermissionStatus.granted.isGranted){
        createFolder();
      }
    }else if(await Permission.storage.status.isDenied == PermissionStatus.denied.isDenied){
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      if(await Permission.storage.status.isGranted == PermissionStatus.granted.isGranted){
        createFolder();
      }
    }else if(await Permission.storage.status.isPermanentlyDenied == PermissionStatus.permanentlyDenied.isPermanentlyDenied){
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();

      if(await Permission.storage.status.isGranted == PermissionStatus.granted.isGranted){
        createFolder();
      }
    }else if(await Permission.storage.status.isGranted == PermissionStatus.granted.isGranted){
      createFolder();
    }
  }


  void createFolder() async {
    // check if book directory exists
    var dir = await getApplicationDocumentsDirectory();
    print(dir.path);
    var bookDir = "dakowabooks";
    Directory('${dir.path}/${bookDir}').exists()
        .then((value) {
          print(value);
      if(value == false){
        Directory('${dir.path}/${bookDir}').create(recursive: true)
            .then((value) => print(value.path));
      }
    });
  }


  Widget bookContainer(Literatures literature){
    return Container(
      width: Get.width,
      height: 150,
      decoration: BoxDecoration(
        //color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(20.0),),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: "${literature.coverPic}",
            imageBuilder: (context, imageProvider) => Container(
              width: Get.width * 0.2,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xfff7f0f8),
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
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
                  width: Get.width * 0.2,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0),),
                      image: DecorationImage(
                          image: AssetImage("assets/images/logored.png"),
                          fit: BoxFit.fill
                      )
                  ),
                ),
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${literature.title}", maxLines: 2, style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 16, color: mainTextColor, ),),
              Text("${literature.author}", maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
              Row(

                children: [
                  RatingBarIndicator(
                    rating: literature.avgRating!,
                    itemBuilder: (context, index) => Icon(Icons.star,
                      color: mainColor,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    unratedColor: mainColor.withAlpha(50),
                    direction: Axis.horizontal,
                  ),
                  SizedBox(width: 5,),
                  Text("${literature.avgRating}", style: TextStyle(color: mainTextColor, fontFamily: 'PoppinsSemiBold', fontSize: 12),)
                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${literature.views!.length} views"),
                  Text(" | "),
                  Text("${literature.saleCount} Sales"),
                  Text(" | "),
                  Text("${literature.ratingCount} Reviews"),
                ],
              )
            ],
          )
        ],

      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Provider.of<LiteratureProvider>(context, listen: true).libraryLoading
      ? Center(
        child: Container(
          width: 50,
          height: 50,
          //constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
          //color: Colors.red,
          child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)),
      )
      :  Provider.of<LiteratureProvider>(context, listen: true).myLibrary == null
      ? Center(
          child: Text("You don't have any literature in your library yet."),
        )
        : ListView.builder(
        itemCount: Provider.of<LiteratureProvider>(context, listen: true).myLibrary!.literatures!.length,
        shrinkWrap: true,
        itemBuilder: (context, i){
          var literature = Provider.of<LiteratureProvider>(context, listen: true).myLibrary!.literatures![i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: InkWell(
                onTap: (){
                  Provider.of<LiteratureProvider>(context, listen: false).setSelectedLibraryLiterature(literature);
                  Get.to(() => ReadBookScreen());
                },
                child: bookContainer(literature)),
          );
        }
    );

  }
}
