import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mohammad/core/helper/custom_colors.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/quiz/presentation/page/end_quiz_page.dart';
import 'package:mohammad/features/quiz/presentation/widgets/video_player.dart';
import 'package:mohammad/widgets/back_button.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';

import '../bloc/quiz_bloc.dart';
import '../bloc/video/video_view_model.dart';
import '../widgets/audio_player.dart';

part 'true_false_quiz_layout.dart';

part 'multi_choice_quiz_layout.dart';

part 'audio_quiz_layout.dart';

part 'video_quiz_layout.dart';

part 'home_work_quiz_layout.dart';

part 'base_quiz_layout.dart';

part '../widgets/option_widget.dart';

class MainQuizPage extends StatefulWidget {
  static const String routeName = "/quiz";

  const MainQuizPage({super.key});

  @override
  State<MainQuizPage> createState() => _MainQuizPageState();
}

class _MainQuizPageState extends State<MainQuizPage> {
  late final List<Widget> _quiz = [
    _TrueFalseQuizLayout(),
    _MultiChoiceQuizLayout(),
    _AudioQuizLayout(),
    _VideoQuizLayout(),
    _HomeWorkQuizLayout(),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {}

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    bloc.close();
  }

  final PageController _controller = PageController();
  final QuizBloc bloc = inject<QuizBloc>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: BlocConsumer<QuizBloc, QuizState>(
        bloc: bloc,
        listener: (context, state) {},
        builder: (context, state) {
          return BaseQuizLayout(
            controller: _controller,
            child: Flexible(
              child: SizedBox(
                child: ListView.builder(
                  itemCount: _quiz.length,
                  controller: _controller,
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.zero,
                  addAutomaticKeepAlives: false,
                  shrinkWrap: false,
                  cacheExtent: MediaQuery.of(context).size.width - 32,
                  itemExtent: MediaQuery.of(context).size.width - 32,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _quiz[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
