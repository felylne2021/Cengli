import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class DragHandleWidget extends StatelessWidget {
  const DragHandleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: KxColors.neutral200, borderRadius: BorderRadius.circular(4)),
      width: 48,
      height: 6,
    );
  }
}
