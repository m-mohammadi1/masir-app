import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/routes.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «خوش اومدی علی!»: the account exists and the student joined the inviting
/// institute. Suggests a course with free units, then enters the institute.
class WelcomePage extends StatefulWidget {
  final String instituteId;
  final Brand? brand;
  final String name;

  const WelcomePage({super.key, required this.instituteId, this.brand, required this.name});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  CourseCard? _suggestion;

  @override
  void initState() {
    super.initState();
    if (widget.instituteId.isNotEmpty) {
      inject<MasirApi>().instituteCourses(widget.instituteId).then((res) {
        if (!mounted) return;
        res.fold((_) {}, (list) {
          final withFree = list.where((c) => c.previewUnits > 0).toList();
          setState(() => _suggestion = withFree.isNotEmpty ? withFree.first : (list.isNotEmpty ? list.first : null));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;
    final pal = brand?.palette ?? masirPalette;
    Widget confetti(double? top, double? left, double? right, double w, double h, Color c, double angle, {bool round = false}) => Positioned(
      top: top,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Container(width: w, height: h, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(round ? w : 3))),
      ),
    );
    return Scaffold(
      backgroundColor: C.paper,
      body: SafeArea(
        child: Stack(children: [
          confetti(90, null, 60, 14, 6, C.sun, .52),
          confetti(150, 50, null, 10, 10, C.violet, 0, round: true),
          confetti(60, 150, null, 12, 5, C.green, -.7),
          confetti(230, null, 30, 9, 9, pal.p, .35),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(children: [
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(color: C.violet, borderRadius: BorderRadius.circular(28), boxShadow: [lip(C.violetDark, 6)]),
                      alignment: Alignment.center,
                      child: const MasirMark(size: 48),
                    ),
                    if (brand != null) ...[
                      const SizedBox(width: 12),
                      const MIcon(MI.plus, size: 28, color: C.lockedLip, strokeWidth: 2.6),
                      const SizedBox(width: 12),
                      DecoratedBox(
                        decoration: BoxDecoration(boxShadow: [lip(pal.e, 6)], borderRadius: BorderRadius.circular(26)),
                        child: InstituteLogo(brand: brand, size: 88, fontSize: 38),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 24),
                  Text('خوش اومدی ${widget.name}!', textAlign: TextAlign.center, style: T.of(30, FontWeight.w900, C.ink, 1.35)),
                  const SizedBox(height: 8),
                  if (brand != null)
                    Text.rich(
                      TextSpan(style: T.of(16, FontWeight.w500, C.body, 1.9), children: [
                        const TextSpan(text: 'حسابت ساخته شد و عضو '),
                        TextSpan(text: brand.name, style: T.of(16, FontWeight.w800, C.body)),
                        const TextSpan(text: ' شدی. دوره‌هاش منتظرتن.'),
                      ]),
                      textAlign: TextAlign.center,
                    )
                  else
                    Text('حسابت ساخته شد. از ویترین شروع کن.', textAlign: TextAlign.center, style: T.of(16, FontWeight.w500, C.body, 1.9)),
                  if (_suggestion != null) ...[
                    const SizedBox(height: 24),
                    PaperCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(width: 56, height: 48, child: CoverImage(url: _suggestion!.coverUrl, brand: brand)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('پیشنهاد برای شروع', style: T.of(12, FontWeight.w500, C.muted)),
                          Text(
                            _suggestion!.previewUnits > 0
                                ? '${_suggestion!.title} · ${fa(_suggestion!.previewUnits)} واحد رایگان'
                                : _suggestion!.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: T.of(15, FontWeight.w800),
                          ),
                        ])),
                      ]),
                    ),
                  ],
                ]),
              ),
              if (brand != null)
                Btn('برو توی ${brand.name}', palette: pal, onPressed: () => context.go(Routes.threshold(widget.instituteId)))
              else
                Btn('بریم سراغ ویترین', onPressed: () => context.go(Routes.vitrine)),
              if (brand != null) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go(Routes.vitrine),
                  style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                  child: Text('اول یه نگاه به ویترین بنداز', style: T.of(15, FontWeight.w700, C.muted)),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}
