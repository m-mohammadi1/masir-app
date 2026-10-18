import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/core/api/models.dart';

Map<String, dynamic> _course({
  String state = 'guest',
  Map<String, dynamic>? extra,
}) => {
  'id': 'c1',
  'institute_id': 'i1',
  'title': 'آمادگی آیلتس',
  'teachers': [
    {'user_id': 't1', 'name': 'مریم احمدی'},
    {'user_id': 't2', 'name': 'Acme Teacher'},
  ],
  'plans': [
    {
      'period': 'm1',
      'months': 1,
      'price': 290000,
      'per_month': 290000,
      'save_percent': 0,
    },
  ],
  'free_course': false,
  'from_per_month': 210000,
  'preview_units': 3,
  'unit_count': 11,
  'access': {'state': state, 'enrolled': state != 'guest', 'days_left': 3},
  ...?extra,
};

void main() {
  test('course access states map from the API', () {
    expect(CourseCard.fromJson(_course()).access.state, AccessState.guest);
    expect(
      CourseCard.fromJson(_course(state: 'expiring')).access.state,
      AccessState.expiring,
    );
    expect(
      CourseCard.fromJson(_course(state: 'expiring')).access.fullAccess,
      isTrue,
    );
    expect(
      CourseCard.fromJson(_course(state: 'trial')).access.fullAccess,
      isFalse,
    );
    expect(
      CourseCard.fromJson(_course(state: 'expired')).access.fullAccess,
      isFalse,
    );
  });

  test('teacher line names the first teacher and counts the rest', () {
    expect(
      CourseCard.fromJson(_course()).teacherLine,
      'مریم احمدی و ۱ نفر دیگه',
    );
  });

  test('outline finds the current unit across modules and paths', () {
    final o = Outline.fromJson({
      'id': 'c1',
      'title': 'x',
      'current_unit_id': 'u3',
      'access': {'state': 'active', 'enrolled': true},
      'modules': [
        {
          'id': 'm1',
          'title': 'فصل',
          'paths': [
            {
              'id': 'p1',
              'title': 'مسیر',
              'units': [
                {
                  'id': 'u1',
                  'title': 'a',
                  'type': 'html',
                  'status': 'completed',
                },
                {
                  'id': 'u2',
                  'title': 'b',
                  'type': 'video',
                  'status': 'completed',
                },
              ],
            },
            {
              'id': 'p2',
              'title': 'مسیر ۲',
              'units': [
                {
                  'id': 'u3',
                  'title': 'c',
                  'type': 'quiz',
                  'status': 'not_started',
                  'question_count': 6,
                },
              ],
            },
          ],
        },
      ],
    });
    expect(o.units.length, 3);
    expect(o.currentUnit?.title, 'c');
    expect(o.units.first.completed, isTrue);
  });

  test('review answers read as Persian text', () {
    final tf = ReviewQuestion.fromJson({
      'id': 'q',
      'type': 'true_false',
      'text': 't',
      'answer_bool': false,
      'correct_bool': true,
    });
    expect(tf.answerText(tf.answerBool, tf.answerIndex), 'نادرست');
    expect(tf.answerText(tf.correctBool, tf.correctIndex), 'درست');
    final four = ReviewQuestion.fromJson({
      'id': 'q',
      'type': 'four_choice',
      'text': 't',
      'options': ['a', 'b', 'c', 'd'],
      'answer_index': 2,
      'correct': true,
    });
    expect(four.answerText(four.answerBool, four.answerIndex), 'c');
    expect(four.answerText(null, null), '—');
  });

  test('units finished offline show as done and move the current unit', () {
    final o = Outline.fromJson({
      'id': 'c1',
      'title': 'x',
      'total_units': 3,
      'completed_units': 0,
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
              'units': [
                {
                  'id': 'u1',
                  'title': 'a',
                  'type': 'html',
                  'status': 'not_started',
                },
                {
                  'id': 'u2',
                  'title': 'b',
                  'type': 'html',
                  'status': 'not_started',
                  'locked': true,
                },
                {
                  'id': 'u3',
                  'title': 'c',
                  'type': 'html',
                  'status': 'not_started',
                  'locked': true,
                },
              ],
            },
          ],
        },
      ],
    }).withCompleted({'u1'});
    expect(o.units.first.completed, isTrue);
    expect(o.completedUnits, 1);
    expect(o.progressPercent, 33);
    expect(o.currentUnitId, 'u2');
  });
}
