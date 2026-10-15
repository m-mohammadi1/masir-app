import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/app/common/widgets.dart';
import '/app/course/plan_sheet.dart';
import '/app/routes.dart';
import '/app/state/load_cubit.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «مؤسسات من»: a coloured card per institute with the next step, then
/// institutes to join.
class MyInstitutesPage extends StatelessWidget {
  const MyInstitutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final api = inject<MasirApi>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoadCubit<List<WalletCard>>(api.wallet)..load(),
        ),
        BlocProvider(
          create: (_) => LoadCubit<List<InstituteSummary>>(
            () => api.institutes(excludeJoined: true),
          )..load(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: C.violet,
            onRefresh: () async {
              await Future.wait([
                context.read<LoadCubit<List<WalletCard>>>().load(),
                context.read<LoadCubit<List<InstituteSummary>>>().load(),
              ]);
            },
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 20,
                16,
                32,
              ),
              children: [
                BlocBuilder<
                  LoadCubit<List<WalletCard>>,
                  Load<List<WalletCard>>
                >(
                  builder: (context, s) {
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مؤسسات من',
                                  style: T.of(28, FontWeight.w900, C.ink, 1.35),
                                ),
                                if (s.data != null)
                                  Text(
                                    s.data!.isEmpty
                                        ? 'هنوز عضو مؤسسه‌ای نیستی'
                                        : 'عضو ${fa(s.data!.length)} مؤسسه‌ای',
                                    style: T.of(14, FontWeight.w500, C.muted),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Lip(
                          onTap: () => context.push(Routes.explore),
                          radius: 16,
                          lipHeight: 3,
                          semanticLabel: 'پیدا کردن مؤسسه‌ی تازه',
                          child: const SizedBox.square(
                            dimension: 44,
                            child: Center(child: MIcon(MI.search)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                LoadView<List<WalletCard>>(
                  skeleton: Column(
                    children: const [
                      Bone(height: 300, radius: 26),
                      SizedBox(height: 20),
                      Bone(height: 300, radius: 26),
                    ],
                  ),
                  builder: (context, cards) => Column(
                    children: [
                      for (var i = 0; i < cards.length; i++) ...[
                        _MembershipCard(card: cards[i], current: i == 0),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const _MoreInstitutes(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  final WalletCard card;
  final bool current;
  const _MembershipCard({required this.card, required this.current});

  @override
  Widget build(BuildContext context) {
    final inst = card.institute;
    final brand = inst.brand;
    final pal = brand.palette;
    final course = card.course;
    final access = course?.access;
    final expired = access?.state == AccessState.expired;
    final unit = course?.currentUnit;
    final photo = card.photoUrl.isNotEmpty ? card.photoUrl : card.coverUrl;

    String? subNote;
    Color subColor = C.muted;
    if (access != null) {
      switch (access.state) {
        case AccessState.active:
          subNote =
              'اشتراک ${planNames[access.plan] ?? ''} · تا ${jDay(access.accessEndsAt!)}';
        case AccessState.expiring:
          subNote =
              '${fa(access.daysLeft ?? 0)} روز تا پایان اشتراک · تمدید از «پروفایل › اشتراک‌ها»';
          subColor = const Color(0xFF8A5A00);
        case AccessState.expired:
          subNote =
              'اشتراک ${jDay(access.accessEndsAt!)} تموم شد؛ پیشرفتت سر جاشه';
          subColor = C.coralText;
        case AccessState.trial:
          subNote = 'بخش رایگان · ${fa(course!.previewUnits)} واحد';
        case AccessState.freeCourse:
          subNote = 'دوره‌ی رایگان';
        case AccessState.guest:
          break;
      }
    }

    void openNext() {
      if (expired) {
        showPlanSheet(context, courseId: course!.id, renew: true, brand: brand);
      } else if (unit != null && !unit.needsSubscription) {
        Session.enterInstitute(inst.id, brand);
        context.push(Routes.unit(unit.id), extra: {'course_id': course!.id});
      } else if (unit != null) {
        showPlanSheet(
          context,
          courseId: course!.id,
          brand: brand,
          returnUnitId: unit.id,
        );
      } else {
        context.push(Routes.threshold(inst.id));
      }
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: pal.p,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [lip(pal.e, 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 104,
            child: CoverImage(url: photo, brand: brand),
          ),
          Stack(
            children: [
              Positioned.fill(
                child: PatternFill(pattern: brand.pattern, color: pal.e),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ShiftUp(
                      dy: 30,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LippedLogo(
                            brand: brand,
                            size: 64,
                            inverted: true,
                            lipHeight: 4,
                          ),
                          const Spacer(),
                          if (current)
                            Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: C.surface,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'مؤسسه‌ی فعلی',
                                style: T.of(12, FontWeight.w800, pal.ink),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      inst.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: T.of(19, FontWeight.w800, pal.on, 1.5),
                    ),
                    if (card.memberSince != null)
                      Text(
                        'عضو از ${jMonthYear(card.memberSince!)}',
                        style: T.of(13, FontWeight.w600, pal.on),
                      ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: course != null && unit != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'قدم بعدی در «${course.title}»',
                                  style: T.of(12, FontWeight.w700, C.muted),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  unit.title,
                                  style: T.of(17, FontWeight.w800),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Track(
                                        value: course.progressPercent / 100,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      pct(course.progressPercent),
                                      style: T.of(
                                        13,
                                        FontWeight.w800,
                                        C.greenText,
                                      ),
                                    ),
                                  ],
                                ),
                                if (subNote != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    subNote,
                                    style: T.of(
                                      12,
                                      FontWeight.w700,
                                      subColor,
                                      1.7,
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course != null
                                      ? 'این دوره رو تموم کردی!'
                                      : 'هنوز دوره‌ای شروع نکردی',
                                  style: T.of(16, FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  course != null
                                      ? 'یه دوره‌ی تازه از ${inst.name} انتخاب کن.'
                                      : 'از واحدهای رایگان یه دوره شروع کن.',
                                  style: T.of(14, FontWeight.w500, C.muted),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Lip(
                            onTap: unit != null || expired
                                ? openNext
                                : () => context.push(Routes.threshold(inst.id)),
                            fill: C.surface,
                            border: null,
                            lipColor: pal.e,
                            radius: 16,
                            child: SizedBox(
                              height: 46,
                              child: Center(
                                child: Text(
                                  expired
                                      ? 'تمدید اشتراک'
                                      : unit != null
                                      ? 'ادامه یادگیری'
                                      : 'دیدن دوره‌ها',
                                  style: T.of(16, FontWeight.w800, pal.ink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Semantics(
                          button: true,
                          label: 'ورود به ${inst.name}',
                          child: GestureDetector(
                            onTap: () =>
                                context.push(Routes.threshold(inst.id)),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: pal.darkText
                                    ? const Color(0x1A000000)
                                    : const Color(0x38FFFFFF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: MIcon(
                                MI.forward,
                                color: pal.on,
                                strokeWidth: 2.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoreInstitutes extends StatelessWidget {
  const _MoreInstitutes();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        LoadCubit<List<InstituteSummary>>,
        Load<List<InstituteSummary>>
      >(
        builder: (context, s) {
          final list = s.data ?? [];
          if (list.isEmpty && s.data != null) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SectionTitle(
                  'مؤسسه‌های بیشتر',
                  subtitle: 'عضویت رایگانه؛ هر چندتا که خواستی عضو شو.',
                ),
              ),
              const SizedBox(height: 12),
              if (s.data == null)
                const Bone(height: 140, radius: 22)
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: C.surface,
                    border: Border.all(color: C.border, width: 2),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < list.length && i < 3; i++) ...[
                        if (i > 0) const SandLine(),
                        InstituteRow(item: list[i]),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push(Routes.explore),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: C.violetBorder, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'همه‌ی مؤسسه‌ها رو ببین',
                    style: T.of(15, FontWeight.w800, C.violetDark),
                  ),
                ),
              ),
            ],
          );
        },
      );
}

/// List row of an institute with a «عضو شو» button.
class InstituteRow extends StatefulWidget {
  final InstituteSummary item;
  const InstituteRow({super.key, required this.item});

  @override
  State<InstituteRow> createState() => _InstituteRowState();
}

class _InstituteRowState extends State<InstituteRow> {
  bool _busy = false;

  Future<void> _join() async {
    setState(() => _busy = true);
    final res = await inject<MasirApi>().joinInstitute(widget.item.id);
    if (!mounted) return;
    setState(() => _busy = false);
    res.fold(
      (e) => Toast.show(
        context,
        title: 'عضو نشدی',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (_) => context.push(Routes.threshold(widget.item.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.push(Routes.instHome(it.id)),
              child: Row(
                children: [
                  InstituteLogo(brand: it.brand, size: 46),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it.name, style: T.of(15, FontWeight.w800)),
                        Text(
                          [
                            if (it.topic.isNotEmpty)
                              it.topic
                            else if (it.description.isNotEmpty)
                              it.description,
                            '${fa(it.courseCount)} دوره',
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: T.of(13, FontWeight.w500, C.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Lip(
            onTap: _busy ? null : _join,
            border: C.violetBorder,
            lipColor: null,
            radius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 36,
              child: Center(
                child: _busy
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'عضو شو',
                        style: T.of(14, FontWeight.w800, C.violetDark),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
