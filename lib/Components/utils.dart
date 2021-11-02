import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'const_details.dart';
import 'package:image_picker/image_picker.dart';

Widget HorizontalLine(BuildContext context, double w, double h) {
  return Container(
    width: w,
    height: h,
    color: bluecolor,
  );
}

Widget VerticalLine(BuildContext context, double w, double h) {
  return Container(
    width: w,
    height: h,
    color: greycolor,
  );
}

Widget progressindicator(BuildContext context) {
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            strokeWidth: 3 * unit,
          ),
          Padding(
              padding: EdgeInsets.only(top: 20 * unit),
              child: MyText(context, "Please wait", TextAlign.center, greycolor,
                  17 * unit, FontWeight.w800)),
        ],
      ),
    ),
  );
}

Widget imageicon(BuildContext context, String name, double size) {
  return Image(
    image: AssetImage('Assets/' + name),
    height: size,
    width: size,
  );
}

aleart(BuildContext context, String message, bool status) async {
  void onclick() {
    Navigator.of(context).pop();
  }

  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 300 * unit,
            height: 300 * unit,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'Assets/logo_horizontal.png',
                    fit: BoxFit.contain,
                    height: 50 * unit,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15 * unit),
                      child: HorizontalLine(context, 200 * unit, 2 * unit)),
                  Padding(
                    padding: EdgeInsets.only(top: 20 * unit),
                    child: Container(
                      width: 40 * unit,
                      height: 40 * unit,
                      decoration: BoxDecoration(
                        color: status ? bluecolor : redcolor,
                        border: Border.all(
                          color: whitecolor,
                          width: 2 * unit,
                        ),
                        borderRadius: BorderRadius.circular(20 * unit),
                      ),
                      child: Icon(
                        status ? Icons.done : Icons.cancel_outlined,
                        color: whitecolor,
                        size: 35 * unit,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20 * unit),
                      child: MyText(
                          context,
                          message,
                          TextAlign.center,
                          status ? bluecolor : redcolor,
                          17 * unit,
                          FontWeight.w800)),
                  Padding(
                      padding: EdgeInsets.only(top: 15 * unit),
                      child: LeftIconBtn(context, Icons.done, bluecolor, "Ok",
                          20.0 * unit, 45 * unit, 200 * unit, onclick)),
                ],
              ),
            ),
          ),
        );
      });
}

Widget MyText(BuildContext context, String label, TextAlign alignment,
    Color clr, double size, FontWeight weight) {
  return Text(label,
      textAlign: alignment,
      style: TextStyle(
          fontSize: size,
          color: clr,
          fontWeight: weight,
          fontFamily: "design.graffiti.comicsansms",
          letterSpacing: 0));
}

typedef StringToVoidFunc = void Function(String);

// Widget myDateTextfield(
//   BuildContext context,
//   IconData iconname,
//   String label,
//   double labelsize,
//   TextInputType inputType,
//   bool flag,
//   TextEditingController data,
//   double h,
//   double w,
// ) {
//   return TextFormField();
// }

