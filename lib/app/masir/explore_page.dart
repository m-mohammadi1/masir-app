import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/routes.dart';
import '/app/state/nav.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «مؤسسه‌ها»: every institute, searchable and filtered by topic.
class ExplorePage extends StatefulWidget {
  final String topic;
  const ExplorePage({super.key, this.topic = ''});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final api = inject<MasirApi>();
  final _q = TextEditingController();
  List<Topic> _topics = [];
  String _topic = '';
  List<InstituteSummary>? _items;
  ApiError? _error;

  @override
  void initState() {
    super.initState();
    _topic = widget.topic;
    api.topics().then((r) => r.fold((_) {}, (t) => mounted ? setState(() => _topics = t) : null));
    _load();
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    final res = await api.institutes(topic: _topic.isEmpty ? null : _topic);
    if (!mounted) return;
    res.fold((e) => setState(() => _error = e), (l) => setState(() => _items = l));
  }

  @override
  Widget build(BuildContext context) {
    final q = _q.text.trim();
    final list = (_items ?? []).where((i) => q.isEmpty || i.name.contains(q) || i.description.contains(q)).toList();
    final topicName = _topics.where((t) => t.slug == _topic).firstOrNull?.name;
    final labels = ['همه', ..._topics.map((t) => t.name)];
    final index = _topic.isEmpty ? 0 : _topics.indexWhere((t) => t.slug == _topic) + 1;
    return Scaffold(
      backgroundColor: C.paper,
      body: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 12, 16, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              BackSquare(onTap: () => back(context, fallback: Routes.vitrine)),
              const SizedBox(width: 12),
              Text('مؤسسه‌ها', style: T.of(22, FontWeight.w900)),
            ]),
            const SizedBox(height: 12),
            Field(
              label: '',
              controller: _q,
              hint: 'اسم مؤسسه یا استاد',
              height: 50,
              fontSize: 15,
              prefix: const MIcon(MI.search, size: 20, color: C.muted),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
          ]),
        ),
        ChipRow(
          labels: labels,
          index: index < 0 ? 0 : index,
          onChanged: (i) {
            setState(() => _topic = i == 0 ? '' : _topics[i - 1].slug);
            _load();
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _error != null
              ? Padding(padding: const EdgeInsets.all(16), child: InlineError(title: 'مؤسسه‌ها بارگذاری نشد', body: _error!.friendly, onRetry: _load))
              : _items == null
                  ? ListView(padding: const EdgeInsets.all(16), children: [
                      for (var i = 0; i < 4; i++) ...[const Bone(height: 108, radius: 20), const SizedBox(height: 12)],
                    ])
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            topicName == null ? '${fa(list.length)} مؤسسه' : '${fa(list.length)} مؤسسه در «$topicName»',
                            style: T.of(13, FontWeight.w500, C.muted),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (list.isEmpty)
                          const EmptyState(icon: MI.search, title: 'چیزی پیدا نشد', body: 'یه اسم دیگه یا یه موضوع دیگه رو امتحان کن.'),
                        for (final it in list) ...[_ExploreRow(item: it), const SizedBox(height: 12)],
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: C.violetSoft, borderRadius: BorderRadius.circular(18)),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const MIcon(MI.info, size: 20, color: Color(0xFF4A2580)),
                            const SizedBox(width: 12),
                            Expanded(child: Text('عضویت توی مؤسسه‌ها رایگانه؛ هر چندتا که خواستی عضو شو.', style: T.of(14, FontWeight.w500, const Color(0xFF4A2580), 1.8))),
                          ]),
                        ),
                      ],
                    ),
        ),
      ]),
    );
  }
}

class _ExploreRow extends StatelessWidget {
  final InstituteSummary item;
  const _ExploreRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final meta = [
      if (item.topic.isNotEmpty) item.topic else if (item.description.isNotEmpty) item.description,
      '${fa(item.courseCount)} دوره',
      '${fa(item.teacherCount)} استاد',
    ].join(' · ');
    return PaperCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: () => item.isMember ? context.push(Routes.threshold(item.id)) : context.push(Routes.instHome(item.id)),
      child: Row(children: [
        SizedBox(
          width: 88,
          height: 86,
          child: Stack(children: [
            ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(width: 88, height: 72, child: CoverImage(url: item.brand.coverUrl, brand: item.brand))),
            Positioned(left: -2, bottom: 0, child: _MiniLogo(brand: item.brand)),
          ]),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.of(16, FontWeight.w800))),
            if (item.isMember) ...[const SizedBox(width: 6), Tag.success('عضوی')],
          ]),
          const SizedBox(height: 3),
          Text(meta, style: T.of(13, FontWeight.w500, C.muted, 1.6)),
        ])),
        const MIcon(MI.forward, size: 20, color: C.muted),
      ]),
    );
  }
}

class _MiniLogo extends StatelessWidget {
  final Brand brand;
  const _MiniLogo({required this.brand});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 38,
    height: 40,
    child: Stack(children: [
      Positioned(top: 2, child: ClipPath(clipper: FrameClipper(brand.frame), child: Container(width: 38, height: 38, color: brand.palette.e))),
      InstituteLogo(brand: brand, size: 38, fontSize: 16),
    ]),
  );
}
