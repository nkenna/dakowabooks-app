import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/book/buybookscreen.dart';
import 'package:dakowabook/screens/common/addliteraturereviewscreen.dart';
import 'package:dakowabook/screens/reviews/bookreviewsscreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class BookDetailScreen extends StatefulWidget {
  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  var currencyFormat = new NumberFormat.currency(locale: "en_US", symbol: "\u{020A6} ");

  @override
  void initState() {
    super.initState();
    Provider.of<LiteratureProvider>(context, listen: false).viewLiteratureRequest(
        Provider.of<AuthProvider>(context, listen: false).profile!.id!,
        Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.id!
    );

  }

  @override
  Widget build(BuildContext context) {
    var literature = Provider.of<LiteratureProvider>(context, listen: true).selectedLiterature;

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
                              imageUrl: "${literature!.coverPic}",
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
                                Text("${literature.saleCount} Sold", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                Text(" | "),
                                Text("${literature.ratingCount} Reviews", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                Text(" | "),
                                Text("${literature.category!.name}".capitalize!, style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: mainColor),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text("${currencyFormat.format(literature.amount)}", style: TextStyle(color: mainColor, fontFamily: 'SofiaProSemiBold', fontSize: 16),),
                                    )),
                                SizedBox(width: 10,),
                                InkWell(
                                  onTap: (){
                                    Get.to(() => BookReviewsScreen());

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
                  child: SizedBox(
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
                        child: Text("Add to Library", style: TextStyle(fontSize: 16, ),)
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
