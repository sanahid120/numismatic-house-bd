import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const SectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(height: 3, width: 100, color: AppColors.forest),
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
    );
  }
}
