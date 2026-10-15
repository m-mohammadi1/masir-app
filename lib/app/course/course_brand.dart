import 'package:flutter/material.dart';

import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// Paints a course page in its institute's colours, loading the course when
/// its brand isn't known yet (deep links, pages opened from another space).
class CourseBrand extends StatefulWidget {
  final String courseId;
  final Widget child;
  const CourseBrand({super.key, required this.courseId, required this.child});

  static final Map<String, Brand> _known = {};

  static void remember(String courseId, Brand brand) =>
      _known[courseId] = brand;

  @override
  State<CourseBrand> createState() => _CourseBrandState();
}

class _CourseBrandState extends State<CourseBrand> {
  Brand? _brand;

  @override
  void initState() {
    super.initState();
    _brand = CourseBrand._known[widget.courseId];
    if (_brand == null && widget.courseId.isNotEmpty) {
      inject<MasirApi>()
          .course(widget.courseId)
          .then(
            (r) => r.fold((_) {}, (c) {
              CourseBrand.remember(widget.courseId, c.instituteBrand);
              if (mounted) setState(() => _brand = c.instituteBrand);
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) => _brand == null
      ? widget.child
      : BrandScope(brand: _brand!, child: widget.child);
}
