import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/book/successscreen.dart';
import 'package:dakowabook/screens/landing/landingscreen.dart';
import 'package:dakowabook/utils/data.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class BuyBookScreen extends StatefulWidget {
  @override
  _BuyBookScreenState createState() => _BuyBookScreenState();
}

class _BuyBookScreenState extends State<BuyBookScreen> {
  final plugin = PaystackPlugin();
  var currencyFormat = new NumberFormat.currency(locale: "en_US", symbol: "\u{020A6} ");


  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: FLW_PUB_KEY);
  }

  @override
  Widget build(BuildContext context) {
    var literature = Provider.of<LiteratureProvider>(context, listen: true).selectedLiterature;
    return SafeArea(

        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: "${literature!.coverPic}",
                      imageBuilder: (context, imageProvider) => Container(
                        width: Get.width * 0.15,
                        height: Get.height * 0.1,
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

                    SizedBox(width: 10,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${literature.title}", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProSemiBold', fontSize: 16,),),
                        Text("${literature.author}", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProRegular', fontSize: 14, ),),
                        Text(literature.isFree! ? "FREE" : "${currencyFormat.format(literature.amount)}", style: TextStyle(color: mainTextColor, fontFamily: 'SofiaProSemiBold', fontSize: 16,),),
                      ],
                    ),

                  ],
                ),
              ),

              literature.isFree!
              ? Container()
              :  Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox(
                  width: Get.width,
                  height: 60,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        )),
                      ),
                      onPressed: ()async {
                        final resp = await Provider.of<LiteratureProvider>(context, listen: false).buyBookWallet(
                            Provider.of<AuthProvider>(context, listen: false).profile!.id!,
                            Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.id!,
                            Provider.of<AuthProvider>(context, listen: false).profile!.wallet!.sId!,
                            Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.amount!
                        );

                        if(resp){
                          Provider.of<AuthProvider>(context, listen: false).getUserProfile(
                              Provider.of<AuthProvider>(context, listen: false).profile!.id!
                          );
                          Get.offAll(() => SuccessScreen());
                        }
                      },
                      child: Provider.of<LiteratureProvider>(context, listen: true).buyBookLoading2
                          ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                      : Text("Use Wallet - Balance: ${currencyFormat.format(Provider.of<AuthProvider>(context, listen: true).profile!.wallet!.balance!)}", style: TextStyle(fontSize: 16, fontFamily: 'SofiaProSemiBold'),),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox(
                  width: Get.width,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xffe6d0cd)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )),
                    ),
                    onPressed: () async{
                      try {
                        Charge charge = Charge()
                          ..amount = (1000 * 100).toInt()
                          ..reference = "dak-" + DateTime.now().millisecondsSinceEpoch.toString() + getRandomString(6)
                        // or ..accessCode = _getAccessCodeFrmInitialization()
                          ..email = '${Provider.of<AuthProvider>(context, listen: false).profile!.email}';

                        final response = await plugin.checkout(
                          context,
                          method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
                          charge: charge,
                        );
                        print(response.status);
                        if(response.status == true){
                          Provider.of<AuthProvider>(context, listen: false).fundWallet(
                              Provider.of<AuthProvider>(context, listen: false).profile!.id!,
                              response.reference!
                          ).then((value) {
                            if(value){
                              Provider.of<AuthProvider>(context, listen: false).getUserProfile(
                                  Provider.of<AuthProvider>(context, listen: false).profile!.id!
                              );
                            }
                          });
                        }
                        else{
                          LoadingControl.showSnackBar(
                              "Ouchs",
                              "${response.message}",
                              Icon(Icons.warning_rounded, color: Colors.orange,)
                          );
                        }
                      } catch(error) {
                        print(error);
                      }

                    },
                    child: Provider.of<AuthProvider>(context, listen: true).fundLoading
                    ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                    : Text("Fund Wallet with ${currencyFormat.format(1000)}", style: TextStyle( color: mainColor, fontSize: 16, fontFamily: 'SofiaProSemiBold'),),
                  ),
                ),
              ),

              literature.isFree!
              ? Container()
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox(
                  width: Get.width,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )),
                    ),
                    onPressed: () async{
                      try {
                        Charge charge = Charge()
                          ..amount = (literature.amount! * 100).toInt()
                          ..reference = "dak-" + DateTime.now().millisecondsSinceEpoch.toString() + getRandomString(6)
                        // or ..accessCode = _getAccessCodeFrmInitialization()
                          ..email = '${Provider.of<AuthProvider>(context, listen: false).profile!.email}';

                        final response = await plugin.checkout(
                          context,
                          method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
                          charge: charge,
                        );
                        print(response.status);
                        if(response.status == true){
                          Provider.of<LiteratureProvider>(context, listen: false).buyBookCard(
                              Provider.of<AuthProvider>(context, listen: false).profile!.id!,
                              Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.id!,
                              response.reference!
                          ).then((value) {
                            if(value){
                              Get.offAll(() => SuccessScreen());
                            }
                          });
                        }
                        else{
                          LoadingControl.showSnackBar(
                              "Ouchs",
                              "${response.message}",
                              Icon(Icons.warning_rounded, color: Colors.orange,)
                          );
                        }
                      } catch(error) {
                        print(error);
                      }

                    },
                    child: Provider.of<LiteratureProvider>(context, listen: true).buyBookLoading
                      ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                      : Text("Use Debit Card => ${currencyFormat.format(Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.amount)}", style: TextStyle(fontSize: 16, fontFamily: 'SofiaProSemiBold'),),
                  ),
                ),
              ),

              if(literature.isFree!) Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox(
                  width: Get.width,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )),
                    ),
                    onPressed: () async{
                      final resp = await Provider.of<LiteratureProvider>(context, listen: false).buyBookFree(
                          Provider.of<AuthProvider>(context, listen: false).profile!.id!,
                          Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.id!
                      );

                      if(resp){
                        Get.offAll(() => SuccessScreen());
                        //Get.offAll(() => LandingScreen(screen: 3,));
                      }
                    },
                    child: Provider.of<LiteratureProvider>(context, listen: true).buyBookLoading
                    ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                    : Text("Add to Library", style: TextStyle(fontSize: 16, fontFamily: 'SofiaProSemiBold'),),
                  ),
                ),
              ),



            ],
          ),
        ));
  }
}
