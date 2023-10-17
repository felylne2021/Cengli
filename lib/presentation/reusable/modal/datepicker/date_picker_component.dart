// ignore_for_file: constant_identifier_names
import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kinetix/kinetix.dart';

const String FORMAT_DATE = 'dd MMMM yyyy';

class DatePickerComponent extends StatefulWidget {
  const DatePickerComponent({super.key});

  @override
  State<DatePickerComponent> createState() => _DatePickerComponentState();
}

class _DatePickerComponentState extends State<DatePickerComponent> {
  // *VARIABLES
  String selectedBirthdate = '';
  KxDatePickerArgument birthdateArgument =
      KxDatePickerArgument(dateTime: DateTime.now(), birthdate: '');
  @override
  Widget build(BuildContext context) {
    final birthdateHeight = MediaQuery.of(context).size.height * 0.6 * 0.41943;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
                height: birthdateHeight,
                child: DateTimePickerWidget(
                  minDateTime: DateTime(DateTime.now().year - 3),
                  maxDateTime: DateTime.now(),
                  initDateTime: DateTime.now(),
                  dateFormat: FORMAT_DATE,
                  pickerTheme: DateTimePickerTheme(
                    selectionOverlay: const SizedBox(),
                    showTitle: false,
                    itemTextStyle: KxTypography(
                        type: KxFontType.subtitle4, color: KxColors.neutral600),
                    pickerHeight: 0.525 * MediaQuery.of(context).size.height,
                    itemHeight: 30.0,
                  ),
                  onChange: (dateTime, selectedIndex) {
                    setState(() {
                      selectedBirthdate =
                          DateFormat(FORMAT_DATE).format(dateTime);
                      birthdateArgument.birthdate = selectedBirthdate;
                      birthdateArgument.dateTime = dateTime;
                    });
                  },
                )),
            const Positioned.fill(
              top: 30,
              left: 2,
              child: Divider(
                thickness: 1,
                color: KxColors.neutral200,
              ),
            ),
            const Positioned.fill(
              bottom: 30,
              left: 2,
              child: Divider(
                thickness: 1,
                color: KxColors.neutral200,
              ),
            ),
          ],
        ).flexible(),
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 50),
          child: KxTextButton(
              argument: KxTextButtonArgument(
                  onPressed: () {
                    Navigator.of(context).pop(birthdateArgument);
                  },
                  buttonText: 'Done',
                  buttonColor: primaryGreen600,
                  textColor: KxColors.neutral700,
                  buttonSize: KxButtonSizeEnum.large,
                  buttonType: KxButtonTypeEnum.primary,
                  buttonShape: KxButtonShapeEnum.square,
                  buttonContent: KxButtonContentEnum.text)),
        )
      ],
    );
  }
}
