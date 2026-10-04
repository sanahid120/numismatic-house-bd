import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/app_colors.dart';
import '../../../shared/widgets/navbar/navbar.dart';
import '../../../shared/widgets/navbar/site_drawer.dart';
import '../../Home/widgets/footer/footer_section.dart';
import '../../shop/widgets/shop_sidebar.dart';
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
                      onSearch: (query) {},
                    ),
                  ),
                ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ScreenTypeLayout.builder(
                  mobile: (context) => MobileAuctionView(
                    selectedCategory: _selectedCategory,
                  ),
                  tablet: (context) => TabAuctionView(
                    selectedCategory: _selectedCategory,
                  ),
                  desktop: (context) => DesktopAuctionView(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),
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
