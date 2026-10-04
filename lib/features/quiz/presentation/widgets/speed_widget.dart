import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/theme/theme_context.dart';

class SpeedWidget extends StatefulWidget {
  final Color color;
  final Function(double) onChanged;

  const SpeedWidget({super.key, required this.color, required this.onChanged});

  @override
  State<SpeedWidget> createState() => _SpeedWidgetState();
}

class _SpeedWidgetState extends State<SpeedWidget> {
  final List<String> data = ["X0.75", "X1", "X1.25", "X1.5", "X2"];
  final List<double> speeds = [0.75, 1.0, 1.25, 1.5, 2.0];

  String selected = "X1";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => OnClick(
            onTap: () {
              setState(() {
                selected = data[index];
              });
              widget.onChanged(speeds[index]);
            },
            child: Container(
              width: 54,
              height: 34,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: data[index] == selected
                      ? widget.color
                      : context.colors.border,
                ),
                borderRadius: BorderRadius.circular(20),
                color: data[index] == selected
                    ? widget.color
                    : context.colors.surface,
              ),
              child: CustomText(
                data[index],
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: data[index] == selected
                    ? context.colors.onPrimary
                    : context.colors.inkMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
