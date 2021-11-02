import 'dart:ui';
import 'package:flutter/material.dart';
var pixelRatio = window.devicePixelRatio;
var physicalScreenSize = window.physicalSize;
var physicalWidth = physicalScreenSize.width/2;
var physicalHeight = physicalScreenSize.height/2;
//const heightunit=0.0009562;
//const widthunit=0.0008333;
const heightunit=0.0009362;
const widthunit=0.0008133;
const heightunit2=0.0010928;
const widthunit2=0.00055555;

double size(){
  return (physicalWidth* widthunit) + (physicalHeight*heightunit);
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
 Color bluecolor =  HexColor("#0072FF");
Color greycolor =  HexColor("#A3A3A3");
Color redcolor =  HexColor("#BB003A");
Color whitecolor =  HexColor("#FFFFFF");
Color blackcolor=Colors.black;