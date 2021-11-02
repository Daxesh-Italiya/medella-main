import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:medella/models/hospital_response_entity.dart';

import 'Components/api.dart';
import 'Components/const_details.dart';
import 'Components/utils.dart';

typedef StringToVoidFunc = void Function(String);


class HospitalPage extends StatefulWidget {
  final List<String> selectedHospitals;
  final  StringToVoidFunc onDone;

  HospitalPage(this.selectedHospitals,this.onDone);

  @override
  _HospitalPage createState() => new _HospitalPage();
}

class _HospitalPage extends State<HospitalPage> {
  List<String> selectedHospitals = [];
  List<HospitalResponseResultData> hospitals = [];

  List<HospitalResponseResultData> searchedList = [];

  TextEditingController search = TextEditingController();

  String searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.selectedHospitals = widget.selectedHospitals;
    loadHospitalsData();
  }

  void loadHospitalsData() async {
    HospitalResponseEntity entity = await allHospitals(context);
    if ((entity.status ?? "fail") == "success") {
      setState(() {
        hospitals = entity.result!.data!;
        searchedList = hospitals;
      });
    }
  }

  onSearchTextChanged(String text) {


    setState(() {
      //searchedList.clear();
      searchText = text;
    });

    print("hospital size - ${hospitals.length}");

    if (searchText.isEmpty) {

      //searchedList.clear();
      //List<HospitalResponseResultData> lists = List.from(hospitals);
      searchedList = List.from(hospitals);

    }else{

      List<HospitalResponseResultData> lists = List.from(hospitals);
      searchedList = lists.where((hospital) => hospital.hospitalName!.toLowerCase().contains(searchText.toLowerCase())).toList();

    }


    setState(() {
      // searchedList.clear();
      // searchedList.addAll(lists.map((e) => e).toList());
    });

    // if (text.isEmpty) {
    //   setState(() {
    //
    //     List<HospitalResponseResultData> lists = [...hospitals];
    //
    //     searchedList.addAll(lists);
    //
    //   });
    //   return;
    // }

    // List.generate(hospitals.length, (index) {
    //   if (hospitals[index].hospitalName!.contains(text) || text.isEmpty) {
    //     setState(() {
    //       searchedList.add(hospitals[index]);
    //     });
    //   }
    // });





    // hospitals.forEach((hospital) {
    //
    //
    // });


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build




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
        actions: [
          Container(
              padding: EdgeInsets.only(right: 20 * unit),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  widget.onDone( json.encode(selectedHospitals));
                  Get.back();
                  //Get.back(result: json.encode(selectedHospitals));
                },
                child: MyText(context, "Done", TextAlign.center, bluecolor,
                    16 * unit, FontWeight.w600),
              )),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
            padding: EdgeInsets.only(top: 20 * unit),
            child: MyTextField(
                context,
                Icons.search,
                "Search by name",
                20 * unit,
                TextInputType.text,
                false,
                search,
                35 * unit,
                300 * unit,
                iconColor: Colors.grey,
                isSearch: true,
                onChange: (value) {
                  //print("search - $value");
                  onSearchTextChanged(value);
                })),
            searchText.isNotEmpty
                ?ListView.builder(
          shrinkWrap: true,
              key: UniqueKey(),
          itemCount: searchedList.length,
          itemBuilder: (context, index) {
            bool isChecked = selectedHospitals
                .contains(searchedList[index].hospitalName ?? "");

            return GFCheckboxListTile(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              //margin: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
              margin: EdgeInsets.only(top: 8, left: 15),
              //margin: EdgeInsets.symmetric(vertical: 10),
              //size: 25,
              inactiveIcon: Icon(
                Icons.check_box_outline_blank_rounded,
                size: 25,
              ),
              activeIcon: Icon(
                Icons.check_box_rounded,
                size: 25,
                color: bluecolor,
              ),
              //icon: Icon(Icons.check_box),
              activeBorderColor: Colors.transparent,
              inactiveBorderColor: Colors.transparent,
              position: GFPosition.start,
              activeBgColor: Colors.transparent,
              inactiveBgColor: Colors.transparent,
              title: Container(
                  alignment: Alignment.centerLeft,
                  child: MyText(
                      context,
                      searchedList[index].hospitalName ?? "",
                      TextAlign.start,
                      blackcolor,
                      18 * unit,
                      FontWeight.normal)),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    selectedHospitals.add(searchedList[index].hospitalName ?? "");
                  } else {
                    selectedHospitals
                        .remove(searchedList[index].hospitalName ?? "");
                  }
                });
              },
            );
          },
        ):ListView.builder(
              shrinkWrap: true,
              key: UniqueKey(),
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                bool isChecked = selectedHospitals
                    .contains(hospitals[index].hospitalName ?? "");

                return GFCheckboxListTile(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  //margin: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                  margin: EdgeInsets.only(top: 8, left: 15),
                  //margin: EdgeInsets.symmetric(vertical: 10),
                  //size: 25,
                  inactiveIcon: Icon(
                    Icons.check_box_outline_blank_rounded,
                    size: 25,
                  ),
                  activeIcon: Icon(
                    Icons.check_box_rounded,
                    size: 25,
                    color: bluecolor,
                  ),
                  //icon: Icon(Icons.check_box),
                  activeBorderColor: Colors.transparent,
                  inactiveBorderColor: Colors.transparent,
                  position: GFPosition.start,
                  activeBgColor: Colors.transparent,
                  inactiveBgColor: Colors.transparent,
                  title: Container(
                      alignment: Alignment.centerLeft,
                      child: MyText(
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
                        selectedHospitals.add(hospitals[index].hospitalName ?? "");
                      } else {
                        selectedHospitals
                            .remove(hospitals[index].hospitalName ?? "");
                      }
                    });
                  },
                );
              },
            ),
      ])),
    );
  }
}
