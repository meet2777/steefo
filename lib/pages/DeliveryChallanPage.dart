

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../Models/challan.dart';
import '../Models/order.dart';
import '../UI/common.dart';
import 'DownloadService.dart';

class deliveryChallanPage extends StatelessWidget {
  // final int order_id = 533;
  Order order;
  Challan challan;
  deliveryChallanPage({Key? key,required this.order,required this.challan}) : super(key: key);

  Future<void> _downloadFile(String url) async {
    DownloadService downloadService = MobileDownloadService();
    await downloadService.download(url: url);
  }

  var order_id;

  loadData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    order_id = await prefs.getString('id');
    print("order id"+ order.order_id.toString());
  }


  @override
  Widget build(BuildContext context) {
    loadData();
    print("order id"+ order.order_id.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Challan",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, fontFamily: "Poppins_Bold")),
          // toolbarHeight: 80,
          elevation: 0.0,
          // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: GestureDetector(
                      onTap:
                          () {
                        _downloadFile("http://steefotmtmobile.com/steefo/download_challan.php?id=${order.order_id}&id2=${challan.challan_id}");
                        print("Download Challan ");

                      },
                      child: Icon(Icons.download_for_offline,color: Colors.black,size: 35,)
                  ),
                ),
          ],

        // Image.asset("assets/images/logo_foreground.png"),
      ),
      body: Container(
        child: SfPdfViewer.network("http://steefotmtmobile.com/steefo/download_challan.php?id=${order.order_id}&id2=${challan.challan_id}"),
      ),

    );
  }
}
