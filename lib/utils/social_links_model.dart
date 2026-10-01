import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/app_paths.dart';
import '../app/app_strings.dart';

class SocialLink {
  final String url;
  final String icon;
  final String label;

  const SocialLink({
    required this.url,
    required this.icon,
    required this.label,
  });
}

final List<SocialLink> socialLinks = [
  SocialLink(
    label: "GitHub",
    url: AppStrings.githubProfileUrl,
    icon: AppPaths.gitHubIcon,
  ),
  SocialLink(
    label: 'LinkedIn',
    url: AppStrings.linkedinProfileUrl,
    icon:
        AppPaths.linkedInIcon,
  ),
  SocialLink(
    label: 'Facebook',
    url: AppStrings.facebookProfileUrl,
    icon: AppPaths.facebookIcon,
  ),
];

Future<void> openLink(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }
}

class SocialLinksRow extends StatelessWidget {
  const SocialLinksRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: socialLinks.map((s) => _SocialChip(link: s)).toList(),
    );
  }
}

class _SocialChip extends StatefulWidget {
  final SocialLink link;
  const _SocialChip({required this.link});

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        onTap: () => openLink(widget.link.url),
        child: AnimatedContainer(

          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(

            color: _hovered ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.cyan.withAlpha(40)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                semanticLabel: widget.link.label,
                widget.link.icon,
                width: 20,
                height: 20,
                cacheWidth: 200,
                cacheHeight: 200,
              ),

              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
