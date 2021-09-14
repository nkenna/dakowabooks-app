import 'dart:io';

import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/utils/data.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class FundWalletScreen extends StatefulWidget {
  @override
  _FundWalletScreenState createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {

  TextEditingController amountController = TextEditingController(text: "1000.0");
  final plugin = PaystackPlugin();


  @override
  void initState() {
    plugin.initialize(publicKey: FLW_PUB_KEY);
    super.initState();

  }



  Widget amountField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: amountController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
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
        //suffixIcon: _validEmail ? Icon(Icons.check, color: Color(0xff02bc4d), size: 16,) : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        labelText: "Amount (NGN)",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)
    ),


  );


  Widget saveBtn (){
    return SizedBox(
        width: Get.width,
        height: Get.height *0.06,
        child: Consumer<AuthProvider>(
          builder: (context, aProvider, _){
            return ElevatedButton(
              onPressed: () async{
                //print(Provider.of<AuthProvider>(context, listen: false).profile!.id!);


                if(double.tryParse(amountController.text) == null
                    && double.tryParse(amountController.text) == 0.0){
                  LoadingControl.showSnackBar("Ouchs!!!", "Valid amount is required.", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                try {
                  Charge charge = Charge()
                    ..amount = (double.tryParse(amountController.text)! * 100).toInt()
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
                    );
                    Provider.of<AuthProvider>(context, listen: false).getUserProfile(
                        Provider.of<AuthProvider>(context, listen: false).profile!.id!
                    );
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
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff831608)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ))
              ),
              child: aProvider.fundLoading
                  ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                  : Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Fund", style: TextStyle(fontFamily: 'JakartaMedium', fontSize: 14, color: Colors.white),),
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

  Widget mainContainer(){
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),


            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: amountField(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: saveBtn(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Fund Wallet"),
        ),
        body: mainContainer()
      ),
    );
  }
}
