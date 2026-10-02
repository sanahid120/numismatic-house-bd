import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'desktop_navbar.dart';
import 'mobile_navbar.dart';
import 'tablet_navbar.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return ScreenTypeLayout.builder(

      mobile: (context) => const MobileNavbar(),
      desktop: (context) => const DesktopNavbar(),
      tablet: (context) => const TabletNavbar(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
