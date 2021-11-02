import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medella/Components/api.dart';
import 'package:medella/Components/utils.dart';
import 'package:medella/edit_family_member.dart';
import 'package:medella/helper/toast.dart';
import 'package:medella/models/controller/authentication_controller.dart';
import 'package:medella/models/get_me_response_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/const_details.dart';

class FamilyDetail extends StatefulWidget {
  @override
  _FamilyDetailState createState() => _FamilyDetailState();
}

class _FamilyDetailState extends State<FamilyDetail> {
  bool isLoading = false;

  final AddMemberFamilyController _addMemberFamilyController = Get.find();

  GetMeResponseData? profile;
  DateTime currentDate = DateTime.now();
  bool isOpen = false;
  RxInt ageval = 0.obs;
  var maskFormatter =
      MaskTextInputFormatter(mask: '###-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getdata();
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
    ageval.value = age;
    return age;
  }

  void onprofile(int id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditFamilyMember(id);
    })).then((value) {
      //getdata();
      _addMemberFamilyController.getOneFamily(id);
    });
  }

  void onverification() {}

  void getdata() async {
    GetMeResponseEntity? responseEntity = await getMe(context);

    if (responseEntity == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Get.offAllNamed("/");
      return;
    }

    if ((responseEntity.status ?? "fail") == "success") {
      setState(() {
        isLoading = false;
        profile = responseEntity.data;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      aleart(context, "Server Didn't response", false);
    }
  }

  Widget build(BuildContext context) {
    calculateAge(
        _addMemberFamilyController.getOneFamilyModel.value.result?.data?.dob ??
            "");
    double unit = (MediaQuery.of(context).size.height) * heightunit +
        (MediaQuery.of(context).size.width) * widthunit;

    return Obx(() => _addMemberFamilyController.isLoading.value
        ? SizedBox()
        : Scaffold(
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
                        onprofile(_addMemberFamilyController
                            .getOneFamilyModel.value.result!.data!.id!);
                      },
                      child: Icon(
                        Icons.account_circle,
                        color: bluecolor,
                        size: 30 * unit,
                      ),
                    )),
              ],
            ),
            body: SafeArea(
              child: (isLoading == false && profile != null)
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(12),
                                //color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage("Assets/bg.jpeg"),
                                  fit: BoxFit.cover,
                                ),

                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      offset: new Offset(1.0, 1.0))
                                ],
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            "Assets/white-logo.svg",
                                            fit: BoxFit.contain,
                                            height: 35 * unit,
                                            color: Colors.white,
                                          ),

                                          // Image.asset(
                                          //   'Assets/logo_horizontal.png',
                                          //   fit: BoxFit.contain,
                                          //   height: 35 * unit,
                                          // ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: Column(children: [
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: MyText(
                                                          context,
                                                          "Medella Code:",
                                                          TextAlign.start,
                                                          Colors.white,
                                                          16 * unit,
                                                          FontWeight.w600)),
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: MyText(
                                                          context,
                                                          maskFormatter.maskText(
                                                              _addMemberFamilyController
                                                                      .getOneFamilyModel
                                                                      .value
                                                                      .result!
                                                                      .data
                                                                      ?.medellaCode
                                                                      .toString() ??
                                                                  "123123"),
                                                          TextAlign.start,
                                                          Colors.white,
                                                          22 * unit,
                                                          FontWeight.w800)),
                                                ])),
                                                ClipOval(
                                                    //borderRadius: BorderRadius.circular(999999),
                                                    child: Container(
                                                  height: 100 * unit,
                                                  width: 100 * unit,
                                                  color: Colors.white,
                                                  //margin: EdgeInsets.symmetric(horizontal: 5),
                                                  child: CachedNetworkImage(
                                                    imageUrl: profile != null
                                                        ? "http://31.220.59.179/uploads/${_addMemberFamilyController.getOneFamilyModel.value.result!.data!.userImage}"
                                                        : "",
                                                    placeholder:
                                                        (context, url) =>
                                                            GFLoader(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                  /* decoration: BoxDecoration(
                                            color: whitecolor,
                                            image: DecorationImage(
                                              image: NetworkImage(profile != null
                                                  ? "http://31.220.59.179/uploads/${profile!.userImage!}"
                                                  : ""),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(50 * unit),
                                          ),*/
                                                ))
                                              ]),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: MyText(
                                                  context,
                                                  _addMemberFamilyController
                                                          .getOneFamilyModel
                                                          .value
                                                          .result
                                                          ?.data
                                                          ?.username ??
                                                      "",
                                                  TextAlign.start,
                                                  Colors.white,
                                                  14 * unit,
                                                  FontWeight.w500)),

                                          SizedBox(
                                            height: isOpen ? 25 : 0,
                                          ),

                                          AnimatedContainer(
                                              duration: Duration(seconds: 2),
                                              child: !isOpen
                                                  ? SizedBox()
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 0),
                                                          padding: EdgeInsets
                                                              .all(15),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .circular(12),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              new BoxShadow(
                                                                  color: Colors
                                                                      .grey,
                                                                  blurRadius: 3,
                                                                  offset:
                                                                      new Offset(
                                                                          1.0,
                                                                          1.0))
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GFAccordion(
                                                                  showAccordion:
                                                                      true,
                                                                  expandedTitleBackgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  titleChild: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        MyText(
                                                                            context,
                                                                            "Basic Information",
                                                                            TextAlign
                                                                                .start,
                                                                            Colors
                                                                                .black,
                                                                            14 *
                                                                                unit,
                                                                            FontWeight.w900),
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                bluecolor,
                                                                            height:
                                                                                2,
                                                                            thickness:
                                                                                3,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                  contentChild:
                                                                      Column(
                                                                    children: [
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              MyText(context, "Age", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600),
                                                                              MyText(context, "38 years, Female", TextAlign.start, Colors.black87, 16 * unit, FontWeight.w400)
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              MyText(context, "Blood Group", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600),
                                                                              MyText(context, "AB+", TextAlign.start, Colors.black87, 16 * unit, FontWeight.w400)
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              MyText(context, "Phone", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600),
                                                                              MyText(context, "${profile!.mobile ?? ""}", TextAlign.start, Colors.black87, 16 * unit, FontWeight.w400)
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              MyText(context, "Address", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600),
                                                                              MyText(context, "${profile!.city ?? ""}, ${profile!.state ?? ""}", TextAlign.start, Colors.black87, 16 * unit, FontWeight.w400)
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              MyText(context, "Emergency\nContact", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600),
                                                                              MyText(context, "Sofiya Brient\n +1 952 976 3574", TextAlign.end, Colors.black87, 16 * unit, FontWeight.w400)
                                                                            ],
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  collapsedIcon:
                                                                      Icon(Icons
                                                                          .add),
                                                                  expandedIcon:
                                                                      Icon(Icons
                                                                          .minimize)),
                                                              GFAccordion(
                                                                  expandedTitleBackgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  titleChild: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            alignment: Alignment
                                                                                .centerLeft,
                                                                            child: MyText(
                                                                                context,
                                                                                "Allergies",
                                                                                TextAlign.start,
                                                                                Colors.black,
                                                                                14 * unit,
                                                                                FontWeight.w900)),
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                bluecolor,
                                                                            height:
                                                                                2,
                                                                            thickness:
                                                                                3,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                  contentChild:
                                                                      Column(
                                                                    children: [
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(flex: 1, child: MyText(context, "Peanuts", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600)),
                                                                              Expanded(
                                                                                  flex: 1,
                                                                                  child: Container(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Icon(
                                                                                        Icons.warning,
                                                                                        color: Colors.redAccent,
                                                                                      )))
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(flex: 1, child: MyText(context, "Wheat", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600)),
                                                                              Expanded(
                                                                                  flex: 1,
                                                                                  child: Container(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Icon(
                                                                                        Icons.warning,
                                                                                        color: Colors.yellow,
                                                                                      )))
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(flex: 1, child: MyText(context, "Tree nuts", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600)),
                                                                              Expanded(
                                                                                  flex: 1,
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerLeft,
                                                                                  ))
                                                                            ],
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  collapsedIcon:
                                                                      Icon(Icons
                                                                          .add),
                                                                  expandedIcon:
                                                                      Icon(Icons
                                                                          .minimize)),
                                                              GFAccordion(
                                                                  expandedTitleBackgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  titleChild: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            alignment: Alignment
                                                                                .centerLeft,
                                                                            child: MyText(
                                                                                context,
                                                                                "Adverse Events",
                                                                                TextAlign.start,
                                                                                Colors.black,
                                                                                14 * unit,
                                                                                FontWeight.w900)),
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                bluecolor,
                                                                            height:
                                                                                2,
                                                                            thickness:
                                                                                3,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                  contentChild:
                                                                      Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child: MyText(
                                                                              context,
                                                                              "Test Content",
                                                                              TextAlign.start,
                                                                              Colors.black87,
                                                                              16 * unit,
                                                                              FontWeight.w400)),
                                                                    ],
                                                                  ),
                                                                  collapsedIcon:
                                                                      Icon(Icons
                                                                          .add),
                                                                  expandedIcon:
                                                                      Icon(Icons
                                                                          .minimize)),
                                                              GFAccordion(
                                                                  expandedTitleBackgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  titleChild: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            alignment: Alignment
                                                                                .centerLeft,
                                                                            child: MyText(
                                                                                context,
                                                                                "Ambulatory Events",
                                                                                TextAlign.start,
                                                                                Colors.black,
                                                                                14 * unit,
                                                                                FontWeight.w900)),
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                bluecolor,
                                                                            height:
                                                                                2,
                                                                            thickness:
                                                                                3,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                  contentChild:
                                                                      Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child: MyText(
                                                                              context,
                                                                              "Test Content",
                                                                              TextAlign.start,
                                                                              Colors.black87,
                                                                              16 * unit,
                                                                              FontWeight.w400)),
                                                                    ],
                                                                  ),
                                                                  collapsedIcon:
                                                                      Icon(Icons
                                                                          .add),
                                                                  expandedIcon:
                                                                      Icon(Icons
                                                                          .minimize)),
                                                              GFAccordion(
                                                                  expandedTitleBackgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  titleChild: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            alignment: Alignment
                                                                                .centerLeft,
                                                                            child: MyText(
                                                                                context,
                                                                                "Medical History",
                                                                                TextAlign.start,
                                                                                Colors.black,
                                                                                14 * unit,
                                                                                FontWeight.w900)),
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                bluecolor,
                                                                            height:
                                                                                2,
                                                                            thickness:
                                                                                3,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                  contentChild:
                                                                      Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              MyText(context, "#MC-0014", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600),
                                                                              MyText(context, "Dental Filing", TextAlign.start, Colors.black87, 16 * unit, FontWeight.w400)
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          margin: EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              MyText(context, "14 Nov 2020", TextAlign.start, Colors.black, 16 * unit, FontWeight.w600),
                                                                              MyText(context, "Dr. Ruby Perrin", TextAlign.start, Colors.black87, 16 * unit, FontWeight.w400)
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          child: Container(
                                                                              alignment: Alignment.center,
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              margin: EdgeInsets.only(top: 25),
                                                                              padding: EdgeInsets.all(15),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: new BorderRadius.circular(12),
                                                                                color: bluecolor,
                                                                                boxShadow: [
                                                                                  new BoxShadow(color: Colors.grey, blurRadius: 3, offset: new Offset(1.0, 1.0))
                                                                                ],
                                                                              ),
                                                                              child: MyText(context, "See Prescriptions", TextAlign.start, Colors.white, 16 * unit, FontWeight.w400))),
                                                                      Container(
                                                                          alignment: Alignment
                                                                              .center,
                                                                          //width: MediaQuery.of(context).size.width * 0.5,
                                                                          margin: EdgeInsets.only(
                                                                              top:
                                                                                  25),
                                                                          padding: EdgeInsets.all(
                                                                              15),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                new BorderRadius.circular(12),
                                                                            color:
                                                                                bluecolor,
                                                                            boxShadow: [
                                                                              new BoxShadow(color: Colors.grey, blurRadius: 3, offset: new Offset(1.0, 1.0))
                                                                            ],
                                                                          ),
                                                                          child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                MyText(context, "CT Scan", TextAlign.start, Colors.white, 16 * unit, FontWeight.w400),
                                                                                MyText(context, "January 2021", TextAlign.start, Colors.white, 16 * unit, FontWeight.w400)
                                                                              ]))
                                                                    ],
                                                                  ),
                                                                  collapsedIcon:
                                                                      Icon(Icons
                                                                          .add),
                                                                  expandedIcon:
                                                                      Icon(Icons
                                                                          .minimize)),
                                                            ],
                                                          ))))
                                        ],
                                      )))),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 32, right: 32, top: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 4, top: 4),
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      if (_addMemberFamilyController
                                              .getOneFamilyModel
                                              .value
                                              .result!
                                              .data!
                                              .userConsent !=
                                          null) {
                                        if (ageval.value > 19) {
                                          _showImageDialog();
                                        } else {
                                          AppToast.toastMessage(
                                              'You haven not any form');
                                        }
                                      } else {
                                        AppToast.toastMessage(
                                            'You haven not uploaded any form');
                                      }

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const AddFamily()),
                                      // );
                                    },
                                    child: Container(
                                      height: 80 * unit,
                                      width: 80 * unit,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        // image: DecorationImage(
                                        //   image: NetworkImage(profile != null
                                        //       ? "http://31.220.59.179/uploads/${profile!.userImage!}"
                                        //       : ""),
                                        //   fit: BoxFit.cover,
                                        // ),
                                        borderRadius:
                                            BorderRadius.circular(50 * unit),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.receipt,
                                              color: Colors.white,
                                            ),
                                            MyText(
                                                context,
                                                "Form",
                                                TextAlign.start,
                                                Colors.black87,
                                                16 * unit,
                                                FontWeight.w800),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 0, top: 0),
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      selectDate();
                                    },
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           ScheduleScreen()),
                                    // );
                                    //  },
                                    child: Container(
                                        height: 80 * unit,
                                        width: 80 * unit,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[600],
                                          // image: DecorationImage(
                                          //   image: NetworkImage(profile != null
                                          //       ? "http://31.220.59.179/uploads/${profile!.userImage!}"
                                          //       : ""),
                                          //   fit: BoxFit.cover,
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(50 * unit),
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.replay,
                                                color: Colors.white,
                                              ),
                                              MyText(
                                                  context,
                                                  "Schedules",
                                                  TextAlign.start,
                                                  Colors.black87,
                                                  16 * unit,
                                                  FontWeight.w800),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 25),
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isOpen = !isOpen;
                                });
                              },
                              child: Container(
                                height: 80 * unit,
                                width: 80 * unit,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  // image: DecorationImage(
                                  //   image: NetworkImage(profile != null
                                  //       ? "http://31.220.59.179/uploads/${profile!.userImage!}"
                                  //       : ""),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  borderRadius:
                                      BorderRadius.circular(50 * unit),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: isOpen
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.keyboard_arrow_up,
                                            color: Colors.black87,
                                          ),
                                          MyText(
                                              context,
                                              "Close",
                                              TextAlign.start,
                                              Colors.black87,
                                              16 * unit,
                                              FontWeight.w800)
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MyText(
                                              context,
                                              "Details",
                                              TextAlign.start,
                                              Colors.black87,
                                              16 * unit,
                                              FontWeight.w800),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black87,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Padding(
                      //     padding: EdgeInsets.only(top: 20*unit),
                      //     child: RightIconBtn(context,Icons.domain_verification ,bluecolor,"Vaccine Verification",20.0*unit,45*unit,280*unit,onverification)
                      // ),
                    )
                  : progressindicator(context),
            ),
          ));
  }

  Future<void> _showImageDialog() async {
    double unit = (MediaQuery.of(context).size.height) * heightunit +
        (MediaQuery.of(context).size.width) * widthunit;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          height: 100 * unit,
          width: 100 * unit,
          color: Colors.white,
          //margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: [
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
                    MyText(Get.context!, "Back", TextAlign.start, Colors.black,
                        16 * unit, FontWeight.w400),
                  ],
                ),
              ),
            ),
            CachedNetworkImage(
              imageUrl: profile != null
                  ? "http://31.220.59.179/uploads/${_addMemberFamilyController.getOneFamilyModel.value.result!.data!.userConsent}"
                  : "",
              placeholder: (context, url) => GFLoader(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          ]),
        );
      },
    );
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime.now(),
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(primary: Colors.blue),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.blue, // button text color
                ),
              ), //selection color
            ),
            child: child!,
          );
        });
    if (pickedDate != null && pickedDate != currentDate)
      currentDate = pickedDate;
    setState(() {});
  }
}
