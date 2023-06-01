import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String customText) async {
  return Fluttertoast.showToast(
      msg: customText,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

showProgressBar(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()));
}
