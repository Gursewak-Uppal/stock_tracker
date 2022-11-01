import 'package:flutter/material.dart';

class AppWidgets{
  AppWidgets._();

 static Widget searchBox(
      {double paddingHorizontal = 10.0,
        double paddingVertical = 10.0,
        double borderRadius = 10.0,
        required TextEditingController controller,
        String hintText = "search",
        bool isPrefix = false,
        Widget? prefixIcon,
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
}