Widget MyDateTextField(BuildContext context, IconData iconname, String label,
    double labelsize, bool flag, double h, double w,
    {bool isSSC = false,
    bool readOnly = false,
    bool isSearch = false,
    String? initialVal,
    bool enable = true,
    Color? iconColor,
    StringToVoidFunc? onChange}) {
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '###-##-####', filter: {"#": RegExp(r'[0-9]')});

  return Container(
    width: w,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            readOnly: readOnly,
            enabled: enable,
            onChanged: (value) {
              if (onChange != null) {
                onChange(value);
              }
            },
            textAlignVertical: TextAlignVertical.center,
            //controller: data,
            obscureText: flag,
            keyboardType: TextInputType.none,
            textInputAction:
                isSearch ? TextInputAction.search : TextInputAction.done,
            inputFormatters: <TextInputFormatter>[
              if (isSSC) maskFormatter
              //FilteringTextInputFormatter.allow(RegExp(r'^(?!666|000|9\\d{2})\\d{3}-(?!00)\\d{2}-(?!0{4})\\d{4}$')),
            ],
            style: TextStyle(
              fontSize: labelsize,
              color: blackcolor,
            ),
            //initialValue: initialVal??'',
            decoration: InputDecoration(
              filled: readOnly,

              fillColor:
                  readOnly ? Colors.grey.withOpacity(0.5) : Colors.transparent,
                  suffixIcon: const Icon(Icons.keyboard_arrow_up),
              prefixIcon: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 20 * unit),
                  child: Container(
                    width: 50 * unit,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          iconname,
                          color: iconColor ?? bluecolor,
                          size: 25 * unit,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        Padding(
                            padding:
                                EdgeInsets.fromLTRB(10 * unit, 0, 10 * unit, 0),
                            child:
                                VerticalLine(context, 1.5 * unit, 25 * unit)),
                      ],
                    ),
                  ),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                borderRadius: BorderRadius.circular(h),
              ),

              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: bluecolor, width: 3 * unit),
              //   borderRadius: BorderRadius.circular(h),
              // ),
              hintText: label,

              hintStyle: TextStyle(
                fontSize: labelsize*0.8,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
              contentPadding:
                  EdgeInsets.fromLTRB(0, 12 * unit, 20 * unit, 12 * unit),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget MyTextField(
    BuildContext context,
    IconData iconname,
    String label,
    double labelsize,
    TextInputType inputType,
    bool flag,
    TextEditingController data,
    double h,
    double w,
    {bool isSSC = false,
    bool readOnly = false,
    bool isSearch = false,
    String? initialVal,
    bool enable = true,
    Color? iconColor,
    StringToVoidFunc? onChange}) {
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '###-##-####', filter: {"#": RegExp(r'[0-9]')});

  return Container(
    width: w,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            readOnly: readOnly,
            //enabled: enable,
            onChanged: (value) {
              if (onChange != null) {
                onChange(value);
              }
            },
            textAlignVertical: TextAlignVertical.center,
            controller: data,
            obscureText: flag,
            keyboardType: inputType,
            textInputAction:
                isSearch ? TextInputAction.search : TextInputAction.done,
            inputFormatters: <TextInputFormatter>[
              if (isSSC) maskFormatter
              //FilteringTextInputFormatter.allow(RegExp(r'^(?!666|000|9\\d{2})\\d{3}-(?!00)\\d{2}-(?!0{4})\\d{4}$')),
            ],
            style: TextStyle(
              fontSize: labelsize,
              color: blackcolor,
            ),
            decoration: InputDecoration(
              filled: readOnly,
              fillColor:
                  readOnly ? Colors.grey.withOpacity(0.5) : Colors.transparent,
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 20 * unit),
                child: Container(
                  width: 50 * unit,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        iconname,
                        color: iconColor ?? bluecolor,
                        size: 25 * unit,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      Padding(
                          padding:
                              EdgeInsets.fromLTRB(10 * unit, 0, 10 * unit, 0),
                          child: VerticalLine(context, 1.5 * unit, 25 * unit)),
                    ],
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                borderRadius: BorderRadius.circular(h),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                borderRadius: BorderRadius.circular(h),
              ),
              hintText: label,
              hintStyle: TextStyle(
                fontSize: labelsize*0.8,
                fontWeight:FontWeight.w300,
                color: Colors.black,
              ),
              contentPadding:
                  EdgeInsets.fromLTRB(0, 12 * unit, 20 * unit, 12 * unit),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget MobileTextField(
    BuildContext context,
    IconData iconname,
    String label,
    double labelsize,
    TextInputType inputType,
    bool flag,
    TextEditingController data,
    double h,
    double w) {
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;
  return Container(
    width: w,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: data,
            maxLength: 10,
            obscureText: flag,
            keyboardType: inputType,
            style: TextStyle(
              fontSize: labelsize,
              color: blackcolor,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 20 * unit),
                child: Container(
                  width: 50 * unit,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        iconname,
                        color: bluecolor,
                        size: 25 * unit,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      Padding(
                          padding:
                              EdgeInsets.fromLTRB(10 * unit, 0, 10 * unit, 0),
                          child: VerticalLine(context, 1.5 * unit, 25 * unit)),
                    ],
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                borderRadius: BorderRadius.circular(h),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                borderRadius: BorderRadius.circular(h),
              ),
              hintText: label,
              hintStyle: TextStyle(
                fontSize: labelsize,
                color: greycolor,
              ),
              contentPadding:
                  EdgeInsets.fromLTRB(0, 12 * unit, 20 * unit, 12 * unit),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget otptextfield(
    BuildContext context, double w, TextEditingController data, int pos) {
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;
  return Container(
      width: w,
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: data,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: TextStyle(fontSize: w * 0.5, color: blackcolor),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                  borderRadius: BorderRadius.circular(w * 0.33),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                  borderRadius: BorderRadius.circular(w * 0.33),
                ),
                contentPadding: EdgeInsets.all(w * 0.25),
                counterText: '',
              ),
              onChanged: (value) {
                if (value.length == 0) {
                  if (pos != 1) {
                    FocusScope.of(context).previousFocus();
                  }
                } else {
                  if (pos != 6) {
                    FocusScope.of(context).nextFocus();
                  }
                }
              },
            ),
          ],
        ),
      ));
}

