import 'package:flutter/material.dart';

import '../domain/dashboard_overview.dart';

/// Illustrative content for the dashboard foundation; not farm or sensor data.
abstract final class DashboardSampleData {
  static const overview = DashboardOverview(
    metrics: [
      DashboardMetric(
        title: 'Active batches',
        value: '04',
        icon: Icons.inventory_2_outlined,
        supportingLabel: '2 Eri · 2 Bombyx',
      ),
      DashboardMetric(
        title: 'Live worms',
        value: '12,480',
        icon: Icons.scatter_plot_rounded,
        supportingLabel: 'Across sample batches',
      ),
      DashboardMetric(
        title: 'Avg. survival',
        value: '92%',
        icon: Icons.favorite_border_rounded,
        supportingLabel: 'Illustrative estimate',
      ),
      DashboardMetric(
        title: 'Expected yield',
        value: '18.4 kg',
        icon: Icons.spa_outlined,
        supportingLabel: 'Sample forecast',
      ),
    ],
    tasks: [
      DashboardTask(
        title: 'Feeding due',
        batchLabel: 'DEMO-ERI-01 · Eri',
        schedule: 'Today · 08:00',
        status: 'Upcoming',
        icon: Icons.grass_rounded,
        route: '/care/feeding',
      ),
      DashboardTask(
        title: 'Moulting observation',
        batchLabel: 'DEMO-BOM-02 · Bombyx mori',
        schedule: 'Today · 10:30',
        status: 'Planned',
        icon: Icons.visibility_outlined,
        route: '/care/lifecycle',
      ),
      DashboardTask(
        title: 'Environmental check',
        batchLabel: 'Rearing room · sample reminder',
        schedule: 'Today · 12:00',
        status: 'Upcoming',
        icon: Icons.thermostat_outlined,
        route: '/care/environment',
      ),
      DashboardTask(
        title: 'Expected harvest',
        batchLabel: 'DEMO-ERI-03 · Eri',
        schedule: 'In 3 days · sample date',
        status: 'Forecast',
        icon: Icons.event_available_outlined,
        route: '/care/lifecycle',
      ),
    ],
    alerts: [
      DashboardAlert(
        title: 'Humidity above example range',
        description: 'Illustrative warning only · no sensor is connected.',
        severity: DashboardAlertSeverity.warning,
        icon: Icons.water_drop_outlined,
      ),
      DashboardAlert(
        title: 'Temperature outside example range',
        description: 'Illustrative alert only · review configured thresholds.',
        severity: DashboardAlertSeverity.warning,
        icon: Icons.device_thermostat_outlined,
      ),
      DashboardAlert(
        title: 'Unusual mortality reported',
        description: 'Sample critical alert · no mortality records are loaded.',
        severity: DashboardAlertSeverity.critical,
        icon: Icons.health_and_safety_outlined,
      ),
    ],
    activeBatches: [
      DashboardBatch(
        id: 'DEMO-ERI-01',
        species: 'Eri · Samia ricini',
        stage: '3rd instar',
        daysSinceStart: 12,
        liveWormCount: 3_240,
      ),
      DashboardBatch(
        id: 'DEMO-BOM-02',
        species: 'Bombyx mori',
        stage: '5th instar',
        daysSinceStart: 18,
        liveWormCount: 4_180,
      ),
      DashboardBatch(
        id: 'DEMO-ERI-03',
        species: 'Eri · Samia ricini',
        stage: 'Spinning',
        daysSinceStart: 24,
        liveWormCount: 2_760,
      ),
    ],
  );
}
