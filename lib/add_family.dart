import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medella/Components/api.dart';
import 'package:medella/edit_profile.dart';
import 'package:medella/models/get_family_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/const_details.dart';
import 'Components/utils.dart';
import 'add_family_member.dart';
import 'models/controller/authentication_controller.dart';
import 'models/get_me_response_entity.dart';

class AddFamily extends StatelessWidget {
  final AddMemberFamilyController _addMemberFamilyController =
      Get.put(AddMemberFamilyController());

  AddFamily({Key? key}) : super(key: key) {
    _addMemberFamilyController.getAllFamily();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Obx(
        () => !_addMemberFamilyController.isLoading.value
            ? body()
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  PreferredSizeWidget appbar() {
    double unit = (MediaQuery.of(Get.context!).size.height) * heightunit +
        (MediaQuery.of(Get.context!).size.width) * widthunit;
    return AppBar(
      title: Image.asset(
        'Assets/logo_horizontal.png',
        fit: BoxFit.contain,
        height: 35 * unit,
      ),
      backgroundColor: Colors.white,
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
    );
  }

  Widget body() {
    double unit = (MediaQuery.of(Get.context!).size.height) * heightunit +
        (MediaQuery.of(Get.context!).size.width) * widthunit;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  MyText(Get.context!, "Back", TextAlign.start, Colors.black,
                      16 * unit, FontWeight.w400),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    Get.context!,
                    MaterialPageRoute(
                        builder: (context) => const AddFamilyMember()),
                  );
                },
                child: Container(
                  height: 50 * unit,
                  width: 250 * unit,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      MyText(
                          Get.context!,
                          "Add a Family Member",
                          TextAlign.start,
                          Colors.white,
                          17 * unit,
                          FontWeight.w600),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30 * unit),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: MyText(Get.context!, "Family Member", TextAlign.start,
                Colors.black, 17 * unit, FontWeight.w600),
          ),
          SizedBox(height: 30 * unit),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [familyMemberTable(unit)],
            ),
          )
        ],
      ),
    );
  }

  Widget familyMemberTable(double unit) {
    List<Datum>? familyMemberList =
        _addMemberFamilyController.getAllFamilyModel.value.result?.data;
    print("family member list... $familyMemberList");
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: familyMemberList != null ? familyMemberList.length : 0,
      itemBuilder: (context, int index) {
        return InkWell(
          onTap: () async {
            await _addMemberFamilyController
                .getOneFamily(familyMemberList?[index].id ?? 0);
          },
          child: Card(
            color: Colors.white.withOpacity(.9),
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.white, width: 4)),
            child: Container(
              height: 36,
              width: 180,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(top: 8, bottom: 8),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 32,
                      ),
                      const SizedBox(width: 10),
                      Text(familyMemberList?[index].username ?? "",
                          style: const TextStyle(fontSize: 22)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.fromLTRB(10 * unit, 0, 10 * unit, 0),
                          child: VerticalLine(context, 1.5 * unit, 25 * unit)),
                      Text(
                        '${calculateAge(familyMemberList![index].dob!)}',
                        style: const TextStyle(fontSize: 25),
                      ),
                      Text('Year', style: const TextStyle(fontSize: 12))
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Expanded(
          //       child: Container(
          //         height: 30,
          //         decoration: const BoxDecoration(
          //           border: Border(
          //             right: BorderSide(
          //               //
          //               color: Colors.black,
          //             ),
          //             left: BorderSide(
          //               //
          //               color: Colors.black,
          //             ),
          //             bottom: BorderSide(
          //               //
          //               color: Colors.black,
          //             ),
          //           ),
          //         ),
          //         child: Center(
          //           child: MyText(
          //               Get.context!,
          //               familyMemberList?[index].username ?? "",
          //               TextAlign.start,
          //               Colors.black,
          //               17 * unit,
          //               FontWeight.w600),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         height: 30,
          //         decoration: const BoxDecoration(
          //           border: Border(
          //             right: BorderSide(
          //               //
          //               color: Colors.black,
          //             ),
          //             bottom: BorderSide(
          //               //
          //               color: Colors.black,
          //             ),
          //           ),
          //         ),
          //         child: Center(
          //           child: familyMemberList==null?const Center(
          //             child: GFLoader(),
          //           ):MyText(
          //               Get.context!,
          //               calculateAge(familyMemberList[index].dob ?? "")
          //                   .toString(),
          //               TextAlign.start,
          //               Colors.black,
          //               17 * unit,
          //               FontWeight.w600),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        );
      },
    );
  }

  void onprofile() {
    Get.to(() => EditProfile())!.then((value) => getdata());
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return EditProfile();
    // })).then((value) {
    //   getdata();
    // });
  }

  void getdata() async {
    GetMeResponseEntity? responseEntity = await getMe(Get.context!);

    if (responseEntity == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Get.offAllNamed("/");
      return;
    }
  }

  int calculateAge(String birthDateAge) {
    String date = birthDateAge.split("-")[0].toString();
    String month = birthDateAge.split("-")[1].toString();
    String year = birthDateAge.split("-")[2].toString();
    int year1 = int.parse(year);
    String formatDate = "$year-$month-$date";
    print("dateeeeee ...${DateTime.now().year}");
    int age = int.parse(DateTime.now().year.toString()) - year1;
    // DateTime birthDate = DateTime.parse(formatDate);
    // DateTime currentDate = DateTime.now();
    // int age = currentDate.year - birthDate.year;
    // int month1 = currentDate.month;
    // int month2 = birthDate.month;
    // if (month2 > month1) {
    //   age--;
    // } else if (month1 == month2) {
    //   int day1 = currentDate.day;
    //   int day2 = birthDate.day;
    //   if (day2 > day1) {
    //     age--;
    //   }
    // }
    return age;
  }
}
