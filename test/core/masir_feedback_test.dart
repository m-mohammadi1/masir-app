import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/feedback/masir_feedback.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final calls = <String>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'HapticFeedback.vibrate') {
            calls.add(call.arguments as String);
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    MasirFeedback.isEnabled = () => true;
  });

  test('is silent when haptics are off', () async {
    MasirFeedback.isEnabled = () => false;
    MasirFeedback.tap();
    MasirFeedback.select();
    MasirFeedback.success();
    MasirFeedback.celebrate();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(calls, isEmpty);
  });

  test('buzzes when haptics are on', () async {
    MasirFeedback.isEnabled = () => true;
    MasirFeedback.tap();
    MasirFeedback.success();
    MasirFeedback.celebrate();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    expect(calls, contains('HapticFeedbackType.lightImpact'));
    expect(calls, contains('HapticFeedbackType.mediumImpact'));
    expect(calls, contains('HapticFeedbackType.heavyImpact'));
  });
}
