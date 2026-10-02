import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import 'footer_widgets.dart';

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forestDeep,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand & Social
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NH BD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Preserving history, one note at a time.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        SocialIcon(icon: Icons.facebook, onTap: () {}),
                        SocialIcon(icon: Icons.camera_alt_outlined, onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
              // Links
              Expanded(
                child: FooterColumn(
                  title: 'Links',
                  children: [
                    FooterLink(label: 'Home', onTap: () {}),
                    FooterLink(label: 'Shop', onTap: () {}),
                  ],
                ),
              ),
              // Contact
              Expanded(
                flex: 2,
                child: FooterColumn(
                  title: 'Contact',
                  children: const [
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
          const SizedBox(height: 40),
          const Divider(color: Colors.white12),
          const SizedBox(height: 20),
          const Text(
            '© 2024 Numismatic House BD.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
