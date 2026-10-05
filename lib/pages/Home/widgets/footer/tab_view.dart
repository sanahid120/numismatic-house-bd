import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/router/route_paths.dart';
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
                        const SocialIcon(icon: Icons.facebook),
                        const SocialIcon(icon: Icons.work_outline),
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
                    FooterLink(label: 'Home', path: RoutePaths.home),
                    FooterLink(label: 'Shop', path: RoutePaths.shop),
                    FooterLink(label: 'Auctions', path: RoutePaths.auction),
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
                      icon: Icons.chat_bubble_outline,
                      text: 'Message us on Messenger',
                      path: RoutePaths.contact,
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
            '© Numismatic House BD.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
