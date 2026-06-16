part of 'main_quiz_page.dart';

class _AudioQuizLayout extends StatelessWidget {
  const _AudioQuizLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        16.h,
        CustomText("عنوان سوال صوتی", fontSize: 18),
        24.h,
        Html(data: "توضیحات سوال"),
        24.h,
        CustomAudioPlayer(onChanged: (value) {}, url: ""),
      ],
    );
  }
}
