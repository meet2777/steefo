import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:stefomobileapp/pages/HomePage.dart';

import '../pages/DownloadService.dart';



//--------------------------------LOGO------------------------------------------

var width;

Widget logo(BuildContext context) {
  width = MediaQuery.of(context).size.width;
  const String assetName = 'assets/images/logo.svg';
  final Widget svg = SvgPicture.asset(
    assetName,
    width: MediaQuery.of(context).size.width - 150,
    height: MediaQuery.of(context).size.height / 3,
  );
  return Container(
    padding: EdgeInsets.all(50),
    child: svg,
  );
}

//----------------------------Button Widget-------------------------------------

Widget buttonStyle(String str, void c()) {
  return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(75, 100, 160, 1.0),
          Color.fromRGBO(19, 59, 78, 1.0),
          //add more colors
         ]
        ),
        // borderRadius: BorderRadius.circular(30),
        // boxShadow: <BoxShadow>[
        // BoxShadow(
        //     color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
        //     blurRadius: 5) //blur radius of shadow
        //]
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.transparent.withOpacity(0.38), disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
            shadowColor: Colors.transparent,
            //make color or elevated button transparent
          ),
          onPressed: c,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 18,
              bottom: 18,
            ),
            child: Text(
              str,
              style: const TextStyle(fontFamily: 'Poppins_Bold',color: Colors.white),
            ),
          )));
}

//----------------------------------Appbar----------------------------------

appbar(String txt, void c(), {void Function()? alert}) {
  return AppBar(
      // toolbarHeight: 80,
      elevation: 0.0,
      // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        LayoutBuilder(builder: (context, constraints) {
          if (txt ==DateFormat('dd-MM-yyyy').format(DateTime.now())) {
            return IconButton(
                onPressed: () {
                  alert!();
                },
                icon: const Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.black,
                ));
          } else {
            return Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => HomePage());
                },
                child: SvgPicture.asset(
                  "assets/images/logo.svg",
                  // fit: BoxFit.fill,
                  // color: Colors.green,
                  height: 30,
                  width: 30,
                ),
              ),
            );
          }
        })
      ],
      title: Center(
          child: Text(
        txt,
        // textAlign: TextAlign.center,
        style: const TextStyle(

            color: Color.fromRGBO(19, 59, 78, 1), fontFamily: "Poppins_Bold"),
      )),
      backgroundColor: Colors.white,
      leading: txt == DateFormat('dd-MM-yyyy').format(DateTime.now())
          ? Image.asset("assets/images/logo_foreground.png")
          : IconButton(
              onPressed: () {
                c();
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ))

      // Image.asset("assets/images/logo_foreground.png"),
      );
}

Future<void> _downloadFile(String url) async {
  DownloadService downloadService = MobileDownloadService();
  await downloadService.download(url: url);
}

appbar1(String txt,String fileName, void c(), {void Function()? alert}) {
  return AppBar(
      toolbarHeight: 80,
      elevation: 0.0,
      // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        LayoutBuilder(builder: (context, constraints) {
          // if (txt ==DateFormat('dd-MM-yyyy').format(DateTime.now())) {
          //   return IconButton(
          //       onPressed: () {
          //         alert!();
          //       },
          //       icon: const Icon(
          //         Icons.power_settings_new_rounded,
          //         color: Colors.black,
          //       ));
          // } else {
            return Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap:
                    () {
                  _downloadFile('http://steefotmtmobile.com/steefo/uploadedpdf/'+ fileName);
                },
                child: Icon(Icons.download_for_offline,color: Colors.black,size: 35,)
              ),
            );
          // }
        }
        )
      ],
      title: Center(
          child: Text(
            txt,
            // textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color.fromRGBO(19, 59, 78, 1), fontFamily: "Poppins_Bold"),
          )),
      backgroundColor: Colors.white,
      leading: txt == DateFormat('dd-MM-yyyy').format(DateTime.now())
          ? Image.asset("assets/images/logo_foreground.png")
          : IconButton(
          onPressed: () {
            c();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ))

    // Image.asset("assets/images/logo_foreground.png"),
  );
}

Widget buttonWhite(String str, void c()) {
  return Container(
    padding: EdgeInsets.only(left: 8,right:8 ),
    child: DecoratedBox(
        decoration: const BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.57),
                  //shadow for button
                  blurRadius: 5) //blur radius of shadow
            ]),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledForegroundColor: Colors.transparent.withOpacity(0.38), disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
              shadowColor: Colors.transparent,
              //make color or elevated button transparent
            ),
            onPressed: c,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 18,
                bottom: 18,
              ),
              child: Text(
                str,
                style: const TextStyle(
                    fontFamily: 'Poppins_Bold', color: Colors.black),
              ),
            ))),
  );
}
