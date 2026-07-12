import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/request_quiz_submit_model.dart';
import 'package:mohammad/features/main/data/models/request_units_model.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/features/main/presentation/bloc/quiz_submit/quiz_submit_bloc.dart';
import 'package:mohammad/features/main/presentation/bloc/units/units_bloc.dart';
import 'package:mohammad/features/quiz/presentation/page/quiz_layout_helper.dart';
import 'package:mohammad/features/quiz/presentation/widgets/audio_unit_content.dart';
import 'package:mohammad/features/quiz/presentation/widgets/html_unit_content.dart';
import 'package:mohammad/features/quiz/presentation/widgets/practice_unit_content.dart';
import 'package:mohammad/features/quiz/presentation/widgets/quiz_result_content.dart';
import 'package:mohammad/features/quiz/presentation/widgets/quiz_unit_content.dart';
import 'package:mohammad/features/quiz/presentation/widgets/unit_content_framework.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_text.dart';

class UnitPage extends StatefulWidget {
  static const String routeName = '/unit';

  final String unitId;
  final String unitType;
  final String unitTitle;
  final String status;

  const UnitPage({
    super.key,
    required this.unitId,
    required this.unitType,
    this.unitTitle = '',
    this.status = '',
  });

  bool get isCompleted => status == 'completed';

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  final UnitsBloc _unitsBloc = inject<UnitsBloc>();
  final QuizSubmitBloc _quizSubmitBloc = inject<QuizSubmitBloc>();
  final GlobalKey<QuizUnitContentState> _quizContentKey =
      GlobalKey<QuizUnitContentState>();

