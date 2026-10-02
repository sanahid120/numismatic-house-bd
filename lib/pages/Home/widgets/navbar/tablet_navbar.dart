import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class TabletNavbar extends StatelessWidget implements PreferredSizeWidget {
  const TabletNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.canvas,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      alignment: Alignment.center,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Logo Icon
            Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                color: AppColors.forest,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            // Brand Name
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
            // Primary Nav Links
            _NavBarLink(title: 'Home', onTap: () {}),
            _NavBarLink(title: 'Shop', onTap: () {}),
            const SizedBox(width: 10),
            // Actions
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: AppColors.forest, size: 22),
            ),
            // Menu trigger for other categories/links
            IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu, color: AppColors.forest, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}

class _NavBarLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _NavBarLink({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.forest,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}