import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mohammad/features/main/data/models/units_model.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';

class HtmlUnitContent extends StatelessWidget {
  final UnitsModel data;
  final bool isCompleted;
  final bool isSubmitting;
  final VoidCallback onNext;

  const HtmlUnitContent({
    super.key,
    required this.data,
    required this.isCompleted,
    this.isSubmitting = false,
    required this.onNext,
  });

  String get _body => data.payload?.body ?? '';

  @override
  Widget build(BuildContext context) {
    final title = data.title ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomAppBar(title: title),
        16.h,
        Row(
          children: [
            _HtmlTypeBadge(label: data.type ?? 'html'),
            const Spacer(),
            if (isCompleted) const _CompletedBadge(),
          ],
        ),
        16.h,
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffE7DEF8)),
              ),
              child: Html(
                data: _body,
                style: {
                  'body': Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff2F2146),
                    textAlign: TextAlign.right,
                    direction: TextDirection.rtl,
                  ),
                  'b': Style(
                    fontWeight: FontWeight.bold,
                  ),
                },
              ),
            ),
          ),
        ),
        16.h,
        CustomButton(
          title: 'واحد بعدی',
          loading: isSubmitting,
          onTap: onNext,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                'واحد بعدی',
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              8.w,
              const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            ],
          ),
        ),
        20.h,
      ],
    );
  }
}

class _HtmlTypeBadge extends StatelessWidget {
  final String label;

  const _HtmlTypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffF3EBFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xff7C3AED),
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffE8F5E9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffA5D6A7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Color(0xff4CAF50),
          ),
          6.w,
          const CustomText(
            'تکمیل شده',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff4CAF50),
          ),
        ],
      ),
    );
  }
}
