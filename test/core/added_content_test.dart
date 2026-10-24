import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/api/models.dart';

Map<String, dynamic> _unit(
  String id, {
  bool done = false,
  bool optional = false,
  bool isNew = false,
  bool updated = false,
}) => {
  'id': id,
  'title': id,
  'type': 'html',
  'status': done ? 'completed' : 'not_started',
  'optional': optional,
  'new': isNew,
  'updated': updated,
};

/// SPEC §2.4's example: chapter 1 done; «لیسنینگ» path 1 has 2 of 3 done
/// plus one unit added behind the student; 5 of 11 units done.
Outline _spec() => Outline.fromJson({
  'id': 'c1',
  'title': 'آمادگی آیلتس',
  'total_units': 11,
  'completed_units': 5,
  'course_progress_percent': 45,
  'current_unit_id': 'l3',
  'access': {'state': 'active', 'enrolled': true},
  'modules': [
    {
      'id': 'ch1',
      'title': 'آشنایی',
      'paths': [
        {
          'id': 'c1p1',
          'title': 'شروع',
          'units': [_unit('a1', done: true), _unit('a2', done: true)],
        },
        {
          'id': 'c1p2',
          'title': 'آزمونک',
          'units': [_unit('a3', done: true)],
        },
      ],
    },
    {
      'id': 'ch2',
      'title': 'لیسنینگ',
      'paths': [
        {
          'id': 'c2p1',
          'title': 'پیش‌خوانی',
          'units': [
            _unit('l1', done: true),
            _unit('new', optional: true, isNew: true),
            _unit('l2', done: true),
            _unit('l3'),
          ],
        },
        {
          'id': 'c2p2',
          'title': 'گفت‌وگوها',
          'units': [_unit('l4'), _unit('l5')],
        },
      ],
    },
    {
      'id': 'ch3',
      'title': 'ریدینگ',
      'paths': [
        {
          'id': 'c3p1',
          'title': 'اسکن',
          'units': [_unit('r1'), _unit('r2'), _unit('r3')],
        },
      ],
    },
  ],
});

void main() {
  test('optional, new and updated flags parse from the outline', () {
    final u = OutlineUnit.fromJson(
      _unit('x', done: true, optional: true, isNew: true, updated: true),
    );
    expect([u.optional, u.isNew, u.updated], [true, true, true]);
    final plain = OutlineUnit.fromJson({'id': 'y', 'status': 'not_started'});
    expect([plain.optional, plain.isNew, plain.updated], [false, false, false]);
  });

  test('optional units count only once completed (SPEC §2.4)', () {
    final o = _spec();
    final ch2 = o.modules[1].counts;
    expect([ch2.done, ch2.total, ch2.optionalLeft], [2, 5, 1]);
    expect(o.modules[1].paths[0].counts.percent, 67);
    expect(o.modules[0].counts.complete, isTrue);
  });

  test('completing an optional unit offline adds 1 to both sides', () {
    final o = _spec().withCompleted({'new'});
    expect(o.completedUnits, 6);
    expect(o.totalUnits, 12);
    expect(o.progressPercent, 50);
    final ch2 = o.modules[1].counts;
    expect([ch2.done, ch2.total, ch2.optionalLeft], [3, 6, 0]);
    expect(o.modules[1].paths[0].counts.percent, 75);
    expect(o.currentUnitId, 'l3', reason: 'the pin never moves back');
    final done = o.units.firstWhere((u) => u.id == 'new');
    expect(done.completed && !done.isNew, isTrue);
  });

  test('the current unit skips optional units when it moves on', () {
    final o = Outline.fromJson({
      'id': 'c1',
      'title': 'x',
      'current_unit_id': 'u1',
      'access': {'state': 'active', 'enrolled': true},
      'modules': [
        {
          'id': 'm1',
          'title': 'فصل',
          'paths': [
            {
              'id': 'p1',
              'title': 'مسیر',
              'units': [_unit('u1'), _unit('opt', optional: true), _unit('u2')],
            },
          ],
        },
      ],
    }).withCompleted({'u1'});
    expect(o.currentUnitId, 'u2');
  });

  test('an added chapter counts all of its units and is new once', () {
    final m = OutlineModule.fromJson({
      'id': 'vocab',
      'title': 'واژگان',
      'new': true,
      'paths': [
        {
          'id': 'vp',
          'title': 'واژه‌ها',
          'units': [
            _unit('v1', optional: true),
            _unit('v2', optional: true),
            _unit('v3', optional: true),
          ],
        },
      ],
    });
    final c = m.counts;
    expect([c.done, c.total, c.added, c.complete], [0, 3, true, false]);
    expect(m.isNew, isTrue);
  });
}
