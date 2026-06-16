part of 'main_quiz_page.dart';

class _VideoQuizLayout extends StatelessWidget {
   _VideoQuizLayout({super.key});

  final VideoViewModel videoViewModel = VideoViewModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        16.h,
        CustomText("عنوان سوال ویدئویی", fontSize: 18),
        24.h,
        Html(data: "توضیحات سوال"),
        24.h,
        CustomVideoPlayer(url: "", videoViewModel: videoViewModel),
      ],
    );
  }
}
