import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../features/catalog/models/catalog_category.dart';
import '../../../features/catalog/providers/catalog_provider.dart';
import '../../widgets/admin_sidebar.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogProvider>();
    return ResponsiveBuilder(builder: (context, sizing) {
      final compact = sizing.isMobile || sizing.isTablet;
      return Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: compact
            ? AppBar(
                backgroundColor: AppColors.forestDeep,
                foregroundColor: Colors.white,
                title: const Text('Categories'),
              )
            : null,
        drawer: compact
            ? const AdminSidebar(currentRoute: RoutePaths.adminCategories)
            : null,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showEditor(context),
          backgroundColor: AppColors.forest,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Add category'),
        ),
        body: Row(children: [
          if (!compact)
            const SizedBox(
              width: 280,
              child: AdminSidebar(currentRoute: RoutePaths.adminCategories),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(compact ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categories', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'Categories appear in catalog filters and product forms.',
                    style: TextStyle(color: AppColors.mutedInk),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: StreamBuilder<List<CatalogCategory>>(
                      stream: catalog.watchAllCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Could not load categories. Check admin access.'),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final categories = snapshot.data!;
                        if (categories.isEmpty) {
                          return const Center(child: Text('No categories created yet.'));
                        }
                        return Card(
                          child: ListView.separated(
                            itemCount: categories.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.mint,
                                  child: Text(category.name.characters.first.toUpperCase()),
                                ),
                                title: Text(category.name),
                                subtitle: Text(category.active ? 'Visible to shoppers' : 'Archived'),
                                trailing: Wrap( children: [
                                  IconButton(
                                    tooltip: 'Edit category',
                                    onPressed: () => _showEditor(context, category: category),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  Switch(
                                    value: category.active,
                                    onChanged: (active) => _setActive(context, category, active),
                                  ),
                                ]),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
    });
  }

  Future<void> _showEditor(BuildContext context, {CatalogCategory? category}) async {
    final controller = TextEditingController(text: category?.name ?? '');
    final formKey = GlobalKey<FormState>();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(category == null ? 'Add category' : 'Edit category'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Category name'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Enter a category name.'
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved != true || !context.mounted) {
      controller.dispose();
      return;
    }
    try {
      await context.read<CatalogProvider>().saveCategory(
        name: controller.text,
        imageUrl: category?.imageUrl ?? '',
        active: category?.active ?? true,
        documentId: category?.id,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category saved.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save category. Check your admin access.')),
        );
      }
    } finally {
      controller.dispose();
    }
  }

  Future<void> _setActive(
    BuildContext context,
    CatalogCategory category,
    bool active,
  ) async {
    try {
      await context.read<CatalogProvider>().saveCategory(
        name: category.name,
        imageUrl: category.imageUrl,
        active: active,
        documentId: category.id,
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update category.')),
        );
      }
    }
  }
}
