import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'Components/api.dart';
import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'login_otp.dart';
import 'package:country_pickers/country_pickers.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => new _Login();
}

class _Login extends State<Login> {

  TextEditingController mobailno =TextEditingController();
  String get _mobailno => mobailno.text;

  bool isloading=false;
  String country_code='+1';

  Country _selectedFilteredDialogCountry =
  CountryPickerUtils.getCountryByName('United States');

  Country _us =
  CountryPickerUtils.getCountryByName('United States');

  Country _india =
  CountryPickerUtils.getCountryByName('India');

  void OnSentOtp()async{
    if(_mobailno != ''){
      if(mobail_number_validation(_mobailno)==true){
       /* Navigator.push(context, MaterialPageRoute(builder: (context){
          return LoginOtp('data["temptoken"]');
        }));*/
        setState(() {
          isloading=true;
        });
        var body= {
          "mobile":(country_code+_mobailno),
        };
        var res = await withotheaderapi(context, "/api/v1/users/sendOtp", body);
        print(res.statusCode);
        if(res.statusCode == 200){
           var data=json.decode(res.body);
           print(data);
            setState(() {
              isloading=false;
            });
            await aleart(context, "Verification Code Sent on "+country_code+_mobailno, true);

            print("temptoken - ${data["temptoken"]}");

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return LoginOtp(data["temptoken"]);
            }));
        }else{
            setState(() {
              isloading=false;
            });
            aleart(context, "Verification Code not Sent.\nFormat should be XXXXXXXXXX or\n may be server issue occur", false);
        }


      }else{
        aleart(context, "Enter Valid Mobile Number\nContry Code is Required\nFormat should be XXXXXXXXXX", false);
      }
    }else{
      aleart(context, "Mobile number is Required.", false);
    }
  }
  bool mobail_number_validation(String num){
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (num.length ==10) {
      if(!regExp.hasMatch(num)){
        return false;
      }else{
        return true;
      }
    } else{
      return false;
    }
  }
  Widget _buildDialogItem(Country country){
    double w=MediaQuery.of(context).size.width;
    double unit=(MediaQuery.of(context).size.height)*heightunit+w*widthunit;
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8*unit),
        MyText(context,"+${country.phoneCode}",TextAlign.start,blackcolor,14*unit,FontWeight.normal),
        SizedBox(width: 8*unit),
        Flexible(child: MyText(context,country.name,TextAlign.start,blackcolor,14*unit,FontWeight.normal)),
      ],
    );
  }
  void _openFilteredCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            priorityList: [_us,_india],
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your Country'),
            onValuePicked: (Country country) =>
                setState(() {
                  _selectedFilteredDialogCountry=country;
                  country_code="+"+country.phoneCode;
                }),
            itemBuilder: _buildDialogItem)),
  );

  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double unit=(MediaQuery.of(context).size.height)*heightunit+w*widthunit;
    return Scaffold(
      body: SafeArea(
          child:Center(
            child: isloading==false?SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top:0),
                      child: MyBodyHeader(context)
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25*unit),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login,
                          color: bluecolor,
                          size: 30*unit,
                          semanticLabel: 'Text to announce in accessibility modes',
                        ),
                        MyText(context," Login",TextAlign.center,redcolor,30*unit,FontWeight.bold),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25*unit),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(context,"We will send you an ",TextAlign.center,blackcolor,17*unit,FontWeight.normal),
                        MyText(context,"One Time",TextAlign.center,blackcolor,17*unit,FontWeight.w600),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(context,"Password",TextAlign.center,blackcolor,17*unit,FontWeight.w600),
                      MyText(context," on the Mobail",TextAlign.center,blackcolor,17*unit,FontWeight.normal),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15*unit,left: (w-280*unit)/2,right: (w-280*unit)/2),
                    child: Center(
                      child: ListTile(
                        onTap: _openFilteredCountryPickerDialog,
                        title: _buildDialogItem(_selectedFilteredDialogCountry),
                      ),
                    ),
                  ),
                 Padding(
                      padding: EdgeInsets.only(top: 0*unit),
                      child: MobileTextField(context,Icons.mobile_friendly,"Mobile Number",19*unit,TextInputType.phone,false,mobailno,50*unit,280*unit)
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 70*unit),
                      child: LeftIconBtn(context,Icons.send_outlined,bluecolor,"Send OTP",20.0*unit,45*unit,280*unit,OnSentOtp)
                  ),
                ],
              ),
            ):
            progressindicator(context),
          ),
      ),
    );
  }
}