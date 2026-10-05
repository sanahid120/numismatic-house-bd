import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../widgets/admin_sidebar.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
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
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile = sizingInformation.isMobile || sizingInformation.isTablet;

        return Scaffold(
          backgroundColor: AppColors.canvas,
          appBar: isMobile
              ? AppBar(
                  backgroundColor: AppColors.forestDeep,
                  title: const Text('Admin Profile', style: TextStyle(color: Colors.white)),
                  iconTheme: const IconThemeData(color: Colors.white),
                )
              : null,
          drawer: isMobile ? const AdminSidebar(currentRoute: RoutePaths.adminProfile) : null,
          body: Row(
            children: [
              if (!isMobile)
                const SizedBox(
                  width: 280,
                  child: AdminSidebar(currentRoute: RoutePaths.adminProfile),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin Profile Settings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestDeep,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (sizingInformation.isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 1, child: _buildAdminInfoCard()),
                            const SizedBox(width: 30),
                            Expanded(flex: 2, child: _buildAdminEditCard()),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildAdminInfoCard(),
                            const SizedBox(height: 20),
                            _buildAdminEditCard(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminInfoCard() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.mint,
                child: Icon(Icons.admin_panel_settings, size: 60, color: AppColors.forest),
              ),
              const SizedBox(height: 20),
              Text(
                '${auth.userData?['firstName'] ?? ''} ${auth.userData?['lastName'] ?? ''}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('System Administrator', style: TextStyle(color: AppColors.brass, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email_outlined),
                title: const Text('Admin Email'),
                subtitle: Text(auth.currentUser?.email ?? ''),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminEditCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Update Credentials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                bool success = await authProvider.updateProfile(
                  firstName: _firstNameController.text.trim(),
                  lastName: _lastNameController.text.trim(),
                );
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin info updated')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              ),
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 30),
            const Text('Security Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Change Admin Password'),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.clay, foregroundColor: Colors.white),
                child: const Text('Change'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
