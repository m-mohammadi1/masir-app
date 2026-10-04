import '/core/feedback/masir_feedback.dart';
import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import '/core/copy/masir_copy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_outline_course_model.dart';
import 'package:mohammad/features/main/domain/entities/outline_course.dart';
import 'package:mohammad/features/main/domain/usecases/outline_course_usecase.dart';
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
import 'package:mohammad/widgets/unit_kit/unit_shell.dart';
import 'package:url_launcher/url_launcher.dart';
import '/widgets/list_row.dart';
import '/widgets/icon_tile.dart';
import 'package:mohammad/features/quiz/presentation/widgets/video_unit_content.dart';
import 'package:mohammad/core/helper/route_args.dart';
import 'package:mohammad/features/home/page/detail_course_page.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/helper/go_back.dart';
import '/core/theme/masir_style.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';
import '/core/theme/institute_themed.dart';
import '/widgets/masir_notice.dart';
import '/widgets/masir_page.dart';
import '/widgets/masir_toast.dart';
import '/widgets/state_view.dart';
import '/features/teacher/presentation/widgets/course_teacher_row.dart';

class UnitPage extends StatefulWidget {
  static const String routeName = '/unit';

  final String unitId;
  final String unitType;
  final String unitTitle;
  final String status;

  /// Institute theme carried over from the screen that opened this unit.
  final String? themePreset;

  const UnitPage({
    super.key,
    required this.unitId,
    required this.unitType,
    this.unitTitle = '',
    this.status = '',
    this.themePreset,
  });

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  final UnitsBloc _unitsBloc = inject<UnitsBloc>();
  final QuizSubmitBloc _quizSubmitBloc = inject<QuizSubmitBloc>();
  final GlobalKey<QuizUnitContentState> _quizContentKey =
      GlobalKey<QuizUnitContentState>();

  // The unit on screen. It starts as the one the roadmap opened and changes
  // in place when the student moves on to the next unit of the path.
  late String _unitId = widget.unitId;
  late String _unitType = widget.unitType;
  late String _unitTitle = widget.unitTitle;
  late String _status = widget.status;

  bool get _isCompleted => _status == 'completed';

  UnitsModel? _unitData;
  QuizSubmitResponseModel? _quizResult;
  Map<String, dynamic> _userAnswers = {};
  bool? _homeworkAnswer;
  bool _isSubmitting = false;

  /// Id of the last unit completed during this visit (a simple unit submitted,
  /// or a quiz passed). Handed back to the roadmap when the page closes.
  String? _lastCompletedId;

  /// Resolving / switching to the next unit.
  bool _advancing = false;

  @override
  void initState() {
    super.initState();
    _fetchUnit();
  }

  void _fetchUnit() {
    _unitsBloc.add(UnitsEvent.units(params: RequestUnitsModel(id: _unitId)));
  }

  void _onUnitsSuccess(UnitsModel data) {
    if (_unitData?.id == data.id) return;
    setState(() => _unitData = data);
  }

  bool get _isQuizUnit {
    final type = _unitData?.type ?? _unitType;
    return type == 'quiz';
  }

  bool get _isHtmlUnit {
    final type = _unitData?.type ?? _unitType;
    return type == 'html';
  }

  bool get _isPracticeUnit {
    final type = _unitData?.type ?? _unitType;
    return type == 'practice';
  }

  bool get _isAudioUnit {
    final type = _unitData?.type ?? _unitType;
    return type == 'audio';
  }

  bool get _isVideoUnit {
    final type = _unitData?.type ?? _unitType;
    return type == 'video';
  }

  void _handleBack() => goBack(context, result: _lastCompletedId);

