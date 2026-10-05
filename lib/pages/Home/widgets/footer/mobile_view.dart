import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/router/route_paths.dart';
import 'footer_widgets.dart';

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forestDeep,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Info
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance, color: AppColors.forest, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'NH BD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Numismatic House BD is your trusted partner in collecting high-grade UNC condition banknotes.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 30),

          // Quick Links
          FooterColumn(
            title: 'Quick Links',
            children: [
              FooterLink(label: 'Home', path: RoutePaths.home),
              FooterLink(label: 'Shop', path: RoutePaths.shop),
              FooterLink(label: 'Auctions', path: RoutePaths.auction),
            ],
          ),
          const SizedBox(height: 30),

          // Contact Info
          FooterColumn(
            title: 'Contact Us',
            children: const [
              ContactItem(
                icon: Icons.location_on_outlined,
                text: 'Dhaka, Bangladesh',
              ),
            ],
          ),
          ContactItem(
            icon: Icons.chat_bubble_outline,
            text: 'Message us on Messenger',
            path: RoutePaths.contact,
          ),
          const SizedBox(height: 30),

          // Social
          const Text(
            'FOLLOW US',
            style: TextStyle(
              color: AppColors.brass,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const SocialIcon(icon: Icons.facebook),
              const SocialIcon(icon: Icons.work_outline),
              const SocialIcon(icon: Icons.language),
            ],
          ),

          const SizedBox(height: 40),
          const Divider(color: Colors.white12),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '© Numismatic House BD.',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
