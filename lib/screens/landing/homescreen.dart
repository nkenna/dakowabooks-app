import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/models/profile.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/author/authordetailscreen.dart';
import 'package:dakowabook/screens/book/bookdetailscreen.dart';
import 'package:dakowabook/screens/landing/landingscreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget bookContainerMain(Literature literature){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: (){
          Provider.of<LiteratureProvider>(context, listen: false).setSelectedLiterature(literature);
          Get.to(() => BookDetailScreen());
        },
        child: SizedBox(
          width: 150,
          height: 150,
          child: Container(
            //color: Colors.red,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              //border: Border.symmetric(vertical: BorderSide.),
              boxShadow: [
                BoxShadow(
                  color: mainColor.withOpacity(0.3),
                  offset: const Offset(
                    0.0,
                    5.0,
                  ),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
               //BoxShadow
              ],
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        //color: Colors.brown,
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 80,

                          decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              image: DecorationImage(
                                  image: AssetImage("assets/images/book_back.png"),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: Text("${literature.title}".capitalize!, maxLines: 1, style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 14, color: mainTextColor, ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: Text("${literature.author}", maxLines: 1, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 12, color: mainTextColor, ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: Row(

                            children: [
                              RatingBarIndicator(
                                rating: literature.avgRating!,
                                itemBuilder: (context, index) => Icon(Icons.star,
                                  color: mainColor,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                unratedColor: mainColor.withAlpha(50),
                                direction: Axis.horizontal,
                              ),
                              SizedBox(width: 5,),
                              Text("${literature.avgRating}", style: TextStyle(color: mainTextColor, fontFamily: 'PoppinsSemiBold', fontSize: 12),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Align(
                  alignment: Alignment.topCenter,
                  child: CachedNetworkImage(
                    imageUrl: "${literature.coverPic}",
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          width: 80,
                          height: 100,
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


                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget featuredBooksListContainer(List<Literature> literatures){
    return SizedBox(
      width: Get.width,
      height: 220,
      child: Container(
        //color: Colors.red,
        child: ListView.builder(
          itemCount: literatures.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i){
              return bookContainerMain(literatures[i]);
            }
        ),
      ),
    );
  }

  Widget recentBooksListContainer(List<Literature> literatures){
    return SizedBox(
      width: Get.width,
      height: 220,
      child: Container(
        //color: Colors.red,
        child: ListView.builder(
            itemCount: literatures.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i){
              return bookContainerMain(literatures[i]);
            }
        ),
      ),
    );
  }

  Widget bestSellersListContainer(List<Literature> literatures){
    return SizedBox(
      width: Get.width,
      height: 220,
      child: Container(
        //color: Colors.red,
        child: ListView.builder(
            itemCount: literatures.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i){
              return bookContainerMain(literatures[i]);
            }
        ),
      ),
    );
  }

  Widget freeBooksListContainer(List<Literature> literatures){
    return SizedBox(
      width: Get.width,
      height: 220,
      child: Container(
        //color: Colors.red,
        child: ListView.builder(
            itemCount: literatures.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i){
              return bookContainerMain(literatures[i]);
            }
        ),
      ),
    );
  }

  Widget topRatedBooksListContainer(List<Literature> literatures){
    return SizedBox(
      width: Get.width,
      height: 220,
      child: Container(
        //color: Colors.red,
        child: ListView.builder(
            itemCount: literatures.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i){
              return bookContainerMain(literatures[i]);
            }
        ),
      ),
    );
  }

  Widget dakowaBooksListContainer(List<Literature> literatures){
    return SizedBox(
      width: Get.width,
      height: 220,
      child: Container(
        //color: Colors.red,
        child: ListView.builder(
            itemCount: literatures.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i){
              return bookContainerMain(literatures[i]);
            }
        ),
      ),
    );
  }

  Widget authorListContainer(List<Profile> authors){
    return SizedBox(
      width: Get.width,
      height: 300,
      child: Container(
        //color: Colors.red,
        child: ListView.builder(
            itemCount: authors.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i){
              var author = authors[i];
              return InkWell(
                onTap: (){
                  Provider.of<LiteratureProvider>(context, listen: false).setSelectedAuthor(author);
                  Get.to(() => AuthorDetailScreen());
                },
                child: Container(
                  width: 250,
                  height: 250,
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl:  AuthHttpService.baseUrl + "${author.avatar}",
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 40,
                        ),
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/images/logored.png"),
                              radius: 40,
                            ),

                      ),
                      SizedBox(height: 10,),
                      Text("${author.firstname} ${author.lastname}".capitalize!, maxLines: 1, style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 14, color: mainTextColor, ),),
                      Text("${author.literatures!.length} Books | ${author.ratingCount} reviews", maxLines: 1, style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 12, color: mainTextColor, ),),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBarIndicator(
                              rating: author.avgRating!,
                              itemBuilder: (context, index) => Icon(Icons.star,
                                color: mainColor,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                              unratedColor: mainColor.withAlpha(50),
                              direction: Axis.horizontal,
                            ),
                            SizedBox(width: 5,),
                            Text("${author.avgRating!.toStringAsFixed(1)}", style: TextStyle(color: mainTextColor, fontFamily: 'PoppinsSemiBold', fontSize: 12),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lProvider = Provider.of<LiteratureProvider>(context, listen: true);

    return lProvider.dashboardLoading
      ? Center(
      child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white,),
    )
     : Container(
      child: RefreshIndicator(
        onRefresh: ()async{
          Provider.of<AuthProvider>(context, listen: false).getUserProfile(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
          Provider.of<LiteratureProvider>(context, listen: false).allCategories();
          Provider.of<LiteratureProvider>(context, listen: false).dashboardData();
          return null;
        },
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                lProvider.dashboardPromotedBooks.isEmpty
                ? Container()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Promoted Books", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),
                      InkWell(
                          onTap: (){},
                          child: Text("See All", style: TextStyle(fontSize: 12, fontFamily: 'MonumentRegular'),)),
                    ],
                  ),
                ),

                lProvider.dashboardPromotedBooks.isEmpty
                ? Container()
                : featuredBooksListContainer(lProvider.dashboardPromotedBooks),
                SizedBox(height: 20,),

                lProvider.dashboardRecentBooks.isEmpty
                ? Container()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recent Books", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),
                      InkWell(
                          onTap: (){},
                          child: Text("See All", style: TextStyle(fontSize: 12, fontFamily: 'MonumentRegular'),)),
                    ],
                  ),
                ),
                lProvider.dashboardRecentBooks.isEmpty
                ? Container()
                : recentBooksListContainer(lProvider.dashboardRecentBooks),
                SizedBox(height: 20,),

                lProvider.dashboardBestSellerBooks.isEmpty
                ? Container()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Best Sellers", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),
                      InkWell(
                          onTap: (){},
                          child: Text("See All", style: TextStyle(fontSize: 12, fontFamily: 'MonumentRegular'),)),
                    ],
                  ),
                ),

                lProvider.dashboardBestSellerBooks.isEmpty
                ? Container()
                : bestSellersListContainer(lProvider.dashboardBestSellerBooks),
                SizedBox(height: 20,),

                lProvider.dashboardFreeBooks.isEmpty
                ? Container()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Free Books", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),
                      InkWell(
                          onTap: (){},
                          child: Text("See All", style: TextStyle(fontSize: 12, fontFamily: 'MonumentRegular'),)),
                    ],
                  ),
                ),

                lProvider.dashboardFreeBooks.isEmpty
                ? Container()
                : freeBooksListContainer(lProvider.dashboardFreeBooks),
                SizedBox(height: 20,),

                lProvider.dashBoardAuthors.isEmpty
                ? Container()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Featured Authors", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),
                      InkWell(
                          onTap: (){
                            print("pressed CCCCCCCCC");
                            Get.offAll(() => LandingScreen(screen: 1,));
                          },
                          child: Text("See All", style: TextStyle(fontSize: 12, fontFamily: 'MonumentRegular'),)),
                    ],
                  ),
                ),
                SizedBox(height: 20,),

                lProvider.dashBoardAuthors.isEmpty
                ? Container()
                : authorListContainer(lProvider.dashBoardAuthors),
                SizedBox(height: 20,),

                lProvider.dashboardTopRatedBooks.isEmpty
                ? Container()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Top Rated Books", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),
                      InkWell(
                          onTap: (){},
                          child: Text("See All", style: TextStyle(fontSize: 12, fontFamily: 'MonumentRegular'),)),
                    ],
                  ),
                ),

                lProvider.dashboardTopRatedBooks.isEmpty
                ? Container()
                : topRatedBooksListContainer(lProvider.dashboardTopRatedBooks),
                SizedBox(height: 20,),

                lProvider.dashBoardDakowaBooks.isEmpty
                ? Container()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Dakowa Books Original", style: TextStyle(fontSize: 14, fontFamily: 'MonumentRegular'),),
                      InkWell(
                          onTap: (){},
                          child: Text("See All", style: TextStyle(fontSize: 12, fontFamily: 'MonumentRegular'),)),
                    ],
                  ),
                ),

                lProvider.dashBoardDakowaBooks.isEmpty
                ? Container()
                : dakowaBooksListContainer(lProvider.dashBoardDakowaBooks),
                SizedBox(height: 20,),
              ],
            ),

        ),
      ),
    );
  }
}
