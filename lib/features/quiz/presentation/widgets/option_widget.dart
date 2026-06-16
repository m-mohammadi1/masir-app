part of '../page/main_quiz_page.dart';

class _OptionWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final Function onTap;

  const _OptionWidget({
    super.key,
    required this.title,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OnClick(
      onTap: () => onTap(),
      child: Container(
        height: 48,
        width: context.appSize.width,
        decoration: BoxDecoration(
          color: selected ? AppColor.primary : null,
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? null
              : Border.all(color: AppColor.primary, width: 1.5),
        ),
        child: Center(
          child: CustomText(
            title,
            fontWeight: FontWeight.bold,
            color: selected ? AppColor.white : AppColor.primary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
