import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '/app/routes.dart';
import '/app/state/session.dart';
import '/core/api/endpoints.dart';
import '/core/api/masir_api.dart';
import '/core/api/models.dart';
import '/core/services/service_locator.dart';
import '/design/design.dart';

/// Sign-up in 4 steps: invite code + phone → SMS code → password → name and
/// username. Every step can go back without losing what was typed.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final api = inject<MasirApi>();
  int _step = 0;

  // Step 1
  final _code = TextEditingController();
  final _phone = TextEditingController();
  InvitePreview? _invite;
  String? _codeError;
  bool _checkingCode = false;
  Timer? _codeDebounce;

  // Step 2
  final _otp = TextEditingController();
  int _resendIn = 0;
  Timer? _resendTimer;
  String? _otpError;

  // Step 3
  final _password = TextEditingController();
  bool _showPassword = false;
  String? _passwordError;

  // Step 4
  final _name = TextEditingController();
  final _username = TextEditingController();
  UsernameCheck? _usernameCheck;
  Timer? _usernameDebounce;
  String? _usernameError;

  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_code, _phone, _otp, _password, _name, _username]) {
      c.dispose();
    }
    _codeDebounce?.cancel();
    _resendTimer?.cancel();
    _usernameDebounce?.cancel();
    super.dispose();
  }

  String get _phoneNumber => '0${_phone.text.replaceAll(RegExp(r'\D'), '')}';
  bool get _phoneValid => RegExp(r'^09\d{9}$').hasMatch(_phoneNumber);

  // ---------------------------------------------------------------- step 1

  void _onCodeChanged(String v) {
    _codeDebounce?.cancel();
    setState(() {
      _invite = null;
      _codeError = null;
    });
    if (v.trim().length < 4) return;
    _codeDebounce = Timer(const Duration(milliseconds: 450), () async {
      setState(() => _checkingCode = true);
      final res = await api.previewInvite(v);
      if (!mounted || _code.text != v) return;
      setState(() {
        _checkingCode = false;
        res.fold(
          (e) => _codeError = e.offline
              ? e.message
              : 'این کد کار نمی‌کنه. از مؤسسه‌ت دوباره بپرس.',
          (p) => _invite = p,
        );
      });
    });
  }

  Future<void> _sendCode() async {
    setState(() => _busy = true);
    final res = await api.sendRegisterCode(_code.text, _phoneNumber);
    if (!mounted) return;
    setState(() => _busy = false);
    res.fold(
      (e) => Toast.show(
        context,
        title: e.status == 429 ? 'یه کم صبر کن' : 'کد ارسال نشد',
        body: e.friendly,
        tone: ToastTone.error,
      ),
      (dev) {
        if (kDebugMode && dev != null) _otp.text = dev;
        _startResendTimer();
        setState(() => _step = 1);
      },
    );
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendIn = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _resendIn--);
      if (_resendIn <= 0) t.cancel();
    });
  }

  // ---------------------------------------------------------------- step 3

  int get _strength {
    final p = _password.text;
    var s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'\d').hasMatch(p)) s++;
    if (RegExp(r'[A-Z]|[^A-Za-z0-9]').hasMatch(p)) s++;
    if (p.length >= 12) s++;
    return s;
  }

  bool get _passwordOk =>
      _password.text.length >= 8 && RegExp(r'\d').hasMatch(_password.text);

  Future<void> _createAccount() async {
    setState(() {
      _busy = true;
      _passwordError = null;
    });
    final res = await api.register(
      inviteCode: _code.text,
      phone: _phoneNumber,
      smsCode: _otp.text,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    await res.fold(
      (e) async {
        if (e.message == 'verification failed') {
          setState(() {
            _step = 1;
            _otpError = 'این کد درست نیست. دوباره بزنش.';
          });
        } else {
          Toast.show(
            context,
            title: 'حساب ساخته نشد',
            body: e.friendly,
            tone: ToastTone.error,
          );
        }
      },
      (r) async {
        await Session.signIn(r.token, r.student);
        if (r.student.name.isNotEmpty) _name.text = r.student.name;
        setState(() => _step = 3);
      },
    );
  }

  // ---------------------------------------------------------------- step 4

  void _onUsernameChanged(String v) {
    _usernameDebounce?.cancel();
    setState(() {
      _usernameCheck = null;
      _usernameError = null;
    });
    final u = v.trim().toLowerCase();
    if (u.length < 3) return;
    if (!RegExp(r'^[a-z0-9][a-z0-9._]{2,31}$').hasMatch(u)) {
      setState(() => _usernameError = 'فقط حروف انگلیسی، عدد، نقطه و _');
      return;
    }
    _usernameDebounce = Timer(const Duration(milliseconds: 400), () async {
      final res = await api.usernameAvailable(u);
      if (!mounted || _username.text.trim().toLowerCase() != u) return;
      res.fold((_) {}, (c) => setState(() => _usernameCheck = c));
    });
  }

  Future<void> _finish() async {
    setState(() => _busy = true);
    final res = await api.setUsername(
      _username.text.trim().toLowerCase(),
      _name.text.trim(),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    res.fold((e) => setState(() => _usernameError = e.friendly), (s) {
      Session.student.value = s;
      context.go(
        Routes.welcome,
        extra: {
          'institute_id': _invite?.instituteId ?? '',
          'brand': _invite?.brand,
          'name': s.firstName,
        },
      );
    });
  }

  // ---------------------------------------------------------------- ui

  void _back() {
    if (_step == 0 || _step == 3) {
      if (_step == 3) {
        return; // the account exists; finishing is the only way on
      }
      context.canPop() ? context.pop() : context.go(Routes.intro);
      return;
    }
    setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    final (label, title, body) = switch (_step) {
      0 => (
        'قدم ۱ از ۴',
        'سلام رفیق! از کجا اومدی؟',
        'مسیر فعلاً با دعوت مؤسسه‌ها باز می‌شه. کد رو از مؤسسه یا استادت بگیر.',
      ),
      1 => ('قدم ۲ از ۴', 'کد رو بزن', ''),
      2 => (
        'قدم ۳ از ۴',
        'یه رمز خوب بساز',
        'دفعه‌های بعد با نام کاربری و همین رمز وارد می‌شی.',
      ),
      _ => (
        'قدم آخر!',
        'اسمت اینجا چیه؟',
        'هم‌کلاسی‌ها و استادها با این اسم می‌شناسنت.',
      ),
    };
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
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
                      Row(
                        children: [
                          if (_step != 3) ...[
                            BackSquare(onTap: _back),
                            const SizedBox(width: 12),
                          ],
                          Expanded(child: _Steps(step: _step)),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text(label, style: T.of(13, FontWeight.w800, C.violet)),
                      const SizedBox(height: 8),
                      Text(title, style: T.of(28, FontWeight.w900, C.ink, 1.4)),
                      const SizedBox(height: 8),
                      if (_step == 1)
                        _otpIntro()
                      else
                        Text(
                          body,
                          style: T.of(15, FontWeight.w500, C.body, 1.9),
                        ),
                      const SizedBox(height: 22),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: KeyedSubtree(
                          key: ValueKey(_step),
                          child: switch (_step) {
                            0 => _stepCode(),
                            1 => _stepOtp(),
                            2 => _stepPassword(),
                            _ => _stepUsername(),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: _actions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actions() => switch (_step) {
    0 => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Btn(
          'ارسال کد',
          loading: _busy,
          onPressed: _invite != null && _phoneValid ? _sendCode : null,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('حساب داری؟', style: T.of(14, FontWeight.w500, C.muted)),
            TextButton(
              onPressed: () => context.go(Routes.login),
              child: Text(
                'وارد شو',
                style: T.of(14, FontWeight.w800, C.violet),
              ),
            ),
          ],
        ),
      ],
    ),
    1 => Btn(
      'تأیید',
      onPressed: _otp.text.length == 5
          ? () => setState(() {
              _otpError = null;
              _step = 2;
            })
          : null,
    ),
    2 => Btn(
      'ادامه',
      loading: _busy,
      onPressed: _passwordOk ? _createAccount : null,
    ),
    _ => Btn(
      'تموم! بزن بریم',
      loading: _busy,
      onPressed:
          _usernameCheck?.available == true && _name.text.trim().length >= 2
          ? _finish
          : null,
    ),
  };

  Widget _stepCode() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Field(
        label: 'کد دعوتِ مؤسسه',
        controller: _code,
        hint: 'ACME-7K2Q',
        direction: TextDirection.ltr,
        align: TextAlign.center,
        fontSize: 20,
        weight: FontWeight.w800,
        letterSpacing: 3,
        valid: _invite != null,
        error: _codeError,
        formatters: [_UpperCase()],
        onChanged: _onCodeChanged,
        suffix: _checkingCode
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
      ),
      if (_invite != null) ...[
        const SizedBox(height: 8),
        Semantics(
          liveRegion: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: C.greenSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                InstituteLogo(brand: _invite!.brand, size: 36, fontSize: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'کد درسته! عضو این مؤسسه می‌شی',
                        style: T.of(12, FontWeight.w700, C.greenText),
                      ),
                      Text(
                        _invite!.brand.name,
                        style: T.of(15, FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const MIcon(MI.check, color: C.greenText, strokeWidth: 3),
              ],
            ),
          ),
        ),
      ],
      const SizedBox(height: 22),
      Text('شماره موبایل', style: T.of(14, FontWeight.w800)),
      const SizedBox(height: 8),
      Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: C.sand,
                border: Border.all(color: C.border, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text('+۹۸', style: T.of(16, FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Field(
                label: '',
                controller: _phone,
                hint: '۹۱۲ ۳۴۵ ۶۷۸۹',
                keyboard: TextInputType.phone,
                direction: TextDirection.ltr,
                fontSize: 18,
                maxLength: 10,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _DropLeadingZero(),
                ],
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Text(
        _phone.text.isNotEmpty && _phone.text.length == 10 && !_phoneValid
            ? 'شماره با ۹ شروع می‌شه.'
            : 'یه کد ۵ رقمی برات پیامک می‌کنیم.',
        style: T.of(13, FontWeight.w500, C.muted),
      ),
    ],
  );

  Widget _otpIntro() {
    final d = _phoneNumber;
    final masked =
        '${d.substring(0, 4)} ${d.substring(4, 7)} ••${d.substring(9)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: T.of(15, FontWeight.w500, C.body, 1.9),
            children: [
              const TextSpan(text: 'یه کد ۵ رقمی به '),
              TextSpan(
                text: fa(masked),
                style: T.of(15, FontWeight.w800, C.body),
              ),
              const TextSpan(text: ' فرستادیم.'),
            ],
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _step = 0),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(44, 36),
          ),
          child: Text(
            'شماره رو عوض کن',
            style: T.of(14, FontWeight.w800, C.violet),
          ),
        ),
      ],
    );
  }

  Widget _stepOtp() => Column(
    children: [
      OtpBoxes(
        controller: _otp,
        error: _otpError != null,
        onChanged: (_) => setState(() => _otpError = null),
      ),
      const SizedBox(height: 12),
      if (_otpError != null)
        Text(_otpError!, style: T.of(13, FontWeight.w700, C.coralText)),
      if (_resendIn > 0)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MIcon(MI.clock, size: 16, color: C.muted),
            const SizedBox(width: 8),
            Text('ارسال دوباره تا ', style: T.of(14, FontWeight.w500, C.muted)),
            Text(clock(_resendIn), style: T.of(14, FontWeight.w800, C.muted)),
          ],
        )
      else
        TextButton(
          onPressed: _busy ? null : _sendCode,
          child: Text(
            'ارسال دوباره',
            style: T.of(14, FontWeight.w800, C.violet),
          ),
        ),
    ],
  );

  Widget _stepPassword() {
    final s = _strength;
    final (word, color) = switch (s) {
      0 || 1 => ('ضعیفه', C.coralText),
      2 => ('بد نیست', C.sunText),
      3 => ('خوبه!', C.greenText),
      _ => ('عالیه!', C.greenText),
    };
    Widget rule(bool ok, String text, {bool optional = false}) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 18,
            child: ok
                ? const MIcon(
                    MI.check,
                    size: 18,
                    color: C.greenText,
                    strokeWidth: 3,
                  )
                : Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: C.lockedLip,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: T.of(14, FontWeight.w500, ok ? C.greenText : C.muted),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Field(
          label: 'رمز عبور',
          controller: _password,
          obscure: !_showPassword,
          direction: TextDirection.ltr,
          fontSize: 18,
          error: _passwordError,
          onChanged: (_) => setState(() {}),
          suffix: _EyeButton(
            shown: _showPassword,
            onTap: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'قدرت رمز: $word',
          child: Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: i < s
                          ? (s <= 1
                                ? C.coral
                                : s == 2
                                ? C.sun
                                : C.green)
                          : C.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_password.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(word, style: T.of(13, FontWeight.w700, color)),
        ],
        const SizedBox(height: 22),
        rule(_password.text.length >= 8, 'دست‌کم ۸ کاراکتر'),
        rule(RegExp(r'\d').hasMatch(_password.text), 'یه عدد داشته باشه'),
        rule(
          RegExp(r'[A-Z]|[^A-Za-z0-9]').hasMatch(_password.text),
          'یه حرف بزرگ یا علامت (اختیاری)',
          optional: true,
        ),
      ],
    );
  }

  Widget _stepUsername() {
    final check = _usernameCheck;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Field(
          label: 'اسمت',
          controller: _name,
          onChanged: (_) => setState(() {}),
          action: TextInputAction.next,
        ),
        const SizedBox(height: 22),
        Field(
          label: 'نام کاربری',
          controller: _username,
          direction: TextDirection.ltr,
          fontSize: 18,
          valid: check?.available == true,
          error:
              _usernameError ??
              (check != null && !check.available
                  ? 'این یکی گرفته شده؛ یکی از اینا چطوره؟'
                  : null),
          prefix: Text('@', style: T.of(18, FontWeight.w700, C.muted)),
          suffix: check?.available == true
              ? const MIcon(MI.check, color: C.greenText, strokeWidth: 3)
              : null,
          onChanged: _onUsernameChanged,
        ),
        if (check?.available == true) ...[
          const SizedBox(height: 6),
          Semantics(
            liveRegion: true,
            child: Text(
              'آزاده، مال توئه!',
              style: T.of(13, FontWeight.w700, C.greenText),
            ),
          ),
        ],
        if (check != null && check.suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in check.suggestions)
                  Lip(
                    onTap: () {
                      _username.text = s;
                      _onUsernameChanged(s);
                    },
                    radius: 10,
                    lipColor: null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(s, style: T.of(14, FontWeight.w500)),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Steps extends StatelessWidget {
  final int step;
  const _Steps({required this.step});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'قدم ${fa(step + 1)} از ۴',
    child: Row(
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 8,
              decoration: BoxDecoration(
                color: i < step
                    ? C.green
                    : i == step
                    ? C.violet
                    : C.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

class _EyeButton extends StatelessWidget {
  final bool shown;
  final VoidCallback onTap;
  const _EyeButton({required this.shown, required this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: shown ? 'پنهان کردن رمز' : 'نشون دادن رمز',
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: C.sand,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: MIcon(MI.eye, size: 20, color: shown ? C.violet : C.ink),
      ),
    ),
  );
}

/// Five boxes over a hidden field; the active box takes the space colour.
class OtpBoxes extends StatefulWidget {
  final TextEditingController controller;
  final bool error;
  final ValueChanged<String>? onChanged;
  const OtpBoxes({
    super.key,
    required this.controller,
    this.error = false,
    this.onChanged,
  });

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.controller.text;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < 5; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _focus.requestFocus(),
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 2,
                          color: widget.error
                              ? C.coral
                              : (_focus.hasFocus && i == v.length.clamp(0, 4))
                              ? C.violet
                              : C.border,
                        ),
                        boxShadow: [
                          lip(
                            (_focus.hasFocus && i == v.length.clamp(0, 4))
                                ? C.violetBorder
                                : C.lip,
                            3,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        i < v.length ? fa(v[i]) : '',
                        style: T.of(26, FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                keyboardType: TextInputType.number,
                maxLength: 5,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (s) {
                  setState(() {});
                  widget.onChanged?.call(s);
                },
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}

class _DropLeadingZero extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.text.startsWith('0')) return newValue;
    final t = newValue.text.substring(1);
    return TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }
}
