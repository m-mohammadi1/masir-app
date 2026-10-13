import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/helper/route_args.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page_args.dart';

void main() {
  group('routeArgs', () {
    test('reads the typed map a page is pushed with', () {
      expect(routeArgs(<String, String>{'id': 'c1', 'title': 'T'}), {
        'id': 'c1',
        'title': 'T',
      });
    });

    test('reads a map restored from browser history (decoded JSON)', () {
      // go_router decodes `extra` with json.decoder: Map<String, dynamic>.
      final restored = <String, dynamic>{'id': 'c1', 'moduleId': null};
      expect(routeArgs(restored), {'id': 'c1'});
    });

    test('reads a bare id string as the course detail shorthand', () {
      expect(routeArgs('c1'), {'id': 'c1'});
    });

    test('is empty when there is no extra (refresh, deep link)', () {
      expect(routeArgs(null), isEmpty);
      expect(routeArgs(42), isEmpty);
    });

    test('feeds UnitPageArgs from a restored map', () {
      final args = UnitPageArgs.fromMap(
        routeArgs(<String, dynamic>{'id': 'u1', 'type': 'quiz'}),
      );
      expect(args.unitId, 'u1');
      expect(args.unitType, 'quiz');
      expect(args.unitTitle, '');
    });
  });
}
