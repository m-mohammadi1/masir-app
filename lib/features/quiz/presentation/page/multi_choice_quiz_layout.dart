part of 'main_quiz_page.dart';

class _MultiChoiceQuizLayout extends StatefulWidget {
  const _MultiChoiceQuizLayout({super.key});

  @override
  State<_MultiChoiceQuizLayout> createState() => _MultiChoiceQuizLayoutState();
}

class _MultiChoiceQuizLayoutState extends State<_MultiChoiceQuizLayout> {
  int correct = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        16.h,
        CustomText("عنوان سوال چهار گزینه ای", fontSize: 18),
        24.h,
        Html(data: "توضیحات سوال"),
        24.h,
        _OptionWidget(
          title: "گزینه یک",
          selected: correct == 1,
          onTap: () {
            setState(() {
              correct = 1;
            });
          },
        ),
        8.h,
        _OptionWidget(
          title: "گزینه دو",
          onTap: () {
            setState(() {
              correct = 2;
            });
          },
          selected: correct == 2,
        ),
        8.h,
        _OptionWidget(
          title: "گزینه سه",
          onTap: () {
            setState(() {
              correct = 3;
            });
          },
          selected: correct == 3,
        ),
        8.h,
        _OptionWidget(
          title: "گزینه چهار",
          onTap: () {
            setState(() {
              correct = 4;
            });
          },
          selected: correct == 4,
        ),
      ],
    );
  }
}
