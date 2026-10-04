import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../pages/Home/widgets/popular_products/product_model.dart';
import '../../widgets/admin_sidebar.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final List<Product> _products = List.from(popularProducts);

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
                  title: const Text('Manage Products', style: TextStyle(color: Colors.white)),
                  iconTheme: const IconThemeData(color: Colors.white),
                )
              : null,
          drawer: isMobile ? const AdminSidebar(currentRoute: RoutePaths.adminProducts) : null,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showProductForm(context),
            backgroundColor: AppColors.forest,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Row(
            children: [
              if (!isMobile)
                const SizedBox(
                  width: 280,
                  child: AdminSidebar(currentRoute: RoutePaths.adminProducts),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Products Inventory',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.forestDeep),
                          ),
                          if (!isMobile)
                            ElevatedButton.icon(
                              onPressed: () => _showProductForm(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Add New Product'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.forest,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: _buildProductTable(isMobile),
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

  Widget _buildProductTable(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: isMobile ? 20 : 40,
          columns: const [
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _products.map((product) {
            return DataRow(cells: [
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  ),
                ),
              ),
              DataCell(SizedBox(width: 200, child: Text(product.name, overflow: TextOverflow.ellipsis))),
              DataCell(Text(product.category)),
              DataCell(Text('৳${product.price}')),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () => _showProductForm(context, product: product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _products.removeWhere((p) => p.id == product.id);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _showProductForm(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(product: product),
    );
  }
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedMainCategory;
  late String _selectedSubCategory;
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> _mainCategories = ['Bangladeshi', 'Pakistani', 'Foreign', 'Accessories'];
  final List<String> _accessoryTypes = ['Albums', 'Poly', 'Books', 'Tools', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedMainCategory = widget.product?.category ?? 'Bangladeshi';
    _selectedSubCategory = 'General';
    if (!_mainCategories.contains(_selectedMainCategory)) {
      _selectedMainCategory = 'Accessories';
      _selectedSubCategory = widget.product?.category ?? 'Albums';
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add New Product' : 'Edit Product'),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: widget.product?.name,
                  decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _mainCategories.contains(_selectedMainCategory) ? _selectedMainCategory : 'Accessories',
                  decoration: const InputDecoration(labelText: 'Main Category', border: OutlineInputBorder()),
                  items: _mainCategories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedMainCategory = val!;
                      _selectedSubCategory = _selectedMainCategory == 'Accessories' ? 'Albums' : 'General';
                    });
                  },
                ),
                const SizedBox(height: 15),
                if (_selectedMainCategory == 'Accessories')
                  DropdownButtonFormField<String>(
                    value: _accessoryTypes.contains(_selectedSubCategory) ? _selectedSubCategory : 'Albums',
                    decoration: const InputDecoration(labelText: 'Accessory Type', border: OutlineInputBorder()),
                    items: _accessoryTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (val) => setState(() => _selectedSubCategory = val!),
                  ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.product?.price.toString(),
                        decoration: const InputDecoration(labelText: 'Price (৳)', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.product?.originalPrice?.toString(),
                        decoration: const InputDecoration(labelText: 'Original Price', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Product Images', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    // Display existing image if editing and no new images selected
                    if (widget.product != null && _selectedImages.isEmpty)
                       _buildImagePreview(widget.product!.imageUrl, isNetwork: true),
                    
                    // Display newly selected images
                    ..._selectedImages.map((image) => Stack(
                          children: [
                            _buildImagePreview(image.path, isNetwork: kIsWeb),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedImages.remove(image)),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          ],
                        )),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.canvas,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: const Icon(Icons.add_a_photo_outlined, color: AppColors.mutedInk),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: widget.product != null ? 'Historical high-grade UNC condition note.' : null,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.forest, foregroundColor: Colors.white),
          child: Text(widget.product == null ? 'Upload Product' : 'Save Changes'),
        ),
      ],
    );
  }

  Widget _buildImagePreview(String path, {bool isNetwork = false}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: isNetwork
            ? Image.network(path, fit: BoxFit.cover)
            : Image.file(File(path), fit: BoxFit.cover),
      ),
    );
  }
}
