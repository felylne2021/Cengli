import 'package:flutter/material.dart';

extension KxWidgetModifierExt on Widget {
  Widget padding([EdgeInsetsGeometry value = const EdgeInsets.all(16)]) {
    return Padding(padding: value, child: this);
  }

  Widget expanded() {
    return Expanded(child: this);
  }

  Widget flexible() {
    return Flexible(child: this);
  }

  Widget visibility(bool visible) {
    return Visibility(visible: visible, child: this);
  }

  Widget center([Key? key, double? widthFactor, double? heightFactor]) {
    return Center(
        key: key,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: this);
  }
}