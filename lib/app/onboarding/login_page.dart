import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/onboarding/register_page.dart';
import '/app/routes.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// «خوش برگشتی!»: username + password, then the Vitrine.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _show = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await inject<MasirApi>().login(_user.text, _pass.text);
    if (!mounted) return;
    setState(() => _busy = false);
    await res.fold(
      (e) async => setState(
        () => _error = e.status == 401
            ? 'نام کاربری یا رمز درست نیست. دوباره امتحان کن.'
            : e.friendly,
      ),
      (r) async {
        await Session.signIn(r.token, r.student);
        if (mounted) context.go(Routes.vitrine);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _user.text.trim().isNotEmpty && _pass.text.isNotEmpty;
    return Scaffold(
      backgroundColor: C.paper,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: BackSquare(
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go(Routes.intro),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: C.violetSoft,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [lip(C.violetBorder, 5)],
                        ),
                        alignment: Alignment.center,
                        child: const MasirMark(
                          size: 44,
                          style: MarkStyle.onLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'خوش برگشتی!',
                      textAlign: TextAlign.center,
                      style: T.of(28, FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'نام کاربری و رمزت رو بزن، از همون‌جا ادامه می‌دیم.',
                      textAlign: TextAlign.center,
                      style: T.of(15, FontWeight.w500, C.body),
                    ),
                    if (Session.expired) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: C.sunSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'نشستت تموم شده؛ برای ادامه دوباره وارد شو.',
                          textAlign: TextAlign.center,
                          style: T.of(14, FontWeight.w700, C.sunText, 1.8),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Field(
                      label: 'نام کاربری',
                      controller: _user,
                      direction: TextDirection.ltr,
                      height: 56,
                      action: TextInputAction.next,
                      onChanged: (_) => setState(() => _error = null),
                    ),
                    const SizedBox(height: 16),
                    Field(
                      label: 'رمز عبور',
                      controller: _pass,
                      obscure: !_show,
                      direction: TextDirection.ltr,
                      height: 56,
                      error: _error,
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) => ready ? _login() : null,
                      suffix: Semantics(
                        button: true,
                        label: _show ? 'پنهان کردن رمز' : 'نشون دادن رمز',
                        child: GestureDetector(
                          onTap: () => setState(() => _show = !_show),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: C.sand,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: MIcon(
                              MI.eye,
                              size: 20,
                              color: _show ? C.violet : C.ink,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: () => showMasirSheet(
                          context,
                          builder: (_) => const _ForgotSheet(),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(44, 40),
                        ),
                        child: Text(
                          'رمزت یادت رفته؟',
                          style: T.of(14, FontWeight.w800, C.violet),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Btn(
                    'بزن بریم',
                    loading: _busy,
                    onPressed: ready ? _login : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'حساب نداری؟',
                        style: T.of(14, FontWeight.w500, C.muted),
                      ),
                      TextButton(
                        onPressed: () => context.go(Routes.register),
                        child: Text(
                          'با کد دعوت ثبت‌نام کن',
                          style: T.of(14, FontWeight.w800, C.violet),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reset the password with an SMS code to the account's phone.
class _ForgotSheet extends StatefulWidget {
  const _ForgotSheet();

  @override
  State<_ForgotSheet> createState() => _ForgotSheetState();
}

class _ForgotSheetState extends State<_ForgotSheet> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _pass = TextEditingController();
  bool _sent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    _pass.dispose();
    super.dispose();
  }

  String get _number {
    final d = _phone.text.replaceAll(RegExp(r'\D'), '');
    return d.startsWith('0') ? d : '0$d';
  }

  Future<void> _send() async {
    setState(() => _busy = true);
    final res = await inject<MasirApi>().sendResetCode(_number);
    if (!mounted) return;
    setState(() => _busy = false);
    res.fold((e) => setState(() => _error = e.friendly), (dev) {
      if (kDebugMode && dev != null) _code.text = dev;
      setState(() {
        _sent = true;
        _error = null;
      });
    });
  }

  Future<void> _reset() async {
    setState(() => _busy = true);
    final res = await inject<MasirApi>().resetPassword(
      _number,
      _code.text,
      _pass.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    res.fold((e) => setState(() => _error = e.friendly), (_) {
      Navigator.pop(context);
      Toast.show(
        context,
        title: 'رمزت عوض شد',
        body: 'حالا با رمز تازه وارد شو.',
      );
    });
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('رمز تازه بساز', style: T.of(19, FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
          _sent
              ? 'کد ۵ رقمی رو بزن و یه رمز تازه انتخاب کن.'
              : 'شماره‌ای که باهاش ثبت‌نام کردی رو بزن؛ یه کد برات پیامک می‌کنیم.',
          style: T.of(15, FontWeight.w500, C.body, 1.9),
        ),
        const SizedBox(height: 16),
        if (!_sent)
          Field(
            label: 'شماره موبایل',
            controller: _phone,
            hint: '۰۹۱۲ ۳۴۵ ۶۷۸۹',
            keyboard: TextInputType.phone,
            direction: TextDirection.ltr,
            error: _error,
          )
        else ...[
          OtpBoxes(controller: _code, error: _error != null),
          const SizedBox(height: 16),
          Field(
            label: 'رمز تازه',
            controller: _pass,
            obscure: true,
            direction: TextDirection.ltr,
            error: _error,
            helper: 'دست‌کم ۸ کاراکتر و یه عدد',
            onChanged: (_) => setState(() {}),
          ),
        ],
        const SizedBox(height: 18),
        if (!_sent)
          Btn(
            'ارسال کد',
            loading: _busy,
            onPressed: _number.length == 11 ? _send : null,
          )
        else
          Btn(
            'ذخیره‌ی رمز',
            loading: _busy,
            onPressed: _code.text.length == 5 && _pass.text.length >= 8
                ? _reset
                : null,
          ),
      ],
    ),
  );
}
