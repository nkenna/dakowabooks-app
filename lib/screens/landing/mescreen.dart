import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/me/bookordersscreen.dart';
import 'package:dakowabook/screens/me/changepasswordscreen.dart';
import 'package:dakowabook/screens/me/createliteraturescreen.dart';
import 'package:dakowabook/screens/me/fundwalletscreen.dart';
import 'package:dakowabook/screens/me/publishedbooksscreen.dart';
import 'package:dakowabook/screens/me/salesrecordscreen.dart';
import 'package:dakowabook/screens/me/updateprofilescreen.dart';
import 'package:dakowabook/screens/me/wallettransscreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:dakowabook/utils/data.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../projectcolors.dart';

class MeScreen extends StatefulWidget {
  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  var currencyFormat = new NumberFormat.currency(locale: "en_US", symbol: "\u{020A6} ");
  final plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: FLW_PUB_KEY);
    WidgetsBinding.instance!.addPostFrameCallback((_){
      print("doing a check");
      Provider.of<LiteratureProvider>(context, listen: false).allAdvertPackages();
      Provider.of<LiteratureProvider>(context, listen: false).allMyLiteratures(
          Provider.of<AuthProvider>(context, listen: false).profile!.id!
      );
    }

    );

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, aProvider, _){
        return Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: Get.width,
                  height: Get.height * 0.3,
                  child: Stack(
                    children: [
                      Container(color: Colors.white,),

                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            CachedNetworkImage(
                              imageUrl: AuthHttpService.baseUrl + "${aProvider.profile!.avatar}",
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
                                    backgroundImage: AssetImage("assets/images/logored.png"),
                                    backgroundColor: Colors.white,
                                  ),

                            ),

                            SizedBox(height: 15,),

                            SizedBox(height: 10,),

                            Text("${aProvider.profile!.firstname} ${aProvider.profile!.lastname}".capitalize!,
                              style: TextStyle(fontSize: 18, fontFamily: 'SofiaProSemiBold', height: 1.5),
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${aProvider.profile!.literatures!.length} Books", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                Text(" | "),
                                //Text("51 Sales", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
                                //Text(" | "),
                                Text("${aProvider.profile!.ratingCount} Reviews", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProMedium', fontSize: 16),),
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
                                      child: Text("${currencyFormat.format(aProvider.profile!.wallet != null ? aProvider.profile!.wallet!.balance : 0.0)}", style: TextStyle(color: mainColor, fontFamily: 'SofiaProSemiBold', fontSize: 16),),
                                    )),
                                SizedBox(width: 10,),
                                InkWell(
                                  onTap: () async{
                                    Get.to(() => FundWalletScreen());
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: mainColor),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("Fund Wallet", style: TextStyle(color: mainColor, fontFamily: 'SofiaProSemiBold', fontSize: 16),),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                ListTile(
                  onTap: (){
                    Get.to(() => PublishedBooksScreen());
                  },
                  leading: Icon(Icons.book_outlined, color: mainColor,),
                  title: Text("My Published Books (${Provider.of<LiteratureProvider>(context, listen: true).myLiteratures.length})", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ),

                ListTile(
                  onTap: (){
                    Get.to(() => CreateLiteratureScreen());
                  },
                  leading: Icon(Icons.publish_outlined, color: mainColor,),
                  title: Text("Become a Publisher", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ),

                ListTile(
                  onTap: (){
                    Get.to(() => ChangePasswordScreen());
                  },
                  leading: Icon(Icons.password_outlined, color: mainColor,),
                  title: Text("Change Password", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ),

                ListTile(
                  onTap: (){
                    Get.to(() => UpdateProfileScreen());
                  },
                  leading: Icon(Icons.update_rounded, color: mainColor,),
                  title: Text("Update Profile", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ),

                aProvider.dataLoading
                ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                : ListTile(
                  onTap: (){
                    if(aProvider.profile!.wallet!.balance == 0 || aProvider.profile!.wallet!.balance! < 0){
                      LoadingControl.showSnackBar("Ouchs!!!", "You cannot request for payout at this time. Wallet balance is empty", Icon(Icons.error, color: Colors.white,));
                      return;
                    }

                    aProvider.requestpayout(aProvider.profile!.id!, aProvider.profile!.wallet!.balance!);
                  },
                  leading: Icon(Icons.request_page_outlined, color: mainColor,),
                  title: Text("Request Payout", style: TextStyle(color: mainTextColor),),
                  subtitle: Text("Attracts 5% of the requested amount", style: TextStyle(color: Color(0xffaebac8)),),
                  horizontalTitleGap: 0,
                ),

                ListTile(
                  onTap: (){

                  },
                  leading: Icon(Icons.app_settings_alt_outlined, color: mainColor,),
                  title: Text("Check for Update", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ),

                ListTile(
                  onTap: (){
                    Get.to(() => WalletTransScreen());
                  },
                  leading: Icon(Icons.account_balance_wallet_outlined, color: mainColor,),
                  title: Text("Your Wallet Transaction records", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ),

              /*  ListTile(
                  onTap: (){},
                  leading: Icon(Icons.payments_outlined, color: mainColor,),
                  title: Text("Your Payout Records", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ), */

                ListTile(
                  onTap: (){
                    Get.to(() => SalesRecordScreen());
                  },
                  leading: Icon(Icons.book, color: mainColor,),
                  title: Text("Your Book Sales Records", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ),

                ListTile(
                  onTap: (){
                    Get.to(() => BookOrdersScreen());
                  },
                  leading: Icon(Icons.shopping_cart, color: mainColor,),
                  title: Text("Your Book Order Records", style: TextStyle(color: mainTextColor),),
                  horizontalTitleGap: 0,
                ),
              ],
            ),
          ),
        );
      },

    );
  }


}
