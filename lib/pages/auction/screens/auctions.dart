import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/app_colors.dart';
import '../../../shared/widgets/navbar/navbar.dart';
import '../../../shared/widgets/navbar/site_drawer.dart';
import '../../Home/widgets/footer/footer_section.dart';
import '../../shop/widgets/shop_sidebar.dart';
import '../../../features/auctions/providers/auction_provider.dart';
import '../../../features/auctions/models/auction.dart';
import 'desktop_auction_view.dart';
import 'mobile_auction_view.dart';
import 'tab_auction_view.dart';

class AuctionsScreen extends StatefulWidget {
  const AuctionsScreen({super.key});

  @override
  State<AuctionsScreen> createState() => _AuctionsScreenState();
}

class _AuctionsScreenState extends State<AuctionsScreen> {
  String _selectedCategory = 'All Collection';
  String _searchQuery = '';

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: const Navbar(),
          drawer: const SiteDrawer(),
          endDrawer: sizingInformation.isDesktop
              ? null
              : Drawer(
                  width: sizingInformation.isMobile
                      ? MediaQuery.of(context).size.width * 0.85
                      : 400,
                  child: SafeArea(
                    child: ShopSidebar(
                      onCategorySelected: (cat) {
                        _onCategorySelected(cat);
                        Navigator.pop(context);
                      },
                      onSearch: (query) => setState(() => _searchQuery = query),
                      selectedCategory: _selectedCategory,
                    ),
                  ),
                ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<List<AuctionProduct>>(
                  stream: context.read<AuctionProvider>().watchPublishedAuctions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Padding(
                        padding: EdgeInsets.all(48),
                        child: Text('Auctions are temporarily unavailable.'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const SizedBox(
                        height: 240,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final category = _selectedCategory
                        .toLowerCase()
                        .replaceAll(' notes', '')
                        .replaceAll(' collection', '')
                        .trim();
                    final auctions = snapshot.data!.where((auction) {
                      final matchesCategory = category == 'all' ||
                          category.isEmpty ||
                          auction.category.toLowerCase() == category;
                      final query = _searchQuery.trim().toLowerCase();
                      final matchesSearch = query.isEmpty ||
                          auction.name.toLowerCase().contains(query) ||
                          auction.category.toLowerCase().contains(query);
                      return matchesCategory && matchesSearch &&
                          auction.endTime.isAfter(DateTime.now());
                    }).toList(growable: false);
                    if (auctions.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(48),
                        child: Text('No live auctions match these filters.'),
                      );
                    }
                    return ScreenTypeLayout.builder(
                      mobile: (_) => MobileAuctionView(
                        selectedCategory: _selectedCategory,
                        products: auctions,
                      ),
                      tablet: (_) => TabAuctionView(
                        selectedCategory: _selectedCategory,
                        products: auctions,
                      ),
                      desktop: (_) => DesktopAuctionView(
                        selectedCategory: _selectedCategory,
                        products: auctions,
                        onCategorySelected: _onCategorySelected,
                        onSearch: (query) => setState(() => _searchQuery = query),
                      ),
                    );
                  },
                ),
                const FooterSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
