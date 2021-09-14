import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/book/bookdetailscreen.dart';
import 'package:dakowabook/screens/landing/landingscreen.dart';
import 'package:dakowabook/screens/me/changepdfscreen.dart';
import 'package:dakowabook/screens/me/createliteraturescreen.dart';
import 'package:dakowabook/screens/me/editliteraturescreen.dart';
import 'package:dakowabook/screens/me/promotescreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../projectcolors.dart';

class PublishedBooksScreen extends StatefulWidget {
  @override
  _PublishedBooksScreenState createState() => _PublishedBooksScreenState();
}

class _PublishedBooksScreenState extends State<PublishedBooksScreen> {

  Widget bookContainer(Literature literature){
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
            imageBuilder: (context, imageProvider) => InkWell(
              onTap: () async{
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image
                );

                if(result != null) {
                  PlatformFile file = result.files.first;

                  print(file.name);
                  print(file.size);
                  print(file.extension);
                  print(file.path);
                  if(file.size > 1000000){
                    LoadingControl.showSnackBar(
                        "Success",
                        "Image size must be less than 1000kb or 1MB",
                        Icon(Icons.check_box_rounded, color: Colors.green,)
                    );
                    return;
                  }

                  if(file == null){
                    LoadingControl.showSnackBar(
                        "Success",
                        "Please select valid file to continue",
                        Icon(Icons.check_box_rounded, color: Colors.green,)
                    );
                    return;
                  }

                  var resp = await Provider.of<LiteratureProvider>(context, listen: false).uploadLiteratureCoverRequest(literature.id!, File(file.path));
                  if(resp){
                    Provider.of<LiteratureProvider>(context, listen: false).allMyLiteratures(
                        Provider.of<AuthProvider>(context, listen: false).profile!.id!
                    );
                  }
                } else {
                  // User canceled the picker
                  LoadingControl.showSnackBar(
                      "Success",
                      "you cancelled this operation",
                      Icon(Icons.check_box_rounded, color: Colors.green,)
                  );
                }
              },
              child: Container(
                width: Get.width * 0.2,
                height: 150,
                decoration: BoxDecoration(
                    color: Color(0xfff7f0f8),
                    borderRadius: BorderRadius.all(Radius.circular(20.0),),
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.screen)
                    )
                ),
                child: Icon(Icons.camera_alt, size: 42, color: mainColor,),
              ),
            ),
            //placeholder: (context, url) => CircularProgressIndicator(),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) =>
                InkWell(
                  onTap: ()async{
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image
                    );

                    if(result != null) {
                      PlatformFile file = result.files.first;

                      print(file.name);
                      print(file.size);
                      print(file.extension);
                      print(file.path);
                      if(file.size > 1000000){
                        LoadingControl.showSnackBar(
                            "Success",
                            "Image size must be less than 1000kb or 1MB",
                            Icon(Icons.check_box_rounded, color: Colors.green,)
                        );
                        return;
                      }

                      if(file == null){
                        LoadingControl.showSnackBar(
                            "Success",
                            "Please select valid file to continue",
                            Icon(Icons.check_box_rounded, color: Colors.green,)
                        );
                        return;
                      }

                      var resp = await Provider.of<LiteratureProvider>(context, listen: false).uploadLiteratureCoverRequest(literature.id!, File(file.path));
                      if(resp){
                        Provider.of<LiteratureProvider>(context, listen: false).allMyLiteratures(
                            Provider.of<AuthProvider>(context, listen: false).profile!.id!
                        );
                      }
                    } else {
                      // User canceled the picker
                      LoadingControl.showSnackBar(
                          "Success",
                          "you cancelled this operation",
                          Icon(Icons.check_box_rounded, color: Colors.green,)
                      );
                    }
                  },
                  child: Container(
                    width: Get.width * 0.2,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0),),
                        image: DecorationImage(
                            image: AssetImage("assets/images/logored.png"),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.screen)
                        )
                    ),
                    child: Icon(Icons.camera_alt, size: 42, color: mainColor,),
                  ),
                ),
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${literature.title}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 16, color: mainTextColor, ),),
              Text("by " + "${literature.author}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
              Text("${literature.category!.name}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
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
              ),

              Row(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        Get.to(() => EditLiteratureScreen(literature));
                      },
                      child: Text("Edit"),
                  ),

                  SizedBox(width: 10,),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xffe6d0cd))
                    ),
                    onPressed: (){
                      Get.to(() => ChangePdfScreen(literature));
                    },
                    child: Text("Change PDF File", style: TextStyle(color: mainColor),),
                  ),

                  SizedBox(width: 10,),

                  literature.promoted!
                  ? Container()
                  : ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xffe6d0cd))
                    ),
                    onPressed: (){
                      Get.to(() => PromoteScreen(literature));
                    },
                    child: Text("Promote", style: TextStyle(color: mainColor),),
                  ),
                ],
              ),
            ],
          ),


        ],

      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
                onTap: () => Get.offAll(() => LandingScreen(screen: 4,)),
                child: Icon(Icons.arrow_back, color: Colors.white,)),
            title: Text("My Books", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: (){
                    Get.to(() => CreateLiteratureScreen());
                  },
                  child: Provider.of<LiteratureProvider>(context, listen: true).newBookLoading
                  ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                  : Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 30,),
                ),
              )
            ],
          ),
          body: ListView.builder(
              itemCount: Provider.of<LiteratureProvider>(context, listen: true).myLiteratures.length,
              shrinkWrap: true,
              itemBuilder: (context, i){
                var literature = Provider.of<LiteratureProvider>(context, listen: true).myLiteratures[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: bookContainer(literature)
                );
              }
          ),
        )
    );

  }
}
