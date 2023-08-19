import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stefomobileapp/ui/common.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../Models/user.dart';
// import '../UI/common.dart';

class pdfViewPage extends StatelessWidget {
  final User user;
  const pdfViewPage({Key? key,required this.user}) : super(key: key);

  @override
  // @override
  Widget build(BuildContext context) {
    print(user.uploadedFile);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar1("View Document", user.uploadedFile!,() {
          print("Back Pressed");
          Navigator.pop(context);
        }),
        body: Container(
            child: SfPdfViewer.network(
                'http://steefotmtmobile.com/steefo/uploadedpdf/'+ user.uploadedFile!)));
  }
}
