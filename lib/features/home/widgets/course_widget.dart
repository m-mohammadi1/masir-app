import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_text.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Ink(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xffE7DEF8)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff6C2BD9).withValues(alpha: .08),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        title,
                        textAlign: TextAlign.right,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2F2146),
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        description,
                        textAlign: TextAlign.right,
                        fontSize: 14,
                        color: Color(0xff6E6884),
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: const Color(0xffF3EBFF),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(icon, size: 34, color: const Color(0xff7C3AED)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
