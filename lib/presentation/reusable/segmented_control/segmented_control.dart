import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

enum SegmentedControlEnum { ghost, filled }

class SegmentedControl extends StatefulWidget {
  const SegmentedControl(
      {super.key,
      required this.onSelected,
      required this.title,
      required this.segmentType,
      this.initialIndex = 0,
      this.sliderBackgroundColor = KxColors.neutral100,
      this.activeColor = KxColors.primary600,
      this.padding = 60});
  final Function(int index) onSelected;
  final List<String> title;
  final SegmentedControlEnum segmentType;
  final Color activeColor;
  final Color sliderBackgroundColor;
  final int initialIndex;
  final double padding;
  @override
  State<SegmentedControl> createState() => _SegmentAccountRolesState();
}

class _SegmentAccountRolesState extends State<SegmentedControl> {
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  final changeDuration = const Duration(milliseconds: 200);
  Map<int, Widget> segmentChildren = {};

  @override
  void initState() {
    super.initState();
    fillSegmentControl();
    currentIndex.value = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return segmentBody(widget.segmentType);
  }

  Widget segmentBody(SegmentedControlEnum type) {
    return type == SegmentedControlEnum.ghost
        ? segmentFlatBody(widget.padding)
        : segmentSliderBody();
  }

  Widget segmentSliderBody() {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (context, value, child) {
            return CupertinoSlidingSegmentedControl(
              children: segmentChildren,
              padding: const EdgeInsets.all(2),
              groupValue: currentIndex.value,
              backgroundColor: widget.sliderBackgroundColor,
              thumbColor: Colors.white,
              onValueChanged: (value) {
                currentIndex.value = value ?? widget.initialIndex;
                widget.onSelected(currentIndex.value);
              },
            );
          }),
    );
  }

  SizedBox segmentFlatBody(double padding) {
    bool valueChanged = false;
    return SizedBox(
        height: 30,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                widget.title.length,
                (index) => GestureDetector(
                    onTap: () {
                      // *If value is changed
                      if (index != widget.initialIndex) {
                        valueChanged = true;
                      }
                      currentIndex.value = index;

                      // *If initial index isn't 0
                      if (widget.initialIndex != 0 && (valueChanged == false)) {
                        currentIndex.value = widget.initialIndex;
                        valueChanged = true;
                      }
                      widget.onSelected(currentIndex.value);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: ValueListenableBuilder(
                          valueListenable: currentIndex,
                          builder: (context, value, child) {
                            return AnimatedContainer(
                              curve: Curves.fastOutSlowIn,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  width: 3,
                                  color: index == currentIndex.value
                                      ? widget.activeColor
                                      : Colors.transparent,
                                )),
                              ),
                              duration: changeDuration,
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.065),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      widget.title[index],
                                      style: index == currentIndex.value
                                          ? KxTypography(
                                              type: KxFontType.buttonMedium,
                                              color: KxColors.neutral700)
                                          : KxTypography(
                                              type: KxFontType.buttonMedium,
                                              color: KxColors.neutral500),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ))),
          ),
        ));
  }

  void fillSegmentControl() {
    //* Mapping from list of segment titles to map needed in the segmented control widget
    widget.title.asMap().forEach((key, value) {
      segmentChildren[key] = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(value,
            style: KxTypography(
                type: KxFontType.caption1, color: KxColors.neutral600)),
      );
    });
  }
}
