import 'package:dakowabook/models/advertpackages.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/me/promotesuccessscreen.dart';
import 'package:dakowabook/screens/me/publishedbooksscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class PromoteScreen extends StatefulWidget {
  final Literature literature;

  PromoteScreen(this.literature);
  @override

  _PromoteScreenState createState() => _PromoteScreenState();
}

class _PromoteScreenState extends State<PromoteScreen> {
  AdvertPackage? _advertPackage;
  var currencyFormat = new NumberFormat.currency(locale: "en_US", symbol: "\u{020A6} ");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        Provider.of<LiteratureProvider>(context, listen: false).allAdvertPackages()
    );

  }

  Widget saveBtn (){
    return SizedBox(
        width: Get.width,
        height: Get.height *0.06,
        child: Consumer<LiteratureProvider>(
          builder: (context, aProvider, _){
            return ElevatedButton(
              onPressed: () async{
                //print(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
                if(_advertPackage == null){
                  LoadingControl.showSnackBar("Ouchs!!!", "Package is required. Select valid package", Icon(Icons.error, color: Colors.white,));
                  return;
                }



                if(Provider.of<AuthProvider>(context, listen: false).profile!.wallet == null){
                  LoadingControl.showSnackBar("Ouchs!!!", "Error retrieving wallet data. Try again", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(_advertPackage!.price! > Provider.of<AuthProvider>(context, listen: false).profile!.wallet!.balance!){
                  LoadingControl.showSnackBar("Ouchs!!!", "Your Wallet balance cannot fund this promotion. Fund your wallet to continue", Icon(Icons.error, color: Colors.white,));
                  return;
                }






                //aProvider.setLoading(true);
                final result = await aProvider.createPromotion(
                    Provider.of<AuthProvider>(context, listen: false).profile!.wallet!.sId!,
                  _advertPackage!.id!,
                    Provider.of<AuthProvider>(context, listen: false).profile!.id!,
                    widget.literature.id!

                );

                if(result){
                  print(result);
                  //aProvider.retrieveProfile().then((value) => aProvider.getUserProfile(aProvider.profile!.id!));
                  aProvider.allMyLiteratures(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
                  Provider.of<AuthProvider>(context, listen: false).getUserProfile(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
                  Get.offAll(() => SuccessPromoteScreen());
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff831608)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ))
              ),
              child: aProvider.newBookLoading
                  ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                  : Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Use Wallet - Balance: ${currencyFormat.format(Provider.of<AuthProvider>(context, listen: true).profile!.wallet != null ? Provider.of<AuthProvider>(context, listen: true).profile!.wallet!.balance! : 0.0)}",
                      style: TextStyle(fontFamily: 'JakartaMedium', fontSize: 14, color: Colors.white),),
                  ),

                  Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_rounded, color: Colors.white,)
                  ),

                ],
              ),
            );
          },
        )

    );
  }

  Widget selectpackage() {
    return SizedBox(
      width: Get.width,
      //height: Get.height * 0.1,
      child: DropdownButton<AdvertPackage>(
        dropdownColor: Colors.white,
        hint: Text("Select Package",
          style: TextStyle(color: mainTextColor, fontSize: 14, fontFamily: 'SofiaProRegular', height: 2.5),
        ),
        value: _advertPackage,
        menuMaxHeight: Get.height * 0.7,
        icon: Icon(
          Icons.arrow_drop_down, color: mainColor, size: 24,),
        elevation: 10,
        style: TextStyle(fontSize: 12, color: Colors.white),
        underline: Container(
          height: 2,
          color: mainColor,
        ),
        onChanged: (value) {
          setState(() {
            _advertPackage = value!;
          });
        },
        isExpanded: true,
        items: Provider.of<LiteratureProvider>(context, listen: true).advertPackages.map((value) {
          return DropdownMenuItem<AdvertPackage>(
            value: value,
            child: Text("${value.name} - ${currencyFormat.format(value.price)},",
                style: TextStyle(color: mainTextColor, fontSize: 14)
            ),
          );
        }).toList(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Promote Literature", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: selectpackage(),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: saveBtn(),
              ),
            ],
          ),
        )
    );
  }
}
