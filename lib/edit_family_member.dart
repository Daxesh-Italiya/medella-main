import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_cropping/constant/enums.dart';
import 'package:image_cropping/image_cropping.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medella/models/api_response_entity.dart';
import 'package:medella/models/family_response_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/api.dart';
import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'models/controller/authentication_controller.dart';
import 'models/hospital_response_entity.dart';

class EditFamilyMember extends StatefulWidget {
  final int fId;
  EditFamilyMember(this.fId);

  @override
  _EditProfile createState() => new _EditProfile();
}

class _EditProfile extends State<EditFamilyMember> {
  TextEditingController name = TextEditingController();
  TextEditingController hospital = TextEditingController();

  final AddMemberFamilyController _addMemberFamilyController = Get.find();

  String get _name => name.text;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '###-##-####', filter: {"#": RegExp(r'[0-9]')});

  TextEditingController security = TextEditingController();

  String get _security => security.text;

  String dob = "";
  String path = '';

  var statedata = [];
  List<String> citydata = [];
  List<String> selectedHospitals = [];
  String city = '';
  String state = '';

  bool isLoading = false;
  FamilyResponseResultData? profile;

  List<HospitalResponseResultData> hospitals = [];

  bool profileSaveLoading = false;

  @override
  void initState() {
    //getstatedata();
    //loadHospitalsData();
    getdata();
  }

  void loadHospitalsData() async {
    HospitalResponseEntity entity = await allHospitals(context);

    if ((entity.status ?? "fail") == "success") {
      hospitals = entity.result!.data!;

      // hospital.text =profile!.hospialNetwork!
      //     .map((e) => e.hospitalName ?? "")
      //     .toList().join(",");

    }
  }

  void getstatedata() async {
    var res = await getstate(context, "United States");
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      setState(() {
        statedata = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      aleart(context, "Not fetching data", false);
    }
  }

  void getcitydata(String statename, {String cityName = ""}) async {
    //citydata.clear();

    setState(() {
      citydata.clear();
    });

    var res = await getcity(context, statename);

    if (res.statusCode == 200) {
      print("city respose - ${res.body}");

      List<dynamic> data = json.decode(res.body);

      setState(() {
        city = "";
      });

      setState(() {
        List<String> list = data.map((e) => "${e["city_name"] ?? ""}").toList();
        final seen = Set<String>();

        citydata = list.where((str) => seen.add(str)).toList();

        // list.reduce((value, element) {
        //   if (value != element)
        //     citydata.add(value);
        //   return element;
        // });

        print("city size - ${citydata.length}");

        if (cityName.isNotEmpty) {
          city = cityName;
        } else {
          city = citydata.first;
        }
      });
    } else {
      citydata = [];
      setState(() {
        isLoading = false;
      });
      aleart(context, "Not fetching data", false);
    }
  }

  void onSave() async {
    print("onSave start");

    if (name.text.isNotEmpty) {
      setState(() {
        profileSaveLoading = true;
      });

      ApiResponseEntity responseEntity = await updateFamily(context,
          id: widget.fId, dob: dob, user_name: name.text);

      if ((responseEntity.status ?? "status") == "success") {
        setState(() {
          profileSaveLoading = false;
        });
        await aleart(context, "Saved", true);

        Navigator.pop(context);
      } else {
        setState(() {
          profileSaveLoading = false;
        });
      }
    } else {
      setState(() {
        profileSaveLoading = false;
      });
      aleart(context, "All Details are Required.", false);
    }
  }

  void onchooseimage() async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        print("result is null");
        return;
      }

      print("file path - ${image.path}");

      final bytes = File(image.path).readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      if (kb <= 500) {
        //final imageBytes = File(image.path).readAsBytesSync();
        //String base64 = base64Encode(imageBytes);
        setState(() {
          //_image = File(image.path);
          path = image.path;
        });

        var imageBytes = await File(path).readAsBytes();

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
              path = file.path;
            });

            uploadDP(path);
          },
          selectedImageRatio: ImageRatio.RATIO_1_1,
          visibleOtherAspectRatios: true,
          squareBorderWidth: 2,
          squareCircleColor: Colors.black,
          defaultTextColor: Colors.orange,
          selectedTextColor: Colors.black,
          colorForWhiteSpace: Colors.grey,
        );

        //upload dp
        /*ApiResponseEntity responseEntity = await updateDP(context,path:path);

        print("responseEntity.status = ${responseEntity.status}");

        if((responseEntity.status ?? "fail") == "fail"){
          aleart(context, "Upload Profile Failed", false);
        }else{
          aleart(context, responseEntity.status!, true);
        }*/

      } else {
        aleart(context, "Please Select file less than 500KB", false);
      }
    } catch (error) {
      print("error - $error");
      aleart(context, "File Not Picked", false);
    }
  }

  uploadDP(String path) async {
    setState(() {
      path = path;
    });

    ApiResponseEntity responseEntity =
        await updateFamilyDP(context, path: path, id: widget.fId);

    print("responseEntity.status = ${responseEntity.status}");

    if ((responseEntity.status ?? "fail") == "fail") {
      aleart(context, "Upload Profile Failed", false);
      //Get.back();
      getdata();
    } else {
      aleart(context, responseEntity.status!, true);
    }
  }

  void getdata() async {
    FamilyResponseEntity? responseEntity =
        await getOneFamily(context, widget.fId);

    if (responseEntity == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Get.offAllNamed("/");
      return;
    }

    if ((responseEntity.status ?? "fail") == "success") {
      setState(() {
        isLoading = false;
        profile = responseEntity.result!.data;

        name.text = profile!.username ?? "";
        dob = profile!.dob ?? "";
        security.text = profile!.socialSecurity ?? "";
        //state = profile!.state ?? "";
        //city = profile!.city ?? "";

        security.text = maskFormatter.maskText(profile!.socialSecurity ?? "");

        //getstatedata();
        //getcitydata(state, cityName: city);

        /* if (profile!.hospialNetwork != null) {
          hospital.text = profile!.hospialNetwork!
              .map((e) => e.hospitalName ?? "")
              .toList()
              .join(",");

          selectedHospitals = profile!.hospialNetwork!
              .map((e) => e.hospitalName ?? "")
             .toList();
        }*/
      });
    } else {
      setState(() {
        isLoading = false;
      });
      aleart(context, "Server Didn't response", false);
    }

    /*  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString('token');
    print("token = " +token.toString());
    var res = await getdetails(context, "/api/v1/users/getMe",token.toString(),);
    if(res.statusCode == 200){
      var data=json.decode(res.body);
      print(data['data']);
      setState(() {
        userdata=data["data"];
        profilelink= "http://31.220.59.179/uploads/"+data['data']['user_image'];
        username=data['data']['username'];
        name =TextEditingController(text: data['data']['username']);
        isloading=false;
      });

    }else{
      setState(() {
        isloading=false;
      });
      aleart(context, "Server Didn't response", false);
    }*/
  }

  void date(double unit) async {
    DateTime? newDateTime = await showRoundedDatePicker(
      height: 200.0 * unit,
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 2)),
      initialDatePickerMode: DatePickerMode.year,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
    setState(() {
      //dob = (newDateTime!.year).toString()+"-"+(newDateTime.month).toString()+"-"+(newDateTime.day).toString();
      dob = (newDateTime!.day).toString() +
          "-" +
          (newDateTime.month).toString() +
          "-" +
          (newDateTime.year).toString();
    });
  }

  Widget build(BuildContext context) {
    double w = (MediaQuery.of(context).size.width);
    double unit = (MediaQuery.of(context).size.height) * heightunit +
        (MediaQuery.of(context).size.width) * widthunit;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'Assets/logo_horizontal.png',
          fit: BoxFit.contain,
          height: 35 * unit,
        ),
        backgroundColor: whitecolor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(
              padding: EdgeInsets.only(right: 20 * unit),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  if (!profileSaveLoading) {
                    onSave();
                  }
                },
                child: MyText(
                    context,
                    profileSaveLoading ? "Saving..." : "Save",
                    TextAlign.center,
                    bluecolor,
                    16 * unit,
                    FontWeight.w600),
              )),
        ],
      ),
      body: SafeArea(
        child: isLoading == false && profile != null
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(Get.context!);
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
                              MyText(Get.context!, "Back", TextAlign.start,
                                  Colors.black, 16 * unit, FontWeight.w400),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10 * unit),
                        child: Container(
                          width: w,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: (w - 300 * unit) / 2, top: 20 * unit),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      color: bluecolor,
                                      size: 25 * unit,
                                      semanticLabel:
                                          'Text to announce in accessibility modes',
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 10 * unit),
                                        child: MyText(
                                            context,
                                            "Edit Profile",
                                            TextAlign.start,
                                            bluecolor,
                                            20 * unit,
                                            FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: w,
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: (w - 300 * unit) / 2, top: 10 * unit),
                                child: HorizontalLine(context,
                                    w - ((w - 300 * unit) / 2), 3 * unit)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30 * unit),
                        child: Container(
                          width: 300 * unit,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  onchooseimage();
                                },
                                child: ClipOval(
                                  //borderRadius: BorderRadius.circular(999999),
                                  child: Container(
                                      height: 100 * unit,
                                      width: 100 * unit,
                                      child: CachedNetworkImage(
                                        imageUrl: profile != null
                                            ? "http://31.220.59.179/uploads/${profile!.userImage!}"
                                            : "",
                                        placeholder: (context, url) =>
                                            GFLoader(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),
                                  /*decoration: BoxDecoration(
                                    color: whitecolor,
                                    image: (path != "")
                                        ? DecorationImage(
                                            image: FileImage(File(path)),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: NetworkImage(profile != null
                                                ? "http://31.220.59.179/uploads/${profile!.userImage!}"
                                                : ""),
                                            fit: BoxFit.cover,
                                          ),
                                    border: Border.all(
                                      color: bluecolor,
                                      width: 2 * unit,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(50 * unit),
                                  ),*/
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20 * unit),
                          child: MyTextField(
                              context,
                              Icons.person,
                              "Name",
                              20 * unit,
                              TextInputType.text,
                              false,
                              name,
                              35 * unit,
                              300 * unit)),
                      Padding(
                          padding: EdgeInsets.only(top: 10 * unit),
                          child: MyTextField(
                              context,
                              Icons.security,
                              "Social Security",
                              20 * unit,
                              TextInputType.number,
                              false,
                              security,
                              35 * unit,
                              300 * unit,
                              isSSC: true,
                              readOnly: true)),
                      Padding(
                          padding: EdgeInsets.only(top: 10 * unit),
                          child: InkWell(
                            onTap: () {
                              date(unit);
                            },
                            child: Container(
                              width: 300 * unit,
                              height: 48 * unit,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: bluecolor,
                                  width: 3 * unit,
                                ),
                                borderRadius: BorderRadius.circular(40 * unit),
                              ),
                              padding: EdgeInsets.only(
                                  left: 20 * unit, right: 20 * unit),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: bluecolor,
                                    size: 25 * unit,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          10 * unit, 0, 10 * unit, 0),
                                      child: VerticalLine(
                                          context, 1.5 * unit, 25 * unit)),
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: MyText(
                                        context,
                                        dob.isEmpty ? "Date of Birth" : dob,
                                        TextAlign.start,
                                        dob.isEmpty ? greycolor : Colors.black,
                                        20 * unit,
                                        FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          )),

                      /* Padding(
                        padding: EdgeInsets.only(top: 10 * unit),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20 * unit, right: 20 * unit),
                          width: 300 * unit,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: bluecolor,
                              width: 3 * unit,
                            ),
                            borderRadius: BorderRadius.circular(30 * unit),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50 * unit,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.local_hospital,
                                      color: bluecolor,
                                      size: 25 * unit,
                                      semanticLabel:
                                          'Text to announce in accessibility modes',
                                    ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10 * unit, 0, 10 * unit, 0),
                                        child: VerticalLine(
                                            context, 1.5 * unit, 25 * unit)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: DropDownMultiSelect(
                                  //hint: MyText(context,"Hospital Network",TextAlign.start,greycolor,18*unit,FontWeight.normal),
                                  onChanged: (List<String> x) {
                                    setState(() {
                                      selectedHospitals = x;
                                    });
                                  },
                                  options: List.generate(
                                      hospitals.length,
                                      (index) =>
                                          hospitals[index].hospitalName ?? ""),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  isDense: true,
                                  //menuItembuilder: (option) => MyText(context,option,TextAlign.start,blackcolor,18*unit,FontWeight.normal),
                                  //childBuilder: (selectedValues) => MyText(context,selectedValues,TextAlign.start,blackcolor,18*unit,FontWeight.normal),
                                  selectedValues: selectedHospitals,
                                  whenEmpty: 'Select Hospitals',
                                )

                                */ /* DropdownButtonFormField<String>(
                            isExpanded: true,
                            hint: MyText(context,"Hospital Network",TextAlign.start,greycolor,18*unit,FontWeight.normal),
                            items: ["abc", "mno", "pqr"]
                                .map((label) => DropdownMenuItem(
                              child: MyText(context,label,TextAlign.start,blackcolor,18*unit,FontWeight.normal),
                              value: label,
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                hospital=value!;
                              });
                            },
                          )*/ /*
                                ,
                              )
                            ],
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: GFLoader(),
              ),
      ),
    );
  }
}
