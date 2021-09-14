import 'dart:io';

import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';


class AddLiteratureReviewScreen extends StatefulWidget {
  @override
  _AddLiteratureReviewScreenState createState() => _AddLiteratureReviewScreenState();
}

class _AddLiteratureReviewScreenState extends State<AddLiteratureReviewScreen> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();
  double _rating = 0.0;

  Widget titleField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: titleController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.text,
    textCapitalization: TextCapitalization.words,
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

        labelText: "Title",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)
    ),
    onChanged: (value){
      if(value.isNotEmpty){
        if(value.contains("@")){
          print(value.isEmail);
          setState(() {
            // _validEmail = true;
          });
        }else{
          setState(() {
            //_validEmail = false;
          });
        }
      }
    },
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'Please enter phone number';
      }
      return null;
    },

  );

  Widget contentField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: contentController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    textInputAction: TextInputAction.newline,
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

        labelText: "Review Content",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor)
    ),


  );

  Widget saveBtn (){
    return SizedBox(
        width: Get.width,
        height: Get.height *0.06,
        child: Consumer<LiteratureProvider>(
          builder: (context, aProvider, _){
            return ElevatedButton(
              onPressed: () async{
                if(titleController.text.isEmpty || contentController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "Review Title and Content are required", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(_rating == 0.0){
                  LoadingControl.showSnackBar("Ouchs!!!", "Rating must be greater than zero", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                //aProvider.setLoading(true);
                final result = await aProvider.addLiteratureReview(
                    titleController.text,
                    contentController.text,
                    _rating,
                    Provider.of<LiteratureProvider>(context, listen: false).selectedLiterature!.id!,
                    Provider.of<AuthProvider>(context, listen: false).profile!.id!
                );

                if(result){
                  print(result);
                  //aProvider.retrieveProfile().then((value) => aProvider.getUserProfile(aProvider.profile!.id!));
                  // Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff831608)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ))
              ),
              child: aProvider.reviewLoading
                  ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                  : Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Save", style: TextStyle(fontFamily: 'JakartaMedium', fontSize: 14, color: Colors.white),),
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



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        child: Container(
          width: 300,
          height: 500,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.white54,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              BoxShadow(
                color: Colors.white,
                offset: const Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ), //BoxShadow
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: titleField(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: contentField(),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: RatingBar(
                  initialRating: _rating,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star_rounded, color: mainColor),
                    half: Icon(Icons.star_half_rounded, color: mainColor,),
                    empty: Icon(Icons.star_border_rounded, color: mainColor,),
                  ),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 7),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                  updateOnDrag: true,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: saveBtn(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
