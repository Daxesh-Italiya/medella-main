import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medella/hospital_page.dart';
import 'package:medella/models/hospital_response_entity.dart';
import 'package:multiselect/multiselect.dart';
import 'Components/api.dart';
import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'register_step_3.dart';
import 'package:getwidget/getwidget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RegisterStep2 extends StatefulWidget {
  RegisterStep2(this.token, this.name, this.security, this.dob,
      this.profile_image, this.id_image);

  String token, name, security, dob, profile_image, id_image;

  @override
  _RegisterStep2 createState() =>
      new _RegisterStep2(token, name, security, dob, profile_image, id_image);
}

class _RegisterStep2 extends State<RegisterStep2> {
  _RegisterStep2(token, name, security, dob, profile_image, id_image);

  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isloading = true;
  var statedata = [];
  var citydata = [];
  List<String> selectedHospitals = [];
  String city = '';
  String state = '';

  //String hospital='';

  List<HospitalResponseResultData> hospitals = [];

  TextEditingController name = TextEditingController();

  @override
  void initState() {
    getstatedata();
    loadHospitalsData();

    name.text = "Hospital List";
  }

  void loadHospitalsData() async {
    HospitalResponseEntity entity = await allHospitals(context);
    if ((entity.status ?? "fail") == "success") {
      hospitals = entity.result!.data!;
    }
  }

