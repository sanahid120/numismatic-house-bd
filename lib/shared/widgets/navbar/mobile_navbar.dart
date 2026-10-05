import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import 'profile_button.dart';

class MobileNavbar extends StatelessWidget implements PreferredSizeWidget {
  const MobileNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.canvas,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      alignment: Alignment.center,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            // Logo
            Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                color: AppColors.forest,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'NUMISMATIC HOUSE',
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            const ProfileButton(color: AppColors.forest),
            // Menu Icon (opens main site navigation drawer)
            IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: AppColors.forest),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