  Widget? _previewBanner(UnitsModel data) {
    if (data.isPreview != true) return null;
    return Builder(
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: context.colors.sunSoft,
          borderRadius: BorderRadius.circular(MasirRadius.chip),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard_rounded,
              size: 18,
              color: context.colors.sunEdge,
            ),
            8.w,
            CustomText.caption(
              'پیش‌نمایش رایگان',
              color: context.colors.sunEdge,
            ),
          ],
        ),
      ),
    );
  }

  Widget? _previewFooter(UnitsModel data) {
    if (data.isLastPreview != true) return null;
    final courseId = data.courseId;
    return Builder(
      builder: (context) => ChunkyBox(
        fill: context.colors.surface,
        edge: context.colors.sunEdge,
        borderColor: context.colors.sun,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText.title(
              'پایان بخش رایگان',
              color: context.colors.ink,
              textAlign: TextAlign.center,
            ),
            8.h,
            CustomText.caption(
              'برای ادامه مسیر ثبت‌نام کن',
              color: context.colors.inkMuted,
              textAlign: TextAlign.center,
            ),
            12.h,
            CustomButton(
              title: 'ثبت‌نام',
              onTap: () {
                if (courseId == null || courseId.isEmpty) return;
                CustomNavigator.pushNamed(
                  DetailCoursePage.routeName,
                  arguments: courseDetailArgs(
                    courseId,
                    themePreset: widget.themePreset,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitAnswers(List<QuizSubmitAnswerModel> answers) {
    setState(() => _isSubmitting = true);
    _userAnswers = {
      for (final answer in answers) answer.questionId: answer.answer,
    };
    _quizSubmitBloc.add(
      QuizSubmitEvent.quizSubmit(
        params: RequestQuizSubmitModel(id: _unitId, answers: answers),
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
      CustomToast.toast(context, 'یه گزینه رو انتخاب کن');
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
      if (data.passed == true) {
        _lastCompletedId = _unitId;
        MasirFeedback.celebrate();
      } else {
        MasirFeedback.tap();
      }
      setState(() => _quizResult = data);
      return;
    }

    _lastCompletedId = _unitId;
    MasirFeedback.success();
    _advance();
  }

  /// Moves straight on to the next unit of the same path, without passing
  /// through the roadmap. Falls back to closing the page (which hands the
  /// completed unit back to the roadmap) at the end of a path, when the next
  /// unit is locked, or if the path can't be resolved.
  Future<void> _advance() async {
    if (_advancing) return;
    final courseId = _unitData?.courseId;
    if (courseId == null || courseId.isEmpty) {
      _handleBack();
      return;
    }
    setState(() {
      _advancing = true;
      _isSubmitting = true;
    });

    final result = await inject<OutlineCourseUseCase>()(
      params: RequestOutlineCourseModel(id: courseId),
    );
    if (!mounted) return;

    final next = result.fold<OutlineUnitEntity?>((_) => null, (outline) {
      for (final module in outline.modules ?? <OutlineModuleEntity>[]) {
        for (final path in module.paths ?? <OutlinePathEntity>[]) {
          final units = path.units ?? <OutlineUnitEntity>[];
          final index = units.indexWhere((u) => u.id == _unitId);
          if (index < 0) continue;
          if (index + 1 >= units.length) return null;
          return units[index + 1];
        }
      }
      return null;
    });

    if (next == null || (next.locked ?? false) || (next.id ?? '').isEmpty) {
      _handleBack();
      return;
    }

    setState(() {
      _unitId = next.id!;
      _unitType = next.type ?? '';
      _unitTitle = next.title ?? '';
      _status = next.status ?? '';
      _unitData = null;
      _quizResult = null;
      _userAnswers = {};
      _homeworkAnswer = null;
      _isSubmitting = false;
      _advancing = false;
    });
    MasirToast.show(
      context,
      title: MasirCopy.cheer(),
      message: 'درس بعدی: $_unitTitle',
      tone: NoticeTone.success,
    );
    _fetchUnit();
  }

  @override
  void dispose() {
    _unitsBloc.close();
    _quizSubmitBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InstituteThemed(
      preset: widget.themePreset,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MultiBlocListener(
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
          child: _withTransition(
            BlocBuilder<UnitsBloc, UnitsState>(
              bloc: _unitsBloc,
              builder: (context, state) {
                return state.when(
                  loading: (isLoading) {
                    if (isLoading || _unitData == null) return _loadingPage();
                    return _buildContent();
                  },
                  error: (_, message) => MasirPage.focus(
                    title: _unitTitle,
                    onClose: _handleBack,
                    body: StateView.error(message: message, retry: _fetchUnit),
                  ),
                  success: (_, data) {
                    if (_unitData == null) return _loadingPage();
                    return _buildContent();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Fades between units when the student moves on. The "well done" notice is
  /// shown by [_advance] through the shared toast.
  Widget _withTransition(Widget child) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 460),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            // The next unit glides in from the leading side while the one just
            // finished slides away the other way (the page is right-to-left,
            // so "next" arrives from the left).
            transitionBuilder: (child, animation) {
              final incoming = child.key == ValueKey(_unitId);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(incoming ? -0.35 : 0.35, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.96,
                      end: 1,
                    ).animate(animation),
                    child: child,
                  ),
                ),
              );
            },
            child: KeyedSubtree(key: ValueKey(_unitId), child: child),
          ),
        ),
      ],
    );
  }

  Widget _loadingPage() => MasirPage.focus(
    title: _unitTitle,
    onClose: _handleBack,
    body: const StateView.loading(variant: SkeletonVariant.detail),
  );

  Widget _buildContent() {
    final data = _unitData!;

    if (_isQuizUnit && _quizResult != null) {
      return QuizResultContent(
        data: data,
        result: _quizResult!,
        userAnswers: _userAnswers,
        onRetry: _onQuizRetry,
        onBack: _handleBack,
        onContinue: _advance,
        banner: _previewBanner(data),
        footer: _previewFooter(data),
      );
    }

    if (_isQuizUnit) {
      return QuizUnitContent(
        key: _quizContentKey,
        data: data,
        isCompleted: _isCompleted,
        isSubmitting: _isSubmitting,
        onSubmit: _isCompleted ? null : _submitQuiz,
        onBack: _handleBack,
        banner: _previewBanner(data),
        footer: _previewFooter(data),
      );
    }

    if (_isHtmlUnit) {
      return HtmlUnitContent(
        data: data,
        isCompleted: _isCompleted,
        isSubmitting: _isSubmitting,
        onComplete: _isCompleted ? null : () => _submitSimpleUnit(),
        onBack: _handleBack,
        banner: _previewBanner(data),
        footer: _previewFooter(data),
      );
    }

    if (_isPracticeUnit) {
      return PracticeUnitContent(
        data: data,
        isCompleted: _isCompleted,
        isSubmitting: _isSubmitting,
        onComplete: _isCompleted ? null : () => _submitSimpleUnit(),
        onBack: _handleBack,
        banner: _previewBanner(data),
        footer: _previewFooter(data),
      );
    }

    if (_isAudioUnit) {
      return AudioUnitContent(
        data: data,
        isCompleted: _isCompleted,
        isSubmitting: _isSubmitting,
        onComplete: _isCompleted ? null : () => _submitSimpleUnit(),
        onBack: _handleBack,
        banner: _previewBanner(data),
        footer: _previewFooter(data),
      );
    }

    if (_isVideoUnit) {
      return VideoUnitContent(
        data: data,
        isCompleted: _isCompleted,
        isSubmitting: _isSubmitting,
        onComplete: _isCompleted ? null : () => _submitSimpleUnit(),
        onBack: _handleBack,
        banner: _previewBanner(data),
        footer: _previewFooter(data),
      );
    }

    return _buildDefaultUnitContent(data);
  }

  Widget _buildDefaultUnitContent(UnitsModel data) {
    final questions = resolveQuizQuestions(data);
    final question = questions.isNotEmpty ? questions.first : null;

    if (question == null) {
      return const Center(child: CustomText('این بخش هنوز خالیه'));
    }

    final title = data.title?.isNotEmpty == true ? data.title! : _unitTitle;
    final instructionText = resolveInstructionText(data, question);
    final attachmentUrl = resolveAttachmentUrl(question);
    final unitType = data.type ?? _unitType;
    final c = context.colors;

    return UnitShell(
      type: unitType,
      title: title,
      isCompleted: _isCompleted,
      headerIcon: unitTeacherHeaderIcon(data.teachers),
      banner: _previewBanner(data),
      footer: _previewFooter(data),
      isSubmitting: _isSubmitting,
      onComplete: _isCompleted ? null : _submitHomework,
      onBack: _handleBack,
      primaryTitle: 'تکمیل شد',
      children: [
        if (instructionText.isNotEmpty)
          ChunkyBox(
            fill: c.surface,
            edge: c.lip,
            borderColor: c.border,
            radius: MasirRadius.card,
            padding: const EdgeInsets.all(MasirSpace.lg),
            child: CustomText.headline(instructionText, color: c.ink),
          ),
        if (attachmentUrl != null && attachmentUrl.isNotEmpty) ...[
          const SizedBox(height: MasirSpace.md),
          ListRow(
            leading: const IconTile(
              Icons.attach_file_rounded,
              tone: IconTileTone.brand,
            ),
            title: 'باز کردن فایل پیوست',
            onTap: () async {
              final uri = Uri.tryParse(attachmentUrl);
              if (uri != null && await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
        if (!_isCompleted) ...[
          const SizedBox(height: MasirSpace.lg),
          buildQuizLayout(
            unitType: unitType,
            question: question,
            readOnly: false,
            onHomeworkAnswerChanged: (value) {
              setState(() => _homeworkAnswer = value);
            },
          ),
        ],
      ],
    );
  }
}
