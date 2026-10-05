import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/app_colors.dart';
import '../../../app/config/app_config.dart';
import '../../../features/catalog/providers/catalog_provider.dart';
import '../../../pages/Home/widgets/footer/footer_section.dart';
import '../../../features/catalog/models/product.dart';
import '../../../shared/widgets/navbar/navbar.dart';
import '../../../shared/widgets/navbar/site_drawer.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product?>(
      stream: context.read<CatalogProvider>().watchPublishedProduct(productId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _messagePage('We could not load this item. Please try again.');
        }
        if (!snapshot.hasData) {
          return _messagePage('Loading collectible…', loading: true);
        }
        final product = snapshot.data;
        if (product == null) {
          return _messagePage('This item is no longer available.');
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: const Navbar(),
          drawer: const SiteDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ScreenTypeLayout.builder(
                  mobile: (context) => _MobileProductDetails(product: product),
                  tablet: (context) => _DesktopProductDetails(product: product, isTablet: true),
                  desktop: (context) => _DesktopProductDetails(product: product),
                ),
                const FooterSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _messagePage(String message, {bool loading = false}) => Scaffold(
    backgroundColor: AppColors.backgroundColor,
    appBar: const Navbar(),
    body: Center(
      child: loading
          ? const CircularProgressIndicator(color: AppColors.forest)
          : Text(message, style: const TextStyle(color: AppColors.mutedInk)),
    ),
  );
}

class _ProductImageGallery extends StatefulWidget {
  final Product product;
  final bool isMobile;

  const _ProductImageGallery({required this.product, this.isMobile = false});

  @override
  State<_ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<_ProductImageGallery> {
  late String _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.product.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product.galleryImages.isNotEmpty
        ? widget.product.galleryImages
        : [widget.product.imageUrl];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Image.network(
                _currentImageUrl,
                key: ValueKey(_currentImageUrl),
                width: double.infinity,
                height: widget.isMobile ? 350 : 500,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: widget.isMobile ? 350 : 500,
                  color: AppColors.mint.withOpacity(0.2),
                  child: const Icon(Icons.image_not_supported_outlined, size: 50, color: AppColors.mutedInk),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: widget.isMobile ? 350 : 500,
                    color: AppColors.mint.withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator(color: AppColors.forest)),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (images.length > 1)
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemBuilder: (context, index) {
                final imageUrl = images[index];
                final isSelected = _currentImageUrl == imageUrl;
                return GestureDetector(
                  onTap: () => setState(() => _currentImageUrl = imageUrl),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.forest : AppColors.line.withOpacity(0.5),
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _DesktopProductDetails extends StatelessWidget {
  final Product product;
  final bool isTablet;

  const _DesktopProductDetails({required this.product, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 100,
        vertical: 60,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _ProductImageGallery(product: product)),
          SizedBox(width: isTablet ? 30 : 60),
          Expanded(flex: 1, child: _ProductInfoSection(product: product)),
        ],
      ),
    );
  }
}

class _MobileProductDetails extends StatelessWidget {
  final Product product;

  const _MobileProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: _ProductImageGallery(product: product, isMobile: true),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: _ProductInfoSection(product: product, isMobile: true),
        ),
      ],
    );
  }
}

class _ProductInfoSection extends StatelessWidget {
  final Product product;
  final bool isMobile;

  const _ProductInfoSection({required this.product, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.forestDeep.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            product.condition.toUpperCase(),
            style: const TextStyle(color: AppColors.forestDeep, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          product.name,
          style: TextStyle(color: AppColors.forestDeep, fontSize: isMobile ? 28 : 42, fontWeight: FontWeight.w900, height: 1.2),
        ),
        const SizedBox(height: 10),
        Text('Category: ${product.category}', style: const TextStyle(color: AppColors.mutedInk, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 25),
        Row(
          children: [
            Text('৳${product.price}', style: const TextStyle(color: AppColors.clay, fontSize: 32, fontWeight: FontWeight.w900)),
            if (product.originalPrice != null) ...[
              const SizedBox(width: 15),
              Text('৳${product.originalPrice}', style: TextStyle(color: AppColors.mutedInk.withOpacity(0.6), fontSize: 20, decoration: TextDecoration.lineThrough)),
            ],
          ],
        ),
        const SizedBox(height: 30),
        const Divider(),
        const SizedBox(height: 30),
        const Text('Description', style: TextStyle(color: AppColors.forestDeep, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text(
          product.description.isNotEmpty
              ? product.description
              : 'Contact us for more information about this collectible.',
          style: TextStyle(color: AppColors.mutedInk, fontSize: 16, height: 1.6),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: isMobile ? double.infinity : 300,
          child: ElevatedButton(
            onPressed: () async {
              final uri = Uri.https(
                'm.me',
                AppConfig.messengerPageUsername,
                {'ref': 'order_${product.id}'},
              );
              final opened = await launchUrl(
                uri,
                webOnlyWindowName: '_blank',
              );
              if (!opened && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open Messenger.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forest,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'MESSAGE ABOUT THIS ITEM',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
