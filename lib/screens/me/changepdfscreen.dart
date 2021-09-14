import 'dart:io';

import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/me/publishedbooksscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChangePdfScreen extends StatefulWidget {
  final Literature editLiterature;

  ChangePdfScreen(this.editLiterature);

  @override
  _ChangePdfScreenState createState() => _ChangePdfScreenState();
}

class _ChangePdfScreenState extends State<ChangePdfScreen> {
  PlatformFile? _file;

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

  Widget saveBtn (){
    return SizedBox(
        width: Get.width,
        height: Get.height *0.06,
        child: Consumer<LiteratureProvider>(
          builder: (context, aProvider, _){
            return ElevatedButton(
              onPressed: () async{
                //print(Provider.of<AuthProvider>(context, listen: false).profile!.id!);

                if(_file == null){
                  LoadingControl.showSnackBar("Ouchs!!!", "Invalid PDF File. Please upload a valid pdf file", Icon(Icons.error, color: Colors.white,));
                  return;
                }



               //aProvider.setLoading(true);
               final result = await aProvider.editLiteratureFile(
                   widget.editLiterature.id!,
                   Provider.of<AuthProvider>(context, listen: false).profile!.id!,
                   File(_file!.path)
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit Literature File", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),

          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: uploadContainer(),
              ),

              _file != null
              ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: saveBtn(),
              ) : Container()
            ],
          ),
        )
    );
  }
}
