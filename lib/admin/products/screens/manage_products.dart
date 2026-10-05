import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../features/catalog/providers/catalog_provider.dart';
import '../../../features/catalog/models/product.dart';
import '../../widgets/admin_sidebar.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogProvider>();
    return ResponsiveBuilder(
      builder: (context, sizing) {
        final compact = sizing.isMobile || sizing.isTablet;
        return Scaffold(
          backgroundColor: AppColors.canvas,
          appBar: compact
              ? AppBar(
                  backgroundColor: AppColors.forestDeep,
                  foregroundColor: Colors.white,
                  title: const Text('Products'),
                )
              : null,
          drawer: compact
              ? const AdminSidebar(currentRoute: RoutePaths.adminProducts)
              : null,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _editProduct(context),
            backgroundColor: AppColors.forest,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add product'),
          ),
          body: Row(
            children: [
              if (!compact)
                const SizedBox(
                  width: 280,
                  child: AdminSidebar(currentRoute: RoutePaths.adminProducts),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(compact ? 16 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product inventory',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Manage the products visitors can browse and order.',
                        style: TextStyle(color: AppColors.mutedInk),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: StreamBuilder<List<Product>>(
                          stream: catalog.watchAllProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return _Notice(
                                message: _readError(snapshot.error),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final products = snapshot.data!;
                            if (products.isEmpty) {
                              return const _Notice(
                                message: 'No products yet. Add your first listing.',
                              );
                            }
                            return _ProductsTable(products: products);
                          },
                        ),
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

  Future<void> _editProduct(BuildContext context, {Product? product}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ProductFormDialog(product: product),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved.')),
      );
    }
  }

  String _readError(Object? error) {
    if (error is FirebaseException && error.code == 'permission-denied') {
      return 'Your account is not authorized to manage products.';
    }
    return 'Could not load products. Check your connection and Firebase setup.';
  }
}

class _ProductsTable extends StatelessWidget {
  const _ProductsTable({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: products.map((product) => DataRow(cells: [
          DataCell(SizedBox(
            width: 280,
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
            ]),
          )),
          DataCell(Text(product.category)),
          DataCell(Text('৳${product.price.toStringAsFixed(2)}')),
          DataCell(Text(product.published ? 'Published' : 'Draft')),
          DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              tooltip: 'Edit product',
              onPressed: () => const ManageProductsScreen()._editProduct(context, product: product),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Delete product',
              onPressed: () => _confirmDelete(context, product),
              icon: const Icon(Icons.delete_outline, color: AppColors.clay),
            ),
          ])),
        ])).toList(),
      ),
    ),
  );

  Future<void> _confirmDelete(BuildContext context, Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this product?'),
        content: Text('“${product.name}” will be removed from the catalog.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.clay),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    try {
      await context.read<CatalogProvider>().deleteProduct(product);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not delete product.')),
        );
      }
    }
  }
}

class _ProductFormDialog extends StatefulWidget {
  const _ProductFormDialog({this.product});
  final Product? product;

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _originalPrice;
  late final TextEditingController _condition;
  late final TextEditingController _description;
  final _picker = ImagePicker();
  final List<XFile> _images = [];
  late String? _category;
  bool _published = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _name = TextEditingController(text: product?.name ?? '');
    _price = TextEditingController(text: product?.price.toString() ?? '');
    _originalPrice = TextEditingController(text: product?.originalPrice?.toString() ?? '');
    _condition = TextEditingController(text: product?.condition ?? '');
    _description = TextEditingController(text: product?.description ?? '');
    _category = product?.category;
    _published = product?.published ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _originalPrice.dispose();
    _condition.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 85);
      if (!mounted || files.isEmpty) return;
      if (_images.length + files.length > 10) {
        _showMessage('Choose up to 10 images.');
        return;
      }
      setState(() => _images.addAll(files));
    } catch (_) {
      _showMessage('Image picker is unavailable on this device.');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final existingGallery = widget.product?.galleryImages ?? const <String>[];
    if (existingGallery.isEmpty && _images.isEmpty) {
      _showMessage('Add at least one product image.');
      return;
    }
    final category = _category;
    if (category == null || category.trim().isEmpty) {
      _showMessage('Create a category before adding products.');
      return;
    }
    setState(() => _saving = true);
    try {
      await context.read<CatalogProvider>().saveProduct(
        product: Product(
          id: widget.product?.id ?? '',
          name: _name.text,
          category: category,
          condition: _condition.text,
          imageUrl: widget.product?.imageUrl ?? '',
          galleryImages: existingGallery,
          price: double.parse(_price.text),
          originalPrice: _originalPrice.text.trim().isEmpty
              ? null
              : double.parse(_originalPrice.text),
          description: _description.text,
          published: _published,
        ),
        newImages: _images,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        _showMessage(error.toString().contains('permission-denied')
            ? 'This account is not authorized to upload products.'
            : 'Product save failed. Please check the image, connection, and Firebase Storage setup.');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogProvider>();
    return AlertDialog(
      title: Text(widget.product == null ? 'Add product' : 'Edit product'),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: _name,
                maxLength: 160,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter a product name.' : null,
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<String>>(
                stream: catalog.watchActiveCategories(),
                builder: (context, snapshot) {
                  final categories = [...(snapshot.data ?? const <String>[])];
                  if (_category != null && !categories.contains(_category)) {
                    categories.add(_category!);
                  }
                  final selected = categories.contains(_category) ? _category : null;
                  return DropdownButtonFormField<String>(
                    value: selected,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories.map((name) => DropdownMenuItem(value: name, child: Text(name))).toList(),
                    onChanged: (value) => setState(() => _category = value),
                    validator: (value) => value == null ? 'Select a category.' : null,
                    hint: snapshot.hasError ? const Text('Could not load categories') : const Text('Select a category'),
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _price,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Price (BDT)'),
                    validator: _validatePrice,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _originalPrice,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Original price (optional)'),
                    validator: (value) => value == null || value.trim().isEmpty ? null : _validatePrice(value),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              TextFormField(
                controller: _condition,
                maxLength: 40,
                decoration: const InputDecoration(labelText: 'Condition (e.g. UNC)'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter the condition.' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLength: 4000,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : _pickImages,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: Text('Choose images (${_images.length}/10)'),
                ),
              ),
              if (_images.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: _images.map((image) => InputChip(
                    label: Text(image.name, overflow: TextOverflow.ellipsis),
                    onDeleted: _saving ? null : () => setState(() => _images.remove(image)),
                  )).toList(),
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Published in the storefront'),
                value: _published,
                onChanged: _saving ? null : (value) => setState(() => _published = value),
              ),
            ]),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: AppColors.forest),
          child: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Save product'),
        ),
      ],
    );
  }

  String? _validatePrice(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    return parsed == null || parsed < 0 ? 'Enter a valid amount.' : null;
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.mutedInk)),
  );
}