Widget MyBodyHeader(BuildContext context) {
  //223
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;
  return Column(
    children: [
      Image(image: AssetImage('Assets/logo_vertical.png'), height: 170 * unit),
      Padding(
          padding: EdgeInsets.only(top: 30 * unit),
          child: HorizontalLine(context, 280 * unit, 3 * unit)),
    ],
  );
}

Widget AppHeader(
    BuildContext context, int step, IconData iconname, String lable) {
  //223
  double w = (MediaQuery.of(context).size.width);
  double unit =
      (MediaQuery.of(context).size.height) * heightunit + w * widthunit;
  return Column(
    children: [
      Container(
        width: w,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: (w - 300 * unit) / 2,
                  top: 10 * unit,
                  bottom: 10 * unit),
              child: Image(
                image: AssetImage('Assets/logo_horizontal.png'),
                height: 40 * unit,
              ),
            ),
          ],
        ),
      ),
      Row(
        children: [
          SvgPicture.asset(
            'Assets/path1red.svg',
            width: w * 0.1985,
          ),
          SizedBox(
            width: w * 0.01448,
          ),
          SvgPicture.asset(
            'Assets/pathsymbolred.svg',
            width: w * 0.0397,
          ),
          SizedBox(
            width: w * 0.01448,
          ),
          SvgPicture.asset(
            step >= 2 ? 'Assets/path2red.svg' : 'Assets/path2blue.svg',
            width: w * 0.1985,
          ),
          SizedBox(
            width: w * 0.01448,
          ),
          SvgPicture.asset(
            step >= 2
                ? 'Assets/pathsymbolred.svg'
                : 'Assets/pathsymbolblue.svg',
            width: w * 0.0397,
          ),
          SizedBox(
            width: w * 0.01448,
          ),
          SvgPicture.asset(
            step >= 3 ? 'Assets/path2red.svg' : 'Assets/path2blue.svg',
            width: w * 0.1985,
          ),
          SizedBox(
            width: w * 0.01448,
          ),
          SvgPicture.asset(
            step >= 3
                ? 'Assets/pathsymbolred.svg'
                : 'Assets/pathsymbolblue.svg',
            width: w * 0.0397,
          ),
          SizedBox(
            width: w * 0.01448,
          ),
          SvgPicture.asset(
            step == 4 ? 'Assets/path3red.svg' : 'Assets/path3blue.svg',
            width: w * 0.1985,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: Text(" ")),
          SvgPicture.asset(
            'Assets/step1red.svg',
            width: 40 * unit,
          ),
          Expanded(child: Text(" ")),
          SvgPicture.asset(
            step >= 2 ? 'Assets/step2red.svg' : 'Assets/step2blue.svg',
            width: 40 * unit,
          ),
          Expanded(child: Text(" ")),
          SvgPicture.asset(
            step >= 3 ? 'Assets/step3red.svg' : 'Assets/step3blue.svg',
            width: 40 * unit,
          ),
          Expanded(child: Text(" ")),
        ],
      ),
      Container(
        width: w,
        child: Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: (w - 300 * unit) / 2, top: 10 * unit),
              child: Row(
                children: [
                  Icon(
                    iconname,
                    color: bluecolor,
                    size: 25 * unit,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10 * unit),
                      child: MyText(context, lable, TextAlign.start, bluecolor,
                          20 * unit, FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        width: w,
        child: Row(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(left: (w - 300 * unit) / 2, top: 10 * unit),
                child: HorizontalLine(
                    context, w - ((w - 300 * unit) / 2), 3 * unit)),
          ],
        ),
      ),
    ],
  );
}

