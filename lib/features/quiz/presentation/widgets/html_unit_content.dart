import 'package:flutter/material.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/widgets/chunky_box.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:mohammad/widgets/unit_kit/unit_shell.dart';
import '/core/helper/jalali_format.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';
import '/widgets/masir_html.dart';

/// A lesson: the text sits on a reading card, the bar at the top fills as
/// the student scrolls, and the header says how long it takes to read.
class HtmlUnitContent extends StatefulWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback? onComplete;
  final VoidCallback onBack;
  final Widget? banner;
  final Widget? footer;

  const HtmlUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    this.onComplete,
    required this.onBack,
    this.banner,
    this.footer,
  });

  @override
  State<HtmlUnitContent> createState() => _HtmlUnitContentState();
}

class _HtmlUnitContentState extends State<HtmlUnitContent> {
  static const int _wordsPerMinute = 200;

  final _controller = ScrollController();
  double _progress = 0;

  String get _body => widget.data.payload?.body ?? '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    // A lesson shorter than the screen is "read" as soon as it shows.
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_controller.hasClients) return;
    final max = _controller.position.maxScrollExtent;
    final next = max <= 0
        ? 100.0
        : (_controller.position.pixels / max * 100).clamp(0.0, 100.0);
    if ((next - _progress).abs() >= 1) setState(() => _progress = next);
  }

  int get _minutes {
    final words = _body
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    return (words / _wordsPerMinute).ceil().clamp(1, 999);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return UnitShell(
      type: 'html',
      title: widget.data.title ?? '',
      isCompleted: widget.isCompleted,
      meta: '${faDigits(_minutes)} دقیقه مطالعه',
      headerIcon: unitTeacherHeaderIcon(widget.data.teachers),
      banner: widget.banner,
      footer: widget.footer,
      isSubmitting: widget.isSubmitting,
      onComplete: widget.onComplete,
      onBack: widget.onBack,
      controller: _controller,
      progress: widget.isCompleted ? 100 : _progress,
      children: [
        ChunkyBox(
          fill: c.surface,
          edge: c.lip,
          borderColor: c.border,
          radius: MasirRadius.card,
          padding: const EdgeInsets.all(MasirSpace.xl - MasirSpace.xs),
          child: MasirHtml(_body),
        ),
        const SizedBox(height: MasirSpace.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: MasirIconSize.md,
              color: c.inkFaint,
            ),
            const SizedBox(width: MasirSpace.sm),
            CustomText.caption('به آخر درس رسیدی', color: c.inkMuted),
          ],
        ),
      ],
    );
  }
}
