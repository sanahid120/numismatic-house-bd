import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
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
                        SocialIcon(icon: Icons.facebook, onTap: () {}),
                        SocialIcon(icon: Icons.camera_alt_outlined, onTap: () {}),
                        SocialIcon(icon: Icons.language, onTap: () {}),
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
                    FooterLink(label: 'Home', onTap: () {}),
                    FooterLink(label: 'Shop', onTap: () {}),
                    FooterLink(label: 'My Account', onTap: () {}),
                    FooterLink(label: 'Privacy Policy', onTap: () {}),
                  ],
                ),
              ),
              // Categories
              Expanded(
                child: FooterColumn(
                  title: 'Categories',
                  children: [
                    FooterLink(label: 'Bangladeshi Notes', onTap: () {}),
                    FooterLink(label: 'Pakistani Notes', onTap: () {}),
                    FooterLink(label: 'Foreign Notes', onTap: () {}),
                    FooterLink(label: 'New Arrivals', onTap: () {}),
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
                      icon: Icons.email_outlined,
                      text: 'contact@numismatichousebd.com',
                    ),
                    ContactItem(
                      icon: Icons.phone_outlined,
                      text: '+880 1234 567890',
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
                '© 2024 Numismatic House BD. All Rights Reserved.',
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
