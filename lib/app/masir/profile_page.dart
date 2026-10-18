import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/common/app_version.dart';
import '/app/routes.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «پروفایل»: who you are, your streak and counts, current institute,
/// subscriptions, settings and sign-out.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final api = inject<MasirApi>();
  StudentStats? _stats;
  List<WalletCard>? _wallet;
  List<Subscription>? _subs;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await Future.wait([
      api.me().then((r) => r.fold((_) {}, (s) => Session.student.value = s)),
      api.stats().then(
        (r) =>
            r.fold((_) {}, (s) => mounted ? setState(() => _stats = s) : null),
      ),
      api.wallet().then(
        (r) =>
            r.fold((_) {}, (w) => mounted ? setState(() => _wallet = w) : null),
      ),
      api.subscriptions().then(
        (r) =>
            r.fold((_) {}, (s) => mounted ? setState(() => _subs = s) : null),
      ),
    ]);
  }

  Future<void> _logout() async {
    final yes = await showMasirSheet<bool>(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('می‌خوای خارج شی؟', style: T.of(20, FontWeight.w800)),
            const SizedBox(height: 14),
            Text(
              'پیشرفتت ذخیره شده. برای برگشتن، نام کاربری و رمزت رو لازم داری.',
              style: T.of(15, FontWeight.w500, C.body, 1.9),
            ),
            const SizedBox(height: 14),
            Btn(
              'آره، خارج شو',
              kind: BtnKind.danger,
              height: 54,
              onPressed: () => Navigator.pop(ctx, true),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('نه، بمونم', style: T.of(16, FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
    if (yes == true) {
      await Session.signOut();
      if (mounted) context.go(Routes.intro);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _wallet?.firstOrNull;
    final subs = _subs ?? [];
    final expiring = subs
        .where((s) => s.course.access.state == AccessState.expiring)
        .toList();
    final paidCount = subs
        .where(
          (s) =>
              s.course.access.state != AccessState.freeCourse &&
              s.course.access.state != AccessState.trial,
        )
        .length;
    return ValueListenableBuilder<Student?>(
      valueListenable: Session.student,
      builder: (context, student, _) => RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.paddingOf(context).top + 16,
            16,
            32,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('پروفایل', style: T.of(28, FontWeight.w900)),
            ),
            const SizedBox(height: 18),
            PaperCard(
              radius: 24,
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: C.violetSoft,
                      shape: BoxShape.circle,
                      border: Border.all(color: C.violet, width: 3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      student?.initial ?? '',
                      style: T.of(24, FontWeight.w900, C.violetDark),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student?.name.isNotEmpty == true
                              ? student!.name
                              : 'بی‌نام',
                          style: T.of(19, FontWeight.w800),
                        ),
                        if (student?.username != null)
                          Text(
                            '@${student!.username}',
                            textDirection: TextDirection.ltr,
                            style: T.of(14, FontWeight.w500, C.muted),
                          ),
                      ],
                    ),
                  ),
                  RoundIcon(
                    MI.pencil,
                    label: 'ویرایش پروفایل',
                    onTap: _editName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    icon: const MIcon(
                      MI.flame,
                      size: 22,
                      color: Color(0xFFFF8A00),
                    ),
                    value: _stats?.streakDays,
                    label: 'روز پیاپی',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Stat(
                    icon: const MIcon(
                      MI.check,
                      size: 22,
                      color: C.green,
                      strokeWidth: 3,
                    ),
                    value: _stats?.completedUnits,
                    label: 'واحد تموم‌شده',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Stat(
                    icon: const MIcon(MI.trophy, size: 22, color: C.sunDark),
                    value: _stats?.trophies,
                    label: 'جام فصل',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: C.surface,
                border: Border.all(color: C.border, width: 2),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  if (current != null) ...[
                    _Row(
                      lead: InstituteLogo(
                        brand: current.institute.brand,
                        size: 36,
                      ),
                      title: 'مؤسسه‌ی فعلی',
                      subtitle: current.institute.name,
                      trailing: Text(
                        'عوض کن',
                        style: T.of(13, FontWeight.w800, C.violet),
                      ),
                      onTap: () => context.go(Routes.myInstitutes),
                    ),
                    const SandLine(),
                  ],
                  _Row(
                    lead: const MIcon(MI.card),
                    title: 'اشتراک‌ها',
                    subtitle: _subs == null
                        ? null
                        : expiring.isNotEmpty
                        ? '${fa(paidCount)} اشتراک • یکی ${fa(expiring.first.course.access.daysLeft ?? 0)} روز دیگه تموم می‌شه'
                        : '${fa(paidCount)} اشتراک',
                    subtitleColor: expiring.isNotEmpty
                        ? const Color(0xFF8A5A00)
                        : C.muted,
                    onTap: () => context.push(Routes.subscriptions),
                  ),
                  const SandLine(),
                  _Row(
                    lead: const MIcon(MI.user),
                    title: 'ویرایش پروفایل',
                    onTap: _editName,
                  ),
                  const SandLine(),
                  _Row(
                    lead: const MIcon(MI.lock),
                    title: 'تغییر رمز عبور',
                    onTap: _changePassword,
                  ),
                  // «حالت تاریک» stays hidden until dark mode is designed.
                  const SandLine(),
                  _Row(
                    lead: const MIcon(MI.info),
                    title: 'درباره‌ی مسیر',
                    onTap: _about,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            OutlinedDanger('خروج از حساب', onPressed: _logout),
            const SizedBox(height: 18),
            AppVersionText(
              prefix: 'مسیر • ',
              textAlign: TextAlign.center,
              style: T.of(12, FontWeight.w500, C.muted),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editName() async {
    final ctrl = TextEditingController(text: Session.student.value?.name ?? '');
    await showMasirSheet(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ویرایش پروفایل', style: T.of(19, FontWeight.w800)),
            const SizedBox(height: 16),
            Field(label: 'اسمت', controller: ctrl, autofocus: true),
            const SizedBox(height: 18),
            Btn(
              'ذخیره',
              onPressed: () async {
                final res = await api.updateMe(name: ctrl.text.trim());
                if (!ctx.mounted) return;
                res.fold(
                  (e) => Toast.show(
                    ctx,
                    title: 'ذخیره نشد',
                    body: e.friendly,
                    tone: ToastTone.error,
                  ),
                  (s) {
                    Session.student.value = s;
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
  }

  Future<void> _changePassword() async {
    final cur = TextEditingController(), next = TextEditingController();
    String? error;
    await showMasirSheet(
      context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('تغییر رمز عبور', style: T.of(19, FontWeight.w800)),
              const SizedBox(height: 16),
              Field(
                label: 'رمز فعلی',
                controller: cur,
                obscure: true,
                direction: TextDirection.ltr,
              ),
              const SizedBox(height: 14),
              Field(
                label: 'رمز تازه',
                controller: next,
                obscure: true,
                direction: TextDirection.ltr,
                helper: 'دست‌کم ۸ کاراکتر و یه عدد',
                error: error,
              ),
              const SizedBox(height: 18),
              Btn(
                'ذخیره',
                onPressed: () async {
                  final res = await api.changePassword(cur.text, next.text);
                  if (!ctx.mounted) return;
                  res.fold(
                    (e) => set(
                      () => error = e.status == 401
                          ? 'رمز فعلی درست نیست.'
                          : e.friendly,
                    ),
                    (_) {
                      Navigator.pop(ctx);
                      Toast.show(context, title: 'رمزت عوض شد');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    cur.dispose();
    next.dispose();
  }

  void _about() => showMasirSheet(
    context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: C.violet,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [lip(C.violetDark)],
            ),
            alignment: Alignment.center,
            child: const MasirMark(size: 44),
          ),
          const SizedBox(height: 14),
          Text('مسیر', style: T.of(22, FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            'مؤسسه‌ها دوره‌هاشون رو به شکل یه مسیر قدم‌به‌قدم می‌سازن و تو هر روز چند دقیقه جلو می‌ری.',
            textAlign: TextAlign.center,
            style: T.of(15, FontWeight.w500, C.body, 1.9),
          ),
          const SizedBox(height: 8),
          AppVersionText(style: T.of(13, FontWeight.w600, C.muted)),
        ],
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  final Widget icon;
  final int? value;
  final String label;
  const _Stat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
    decoration: BoxDecoration(
      color: C.surface,
      border: Border.all(color: C.border, width: 2),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        icon,
        const SizedBox(height: 2),
        value == null
            ? const Bone(width: 24, height: 18)
            : Text(fa(value), style: T.of(18, FontWeight.w800)),
        Text(label, style: T.of(12, FontWeight.w500, C.muted)),
      ],
    ),
  );
}

class _Row extends StatelessWidget {
  final Widget lead;
  final String title;
  final String? subtitle;
  final Color subtitleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _Row({
    required this.lead,
    required this.title,
    this.subtitle,
    this.subtitleColor = C.muted,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          SizedBox(width: 36, child: Center(child: lead)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: T.of(15, FontWeight.w700)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: T.of(12, FontWeight.w500, subtitleColor),
                  ),
              ],
            ),
          ),
          trailing ?? const MIcon(MI.forward, size: 18, color: C.muted),
        ],
      ),
    ),
  );
}
