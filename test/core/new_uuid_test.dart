import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/api/masir_api.dart';

void main() {
  test('newUuid makes distinct v4 UUIDs', () {
    final re = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    );
    final ids = {for (var i = 0; i < 50; i++) newUuid()};
    expect(ids.length, 50);
    expect(ids.every(re.hasMatch), isTrue);
  });
}
