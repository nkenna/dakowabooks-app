import 'dart:io';

import 'package:dakowabook/models/category.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/me/publishedbooksscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class EditLiteratureScreen extends StatefulWidget {
  final Literature editLiterature;

  EditLiteratureScreen(this.editLiterature);


  @override
  _EditLiteratureScreenState createState() => _EditLiteratureScreenState();
}

class _EditLiteratureScreenState extends State<EditLiteratureScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bookAuthorController = TextEditingController();
  TextEditingController synopsisController = TextEditingController();
  //TextEditingController contentController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController amountController = TextEditingController(text: "0.0");
  bool _isFree = true;
  bool _publish = false;
  int? _pages;
  bool _isLoading = true;
  Category? _category;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //print(widget.editLiterature.category!.id);
      titleController.text = widget.editLiterature.title! != null ? widget.editLiterature.title! : "";
      bookAuthorController.text = widget.editLiterature.author! != null ? widget.editLiterature.author! : "";
      isbnController.text = widget.editLiterature.isbn! != null ? widget.editLiterature.isbn! : "";
      synopsisController.text = widget.editLiterature.synopsis! != null ? widget.editLiterature.synopsis! : "";
      amountController.text = widget.editLiterature.amount!.toString() != null ? widget.editLiterature.amount!.toString() : "";
      _publish = widget.editLiterature.published!;

      // select category
      for(var i = 0; i < Provider.of<LiteratureProvider>(context, listen: false).categories.length; i++){
        print(Provider.of<LiteratureProvider>(context, listen: false).categories[i].id);
        print(widget.editLiterature.categoryId);
        print("\n");
        if(Provider.of<LiteratureProvider>(context, listen: false).categories[i].id == widget.editLiterature.categoryId){
          print(Provider.of<LiteratureProvider>(context, listen: false).categories[i].id);
          print(widget.editLiterature.categoryId);
          _category = Provider.of<LiteratureProvider>(context, listen: false).categories[i];
          break;
        }
      }
      setState(() {});
    }
    );
  }

  Widget titleField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: titleController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    //textCapitalization: TextCapitalization.sentences,
    keyboardType: TextInputType.text,
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



  );

  Widget authorNameField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: bookAuthorController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.text,
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

        labelText: "Author Full Name",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)
    ),


  );

  Widget isbnField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: isbnController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.text,
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

        labelText: "ISBN",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)
    ),


  );

  Widget synopsisField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: synopsisController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.text,
    textInputAction: Platform.isIOS ? TextInputAction.continueAction : TextInputAction.next,
    minLines: 5,
    maxLines: 10,
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

        labelText: "Synopsis",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)
    ),



  );

  Widget amountField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: amountController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: true,
    enabled: _isFree ? false : true,
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

  Widget isFreeCheck() => CheckboxListTile(
      title: Text("If this Literature is free, check the box."),
      value: _isFree,
      onChanged: (value){
        _isFree = value!;
        print(_isFree);
        if(_isFree){
          amountController.text = "0";
        }
        setState(() {});
      }
  );

  Widget isPublishCheck() => CheckboxListTile(
      title: Text("Publish this immediately. You can always wait till everything is complete."),
      value: _publish,
      onChanged: (value){
        _publish = value!;
        setState(() {});
      }
  );

  Widget selectCategory() {
    return SizedBox(
      width: Get.width,
      //height: Get.height * 0.1,
      child: DropdownButton<Category>(
        dropdownColor: Colors.white,
        hint: Text("Select Literature Category",
          style: TextStyle(color: mainTextColor, fontSize: 14, fontFamily: 'SofiaProRegular', height: 2.5),
        ),
        value: _category,
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
            _category = value!;
          });
        },
        isExpanded: true,
        items: Provider.of<LiteratureProvider>(context, listen: true).categories.map((value) {
          return DropdownMenuItem<Category>(
            value: value,
            child: Text("${value.name}",
                style: TextStyle(color: mainTextColor, fontSize: 14)
            ),
          );
        }).toList(),
      ),
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
                if(titleController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "Title is required", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(bookAuthorController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "Author Name is required", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(_isFree == false
                    && double.tryParse(amountController.text) == null
                    && double.tryParse(amountController.text) == 0.0){
                  LoadingControl.showSnackBar("Ouchs!!!", "This is not a free literature. Valid amount is required or set it to free.", Icon(Icons.error, color: Colors.white,));
                  return;
                }



                //aProvider.setLoading(true);
                final result = await aProvider.editLiterature(
                    titleController.text,
                    bookAuthorController.text,
                    synopsisController.text,
                    isbnController.text,
                    _isFree,
                    double.tryParse(amountController.text)!,
                    Provider.of<AuthProvider>(context, listen: false).profile!.id!,
                    _publish,
                    _category!.id!,
                    widget.editLiterature.id!
                );

                if(result){
                  print(result);
                  //aProvider.retrieveProfile().then((value) => aProvider.getUserProfile(aProvider.profile!.id!));
                  aProvider.allMyLiteratures(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
                  Provider.of<AuthProvider>(context, listen: false).getUserProfile(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
                  Get.offAll(() => PublishedBooksScreen());
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

  Widget mainContainer(){
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: selectCategory(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: titleField(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: authorNameField(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: isbnField(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: synopsisField(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: isFreeCheck(),
            ),


            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: amountField(),
            ),







            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: isPublishCheck(),
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
          title: Text("Edit Literature"),
        ),
        body: mainContainer(),
      ),
    );
  }
}
