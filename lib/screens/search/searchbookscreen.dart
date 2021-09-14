import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/book/bookdetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class SearchBookScreen extends StatefulWidget {
  @override
  _SearchBookScreenState createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  TextEditingController searchController = TextEditingController();

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


  Widget searchField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: searchController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 1.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.emailAddress,
    textInputAction: Platform.isIOS ? TextInputAction.continueAction : TextInputAction.next,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 5 ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 2 ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        suffixIcon: Icon(Icons.search_rounded, color: mainColor, size: 20,),
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        labelText: "Search here",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)
    ),
    onChanged: (value){
      if(value.isNotEmpty){
        if(value.length > 2){
          Provider.of<LiteratureProvider>(context, listen: false).searchForBooks(value);
        }
      }
    },


  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search for Literature", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: searchField(),
            ),

            Provider.of<LiteratureProvider>(context, listen: true).searchLoading
            ? Center(child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white,),)
            : Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Provider.of<LiteratureProvider>(context, listen: true).searchLits.isEmpty
                ? Center(child: Text("No data found"),)
                : ListView.builder(
                    itemCount: Provider.of<LiteratureProvider>(context, listen: true).searchLits.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i){
                      var literature = Provider.of<LiteratureProvider>(context, listen: true).searchLits[i];
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

            ),
          ],
        ),
      ),
    );
  }
}