  void getstatedata() async {
    var res = await getstate(context, "United States");
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      setState(() {
        statedata = data;
        isloading = false;
      });
    } else {
      setState(() {
        isloading = false;
      });
      aleart(context, "Not fetching data", false);
    }
  }

  void getcitydata(String statename) async {
    var res = await getcity(context, statename);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      setState(() {
        city = data[0]['city_name'];
        citydata = data;
      });
    } else {
      setState(() {
        isloading = false;
      });
      aleart(context, "Not fetching data", false);
    }
  }

  void onback() {
    Navigator.pop(context);
  }

  void onsubmit() {
    if (state != '' && city != '' && selectedHospitals.isNotEmpty) {
      if (isChecked1 == true && isChecked2 == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          List<int> hospitalList = hospitals
              .where((element) =>
                  selectedHospitals.contains(element.hospitalName!))
              .toList()
              .map((e) => e.id!)
              .toList();

          return RegisterStep3(
              widget.token,
              widget.name,
              widget.security,
              widget.dob,
              widget.profile_image,
              widget.id_image,
              state,
              city,
              hospitalList);
        }));
      } else {
        aleart(context, "Please Accept the Terms & Conditions", false);
      }
    } else {
      aleart(context, "All Details are Required.", false);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // user must tap button!
      builder: (BuildContext context) {


        return AlertDialog(
          title: Text('Select Hospital'),
          content: StatefulBuilder(  // You need this, notice the parameters below:
          builder: (BuildContext context, StateSetter setState) {

            double unit = (MediaQuery.of(context).size.height) * heightunit +
                (MediaQuery.of(context).size.width) * widthunit;

        return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: List.generate(hospitals.length, (index) {
                    bool isChecked = selectedHospitals
                        .contains(hospitals[index].hospitalName ?? "");

                    return GFCheckboxListTile(
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      size: 25,
                      position: GFPosition.start,
                      activeBgColor: bluecolor,
                      title: MyText(
                          context,
                          hospitals[index].hospitalName ?? "",
                          TextAlign.start,
                          blackcolor,
                          18 * unit,
                          FontWeight.normal),
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            selectedHospitals
                                .add(hospitals[index].hospitalName ?? "");
                          } else {
                            selectedHospitals
                                .remove(hospitals[index].hospitalName ?? "");
                          }
                        });
                      },
                    );

                    return MyText(
                        context,
                        hospitals[index].hospitalName ?? "",
                        TextAlign.start,
                        blackcolor,
                        18 * unit,
                        FontWeight.normal);
                  }),
                )
              ],
            ),
          );}),
        /*  actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],*/
        );
      },
    ).then((value) {
      setState(() {

      });
    });
  }

  Widget build(BuildContext context) {
    double w = (MediaQuery.of(context).size.width);
    double unit = (MediaQuery.of(context).size.height) * heightunit +
        (MediaQuery.of(context).size.width) * widthunit;
    return Scaffold(
      body: SafeArea(
        child: isloading == false
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppHeader(context, 2, Icons.local_hospital_outlined,
                          "Hospital Information"),
                      Padding(
                        padding: EdgeInsets.only(top: 30 * unit),
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
                                      Icons.location_city_rounded,
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
                                child: DropdownButtonFormField<dynamic>(
                                  isExpanded: true,
                                  hint: MyText(
                                      context,
                                      "State",
                                      TextAlign.start,
                                      greycolor,
                                      15 * unit,
                                      FontWeight.normal),
                                  items: statedata
                                      .map((label) => DropdownMenuItem(
                                            child: MyText(
                                                context,
                                                label["state_name"],
                                                TextAlign.start,
                                                blackcolor,
                                                18 * unit,
                                                FontWeight.normal),
                                            value: label["state_name"],
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      state = value;
                                    });
                                    getcitydata(state);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
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
                                      Icons.location_city_rounded,
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
                                child: DropdownButtonFormField<dynamic>(
                                  isExpanded: true,
                                  hint: MyText(context, "City", TextAlign.start,
                                      greycolor, 15 * unit, FontWeight.normal),
                                  items: citydata
                                      .map((label) => DropdownMenuItem(
                                            child: MyText(
                                                context,
                                                label["city_name"],
                                                TextAlign.start,
                                                blackcolor,
                                                18 * unit,
                                                FontWeight.normal),
                                            value: label["city_name"],
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      city = value;
                                    });
                                    //getcitydata(value);
                                  },
                                  value: city,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10 * unit),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 12 * unit, right: 20 * unit),
                          width: 300 * unit,
                          // decoration: BoxDecoration(
                          //   border: Border.all(
                          //     color: bluecolor,
                          //     width: 3 * unit,
                          //   ),
                          //   borderRadius: BorderRadius.circular(30 * unit),
                          // ),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40 * unit,
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Icon(
                                      Icons.local_hospital,
                                      color: bluecolor,
                                      size: 25 * unit,
                                      semanticLabel:
                                          'Text to announce in accessibility modes',
                                    )),

                                  ],
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      //_showMyDialog();
                                    },
                                    child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text("Hospital Network",
                                            style: TextStyle(
                                                fontSize: 20 * unit))))

                                /*MultiSelectChipField(
                            items: hospitals.map((e) => MultiSelectItem<String>(e.hospitalName??"",e.hospitalName??"")).toList(),
                            initialValue: [],
                            title: Text("Hospitals"),
                            headerColor: Colors.transparent,
                            //height: 50,
                            scroll: false,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent, width: 0),
                            ),
                            //showHeader: false,
                            selectedChipColor: bluecolor,
                            selectedTextStyle: TextStyle(color: Colors.white),
                            onTap: (values) {

                              print("$values");
                            },
                            onSaved: (newValue) {
                              print(newValue!.length);
                            },
                            // onSaved: (newValue) {
                            //   setState(() {
                            //     //selectedHospitals = newValue ?? [];
                            //   });
                            // },
                          )*/

                                /* MultiSelectBottomSheetField(
                            initialChildSize: 0.4,
                            listType: MultiSelectListType.CHIP,
                            searchable: false,
                            buttonText: Text("Hospitals - ${selectedHospitals.length}"),
                            title: Text("Hospitals"),
                            initialValue: [],
                            items: hospitals.map((e) => MultiSelectItem<String>(e.hospitalName??"",e.hospitalName??"")).toList(),

                            onConfirm: (values) {

                              setState(() {
                                selectedHospitals = values.map((e) => "$e").toList();
                              });
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              onTap: (value) {
                                setState(() {
                                  selectedHospitals.remove(value);
                                });
                              },
                            ),
                          )*/

                                /*GFMultiSelect<String>(
                            items: List.generate(hospitals.length, (index) => hospitals[index].hospitalName??""),
                            onSelect: (value) {
                              //print('selected $value ');
                            },
                            dropdownTitleTileText: 'Select Hospitals',
                            dropdownTitleTileMargin: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                            dropdownTitleTilePadding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                            dropdownTitleTileColor: Colors.transparent,
                            dropdownUnderlineBorder:
                            const BorderSide(color: Colors.transparent, width: 0),
                            dropdownTitleTileBorder:
                            Border.all(color: Colors.transparent, width: 0),
                            dropdownTitleTileBorderRadius: BorderRadius.circular(0),
                            expandedIcon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Colors.black54,
                            ),
                            collapsedIcon: const Icon(
                              Icons.arrow_drop_up_outlined,
                              color: Colors.black54,
                            ),
                            submitButton: Text('OK'),
                            cancelButton: Text('Cancel'),
                            dropdownTitleTileTextStyle:
                             TextStyle(fontSize: 18*unit, color:Colors.black,fontWeight: FontWeight.normal),
                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                            type: GFCheckboxType.circle,
                            activeBgColor: bluecolor,
                            activeBorderColor: bluecolor,
                            inactiveBorderColor: Colors.grey,
                            activeIcon:Icon(Icons.check,color: Colors.white,),
                          )*/

                                /*DropDownMultiSelect(
                            //hint: MyText(context,"Hospital Network",TextAlign.start,greycolor,18*unit,FontWeight.normal),
                            onChanged: (List<String> x) {
                              setState(() {
                                selectedHospitals = x;
                              });
                            },
                            options: List.generate(hospitals.length, (index) => hospitals[index].hospitalName??""),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            isDense: false,
                            //menuItembuilder: (option) => MyText(context,option,TextAlign.start,blackcolor,18*unit,FontWeight.normal),
                            //childBuilder: (selectedValues) => MyText(context,selectedValues,TextAlign.start,blackcolor,18*unit,FontWeight.normal),
                            selectedValues: selectedHospitals,
                            whenEmpty: 'Select Hospitals',
                          )*/

                                /* DropdownButtonFormField<String>(
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
                          )*/
                                ,
                              ),


                              GFIconButton(
                                onPressed: () async{

                                  Get.to(HospitalPage(selectedHospitals,(list){
                                   List<dynamic> listData = json.decode(list);

                                   setState(() {
                                     selectedHospitals = listData.map((e) => "$e").toList();
                                   });
                                 }));




                                },
                                size: 15,
                                iconSize: 25,
                                padding: EdgeInsets.all(0),
                                icon: Icon(Icons.add,),
                                color: bluecolor,
                                shape: GFIconButtonShape.pills,
                              ),
                              
                            ],
                          ),
                        ),
                      ),


                  Container(
                    //margin: EdgeInsets.only(top: 10 * unit),
                    padding: EdgeInsets.only(
                        left: 10 * unit, right: 20 * unit),
                    child:ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedHospitals.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            padding: EdgeInsets.only(
                            left: 20 * unit, right: 20 * unit),
                        decoration: BoxDecoration(
                        border: Border.all(
                        color: bluecolor,
                        width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8 * unit),
                        ),
                        child:GFListTile(
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                          avatar: Icon(Icons.check_box_rounded,size: 20,color: bluecolor,),

                          title: Container(
                              alignment: Alignment.centerLeft,
                              child:MyText(
                                  context,
                                  selectedHospitals[index],
                                  TextAlign.start,
                                  blackcolor,
                                  18 * unit,
                                  FontWeight.normal)),
                        ));
                      },
                    )),


               /* Container(
                  margin: EdgeInsets.only(top: 10 * unit),
                  padding: EdgeInsets.only(
                      left: 10 * unit, right: 20 * unit),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: hospitals.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 4,
                        crossAxisCount: 2),
                    itemBuilder: (_, index) {

                      bool isChecked = selectedHospitals
                          .contains(hospitals[index].hospitalName ?? "");

                      return GFCheckboxListTile(
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        //margin: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                        margin: EdgeInsets.only(top: 8,left: 15),
                        //margin: EdgeInsets.symmetric(vertical: 10),
                        //size: 25,
                        inactiveIcon: Icon(Icons.check_box_outline_blank_sharp,size: 25,),
                        activeIcon: Icon(Icons.check_box_sharp,size: 25,color: bluecolor,),
                        //icon: Icon(Icons.check_box),
                        activeBorderColor: Colors.transparent,
                        inactiveBorderColor: Colors.transparent,
                        position: GFPosition.start,
                        activeBgColor: Colors.transparent,
                        inactiveBgColor: Colors.transparent,
                        title: Container(
                            alignment: Alignment.centerLeft,
                            child:MyText(
                            context,
                            hospitals[index].hospitalName ?? "",
                            TextAlign.start,
                            blackcolor,
                            18 * unit,
                            FontWeight.normal)),
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            if (value) {
                              selectedHospitals
                                  .add(hospitals[index].hospitalName ?? "");
                            } else {
                              selectedHospitals
                                  .remove(hospitals[index].hospitalName ?? "");
                            }
                          });
                        },
                      );

                    }),
                ),*/


                /*  Padding(
                    padding: EdgeInsets.only(top: 10 * unit),
                    child:Container(
                        padding: EdgeInsets.only(
                            left: 20 * unit, right: 20 * unit),
                        child:ListView(
                      shrinkWrap: true,
                      children: List.generate(selectedHospitals.length, (index) => GFListTile(
                        avatar: Icon(Icons.circle,size: 10,),
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        title: MyText(
                            context,
                            selectedHospitals[index],
                            TextAlign.start,
                            Colors.black,
                            15 * unit,
                            FontWeight.normal),
                      )),
                    ))),*/


                      Padding(
                        padding: EdgeInsets.only(top: 20 * unit),
                        child: Container(
                          width: 300 * unit,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked1 = value!;
                                      });
                                    },
                                    value: isChecked1,
                                    activeColor: bluecolor,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0 * unit),
                                      child: MyText(
                                          context,
                                          "I would like to participate in medella's emergency response program that grants all licensed providers to view your "
                                          "records in case of emergency or immediate need. ",
                                          TextAlign.start,
                                          greycolor,
                                          15 * unit,
                                          FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10 * unit),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked2 = value!;
                                        });
                                      },
                                      value: isChecked2,
                                      activeColor: bluecolor,
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding:
                                              EdgeInsets.only(top: 0 * unit),
                                          child: MyText(
                                              context,
                                              "I agree to the terms and conditions stated here ",
                                              TextAlign.start,
                                              greycolor,
                                              15 * unit,
                                              FontWeight.normal)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 80 * unit),
                        child: Container(
                          width: 300 * unit,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LeftIconBtn(
                                  context,
                                  Icons.arrow_back,
                                  redcolor,
                                  "Back",
                                  20.0 * unit,
                                  45 * unit,
                                  145 * unit,
                                  onback),
                              LeftIconBtn(
                                  context,
                                  Icons.done,
                                  bluecolor,
                                  "Submit",
                                  20.0 * unit,
                                  45 * unit,
                                  145 * unit,
                                  onsubmit)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : progressindicator(context),
      ),
    );
  }
}
