import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import '/core/helper/custom_colors.dart';
import '/widgets/custom_text.dart';

class TimePickerAnchor extends StatefulWidget {
  final Function(String) onChange;
  final String? value;

  const TimePickerAnchor({super.key, required this.onChange, this.value});

  @override
  State<TimePickerAnchor> createState() => _TimePickerAnchorState();
}

class _TimePickerAnchorState extends State<TimePickerAnchor>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlay;

  int hour = 8;
  int minute = 0;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      hour = int.parse(widget.value!.split(":").first);
      minute = int.parse(widget.value!.split(":").last);
    }
  }

  void _togglePicker() {
    if (_overlay == null) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    setState(() {
      _overlay = _createOverlay();
    });
    Overlay.of(context).insert(_overlay!);
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _removeOverlay,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 50),
                child: _TimePickerOverlay(
                  initialHour: hour,
                  initialMinute: minute,
                  onConfirm: (h, m) {
                    setState(() {
                      hour = h;
                      minute = m;
                    });
                    widget.onChange('${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeOverlay() {
    if (_overlay != null) {
      _overlay?.remove();
      setState(() {
        _overlay = null;
      });
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _togglePicker,
        child: Container(
          height: 48,
          width: context.appSize.width,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _overlay == null ? AppColor.border : AppColor.primary,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                  color: AppColor.text92,
                ),
                Icon(
                  Icons.access_time_rounded,
                  color: AppColor.text92,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimePickerOverlay extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final void Function(int, int) onConfirm;

  const _TimePickerOverlay({
    required this.initialHour,
    required this.initialMinute,
    required this.onConfirm,
  });

  @override
  State<_TimePickerOverlay> createState() => _TimePickerOverlayState();
}

class _TimePickerOverlayState extends State<_TimePickerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  int hour = 0;
  int minute = 0;

  @override
  void initState() {
    super.initState();

    hour = widget.initialHour;
    minute = widget.initialMinute;

    hourController = FixedExtentScrollController(initialItem: hour);
    minuteController = FixedExtentScrollController(initialItem: minute);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: ScaleTransition(
        scale: Tween(begin: 0.95, end: 1.0).animate(_controller),
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: (context.appSize.width / 2) - 28,
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 40,
                  width: context.appSize.width,
                  decoration: BoxDecoration(
                    color: AppColor.primary100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _wheel(
                            controller: hourController,
                            count: 24,
                            onChanged: (v) {
                              hour = v;
                              widget.onConfirm(hour, minute);
                            },
                          ),
                          Text(":", style: TextStyle(fontSize: 24)),
                          _wheel(
                            controller: minuteController,
                            count: 60,
                            onChanged: (v) {
                              minute = v;
                              widget.onConfirm(hour, minute);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      height: 120, // 3 × 40
      width: 60,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (_, index) => Center(
            child: CustomText(
              index.toString().padLeft(2, '0'),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
