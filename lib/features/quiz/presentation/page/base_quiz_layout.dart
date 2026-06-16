part of 'main_quiz_page.dart';

class BaseQuizLayout extends StatelessWidget {
  final Widget child;
  final PageController controller;

  const BaseQuizLayout({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final QuizBloc bloc = inject<QuizBloc>();
    return BlocListener<QuizBloc, QuizState>(
      bloc: bloc,
      listener: (context, state) {
        state.whenOrNull(
          changeIndex: (_, step) {
            if (bloc.isLastItem) {
              CustomNavigator.pushNamed(EndQuizPage.routeName);
            } else {
              controller.nextPage(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeIn,
              );
            }
          },
        );
      },
      child: Container(
        child: Column(
          children: [
            CustomBackButton(
              backAction: () {
                bloc.add(QuizEvent.changeStep(value: bloc.state.step - 1));
                controller.previousPage(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              },
            ),
            child,
            CustomButton(
              title: "بعدی",
              onTap: () {
                if (bloc.isLastItem) {
                  CustomNavigator.pushNamed(EndQuizPage.routeName);
                } else {
                  bloc.add(QuizEvent.changeStep(value: bloc.state.step + 1));
                }
              },
            ),
            30.h,
          ],
        ),
      ),
    );
  }
}
