import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

class SectionHeaderWithAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSeeAllTap;

  const SectionHeaderWithAction({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.brass,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 3, width: 50, color: AppColors.forest),
            const SizedBox(height: 15),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.forestDeep,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onSeeAllTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.forest,
          ),
          child: const Row(
            children: [
              Text(
                'See All',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ],
    );
  }
}
