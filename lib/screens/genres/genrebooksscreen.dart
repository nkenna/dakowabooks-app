import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/category.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/book/bookdetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class GenreBooksScreen extends StatefulWidget {
  final Category? category;

  const GenreBooksScreen({Key? key, this.category}) : super(key: key);

  @override
  _GenreBooksScreenState createState() => _GenreBooksScreenState();
}

class _GenreBooksScreenState extends State<GenreBooksScreen> {

  final ScrollController scrollController = ScrollController();
  StreamController<List<Literature>?> _streamController = StreamController<List<Literature>?>();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    print(widget.category!.name);
    scrollController.addListener(() async{
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent){
        currentPage = currentPage + 1;
        print("I am at the bottom");
        print("total all literature page: ${ Provider.of<LiteratureProvider>(context, listen: false).categoryLiteratureTotalPages}");
        print("current page: ${ currentPage}");
        if(currentPage <= Provider.of<LiteratureProvider>(context, listen: false).categoryLiteratureTotalPages){
          final dd = await Provider.of<LiteratureProvider>(context, listen: false).allLiteraturesByCategory(currentPage, widget.category!.id!);
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
    final dd = await Provider.of<LiteratureProvider>(context, listen: false).allLiteraturesByCategory(currentPage, widget.category!.id!);
    print("lengrh::::::::::::::${dd!.length}");
    _streamController.add(dd);
   
  }



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
              Text("${literature.title}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 16, color: mainTextColor, ),),
              Text("by ${literature.author}", maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
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
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("${widget.category!.name}".capitalize!, style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
          ),
          body: StreamBuilder<List<Literature>?>(
            stream: _streamController.stream,
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Center(child: Text("Error occurred retrieving data..."),);
              }else if (snapshot.connectionState == ConnectionState.waiting){
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
                  controller: scrollController,
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: InkWell(
                            onTap: (){
                              Provider.of<LiteratureProvider>(context, listen: false).setSelectedLiterature(snapshot.data![i]);
                              Get.to(() => BookDetailScreen());
                            },
                            child: bookContainer(snapshot.data![i])),
                      );
                    }
                );
              }
              else{
                print("snapshot length: ${snapshot.data!.length}");
                return Center(child: Text("No data found..."),);
              }

            },

          ),
        )
    );

  }
}
