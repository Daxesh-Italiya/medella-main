import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Components/api.dart';
import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'home_page.dart';
import 'register_step_1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginOtp extends StatefulWidget {
  LoginOtp(this.verification_token);
  String verification_token;
  @override
  _LoginOtp createState() => new _LoginOtp(verification_token);
}

class _LoginOtp extends State<LoginOtp> {
  _LoginOtp(verification_token);
  TextEditingController otp1 =TextEditingController();
  String get _otp1 => otp1.text;
  TextEditingController otp2 =TextEditingController();
  String get _otp2 => otp2.text;
  TextEditingController otp3 =TextEditingController();
  String get _otp3 => otp3.text;
  TextEditingController otp4 =TextEditingController();
  String get _otp4 => otp4.text;
  TextEditingController otp5 =TextEditingController();
  String get _otp5 => otp5.text;
  TextEditingController otp6 =TextEditingController();
  String get _otp6 => otp6.text;
   bool isloading=false;
  late Timer _timer,_timer2;
  String temptoken='';
  int time = 30;
  void startTimer() {
    time = 30;
    _timer =  Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) => {
          if (time == 0) {
            _timer.cancel()
          } else {
            setState(() {
              time=time - 1;
            })

            }

          }
    );
  }
  void initState() {
    setState(() {
      temptoken=widget.verification_token;
    });
    startTimer();
  }
  void Onotpresend()async{
    if(time==0){
      setState(() {
        isloading=true;
      });

      var body= {
        "temptoken":temptoken,
      };
      var res = await withotheaderapi(context, "/api/v1/users/resendOtp", body);
      if(res.statusCode == 200){
        var data=json.decode(res.body);
        print(data);
        setState(() {

          print("resend temptoken - ${data["temptoken"]}");

          temptoken=data["temptoken"];
          isloading=false;
        });
        aleart(context, "Verification Code Resent on "+data['phonenumber'], true);

        setState(() {
          time = 30;
        });


      }else{
        setState(() {
          isloading=false;
        });
        aleart(context, "Otp Not Resend", false);
      }

    }else{
      aleart(context, "You can try resend OTP after timer time over.", false);
    }
  }
  void OnVerify()async{
    if(_otp1 !='' && _otp2 !='' && _otp3 !='' && _otp4 !='' && _otp5 !='' && _otp6!=''){
      String finalotp=_otp1+_otp2+_otp3+_otp4+_otp5+_otp6;
      /*Navigator.push(context, MaterialPageRoute(builder: (context){
        return RegisterStep1("res.token");
      }));*/
      setState(() {
        isloading=true;
      });
      var body= {
        "otp":finalotp,
        "temptoken":widget.verification_token,
      };
      var res = await withotheaderapi(context, "/api/v1/users/verifyOtp", body);
      print(res.statusCode);

      if(res.statusCode == 200){
        var data=json.decode(res.body);
        print(data);
        aleart(context, "Your OTP is Verified", true);
        if(data["status"]=="success"){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("auth", true);
          prefs.setString("token", data['token']);

          print("access token - ${data["token"]}");

          setState(() {
            isloading=false;
          });

          await aleart(context, "Your Account Verified", true);
          if(data["user"]=="old"){
            print("access old token - ${data["token"]}");

            _timer.cancel();
            Get.offAll(HomePage());

            // Navigator.push(context, MaterialPageRoute(builder: (context){
            //   return HomePage();
            // }));
          }else{

            print("access new token - ${data["token"]}");

            _timer.cancel();
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return RegisterStep1(data['token']);
            }));
          }

        }else{
          setState(() {
            isloading=false;
          });
          aleart(context, "OTP not Verified ,Enter Valid OTP", false);
        }
      }else{
        setState(() {
          isloading=false;
        });
        aleart(context, "Enter Valid OTP", false);
      }




    }else{
      aleart(context, "OTP is Required.", false);
    }

  }
  Widget build(BuildContext context) {
    double unit=(MediaQuery.of(context).size.height)*heightunit+(MediaQuery.of(context).size.width)*widthunit;
    return WillPopScope(
        onWillPop: () async {
      _timer.cancel();
      return true;
    },
     child: Scaffold(
      body: SafeArea(
        child: Center(
          child:isloading==false?SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: MyBodyHeader(context)
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25*unit, 0, 25*unit),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send_to_mobile ,
                        color: bluecolor,
                        size: 30*unit,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                      MyText(context," OTP",TextAlign.center,redcolor,30*unit,FontWeight.bold),
                    ],
                  ),
                ),
                MyText(context,"OTP was sended in",TextAlign.center,blackcolor,17*unit,FontWeight.normal),
                MyText(context,"Mobile Number",TextAlign.center,blackcolor,17*unit,FontWeight.w600),
                Container(
                  width: 280*unit,
                  margin: EdgeInsets.only(top: 40*unit),
                  child:Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          otptextfield(context,40*unit,otp1,1),
                          otptextfield(context,40*unit,otp2,2),
                          otptextfield(context,40*unit,otp3,3),
                          otptextfield(context,40*unit,otp4,4),
                          otptextfield(context,40*unit,otp5,5),
                          otptextfield(context,40*unit,otp6,6),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10*unit),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                Onotpresend();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.refresh ,
                                    color: time!=0?greycolor:blackcolor,
                                    size: 15*unit,
                                    semanticLabel: 'Text to announce in accessibility modes',
                                  ),
                                  MyText(context," Resend",TextAlign.center,time!=0?greycolor:blackcolor,17*unit,FontWeight.normal),

                                ],
                              ),
                            ),
                            MyText(context,(time/60).toInt().toString()+":"+(time%60).toString(),TextAlign.center,time!=0?bluecolor:redcolor,17*unit,FontWeight.normal),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 85*unit),
                    child: RightIconBtn(context,Icons.done,bluecolor,"Verify",20.0*unit,45*unit,280*unit,OnVerify)
                ),
              ],
            ),
          ):
          progressindicator(context),
        ),
      ),
     ),
    );
  }
}