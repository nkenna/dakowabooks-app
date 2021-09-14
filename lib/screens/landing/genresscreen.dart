import 'package:dakowabook/models/category.dart';
import 'package:dakowabook/projectcolors.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/genres/genrebooksscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Provider.of<LiteratureProvider>(context, listen: true).categoryLoading
      ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
      : Provider.of<LiteratureProvider>(context, listen: true).categories.isEmpty
        ? Expanded(
          child: Center(
            child: Text("No Book Genre is available"),
          )
      )
      : GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        shrinkWrap: true,
        //controller: scrollController,
        //scrollDirection: Axis.horizontal,
        children: List.generate(Provider.of<LiteratureProvider>(context, listen: true).categories.length, (i) {
          //Video vd = snapshot.data[i];
          Category category = Provider.of<LiteratureProvider>(context, listen: true).categories[i];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: (){
                print("Is there a tap here");
                Get.to(() => GenreBooksScreen(category: category,));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor.withAlpha(60),//Color(0xff77198c).withAlpha(80),//mainColor.withAlpha(60),
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("${category.name}", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 12, color: mainTextColor),),
                ),

              ),
            ),
          );
        }),
      ),
    );
  }
}
