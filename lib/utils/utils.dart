
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Utils {

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(349, 58),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static void successToast(String successMsg) {
    Toast.show(successMsg, duration: Toast.lengthShort, gravity:  Toast.bottom, backgroundColor: Colors.green);
  }

  static void errorToast(String errorMsg) {
    Toast.show(errorMsg, duration: Toast.lengthShort, gravity:  Toast.bottom, backgroundColor: Colors.red);
  }


}