import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medella/models/sign_up_response_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/api.dart';
import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'dart:math' as math;
import 'home_page.dart';

class RegisterStep3 extends StatefulWidget {
  RegisterStep3(this.token, this.name, this.security, this.dob,
      this.profile_image, this.id_image, this.state, this.city, this.hospitals);

  String token, name, security, dob, profile_image, id_image, state, city;
  List<int> hospitals;

  @override
  _RegisterStep3 createState() =>
      new _RegisterStep3(
          token,
          name,
          security,
          dob,
          profile_image,
          id_image,
          state,
          city);
}

class _RegisterStep3 extends State<RegisterStep3>
    with SingleTickerProviderStateMixin {
  _RegisterStep3(token, name, security, dob, profile_image, id_image, state,
      city);

  bool isfailed = false;
  bool issuccess = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: Duration(seconds: 3),)
      ..repeat();
    //onsenddata();
    signUpCall();
  }

  void signUpCall() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    SignUpResponseEntity entity = await signUp(context, city: widget.city,
        country: "United State",
        dob: widget.dob,
        hospitals: json.encode(widget.hospitals),
        social_security:widget.security,
        state: widget.state,
      user_id: widget.id_image,
      user_image: widget.profile_image,
      username: widget.name
        );

    if((entity.status ?? "status") == "success"){
      prefs.setBool("auth", true);
      prefs.setString("token", entity.token ?? "");
      _controller.dispose();
      await aleart(context, "Your Account Successfully Created.", true);
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return HomePage();
      // }));

      Get.offAll(HomePage());

    }else{
      _controller.dispose();
      setState(() {
        issuccess = false;
        isfailed = true;
      });
    }
  }

  void onsenddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var body = {
      "user_image": widget.profile_image,
      "user_id": widget.id_image,
      "username": widget.name,
      "dob": widget.dob,
      "social_security": widget.security,
      "country": "United State",
      "state": widget.state,
      "city": widget.city,
      "hospial_network": json.encode(widget.hospitals),
    };
    print("my token " + token.toString());
    var res = await api(
        context, "/api/v1/users/singup", token.toString(), body);
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      print(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("auth", true);
      prefs.setString("token", data['token']);
      _controller.dispose();
      await aleart(context, "Your Account Successfully Created.", true);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    } else {
      _controller.dispose();
      setState(() {
        issuccess = false;
        isfailed = true;
      });
    }
  }

  void onbackstart() {
    Navigator.popUntil(
        context, (Route<dynamic> predicate) => predicate.isFirst);
  }

  void gofailed() {
    setState(() {
      issuccess = false;
      isfailed = true;
    });
  }

  void gossuccess() async {
    setState(() {
      issuccess = true;
      isfailed = false;
    });
    await aleart(context, "Medella Successfully created your account", true);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }


  Widget build(BuildContext context) {
    double w = (MediaQuery
        .of(context)
        .size
        .width);
    double unit = (MediaQuery
        .of(context)
        .size
        .height) * heightunit + (MediaQuery
        .of(context)
        .size
        .width) * widthunit;
    return WillPopScope(
      onWillPop: () async {
        _controller.dispose();
        //super.dispose();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppHeader(context, (isfailed || issuccess) ? 4 : 3,
                    Icons.person_add_alt_1,
                    "Medella Create Profile"),
                isfailed == false ? Container(
                  width: 300 * unit,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50 * unit),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 30 * unit, top: 30 * unit),
                              child: Image(
                                image: AssetImage('Assets/onlylogo.png'),
                                height: 120 * unit, width: 120 * unit,),
                            ),
                            Container(
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (_, child) {
                                  return Transform.rotate(
                                    angle: _controller.value * 2 * math.pi,
                                    child: child,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Image(image: AssetImage(
                                        'Assets/loadingback.png'),
                                        height: 180 * unit),
                                    Image(image: AssetImage(
                                        'Assets/loadingfront.png'),
                                        height: 180 * unit),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20 * unit),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Icon(
                              Icons.access_time,
                              color: bluecolor,
                              size: 20 * unit,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),

                            MyText(context, " Please Wait", TextAlign.center,
                                greycolor, 20 * unit, FontWeight.w800)
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10 * unit),
                          child: MyText(context, "Checking Profile Data",
                              TextAlign.center, greycolor, 20 * unit,
                              FontWeight.normal)
                      ),
                    ],
                  ),
                ) :
                Container(
                  width: 300 * unit,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15 * unit),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: redcolor,
                              size: 25 * unit,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            MyText(context, " Account creation failed",
                                TextAlign.center, redcolor, 20 * unit,
                                FontWeight.normal)
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25 * unit, top: 10 * unit),
                          child: Row(
                            children: [
                              MyText(context, " Reason", TextAlign.center,
                                  greycolor, 20 * unit, FontWeight.normal),
                            ],
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 370 * unit),
                          child: LeftIconBtn(
                              context,
                              Icons.arrow_back,
                              redcolor,
                              "Back to Starting Page",
                              20.0 * unit,
                              45 * unit,
                              300 * unit,
                              onbackstart)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}