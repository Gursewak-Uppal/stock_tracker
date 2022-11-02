import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class AppUtils{
  AppUtils._();


  /// App Colors
  static Color appColor=Colors.blue.shade600;



  /// App Widget
  static Widget searchBox(
      {double paddingHorizontal = 10.0,
        double paddingVertical = 10.0,
        double borderRadius = 10.0,
        required TextEditingController controller,
        String hintText = "search",
        bool isPrefix = false,
        Widget? prefixIcon,
        var onTap,
        var onChangedFunction}) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
          children: [
            isPrefix
                ? prefixIcon!
                : const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            Expanded(
                child: TextFormField(
                  onTap: onTap,
                  textInputAction: TextInputAction.done,
                  controller: controller,
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: hintText,
                  ),
                  onChanged: onChangedFunction,
                ))
          ],
        ),
      );

/// App Common Methods

static Widget sizedBox({double? height, double? width}){
  return SizedBox(height: height??5,width: width??5,);
}

  static appTextStyle({Color? color, double? size, FontWeight? fontWeight  }){
    return TextStyle(
      color: color??Colors.black,
      fontSize: size??15.0,
      fontWeight: fontWeight??FontWeight.normal

    );
  }

  /// Common Text Widget
static appTextWidget({String? text,Color? color,FontWeight?fontWeight }){
  return  AutoSizeText(
   text??"",
    minFontSize: 9,
    maxLines: 12,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(color:color?? Colors.black,
    fontWeight: fontWeight??FontWeight.normal),
  );
}

/// Get Internet Connection Status

 static bool getInternetConnection(Map _source) {
    bool isConnected = true;
    if (_source.keys.toList()[0] == ConnectivityResult.mobile) {
      isConnected = true;
      return isConnected;
    } else if (_source.keys.toList()[0] == ConnectivityResult.wifi) {
      isConnected = true;
      return isConnected;
    } else if (_source.keys.toList()[0] == ConnectivityResult.none) {
      isConnected = false;
      return isConnected;
    } else {
      isConnected = true;
      return isConnected;
    }
  }

}