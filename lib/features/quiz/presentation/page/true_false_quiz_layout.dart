part of 'main_quiz_page.dart';

class _TrueFalseQuizLayout extends StatefulWidget {
  const _TrueFalseQuizLayout({super.key});

  @override
  State<_TrueFalseQuizLayout> createState() => _TrueFalseQuizLayoutState();
}

class _TrueFalseQuizLayoutState extends State<_TrueFalseQuizLayout> {
  bool? correct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        16.h,
        CustomText("عنوان سوال صحیح و غلط", fontSize: 18),
        24.h,
        Html(data: "توضیحات سوال"),
        24.h,
        _OptionWidget(
          title: "درست",
          selected: correct == true,
          onTap: () {
            setState(() {
              correct = true;
            });
          },
        ),
        8.h,
        _OptionWidget(
          title: "غلط",
          onTap: () {
            setState(() {
              correct = false;
            });
          },
          selected: correct == false,
        ),
      ],
    );
  }
}
