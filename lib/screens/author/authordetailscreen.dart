import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/author/authorbooksscreen.dart';
import 'package:dakowabook/screens/book/bookdetailscreen.dart';
import 'package:dakowabook/screens/common/addauthorreviewmodal.dart';
import 'package:dakowabook/screens/reviews/authorreviewsscreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class AuthorDetailScreen extends StatefulWidget {
  @override
  _AuthorDetailScreenState createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        Provider.of<LiteratureProvider>(context, listen: false).allLiteraturesByAuthor(
            Provider.of<LiteratureProvider>(context, listen: false).selectedAuthor!.id!
        )
    );

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
              Text("by ${literature.author}".capitalize!, maxLines: 2, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 16, color: mainTextColor, ),),
              Row(

                children: [
                  RatingBarIndicator(
                    rating: 3.2,
                    itemBuilder: (context, index) => Icon(Icons.star,
                      color: mainColor,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    unratedColor: mainColor.withAlpha(50),
                    direction: Axis.horizontal,
                  ),
                  SizedBox(width: 5,),
                  Text("3.2", style: TextStyle(color: mainTextColor, fontFamily: 'PoppinsSemiBold', fontSize: 12),)
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
    var author = Provider.of<LiteratureProvider>(context, listen: true).selectedAuthor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: Get.width,
                  height: Get.height * 0.35,
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
                              imageUrl: AuthHttpService.baseUrl + "${author!.avatar}",
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: Get.width * 0.17,
                                backgroundImage: imageProvider,
                              ),
                              //placeholder: (context, url) => CircularProgressIndicator(),
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    radius: Get.width * 0.17,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage("assets/images/logored.png"),
                                  ),

                            ),

                            SizedBox(height: 10,),

                            Text("${author.firstname} ${author.lastname}".capitalize!,
                              style: TextStyle(fontSize: 18, fontFamily: 'SofiaProSemiBold', height: 1.5),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${author.literatures!.length} Books", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                Text(" | "),
                                //Text("51 Sales", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                //Text(" | "),
                                Text("${author.ratingCount} Reviews", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RatingBarIndicator(
                                  rating: author.avgRating == null ? 0.0 : author.avgRating!,
                                  itemBuilder: (context, index) => Icon(Icons.star,
                                    color: mainColor,
                                  ),
                                  itemCount: 5,
                                  itemSize: 30.0,
                                  unratedColor: mainColor.withAlpha(50),
                                  direction: Axis.horizontal,
                                ),
                                SizedBox(width: 10,),
                                Text("${author.avgRating != null ? author.avgRating!.toStringAsFixed(1) : author.avgRating}", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),)
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Get.dialog(AddAuthReviewModal());

                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: mainColor),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("Add a Review", style: TextStyle(color: mainColor, fontFamily: 'SofiaProSemiBold', fontSize: 16),),
                                      ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                InkWell(
                                  onTap: (){
                                    Get.to(() => AuthorReviewsScreen());

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: mainColor),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Text("All Reviews", style: TextStyle(color: mainColor, fontFamily: 'SofiaProSemiBold', fontSize: 16),),
                                          Icon(Icons.arrow_forward_ios_rounded, color: mainColor, size: 16,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Author's Featured Book", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),

                    ],
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Consumer<LiteratureProvider>(
                    builder: (context, lProvider, _){
                      if(lProvider.authorLoading){
                        return CircularProgressIndicator.adaptive(backgroundColor: Colors.white,);
                      }
                      else if(lProvider.authorLiteratures.isEmpty){
                        return Center(
                          child: Text("No data here"),
                        );
                      } else if(lProvider.authorLiteratures.first == null){
                        return Center(
                          child: Text("No data here"),
                        );
                      }

                      return InkWell(
                          onTap: (){
                            Provider.of<LiteratureProvider>(context, listen: false).setSelectedLiterature(lProvider.authorLiteratures.first);
                            Get.to(() => BookDetailScreen());
                          },
                          child: bookContainer(lProvider.authorLiteratures.first)
                      );

                    },

                  ),
                ),

                SizedBox(height: 10,),

                Provider.of<LiteratureProvider>(context, listen: true).authorLiteratures.isEmpty
                ? Container()
                : InkWell(
                  onTap: (){
                    Get.to(() => AuthorBooksScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: mainColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("See All", style: TextStyle(color: mainColor, fontFamily: 'SofiaProSemiBold', fontSize: 16),),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      )
    );
  }


}
