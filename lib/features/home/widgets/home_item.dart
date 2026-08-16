import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/assets.dart';
import '../../../widgets/custom_text.dart';
import '../page/route_map_page.dart';
import '/core/theme/theme_context.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return OnClick(
      onTap: () => CustomNavigator.pushNamed(RouteMapPage.routeName),
      child: Container(
        // height: 270,
        width: 340,
        margin: EdgeInsetsDirectional.only(start: 8, bottom: 0),
        decoration: BoxDecoration(
          color: context.colors.white,
          border: Border.all(color: context.colors.border150),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomImage(
                assets: Assets.banner,
                radius: 16,
                height: 176,
                fit: BoxFit.fill,
              ),
              12.h,
              Padding(
                padding: EdgeInsetsDirectional.only(start: 8),
                child: CustomText(
                  'تست تست',
                  fontSize: 14,
                  maxLines: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              4.h,
              Padding(
                padding: EdgeInsetsDirectional.only(start: 8),
                child: CustomText(
                  'لورم تکست',
                  fontSize: 12,
                  maxLines: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
