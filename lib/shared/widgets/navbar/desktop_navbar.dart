import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_paths.dart';
import 'profile_button.dart';

class DesktopNavbar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F4F1),
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      alignment: Alignment.center,
      child: Container(
        height: 60,
        constraints: const BoxConstraints(maxWidth: 1200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Logo Section
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF1E4D3B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NUMISMATIC',
                  style: TextStyle(
                    color: Color(0xFF1E4D3B),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    height: 1.1,
                  ),
                ),
                Text(
                  'HOUSE BD',
                  style: TextStyle(
                    color: Color(0xFF1E4D3B),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Links Section
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavBarLink(title: 'Home', onTap: () => context.go(RoutePaths.home)),
                _NavBarLink(title: 'Shop', onTap: () => context.go(RoutePaths.shop)),
                _NavBarLink(title: 'Auction', onTap: () => context.go(RoutePaths.auction)),
                _NavBarLink(title: 'Contact', onTap: () => context.go(RoutePaths.contact)),
              ],
            ),
            const SizedBox(width: 10),
            // Actions Section
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Color(0xFF1E4D3B), size: 22),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF1E4D3B), size: 22),
            ),
            const ProfileButton(color: Color(0xFF1E4D3B)),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}

class _NavBarLink extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavBarLink({required this.title, required this.onTap, super.key});

  @override
  State<_NavBarLink> createState() => _NavBarLinkState();
}

class _NavBarLinkState extends State<_NavBarLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _isHovered ? const Color(0xFF4CAF50) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) {
          setState(() {
            _isHovered = hovering;
          });
        },
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text(
          widget.title,
          style: TextStyle(
            color: _isHovered ? const Color(0xFF4CAF50) : const Color(0xFF1E4D3B),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
