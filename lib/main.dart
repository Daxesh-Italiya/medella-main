import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:medella/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(GetMaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("auth") ?? false) {
      Get.offAll(HomePage());
      /* Navigator.push(context, MaterialPageRoute(builder: (context){
        return HomePage();
        //return RegisterStep1("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOiIrOTE3Njk4ODQ1MjM1IiwiaWF0IjoxNjM0MjI5OTY4LCJleHAiOjE2MzY4MjE5Njh9.lyfo5hfm6nvLJtcxfkYNDw_fm1ZCqsp5rgKp8yPJxv4");
      }));*/
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void OnLogin() {
    Get.to(Login());

    //Get.to(RegisterStep1("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOiIrOTE3Njk4ODQ1MjM1IiwiaWF0IjoxNjM0MjI5OTY4LCJleHAiOjE2MzY4MjE5Njh9.lyfo5hfm6nvLJtcxfkYNDw_fm1ZCqsp5rgKp8yPJxv4"));

    // Navigator.push(context, MaterialPageRoute(builder: (context){
    //   return Login();
    //   //return RegisterStep1("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOiIrOTE3Njk4ODQ1MjM1IiwiaWF0IjoxNjM0MjI5OTY4LCJleHAiOjE2MzY4MjE5Njh9.lyfo5hfm6nvLJtcxfkYNDw_fm1ZCqsp5rgKp8yPJxv4");
    // }));
  }

  Widget build(BuildContext context) {
    double unit = (MediaQuery.of(context).size.height) * heightunit +
        (MediaQuery.of(context).size.width) * widthunit;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: loading
              ? Center(child: GFLoader())
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: MyBodyHeader(context)),
                      Padding(
                          padding: EdgeInsets.only(top: 40 * unit),
                          child: MyText(
                              context,
                              "Welcome To Medella\nContinue with",
                              TextAlign.center,
                              greycolor,
                              17 * unit,
                              FontWeight.w800)),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 160 * unit, bottom: 20 * unit),
                          child: LeftIconBtn(
                              context,
                              Icons.login,
                              bluecolor,
                              "Login",
                              20.0 * unit,
                              45 * unit,
                              280 * unit,
                              OnLogin)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
