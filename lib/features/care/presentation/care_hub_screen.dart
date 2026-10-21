import 'package:flutter/material.dart';

import '../../shared/presentation/feature_link.dart';

class CareHubScreen extends StatelessWidget {
  const CareHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePage(
      title: 'Rearing care',
      child: FeatureLinkList(
        items: [
          FeatureLink(
            title: 'Feeding logs',
            description: 'Capture feeding events and observations',
            path: '/care/feeding',
            icon: Icons.grass_rounded,
          ),
          FeatureLink(
            title: 'Lifecycle calendar',
            description: 'Review development stages and dates',
            path: '/care/lifecycle',
            icon: Icons.calendar_month_rounded,
          ),
          FeatureLink(
            title: 'Environmental monitoring',
            description: 'Temperature, humidity, and conditions',
            path: '/care/environment',
            icon: Icons.thermostat_rounded,
          ),
          FeatureLink(
            title: 'Cocoon analysis',
            description: 'Record quality assessments',
            path: '/care/cocoons',
            icon: Icons.spa_outlined,
          ),
        ],
      ),
    );
  }
}