Widget LeftIconBtn(BuildContext context, IconData iconname, Color fillcolor,
    String label, double s, double h, double w, void Function() fn) {
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;
  return InkWell(
    onTap: fn,
    child: Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: fillcolor,
        border: Border.all(
          color: whitecolor,
          width: 3 * unit,
        ),
        borderRadius: BorderRadius.circular(h),
      ),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconname,
                color: whitecolor,
                size: s,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              MyText(context, " " + label, TextAlign.center, whitecolor, s,
                  FontWeight.w300),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget RightIconBtn(BuildContext context, IconData iconname, Color fillcolor,
    String label, double s, double h, double w, void Function() fn) {
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;
  return InkWell(
    onTap: fn,
    child: Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        border: Border.all(
          color: whitecolor,
          width: 3 * unit,
        ),
        color: fillcolor,
        borderRadius: BorderRadius.circular(h),
      ),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(context, label + " ", TextAlign.center, whitecolor, s,
                  FontWeight.w300),
              Icon(
                iconname,
                color: whitecolor,
                size: s,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget MyTextField2(
    BuildContext context,
    IconData iconname,
    String label,
    double labelsize,
    TextInputType inputType,
    bool flag,
    TextEditingController data,
    double h,
    double w,
    void Function() fn) {
  double unit = (MediaQuery.of(context).size.height) * heightunit +
      (MediaQuery.of(context).size.width) * widthunit;
  return Container(
    width: w,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: data,
            obscureText: flag,
            keyboardType: inputType,
            style: TextStyle(
              fontSize: labelsize,
              color: blackcolor,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              suffixIcon: IconButton(
                icon: Padding(
                  padding: EdgeInsets.only(right: 10 * unit),
                  child: Icon(
                    Icons.add_box_rounded,
                    color: bluecolor,
                    size: 25 * unit,
                  ),
                ),
                onPressed: fn,
              ),
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 20 * unit),
                child: InkWell(
                  onTap: fn,
                  child: Container(
                    width: 50 * unit,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          iconname,
                          color: bluecolor,
                          size: 25 * unit,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        Padding(
                            padding:
                                EdgeInsets.fromLTRB(10 * unit, 0, 10 * unit, 0),
                            child:
                                VerticalLine(context, 1.5 * unit, 25 * unit)),
                      ],
                    ),
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                borderRadius: BorderRadius.circular(h),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: bluecolor, width: 3 * unit),
                borderRadius: BorderRadius.circular(h),
              ),
              hintText: label,
              hintStyle: TextStyle(
                fontSize: labelsize,
                color: greycolor,
              ),
              // contentPadding: EdgeInsets.fromLTRB(0, 12*unit, 20*unit, 12*unit),
            ),
          ),
        ],
      ),
    ),
  );
}
