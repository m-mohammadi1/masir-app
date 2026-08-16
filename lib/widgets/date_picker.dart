import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/base_modal.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/modal_title.dart';
import '/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

class CustomDatePicker {
  static void show({
    required BuildContext context,
    required Function(String) onChange,
    String? initialValue,
  }) {
    String? value = initialValue;
    showCustomModal(
      context: context,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TitleModal(txt: "تاریخ تولد خود را انتخاب کنید"),
            20.h,
            DatePickerInline(onChange: (v){
              value = v;
            }, initialValue: initialValue),
            20.h,
            CustomButton(title: "تایید",onTap: () {
              if(value != null){
                onChange(value!);
              }
              CustomNavigator.pop();

            },),
            20.h,
          ],
        ),
      ),
    );
  }
}

class DatePickerInline extends StatefulWidget {
  final Function(String) onChange;
  final String? initialValue;

  const DatePickerInline({
    super.key,
    required this.onChange,
    this.initialValue,
  });

  @override
  State<DatePickerInline> createState() => _DatePickerInlineState();
}

class _DatePickerInlineState extends State<DatePickerInline> {
  int year = 2024;
  int month = 1;
  int day = 1;

  final int minYear = 1900;
  final int maxYear = 2100;

  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      try {
        final parts = widget.initialValue!.split('/');
        if (parts.length == 3) {
          year = int.parse(parts[0]);
          month = int.parse(parts[1]);
          day = int.parse(parts[2]);
        }
      } catch (e) {
        throw e.toString();
      }
    }

    yearController = FixedExtentScrollController(initialItem: year - minYear);
    monthController = FixedExtentScrollController(initialItem: month - 1);
    dayController = FixedExtentScrollController(initialItem: day - 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDayIfNeeded();
    });
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    super.dispose();
  }

  int _getDaysInMonth(int y, int m) {
    if (m == 2) {
      final isLeap = (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
      return isLeap ? 29 : 28;
    }
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[m - 1];
  }

  void _updateDayIfNeeded() {
    final maxDays = _getDaysInMonth(year, month);
    if (day > maxDays) {
      setState(() {
        day = maxDays;
      });
      dayController.jumpToItem(day - 1);
    }
    _notifyChange();
  }

  void _notifyChange() {
    final formatted =
        '${year.toString().padLeft(4, '0')}/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
    widget.onChange(formatted);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.appSize.width,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            height: 40,
            width: context.appSize.width,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // year
                _wheel(
                  controller: yearController,
                  count: maxYear - minYear + 1,
                  initialOffset: minYear,
                  onChanged: (index) {
                    setState(() => year = minYear + index);
                    _updateDayIfNeeded();
                  },
                ),

                // month
                _wheel(
                  controller: monthController,
                  count: 12,
                  initialOffset: 1,
                  onChanged: (index) {
                    setState(() => month = index + 1);
                    _updateDayIfNeeded();
                  },
                ),

                // day
                _wheel(
                  controller: dayController,
                  count: _getDaysInMonth(year, month),
                  initialOffset: 1,
                  onChanged: (index) {
                    setState(() => day = index + 1);
                    _notifyChange();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required int initialOffset,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      height: 140,
      width: 90,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 48,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (_, index) {
            final value = index + initialOffset;
            final display = value.toString().padLeft(2, '0');
            return Center(
              child: CustomText(
                display,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: index == controller.selectedItem
                    ? context.colors.text
                    : context.colors.text92,
              ),
            );
          },
        ),
      ),
    );
  }
}
