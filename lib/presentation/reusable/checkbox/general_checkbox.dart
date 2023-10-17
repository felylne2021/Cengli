import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class GeneralCheckbox extends StatefulWidget {
  final bool? initialValue;
  final Widget checkboxWidget;
  final ValueChanged<bool?>? onChanged;
  final OutlinedBorder? shape;

  const GeneralCheckbox({
    Key? key,
    this.initialValue,
    this.onChanged,
    required this.checkboxWidget,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GeneralCheckboxState();
}

class _GeneralCheckboxState extends State<GeneralCheckbox> {
  ValueNotifier<bool> isChecked = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    isChecked.value = widget.initialValue == true;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () => _onCheckedChanged(), child: _buildCheckbox(context)),
        Expanded(
            child: Column(
          children: [
            4.0.height,
            widget.checkboxWidget,
          ],
        ))
      ],
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isChecked,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0,
          child: Checkbox(
            shape: widget.shape,
            side: MaterialStateBorderSide.resolveWith(
              (states) => BorderSide(width: 1.0, color: primaryGreen600),
            ),
            checkColor: KxColors.neutral700,
            activeColor: primaryGreen600,
            value: value,
            onChanged: (v) => _onCheckedChanged(),
          ),
        );
      },
    );
  }

  void _onCheckedChanged() {
    isChecked.value = !isChecked.value;
    if (widget.onChanged != null) {
      widget.onChanged!.call(isChecked.value);
    }
  }
}
