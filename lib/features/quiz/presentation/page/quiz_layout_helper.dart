import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/quiz/presentation/page/audio_quiz_layout.dart';
import 'package:mohammad/features/quiz/presentation/page/home_work_quiz_layout.dart';
import 'package:mohammad/features/quiz/presentation/page/multi_choice_quiz_layout.dart';
import 'package:mohammad/features/quiz/presentation/page/true_false_quiz_layout.dart';
import 'package:mohammad/features/quiz/presentation/page/video_quiz_layout.dart';
import 'package:flutter/material.dart';

enum QuizLayoutType {
  trueFalse,
  multiChoice,
  audio,
  video,
  homeWork,
}

QuizLayoutType quizLayoutTypeFromQuestion(String? type) {
  switch (type) {
    case 'true_false':
      return QuizLayoutType.trueFalse;
    case 'four_choice':
      return QuizLayoutType.multiChoice;
    case 'audio':
      return QuizLayoutType.audio;
    case 'video':
      return QuizLayoutType.video;
    case 'html':
    case 'practice':
      return QuizLayoutType.homeWork;
    default:
      return QuizLayoutType.trueFalse;
  }
}

QuizLayoutType quizLayoutTypeFromUnit(String? type) {
  switch (type) {
    case 'html':
    case 'practice':
      return QuizLayoutType.homeWork;
    case 'audio':
      return QuizLayoutType.audio;
    case 'video':
      return QuizLayoutType.video;
    case 'quiz':
      return QuizLayoutType.trueFalse;
    default:
      return QuizLayoutType.homeWork;
  }
}

String unitTypeLabel(String? type) {
  switch (type) {
    case 'html':
      return 'درس';
    case 'practice':
      return 'تمرین';
    case 'quiz':
      return 'آزمون';
    case 'audio':
      return 'صوتی';
    case 'video':
      return 'ویدئو';
    default:
      return type ?? '';
  }
}

List<UnitsQuestionModel> resolveQuizQuestions(UnitsModel data) {
  final questions =
      (data.payload?.questions ?? []).cast<UnitsQuestionModel>();
  if (questions.isNotEmpty) {
    return questions;
  }

  return [
    UnitsQuestionModel(
      id: data.id,
      type: data.type,
      text: data.title,
    ),
  ];
}

String? resolveAttachmentUrl(UnitsQuestionModel question) {
  final options = question.options ?? [];
  if (options.isEmpty) return null;

  final url = options.first;
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }
  return null;
}

String resolveInstructionText(UnitsModel data, UnitsQuestionModel question) {
  return question.text?.trim().isNotEmpty == true
      ? question.text!
      : data.title ?? '';
}

Widget buildQuizLayout({
  required String unitType,
  required UnitsQuestionModel question,
  required bool readOnly,
  ValueChanged<bool?>? onHomeworkAnswerChanged,
}) {
  final layoutType = unitType == 'quiz'
      ? quizLayoutTypeFromQuestion(question.type)
      : quizLayoutTypeFromUnit(unitType);

  switch (layoutType) {
    case QuizLayoutType.trueFalse:
      return TrueFalseQuizLayout(question: question, readOnly: readOnly);
    case QuizLayoutType.multiChoice:
      return MultiChoiceQuizLayout(question: question, readOnly: readOnly);
    case QuizLayoutType.audio:
      return AudioQuizLayout(question: question, readOnly: readOnly);
    case QuizLayoutType.video:
      return VideoQuizLayout(question: question, readOnly: readOnly);
    case QuizLayoutType.homeWork:
      return HomeWorkQuizLayout(
        question: question,
        readOnly: readOnly,
        onAnswerChanged: onHomeworkAnswerChanged,
      );
  }
}
