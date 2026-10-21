import 'package:flutter/material.dart';

import 'feature_link.dart';

class MoreHubScreen extends StatelessWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePage(
      title: 'More',
      child: FeatureLinkList(
        items: [
          FeatureLink(
            title: 'Reports',
            description: 'Review rearing summaries and outcomes',
            path: '/more/reports',
            icon: Icons.insert_chart_outlined_rounded,
          ),
          FeatureLink(
            title: 'Settings',
            description: 'App preferences and workspace options',
            path: '/more/settings',
            icon: Icons.settings_outlined,
          ),
          FeatureLink(
            title: 'Login',
            description: 'Authentication will be integrated later',
            path: '/login',
            icon: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }
}