  UnitsModel? _unitData;
  QuizSubmitResponseModel? _quizResult;
  Map<String, dynamic> _userAnswers = {};
  bool? _homeworkAnswer;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchUnit();
  }

  void _fetchUnit() {
    _unitsBloc.add(
      UnitsEvent.units(
        params: RequestUnitsModel(id: widget.unitId),
      ),
    );
  }

  void _onUnitsSuccess(UnitsModel data) {
    if (_unitData?.id == data.id) return;
    setState(() => _unitData = data);
  }

  bool get _isQuizUnit {
    final type = _unitData?.type ?? widget.unitType;
    return type == 'quiz';
  }

  bool get _isHtmlUnit {
    final type = _unitData?.type ?? widget.unitType;
    return type == 'html';
  }

  bool get _isPracticeUnit {
    final type = _unitData?.type ?? widget.unitType;
    return type == 'practice';
  }

  bool get _isAudioUnit {
    final type = _unitData?.type ?? widget.unitType;
    return type == 'audio';
  }

  void _handleBack() => CustomNavigator.pop();

  void _submitAnswers(List<QuizSubmitAnswerModel> answers) {
    setState(() => _isSubmitting = true);
    _userAnswers = {
      for (final answer in answers) answer.questionId: answer.answer,
    };
    _quizSubmitBloc.add(
      QuizSubmitEvent.quizSubmit(
        params: RequestQuizSubmitModel(
          id: widget.unitId,
          answers: answers,
        ),
      ),
    );
  }

  void _submitQuiz(List<QuizSubmitAnswerModel> answers) {
    _submitAnswers(answers);
  }

  void _submitSimpleUnit({List<QuizSubmitAnswerModel>? answers}) {
    _submitAnswers(answers ?? []);
  }

  void _submitHomework() {
    final questions = resolveQuizQuestions(_unitData!);
    final question = questions.isNotEmpty ? questions.first : null;
    if (question == null) {
      _handleBack();
      return;
    }

    if (_homeworkAnswer == null) {
      CustomToast.toast(context, 'لطفاً یک گزینه را انتخاب کنید');
      return;
    }

    _submitAnswers([
      QuizSubmitAnswerModel(
        questionId: question.id ?? '',
        answer: _homeworkAnswer,
      ),
    ]);
  }

  void _onQuizRetry() {
    setState(() {
      _quizResult = null;
      _userAnswers = {};
    });
    _quizContentKey.currentState?.reset();
  }

  void _onSubmitSuccess(QuizSubmitResponseModel data) {
    setState(() => _isSubmitting = false);

    if (_isQuizUnit) {
      setState(() => _quizResult = data);
      return;
    }

    _handleBack();
  }

  @override
  void dispose() {
    _unitsBloc.close();
    _quizSubmitBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BaseScreen(
        body: MultiBlocListener(
          listeners: [
            BlocListener<UnitsBloc, UnitsState>(
              bloc: _unitsBloc,
              listener: (context, state) {
                state.whenOrNull(success: (_, data) => _onUnitsSuccess(data));
              },
            ),
            BlocListener<QuizSubmitBloc, QuizSubmitState>(
              bloc: _quizSubmitBloc,
              listener: (context, state) {
                state.whenOrNull(
                  success: (_, data) => _onSubmitSuccess(data),
                  error: (_, __) => setState(() => _isSubmitting = false),
                );
              },
            ),
          ],
          child: BlocBuilder<UnitsBloc, UnitsState>(
            bloc: _unitsBloc,
            builder: (context, state) {
              return state.when(
                loading: (isLoading) {
                  if (isLoading || _unitData == null) {
                    return const Center(child: CustomLoading());
                  }
                  return _buildContent();
                },
                error: (_, message) => CustomError(
                  message: message,
                  retry: _fetchUnit,
                ),
                success: (_, data) {
                  if (_unitData == null) {
                    return const Center(child: CustomLoading());
                  }
                  return _buildContent();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final data = _unitData!;

    if (_isQuizUnit && _quizResult != null) {
      return QuizResultContent(
        data: data,
        result: _quizResult!,
        userAnswers: _userAnswers,
        onRetry: _onQuizRetry,
        onBack: _handleBack,
      );
    }

    if (_isQuizUnit) {
      return QuizUnitContent(
        key: _quizContentKey,
        data: data,
        isCompleted: widget.isCompleted,
        isSubmitting: _isSubmitting,
        onSubmit: widget.isCompleted ? null : _submitQuiz,
        onBack: _handleBack,
      );
    }

    if (_isHtmlUnit) {
      return HtmlUnitContent(
        data: data,
        isCompleted: widget.isCompleted,
        isSubmitting: _isSubmitting,
        onNext: widget.isCompleted
            ? _handleBack
            : () => _submitSimpleUnit(),
      );
    }

    if (_isPracticeUnit) {
      return PracticeUnitContent(
        data: data,
        isCompleted: widget.isCompleted,
        isSubmitting: _isSubmitting,
        onNext: widget.isCompleted
            ? _handleBack
            : () => _submitSimpleUnit(),
      );
    }

    if (_isAudioUnit) {
      return AudioUnitContent(
        data: data,
        isCompleted: widget.isCompleted,
        isSubmitting: _isSubmitting,
        onNext: widget.isCompleted
            ? _handleBack
            : () => _submitSimpleUnit(),
      );
    }

    return _buildDefaultUnitContent(data);
  }

  Widget _buildDefaultUnitContent(UnitsModel data) {
    final questions = resolveQuizQuestions(data);
    final question = questions.isNotEmpty ? questions.first : null;

    if (question == null) {
      return const Center(child: CustomText('سوالی برای نمایش وجود ندارد'));
    }

    final title =
        data.title?.isNotEmpty == true ? data.title! : widget.unitTitle;
    final instructionText = resolveInstructionText(data, question);
    final attachmentUrl = resolveAttachmentUrl(question);
    final typeLabel = unitTypeLabel(data.type ?? widget.unitType);

    return UnitContentFramework(
      title: title,
      typeLabel: typeLabel,
      isCompleted: widget.isCompleted,
      instructionText: instructionText,
      attachmentUrl: attachmentUrl,
      isSubmitting: _isSubmitting,
      content: widget.isCompleted
          ? null
          : buildQuizLayout(
              unitType: data.type ?? widget.unitType,
              question: question,
              readOnly: false,
              onHomeworkAnswerChanged: (value) {
                setState(() => _homeworkAnswer = value);
              },
            ),
      onNext: widget.isCompleted ? _handleBack : _submitHomework,
      nextButtonTitle: widget.isCompleted ? 'واحد بعدی' : 'ثبت پاسخ',
    );
  }
}
