import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropping/constant/enums.dart';
import 'package:image_cropping/image_cropping.dart';
import 'package:path_provider/path_provider.dart';
import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'register_step_2.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class RegisterStep1 extends StatefulWidget {
  RegisterStep1(this.token);
  String token;
  @override
  _RegisterStep1 createState() => new _RegisterStep1(token);
}

class _RegisterStep1 extends State<RegisterStep1> {
  _RegisterStep1(token);

  TextEditingController name = TextEditingController();
  String get _name => name.text;

  TextEditingController security = TextEditingController();
  String get _security => security.text;

  bool isloading=false;
  late Future<dynamic> profilefile,idfile;
  //String profilebase64Image = '',idbase64Image='';
  //String profilepath = '',idpath='';
  //var profile_image,id_image;
  String idstatus="Upload ID";
  String dob="";

  String profilePath = "",idPath = "";

  void onchooseimage()async{
    try {
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      final bytes = File(image!.path)
          .readAsBytesSync()
          .lengthInBytes;
      final kb = bytes / 1024;
      if (kb <= 500) {


        setState(() {
          profilePath = image.path;
        });

        var imageBytes = await File(profilePath).readAsBytes();

        ImageCropping.cropImage(
          context,
          imageBytes,
              () {},
              () {},
              (data) async {

            imageBytes = data;

            Directory tempDir = await getTemporaryDirectory();
            File file = File("${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");
            file.writeAsBytesSync(imageBytes);

            setState(
                    () {
                      profilePath = file.path;
                });


          },
          selectedImageRatio: ImageRatio.RATIO_1_1,
          visibleOtherAspectRatios: true,
          squareBorderWidth: 2,
          squareCircleColor: Colors.black,
          defaultTextColor: Colors.orange,
          selectedTextColor: Colors.black,
          colorForWhiteSpace: Colors.grey,
        );

        // final imageBytes = File(image.path).readAsBytesSync();
        // String base64 = base64Encode(imageBytes);
        // setState(() {
        //   profile_image = File(image.path);
        //   profilebase64Image = base64;
        // });
      } else {
        aleart(context, "Please Select file less than 500KB", false);
      }
    }catch (error) {
      aleart(context, "File Not Picked", false);
    }
  }


  void onchooseimageid()async{
    try {
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      final bytes = File(image!.path)
          .readAsBytesSync()
          .lengthInBytes;
      final kb = bytes / 1024;
      if (kb <= 500) {
        // final imageBytes = File(image.path).readAsBytesSync();
        // String base64 = base64Encode(imageBytes);
        // setState(() {
        //   id_image = File(image.path);
        //   idbase64Image = base64;
        //   idstatus="ID Uploaded";
        // });

        setState(() {
          idPath = image.path;
          idstatus = "ID Uploaded";
        });

        aleart(context, "ID Uploaded", true);
      } else {
        aleart(context, "Please Select file less than 500KB", false);
      }
    }catch (error) {
      aleart(context, "File Not Picked", false);
    }

  }
  void onnext() {
    if(_name!='' && _security !='' && dob != "" && profilePath!='' && idPath!=''){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return RegisterStep2(widget.token,_name,_security,dob,profilePath,idPath);
      }));
    }else{
      aleart(context, "All Details are Required.", false);
    }

  }

  void date(double unit)async{
    
    DateTime? newDateTime = await showRoundedDatePicker(
      height: 200.0 * unit,
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
      initialDatePickerMode: DatePickerMode.year,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
    
    setState(() {
      //dob = (newDateTime!.year).toString()+"-"+(newDateTime.month).toString()+"-"+(newDateTime.day).toString();
      dob = (newDateTime!.day).toString()+"-"+(newDateTime.month).toString()+"-"+(newDateTime.year).toString();
    });
  }

  Widget build(BuildContext context) {
    double w = (MediaQuery.of(context).size.width);
    double unit = (MediaQuery.of(context).size.height) * heightunit + (MediaQuery.of(context).size.width) * widthunit;
    return Scaffold(
      body: SafeArea(
        child: isloading==false?SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppHeader(context, 1, Icons.person , "Personal Information"),
                Padding(
                  padding: EdgeInsets.only(top: 20 * unit),
                  child: GestureDetector(
                    onTap: () {
                      onchooseimage();
                    },
                    child: profilePath!=''?Container(
                      height: 100*unit,
                      width:100*unit,
                      decoration: BoxDecoration(
                        color: whitecolor,
                        image: DecorationImage(
                          image: FileImage(File(profilePath)),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: bluecolor,
                          width: 2*unit,
                        ),
                        borderRadius: BorderRadius.circular(50*unit),
                      ),
                    ): Container(
                      height: 100*unit,
                      width:100*unit,
                      decoration: BoxDecoration(
                        color: whitecolor,
                        border: Border.all(
                          color: bluecolor,
                          width: 2*unit,
                        ),
                        borderRadius: BorderRadius.circular(50*unit),
                      ),
                      child:Container(
                        width: 100*unit,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_rounded,
                              color: greycolor,
                              size: 25*unit,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10*unit,right:10*unit),
                              child: Row(
                                children: [
                                  Expanded(child: MyText(context,"Upload profile pick ",TextAlign.center,greycolor,12*unit,FontWeight.w400)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20 * unit),
                    child: MyTextField(
                        context, Icons.person, "Name", 20 * unit, TextInputType.text,
                        false, name, 35 * unit, 300 * unit)
                ),

                Padding(
                    padding: EdgeInsets.only(top: 10 * unit),
                    child: MyTextField(
                        context, Icons.security , "Social Security", 20 * unit, TextInputType.number,
                        false, security, 35 * unit, 300 * unit,isSSC: true)
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10 * unit),
                    child:InkWell(
                      onTap: () {
                        date(unit);
                      },
                      child: Container(
                        width: 300*unit,
                        height: 48*unit,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: bluecolor,
                            width: 3*unit,
                          ),
                          borderRadius: BorderRadius.circular(40*unit),
                        ),
                        padding: EdgeInsets.only(left:20*unit,right: 20*unit),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.date_range,
                              color: bluecolor,
                              size: 25*unit,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10*unit, 0, 10*unit, 0),
                                child: VerticalLine(context,1.5*unit,25*unit)
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: MyText(context,dob.isEmpty ? "Date of Birth":dob,TextAlign.start, dob.isEmpty ? greycolor:Colors.black,20*unit,FontWeight.normal),
                            ),

                          ],
                        ),
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10 * unit),
                    child:InkWell(
                      onTap: () {
                        onchooseimageid();
                      },
                      child: Container(
                        width: 300*unit,
                        height: 48*unit,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: bluecolor,
                            width: 3*unit,
                          ),
                          borderRadius: BorderRadius.circular(40*unit),
                        ),
                        padding: EdgeInsets.only(left:20*unit,right: 20*unit),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.contact_mail_rounded,
                              color: bluecolor,
                              size: 25*unit,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10*unit, 0, 10*unit, 0),
                                child: VerticalLine(context,1.5*unit,25*unit)
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: MyText(context,idstatus,TextAlign.start,idPath != ""? Colors.black : greycolor,20*unit,FontWeight.normal),
                            ),

                          ],
                        ),
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 60*unit),
                    child: RightIconBtn(context,Icons.arrow_forward ,bluecolor,"Next",20.0*unit,45*unit,280*unit,onnext)
                ),
              ],
            ),
          ),
        ):
        progressindicator(context),
      ),
    );
  }
}