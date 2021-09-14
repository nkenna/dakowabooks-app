import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/review.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class BookReviewsScreen extends StatefulWidget {
  @override
  _BookReviewsScreenState createState() => _BookReviewsScreenState();
}

class _BookReviewsScreenState extends State<BookReviewsScreen> {
  final ScrollController scrollController = ScrollController();
  StreamController<List<Review>?> _streamController = StreamController<List<Review>?>();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() async{
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent){
        currentPage = currentPage + 1;
        print("I am at the bottom");
        print("total all literature page: ${ Provider.of<LiteratureProvider>(context, listen: false).authorReviewTotalPages}");
        print("current page: ${ currentPage}");
        if(currentPage <= Provider.of<LiteratureProvider>(context, listen: false).authorReviewTotalPages){
          final dd = await Provider.of<LiteratureProvider>(context, listen: false).allBookReviews(
              currentPage,
              Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.id!
          );
         // print("lengrh::::::::::::::${dd!.length}");
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
    final dd = await Provider.of<LiteratureProvider>(context, listen: false).allBookReviews(
        currentPage,
        Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.id!
    );
    // print("lengrh::::::::::::::${dd!.length}");
    _streamController.add(dd);
  }

  Widget reviewContainer(Review review){
    return Container(
      width: Get.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: AuthHttpService.baseUrl + "${review.user!.avatar}",
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 20,
              backgroundImage: imageProvider,
              backgroundColor: Colors.white,
            ),
            //placeholder: (context, url) => CircularProgressIndicator(),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) =>
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/logored.png"),
                  backgroundColor: Colors.white,
                ),

          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${review.title}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 16, color: mainTextColor, ),),
              Text("${review.user!.firstname} ${review.user!.lastname}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
              Row(

                children: [
                  RatingBarIndicator(
                    rating: review.rating == null ? 0.0 : review.rating!,
                    itemBuilder: (context, index) => Icon(Icons.star,
                      color: mainColor,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    unratedColor: mainColor.withAlpha(50),
                    direction: Axis.horizontal,
                  ),
                  SizedBox(width: 10,),
                  Text("${review.rating  != null ? review.rating!.toStringAsFixed(1) : review.rating}", style: TextStyle(color: mainTextColor, fontFamily: 'PoppinsSemiBold', fontSize: 12),)
                ],
              ),
              SizedBox(height: 10,),
              Text("${review.content}".capitalizeFirst!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
            ],
          ),
        ],
      ),
    );
  }

  Widget mainContainer(){
    return Container(
        width: Get.width,
        height: Get.height,
        child: StreamBuilder<List<Review>?>(
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
                        child: reviewContainer(snapshot.data![i]),
                      );
                    }
                );
              }
              else{
                print("snapshot length: ${snapshot.data!.length}");
                return Center(child: Text("No data found..."),);
              }
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Ratings and Reviews",
              style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
          ),

          body: mainContainer(),
        )
    );
  }
}
