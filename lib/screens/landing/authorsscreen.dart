import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/profile.dart';
import 'package:dakowabook/projectcolors.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/author/authordetailscreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class AuthorsScreen extends StatefulWidget {
  @override
  _AuthorsScreenState createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  final ScrollController scrollController = ScrollController();
  StreamController<List<Profile>?> _streamController = StreamController<List<Profile>?>();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() async{
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent){
        currentPage = currentPage + 1;
        print("I am at the bottom");
        print("total all literature page: ${ Provider.of<LiteratureProvider>(context, listen: false).authorTotalPages}");
        print("current page: ${ currentPage}");
        if(currentPage <= Provider.of<LiteratureProvider>(context, listen: false).authorTotalPages){
          final dd = await Provider.of<LiteratureProvider>(context, listen: false).allAuthors(currentPage);
          print("lengrh::::::::::::::${dd!.length}");
          _streamController.add(dd);
        }

      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        initData()
    );

  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _streamController.close();
  }

  initData() async {
    final dd = await Provider.of<LiteratureProvider>(context, listen: false).allAuthors(currentPage);
   // print("lengrh::::::::::::::${dd!.length}");
    _streamController.add(dd);
  }

  Widget authorContainer(Profile author){
    return InkWell(
      onTap: (){
        Provider.of<LiteratureProvider>(context, listen: false).setSelectedAuthor(author);
        Get.to(() => AuthorDetailScreen());
      },
      child: Container(
        width: Get.width,
        height: 120,
        decoration: BoxDecoration(
          //color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20.0),),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: AuthHttpService.baseUrl + "${author.avatar}",
              imageBuilder: (context, imageProvider) => Container(
                width: Get.width * 0.2,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xfff7f0f8),
                    borderRadius: BorderRadius.all(Radius.circular(20.0),),
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain
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
                Text("${author.firstname} ${author.lastname}", maxLines: 2, style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 16, color: mainTextColor, ),),
                //Text("By Jude Inoga", maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
                Row(

                  children: [
                    RatingBarIndicator(
                      rating: author.avgRating == null ? 0.0 : author.avgRating!,
                      itemBuilder: (context, index) => Icon(Icons.star,
                        color: mainColor,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      unratedColor: mainColor.withAlpha(50),
                      direction: Axis.horizontal,
                    ),
                    SizedBox(width: 10,),
                    Text("${author.avgRating != null ? author.avgRating!.toStringAsFixed(1) : author.avgRating}", style: TextStyle(color: mainTextColor, fontFamily: 'PoppinsSemiBold', fontSize: 12),)
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("${author.literatures!.length} Books"),
                    Text(" | "),
                    //Text("51 Sales"),
                    //Text(" | "),
                    Text("${author.ratingCount} Reviews"),
                  ],
                )
              ],
            )
          ],

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Profile>?>(
      stream: _streamController.stream,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Center(child: Text("Error occurred retrieving data..."),);
        }
        else if (snapshot.connectionState == ConnectionState.waiting){
          //return SkeletonLoadingGrid(items: 10,);
          return Center(child: Text("Loading...."),);
        }
        else if(snapshot.data == null){
          return Center(child: Text("No Book found"),);
        }
        else if(snapshot.hasData == true){
          return snapshot.data!.length == 0
              ? Center(child: Text("This Genre does not have any books"),)
              : ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, i){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: authorContainer(snapshot.data![i]),
                );
              }
          );
        }
        else{
          print("snapshot length: ${snapshot.data!.length}");
          return Center(child: Text("No data found..."),);
        }
      }
    );


  }
}
