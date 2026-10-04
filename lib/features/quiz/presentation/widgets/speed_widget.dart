import 'package:flutter/material.dart';
import 'package:mohammad/widgets/pill_chip.dart';
import '/core/theme/masir_style.dart';

/// Playback speed picker: a row of chips, the chosen one filled.
class SpeedWidget extends StatefulWidget {
  final Color color;
  final Function(double) onChanged;

  const SpeedWidget({super.key, required this.color, required this.onChanged});

  @override
  State<SpeedWidget> createState() => _SpeedWidgetState();
}

class _SpeedWidgetState extends State<SpeedWidget> {
  static const List<double> _speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
  static const List<String> _labels = ['۰٫۷۵×', '۱×', '۱٫۲۵×', '۱٫۵×', '۲×'];

  int _selected = 1;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: MasirSpace.sm,
      runSpacing: MasirSpace.sm,
      children: [
        for (var i = 0; i < _speeds.length; i++)
          PillChip(
            _labels[i],
            color: widget.color,
            selected: i == _selected,
            onTap: () {
              setState(() => _selected = i);
              widget.onChanged(_speeds[i]);
            },
          ),
      ],
    );
  }
}
