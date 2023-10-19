import 'package:cengli/values/styles.dart';
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
      required this.currentIndex,
      this.initialIndex = 0,
      this.sliderBackgroundColor = KxColors.neutral100,
      this.activeColor = KxColors.primary600,
      this.padding = 0});
  final Function(int index) onSelected;
  final List<String> title;
  final SegmentedControlEnum segmentType;
  final Color activeColor;
  final Color sliderBackgroundColor;
  final int initialIndex;
  final ValueNotifier<int> currentIndex;
  final double padding;

  @override
  State<SegmentedControl> createState() => _SegmentAccountRolesState();
}

class _SegmentAccountRolesState extends State<SegmentedControl> {
  final changeDuration = const Duration(milliseconds: 200);
  Map<int, Widget> segmentChildren = {};

  @override
  void initState() {
    super.initState();
    fillSegmentControl();
  }

  @override
  Widget build(BuildContext context) {
    return segmentBody(widget.segmentType);
  }

  Widget segmentBody(SegmentedControlEnum type) {
    return type == SegmentedControlEnum.ghost
        ? segmentFlatBody()
        : segmentSliderBody();
  }

  Widget segmentSliderBody() {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
          valueListenable: widget.currentIndex,
          builder: (context, value, child) {
            return CupertinoSlidingSegmentedControl(
              children: segmentChildren,
              padding: const EdgeInsets.all(2),
              groupValue: widget.currentIndex.value,
              backgroundColor: widget.sliderBackgroundColor,
              thumbColor: Colors.white,
              onValueChanged: (value) {
                widget.currentIndex.value = value ?? widget.initialIndex;
                widget.onSelected(widget.currentIndex.value);
              },
            );
          }),
    );
  }

  SizedBox segmentFlatBody() {
    bool valueChanged = false;
    return SizedBox(
        height: 50,
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
                        widget.currentIndex.value = index;

                        // *If initial index isn't 0
                        if (widget.initialIndex != 0 &&
                            (valueChanged == false)) {
                          widget.currentIndex.value = widget.initialIndex;
                          valueChanged = true;
                        }
                        widget.onSelected(widget.currentIndex.value);
                      },
                      child: ValueListenableBuilder(
                          valueListenable: widget.currentIndex,
                          builder: (_, value, child) {
                            return AnimatedContainer(
                              curve: Curves.fastOutSlowIn,
                              width: MediaQuery.of(context).size.width != 0
                                  ? (MediaQuery.of(context).size.width /
                                          widget.title.length) -
                                      widget.padding
                                  : null,
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width == 0
                                          ? 35
                                          : 2),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  width: 3,
                                  color: index == widget.currentIndex.value
                                      ? widget.activeColor
                                      : Colors.transparent,
                                )),
                              ),
                              duration: changeDuration,
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    widget.title[index],
                                    style: index == widget.currentIndex.value
                                        ? CengliTypography(
                                            type: CengliFontType.subtitle6,
                                            color: KxColors.neutral700)
                                        : CengliTypography(
                                            type: CengliFontType.subtitle6,
                                            color: KxColors.neutral500),
                                  ).padding(const EdgeInsets.only(bottom: 5)),
                                ),
                              ),
                            );
                          }),
                    )),
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
