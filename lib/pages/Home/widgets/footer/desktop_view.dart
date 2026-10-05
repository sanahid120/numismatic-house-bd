import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/router/route_paths.dart';
import 'footer_widgets.dart';

class DesktopView extends StatelessWidget {
  const DesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forestDeep,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand Info
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_balance, color: AppColors.forest, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'NH BD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Numismatic House BD is your trusted partner in collecting high-grade UNC condition banknotes from around the world. We preserve history, one note at a time.',
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const SocialIcon(icon: Icons.facebook),
                        const SocialIcon(icon: Icons.work_outline),
                        const SocialIcon(icon: Icons.language),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              // Quick Links
              Expanded(
                child: FooterColumn(
                  title: 'Quick Links',
                  children: [
                    FooterLink(label: 'Home', path: RoutePaths.home),
                    FooterLink(label: 'Shop', path: RoutePaths.shop),
                    FooterLink(label: 'My Account', path: RoutePaths.profile),
                    FooterLink(label: 'Contact', path: RoutePaths.contact),
                  ],
                ),
              ),
              // Categories
              Expanded(
                child: FooterColumn(
                  title: 'Categories',
                  children: [
                    FooterLink(label: 'Bangladeshi Notes', path: '${RoutePaths.shop}?category=Bangladeshi'),
                    FooterLink(label: 'Pakistani Notes', path: '${RoutePaths.shop}?category=Pakistani'),
                    FooterLink(label: 'Foreign Notes', path: '${RoutePaths.shop}?category=Foreign'),
                    FooterLink(label: 'Auctions', path: RoutePaths.auction),
                  ],
                ),
              ),
              // Contact Info
              Expanded(
                flex: 1,
                child: FooterColumn(
                  title: 'Contact Us',
                  children: const [
                    ContactItem(
                      icon: Icons.location_on_outlined,
                      text: 'Dhaka, Bangladesh',
                    ),
                    ContactItem(
                      icon: Icons.chat_bubble_outline,
                      text: 'Message us on Messenger',
                      path: RoutePaths.contact,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Divider(color: Colors.white12),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© Numismatic House BD. All Rights Reserved.',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              Text(
                'Developed with ❤️ for Collectors',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
