import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'desktop_view.dart';
import 'mobile_view.dart';
import 'tab_view.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => const MobileView(),
      tablet: (context) => const TabView(),
      desktop: (context) => const DesktopView(),
    );
  }
}
