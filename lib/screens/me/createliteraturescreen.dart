import 'dart:async';
import 'dart:io';

import 'package:dakowabook/models/category.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/me/publishedbooksscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class CreateLiteratureScreen extends StatefulWidget {
  @override
  _CreateLiteratureScreenState createState() => _CreateLiteratureScreenState();
}

class _CreateLiteratureScreenState extends State<CreateLiteratureScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bookAuthorController = TextEditingController();
  TextEditingController synopsisController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController amountController = TextEditingController(text: "0.0");
  bool _isFree = true;
  bool _isFile = true;
  bool _publish = false;
  PlatformFile? _file;
  int? _pages;
  bool _isLoading = true;
  Category? _category;

  @override
  void initState() {
    super.initState();
    
  }

  Widget titleField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: titleController,
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
    onChanged: (value){



    },
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'Please enter phone number';
      }
      return null;
    },

  );

  Widget isFileCheck() => CheckboxListTile(
      title: Text("The soft copy of this publicated will be uploaded. This is the recommended method of publication owing to how easy and fast it is."),
      value: _isFile,
      onChanged: (value){
        setState(() {
          _isFile = value!;
          if(_isFile){
            _file = null;

          }
        });
        print(_isFile);
      }
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

  Widget contentField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: contentController,
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

        labelText: "Literature Content.",
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

  Widget uploadContainer() =>

      InkWell(
        onTap: ()async{
          FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
            allowedExtensions: ["pdf"]
          );

          if(result != null) {
            PlatformFile file = result.files.first;
            //document = null;
            //setState(() {});
            _file = file;
            //document = await PDFDocument.fromFile(File(file.path));
            setState(() {});

          } else {
            // User canceled the picker
          }
        },
        child: Container(
            width: Get.width,
            height: Get.height * 0.1,
            decoration: BoxDecoration(
              color: Colors.blueAccent
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("select PDF file"),
              _file != null ? Text(_file!.name) : Container(),
            ],
          ),

    ),
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

                if(_isFile && _file == null){
                  LoadingControl.showSnackBar("Ouchs!!!", "Invalid PDF File. Please upload a valid pdf file", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(_isFile && _file == null && _publish == true){
                  LoadingControl.showSnackBar("Ouchs!!!", "You cannot publish now. You have to upload the PDF soft copy of this literature.", Icon(Icons.error, color: Colors.white,));
                  return;
                }
                ;


                //aProvider.setLoading(true);
                final result = await aProvider.createLiteratureFileRequest(
                    titleController.text,
                    bookAuthorController.text,
                    synopsisController.text,
                    contentController.text,
                    isbnController.text,
                    _isFree,
                    double.tryParse(amountController.text)!,
                    _isFile,
                    _publish,
                    _category!.id!,
                    Provider.of<AuthProvider>(context, listen: false).profile!.id!,
                    File(_file!.path)
                );

                if(result){
                  print(result);
                  //aProvider.retrieveProfile().then((value) => aProvider.getUserProfile(aProvider.profile!.id!));
                  aProvider.allMyLiteratures(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
                  Provider.of<AuthProvider>(context, listen: false).getUserProfile(Provider.of<AuthProvider>(context, listen: false).profile!.id!);
                  Future.delayed(Duration(seconds: 3), () => Get.offAll(() => PublishedBooksScreen()));

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
            SizedBox(height: 10,),
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
              child: isFileCheck(),
            ),

            _isFile
            ? Container()
            : Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: contentField(),
            ),

            _isFile
            ? Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: uploadContainer(),
            )
            : Container(),

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
          title: Text("Add New Literature"),
        ),
        body: RefreshIndicator(
          onRefresh: ()async{
            Provider.of<LiteratureProvider>(context, listen: false).allCategories();
            return null;
          },
            child: mainContainer()
        ),
      ),
    );
  }
}
