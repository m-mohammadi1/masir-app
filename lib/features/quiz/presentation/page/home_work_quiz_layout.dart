part of 'main_quiz_page.dart';

class _HomeWorkQuizLayout extends StatefulWidget {
  const _HomeWorkQuizLayout({super.key});

  @override
  State<_HomeWorkQuizLayout> createState() => _HomeWorkQuizLayoutState();
}

class _HomeWorkQuizLayoutState extends State<_HomeWorkQuizLayout> {

  bool? correct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        16.h,
        CustomText("عنوان سوال تمرینی", fontSize: 18),
        24.h,
        Html(data: "توضیحات سوال"),
        24.h,
        Html(data: "محتوای متن درس به شرح زیر هست ولی شرح زیر خالیه پس یک متنی مینویسیم تا خالی نباشد.</br></br></br></br></br> نقطه سر خط"),
        8.h,
        _OptionWidget(
          title: "خواندم",
          selected: correct == true,
          onTap: () {
            setState(() {
              correct = true;
            });
          },
        ),
        8.h,
        _OptionWidget(
          title: "فراموش کردم",
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
