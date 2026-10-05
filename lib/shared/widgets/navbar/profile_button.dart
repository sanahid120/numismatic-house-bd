import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfileButton extends StatelessWidget {
  final Color color;
  const ProfileButton({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final bool isLoggedIn = auth.currentUser != null;

        if (!isLoggedIn) {
          return IconButton(
            onPressed: () => context.push(RoutePaths.signIn),
            icon: Icon(Icons.person_outline, color: color, size: 22),
          );
        }

        return PopupMenuButton<String>(
          offset: const Offset(0, 50),
          onSelected: (value) async {
            if (value == 'profile') {
              final role = auth.userData?['role'] ?? 'user';
              if (role == 'admin') {
                context.go(RoutePaths.adminProfile);
              } else {
                context.push(RoutePaths.profile);
              }
            } else if (value == 'logout') {
              await auth.signOut();
              context.go(RoutePaths.home);
            } else if (value == 'admin') {
              context.go(RoutePaths.adminDashboard);
            }
          },
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.forest.withOpacity(0.1),
            backgroundImage: auth.userData?['profilePic'] != null && auth.userData?['profilePic'] != ''
                ? NetworkImage(auth.userData?['profilePic'])
                : null,
            child: auth.userData?['profilePic'] == null || auth.userData?['profilePic'] == ''
                ? Icon(Icons.person, size: 18, color: color)
                : null,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 20, color: AppColors.forest),
                  const SizedBox(width: 10),
                  const Text('My Profile'),
                ],
              ),
            ),
            if (auth.userData?['role'] == 'admin')
              PopupMenuItem(
                value: 'admin',
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings_outlined, size: 20, color: AppColors.forest),
                    const SizedBox(width: 10),
                    const Text('Admin Dashboard'),
                  ],
                ),
              ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 20, color: Colors.redAccent),
                  const SizedBox(width: 10),
                  const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
