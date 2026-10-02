import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPageButton(
          context,
          icon: Icons.chevron_left,
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        const SizedBox(width: 10),
        for (int i = 1; i <= totalPages; i++)
          _buildPageNumber(context, i, i == currentPage),
        const SizedBox(width: 10),
        _buildPageButton(
          context,
          icon: Icons.chevron_right,
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }

  Widget _buildPageButton(BuildContext context, {required IconData icon, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: onPressed != null ? AppColors.forest : AppColors.mutedInk),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.mint.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPageNumber(BuildContext context, int page, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => onPageChanged(page),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.forest : AppColors.paper,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? AppColors.forest : AppColors.line),
          ),
          child: Text(
            page.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.ink,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
