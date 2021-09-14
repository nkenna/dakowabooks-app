import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/book/bookdetailscreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class AuthorBooksScreen extends StatefulWidget {
  @override
  _AuthorBooksScreenState createState() => _AuthorBooksScreenState();
}

class _AuthorBooksScreenState extends State<AuthorBooksScreen> {

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
              Text("${literature.title}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 16, color: mainTextColor, ),),
              Text("by " + "${literature.author}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
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
          title: Text("${Provider.of<LiteratureProvider>(context, listen: false).selectedAuthor!.firstname} ${Provider.of<LiteratureProvider>(context, listen: false).selectedAuthor!.lastname}'s Books", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
        ),
        body: ListView.builder(
            itemCount: Provider.of<LiteratureProvider>(context, listen: true).authorLiteratures.length,
            shrinkWrap: true,
            itemBuilder: (context, i){
              var literature = Provider.of<LiteratureProvider>(context, listen: true).authorLiteratures[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: InkWell(
                    onTap: (){
                      Provider.of<LiteratureProvider>(context, listen: false).setSelectedLiterature(literature);
                      Get.to(() => BookDetailScreen());
                    },
                    child: bookContainer(literature)),
              );
            }
        ),
      )
    );

  }
}
