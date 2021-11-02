import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropping/constant/enums.dart';
import 'package:image_cropping/image_cropping.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medella/Components/api.dart';
import 'package:medella/edit_profile.dart';
import 'package:medella/helper/toast.dart';
import 'package:medella/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'models/api_response_entity.dart';
import 'models/controller/authentication_controller.dart';
import 'models/get_me_response_entity.dart';

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({Key? key}) : super(key: key);

  @override
  _AddFamilyMemberState createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  final AddMemberFamilyController _addMemberFamilyController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ssnController = TextEditingController();
  final TextEditingController uIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController ucfController = TextEditingController();
  String? userImagePath;
  File? userIdPath;
  File? userConsentPath;
  String? _pickedDate;
  String? dob = '1969-01-01';
  //RxInt ageVal = 0.obs;
  int ageVal = 0;
  GetMeResponseData? profile;
  uploadDP(String path) async {
    setState(() {
      path = path;
    });

    ApiResponseEntity responseEntity = await updateDP(context, path: path);

    print("responseEntity.status = ${responseEntity.status}");

    if ((responseEntity.status ?? "fail") == "fail") {
      aleart(context, "Upload Profile Failed", false);
    } else {
      aleart(context, responseEntity.status!, true);
    }
  }

  @override
  void initState() {
    calculateAge('01-01-1996');
    // TODO: implement initState
    super.initState();
  }

  void chooseUserImage() async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {});
      if (image != null) {
        print("result is null");
        userImagePath = image.path;
        print("file path - ${image.path}");

        var imageBytes = await File(userImagePath!).readAsBytes();
        ImageCropping.cropImage(
          context,
          imageBytes,
          () {},
          () {},
          (data) async {
            imageBytes = data;

            Directory tempDir = await getTemporaryDirectory();
            File file = File(
                "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");
            file.writeAsBytesSync(imageBytes);

            setState(() {
              userImagePath = file.path;
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

        return;
      }
    } catch (error) {
      print("error - $error");
      aleart(context, "File Not Picked", false);
    }
  }

  void chooseUserIdImage() async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {});
      if (image != null) {
        print("result is null");
        userIdPath = File(image.path);
        print("file path - ${image.path}");
        return;
      }
    } catch (error) {
      print("error - $error");
      aleart(context, "File Not Picked", false);
    }
  }

  void chooseUserConsentImage() async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {});
      if (image != null) {
        print("result is null");
        userConsentPath = File(image.path);
        print("file path - ${image.path}");
        return;
      }
    } catch (error) {
      print("error - $error");
      aleart(context, "File Not Picked", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double unit = (MediaQuery.of(context).size.height) * heightunit +
        (MediaQuery.of(context).size.width) * widthunit;
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'Assets/logo_horizontal.png',
              fit: BoxFit.contain,
              height: 35 * unit,
            ),
            backgroundColor: whitecolor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20 * unit),
                  child: GestureDetector(
                    onTap: () {
                      onprofile();
                    },
                    child: Icon(
                      Icons.account_circle,
                      color: bluecolor,
                      size: 30 * unit,
                    ),
                  )),
            ],
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40 * unit),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          chooseUserImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ClipOval(
                            child: CircleAvatar(
                              radius: 50,
                              child: userImagePath == null
                                  ? Icon(
                                      Icons.account_circle_rounded,
                                      size: 100,
                                      color: Colors.white,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              FileImage(File(userImagePath!)),
                                          fit: BoxFit.cover,
                                          // errorBuilder: (context, url, error) =>
                                          //     const Icon(
                                          //   Icons.account_circle_rounded,
                                          //   size: 80,
                                          //   color: Colors.white,
                                          // ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20 * unit),
                          child: MyTextField(
                              context,
                              Icons.account_circle_rounded,
                              "Name",
                              19 * unit,
                              TextInputType.name,
                              false,
                              nameController,
                              50 * unit,
                              280 * unit)),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1969),
                              lastDate: DateTime.now(),
                            ).then((newDateTime) {
                              if (newDateTime == null)
                                return;
                              else
                                // ignore: curly_braces_in_flow_control_structures
                                setState(() {
                                  log("aadadaD->$newDateTime");
                                  String data =
                                      newDateTime.toString().split(' ')[0];
                                  String dateTime =
                                      data.split("-")[0].toString();
                                  String month = data.split("-")[1].toString();
                                  String year = data.split("-")[2].toString();
                                  String formatDate = "$year-$month-$dateTime";
                                  dob = formatDate;
                                  calculateAge(formatDate);
                                  _pickedDate = formatDate;
                                  setState(() {});
                                });
                            });
                          },
                          child: MyDateTextField(
                              context,
                              Icons.event,
                              _pickedDate ?? "Date Of Birth",
                              19 * unit,
                              false,
                              50 * unit,
                              280 * unit,
                              enable: false,
                              initialVal: "1969-01-01"),
                        ),
                      ),
                      // Padding(
                      //   padding:
                      //       EdgeInsets.only(left: 70 * unit, top: 10 * unit),
                      //   child: Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: MyText(
                      //         context,
                      //         "Date of Birth",
                      //         TextAlign.start,
                      //         Colors.black,
                      //         19 * unit,
                      //         FontWeight.w600),
                      //   ),
                      // ),
                      // Container(
                      //   height: 50 * unit,
                      //   width: 280 * unit,
                      //   decoration: BoxDecoration(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(50 * unit)),
                      //       border: Border.all(color: bluecolor, width: 3)),
                      //   child: CupertinoTheme(
                      //     data: CupertinoThemeData(
                      //       textTheme: CupertinoTextThemeData(
                      //         dateTimePickerTextStyle: TextStyle(
                      //           fontSize: 18,
                      //         ),
                      //       ),
                      //     ),
                      //     child: CupertinoDatePicker(
                      //       backgroundColor: Colors.transparent,
                      //       mode: CupertinoDatePickerMode.date,
                      //       initialDateTime: DateTime(1969, 1, 1),
                      //       onDateTimeChanged: (DateTime newDateTime) {
                      //         log("aadadaD->$newDateTime");
                      //         String data =
                      //             newDateTime.toString().split(' ')[0];
                      //         String dateTime = data.split("-")[0].toString();
                      //         String month = data.split("-")[1].toString();
                      //         String year = data.split("-")[2].toString();
                      //         String formatDate = "$year-$month-$dateTime";
                      //         dob = formatDate;
                      //         calculateAge(formatDate);

                      //         // Do something
                      //       },
                      //     ),
                      //   ),
                      // ),
                      Padding(
                          padding: EdgeInsets.only(top: 10 * unit),
                          child: MyTextField(
                              context,
                              Icons.security,
                              "Social Security",
                              19 * unit,
                              TextInputType.number,
                              false,
                              ssnController,
                              50 * unit,
                              280 * unit,
                              isSSC: true)),
                      ageVal < 19
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Center(
                                child: InkWell(
                                    onTap: () {
                                      chooseUserIdImage();
                                    },
                                    child: MyDateTextField(
                                      context,
                                      Icons.upload_file,
                                      'Upload Id',
                                      19 * unit,
                                      false,
                                      50 * unit,
                                      280 * unit,
                                      enable: false,
                                    )
                                    //  Row(
                                    //   mainAxisSize: MainAxisSize.min,
                                    //   children: [
                                    //     Container(
                                    //       height: 50 * unit,
                                    //       width: 280 * unit,
                                    //       padding: EdgeInsets.all(5),
                                    //       decoration: BoxDecoration(
                                    //           //color: Colors.blue,
                                    //           borderRadius: BorderRadius.all(
                                    //             Radius.circular(50 * unit),
                                    //           ),
                                    //           border: Border.all(
                                    //               width: 5, color: Colors.blue)),
                                    //       child: Row(
                                    //         children: [
                                    //           Padding(
                                    //            padding: EdgeInsetsDirectional.only(start: 20 * unit),
                                    //             child: Icon(
                                    //               Icons.upload_file,
                                    //               color: bluecolor,
                                    //               size: 25 * unit,
                                    //               semanticLabel:
                                    //                   'Text to announce in accessibility modes',
                                    //             ),
                                    //           ),
                                    //           // SizedBox(
                                    //           //   width: 10,
                                    //           // ),
                                    //           Padding(
                                    //               padding: EdgeInsets.fromLTRB(
                                    //                   10 * unit, 0, 10 * unit, 0),
                                    //               child: VerticalLine(context,
                                    //                   1.5 * unit, 25 * unit)),
                                    //           MyText(
                                    //               context,
                                    //               "Upload Id",
                                    //               TextAlign.start,
                                    //               Colors.black87,
                                    //               20 * unit,
                                    //               FontWeight.w600),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    ),
                              ),
                            ),

                      ageVal < 19
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(top: 10 * unit),
                              child: MyTextField(
                                  context,
                                  Icons.phone_android,
                                  "Mobile Number",
                                  19 * unit,
                                  TextInputType.phone,
                                  false,
                                  mobileNumberController,
                                  50 * unit,
                                  280 * unit)),

                      ageVal < 19
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    chooseUserConsentImage();
                                  },
                                  child: Container(
                                    height: 50 * unit,
                                    width: 280 * unit,
                                    decoration: BoxDecoration(
                                      //color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50 * unit),
                                      ),
                                    ),
                                    child: Center(
                                      child: MyDateTextField(
                                          context,
                                          Icons.upload_file,
                                          "Upload Consent Form",
                                          19 * unit,
                                          false,
                                          50 * unit,
                                          280 * unit,
                                          enable: false),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                       SizedBox(
                        height: ageVal<19?120:100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = RegExp(patttern);
                              if (nameController.text.isEmpty) {
                                AppToast.toastMessage('Please enter name');
                              } else if (dob == null) {
                                AppToast.toastMessage(
                                    'Please enter dateb of birth');
                              } else if (ssnController.text.isEmpty &&
                                  ageVal >= 19) {
                                AppToast.toastMessage(
                                    'Please enter Social Security Number');
                              } else if (mobileNumberController.text.isEmpty &&
                                  ageVal >= 19) {
                                AppToast.toastMessage(
                                    'Please enter mobile Number');
                              } else if (!regExp
                                      .hasMatch(mobileNumberController.text) &&
                                  ageVal >= 19) {
                                AppToast.toastMessage(
                                    'Please enter valid mobile number');
                              } else if (userImagePath == null) {
                                AppToast.toastMessage('Select Picture');
                              } else {
                                if (userImagePath != null) {
                                  _addMemberFamilyController.addMember(
                                      userName: nameController.text,
                                      dob: dob ?? "",
                                      socialSecurity: ssnController.text,
                                      userConsent: userConsentPath,
                                      moNumber: mobileNumberController.text,
                                      userId: userIdPath,
                                      userImage: File(userImagePath!));
                                }

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (Route<dynamic> route) => false);
                              }
                            },
                            child: Container(
                              height: 40 * unit,
                              width: 170 * unit,
                              decoration: const BoxDecoration(
                                color: Color(0xff0072FF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: MyText(
                                    context,
                                    "Submit",
                                    TextAlign.start,
                                    Colors.white,
                                    20 * unit,
                                    FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.yellow,
                  height: 35 * unit,
                  child: Row(
                    children: [
                      SizedBox(width: 30 * unit),
                      const Icon(
                        Icons.arrow_back_ios,
                        size: 10,
                      ),
                      MyText(context, "Back", TextAlign.start, Colors.black,
                          16 * unit, FontWeight.w400),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() => _addMemberFamilyController.isAddMemberLoading.value
            ? const CircularProgressIndicator()
            : const SizedBox())
      ],
    );
  }

  int calculateAge(String birthDateAge) {
    String date = birthDateAge.split("-")[0].toString();
    String month = birthDateAge.split("-")[1].toString();
    String year = birthDateAge.split("-")[2].toString();
    String formatDate = "$year-$month-$date";

    DateTime birthDate = DateTime.parse(formatDate);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    setState(() {
      ageVal = age;
    });

    print("aggeeee $age");
    print("agevalueeeee ${ageVal}");

    return age;
  }

  void onprofile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditProfile();
    })).then((value) {
      getdata();
    });
  }

  void getdata() async {
    GetMeResponseEntity? responseEntity = await getMe(context);

    if (responseEntity == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Get.offAllNamed("/");
      return;
    }
  }
}
