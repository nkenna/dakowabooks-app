import 'dart:async';

import 'package:dakowabook/models/salerecord.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class BookOrdersScreen extends StatefulWidget {
  @override
  _BookOrdersScreenState createState() => _BookOrdersScreenState();
}

class _BookOrdersScreenState extends State<BookOrdersScreen> {
  var currencyFormat = new NumberFormat.currency(locale: "en_US", symbol: "\u{020A6} ");
  final ScrollController scrollController = ScrollController();
  StreamController<List<SaleRecord>?> _streamController = StreamController<List<SaleRecord>?>();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() async{
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent){
        currentPage = currentPage + 1;
        print("I am at the bottom");
        print("total all literature page: ${ Provider.of<LiteratureProvider>(context, listen: false).ordersTotalPages}");
        print("current page: ${ currentPage}");
        if(currentPage <= Provider.of<LiteratureProvider>(context, listen: false).salesRecordTotalPages){
          final dd = await Provider.of<LiteratureProvider>(context, listen: false).ordersByUser(
              currentPage,
              Provider.of<AuthProvider>(context, listen: false).profile!.id!
          );
          //print("lengrh::::::::::::::${dd!.length}");
          _streamController.add(dd);
        }

      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        initData()
    );

  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _streamController.close();
  }

  initData() async {
    final dd = await Provider.of<LiteratureProvider>(context, listen: false).ordersByUser(
        currentPage,
        Provider.of<AuthProvider>(context, listen: false).profile!.id!
    );
    // print("lengrh::::::::::::::${dd!.length}");
    _streamController.add(dd);
  }

  Widget transContainer(SaleRecord wt){
    return Container(
      width: Get.width,
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: mainColor)
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${wt.channel}".toUpperCase(), style: TextStyle(color: mainTextColor, fontSize: 14, fontFamily: 'SofiaProSemiBold'),),
              Text("${currencyFormat.format(wt.amount)}", style: TextStyle(color: mainTextColor, fontSize: 14, fontFamily: 'SofiaProSemiBold'),),
            ],
          ),

          Text("${ wt.literature != null ? wt.literature!.title : ""} ".capitalize!, style: TextStyle(color: mainTextColor, fontSize: 14, fontFamily: 'SofiaProRegular'),),
          Text("${Jiffy(wt.transDate).yMMMdjm}", style: TextStyle(color: mainTextColor, fontSize: 14, fontFamily: 'SofiaProRegular'),),
          Text("${wt.transRef}", style: TextStyle(color: mainTextColor, fontSize: 14, fontFamily: 'SofiaProRegular'),),
         // Text("Platform Commission: ${currencyFormat.format(wt.commission)}", style: TextStyle(color: mainTextColor, fontSize: 14, fontFamily: 'SofiaProRegular'),),


        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
          appBar: AppBar(
            title: Text("Your Orders", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
          ),
          body: StreamBuilder<List<SaleRecord>?>(
              stream: _streamController.stream,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Center(child: Text("Error occurred retrieving data..."),);
                }
                else if (snapshot.connectionState == ConnectionState.waiting){
                  //return SkeletonLoadingGrid(items: 10,);
                  return Center(child: Text("Loading...."),);
                }
                else if(snapshot.data == null){
                  return Center(child: Text("No Record found"),);
                }
                else if(snapshot.hasData == true){
                  return snapshot.data!.length == 0
                      ? Center(child: Text("No transactions in this wallet yet"),)
                      : ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: transContainer(snapshot.data![i]),
                        );
                      }
                  );
                }
                else{
                  print("snapshot length: ${snapshot.data!.length}");
                  return Center(child: Text("No data found..."),);
                }
              }
          ),
        )
    );


  }
}
