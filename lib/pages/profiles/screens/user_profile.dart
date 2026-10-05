import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../shared/widgets/navbar/navbar.dart';
import '../../../shared/widgets/navbar/site_drawer.dart';
import '../../Home/widgets/footer/footer_section.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _firstNameController = TextEditingController(text: authProvider.userData?['firstName'] ?? '');
    _lastNameController = TextEditingController(text: authProvider.userData?['lastName'] ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const Navbar(),
      drawer: const SiteDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveBuilder(
              builder: (context, sizingInformation) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizingInformation.isDesktop ? 100 : 20,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.forestDeep,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (sizingInformation.isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 1, child: _buildProfileImageCard()),
                            const SizedBox(width: 40),
                            Expanded(flex: 2, child: _buildProfileDetailsCard()),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildProfileImageCard(),
                            const SizedBox(height: 20),
                            _buildProfileDetailsCard(),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageCard() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Container(
          padding: const EdgeInsets.all(30),
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
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.mint,
                    backgroundImage: auth.userData?['profilePic'] != null && auth.userData?['profilePic'] != ''
                        ? NetworkImage(auth.userData?['profilePic'])
                        : null,
                    child: auth.userData?['profilePic'] == null || auth.userData?['profilePic'] == ''
                        ? const Icon(Icons.person, size: 60, color: AppColors.forest)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppColors.forest,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: () {
                          // TODO: Implement actual image upload logic
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '${auth.userData?['firstName'] ?? ''} ${auth.userData?['lastName'] ?? ''}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                auth.currentUser?.email ?? '',
                style: const TextStyle(color: AppColors.mutedInk, fontSize: 14),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 10),
              _buildProfileOption(Icons.email_outlined, 'Change Email', () => _showChangeEmailDialog()),
              _buildProfileOption(Icons.lock_outline, 'Change Password', () => _showChangePasswordDialog()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.forest, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, size: 16),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildProfileDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(40),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.forestDeep),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  bool success = await authProvider.updateProfile(
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                  );
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forest,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Update Profile'),
              ),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),
            const Text(
              'Account Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.clay),
            ),
            const SizedBox(height: 10),
            const Text(
              'Deleting your account will permanently remove all your data.',
              style: TextStyle(color: AppColors.mutedInk),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => _showDeleteAccountDialog(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.clay,
                side: const BorderSide(color: AppColors.clay),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Delete My Account'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeEmailDialog() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Email'),
        content: TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'New Email'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              bool success = await authProvider.changeEmail(emailController.text.trim());
              if (success && mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email updated successfully')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'New Password'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              bool success = await authProvider.changePassword(passwordController.text);
              if (success && mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated successfully')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              bool success = await authProvider.deleteAccount();
              if (success && mounted) {
                Navigator.pop(context);
                // Redirect home or logout logic
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.clay),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
