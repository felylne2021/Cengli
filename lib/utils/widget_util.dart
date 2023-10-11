import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showLoading() {
  EasyLoading.show();
}

void hideLoading() {
  EasyLoading.dismiss();
}

void showToast(String value) {
  Fluttertoast.showToast(msg: value);
}
