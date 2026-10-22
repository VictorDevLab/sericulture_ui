import 'package:flutter/material.dart';

enum DashboardAlertSeverity { warning, critical }

class DashboardMetric {
  const DashboardMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.supportingLabel,
  });

  final String title;
  final String value;
  final IconData icon;
  final String supportingLabel;
}

class DashboardTask {
  const DashboardTask({
    required this.title,
    required this.batchLabel,
    required this.schedule,
    required this.status,
    required this.icon,
    required this.route,
  });

  final String title;
  final String batchLabel;
  final String schedule;
  final String status;
  final IconData icon;
  final String route;
}

class DashboardAlert {
  const DashboardAlert({
    required this.title,
    required this.description,
    required this.severity,
    required this.icon,
  });

  final String title;
  final String description;
  final DashboardAlertSeverity severity;
  final IconData icon;
}

class DashboardBatch {
  const DashboardBatch({
    required this.id,
    required this.species,
    required this.stage,
    required this.daysSinceStart,
    required this.liveWormCount,
  });

  final String id;
  final String species;
  final String stage;
  final int daysSinceStart;
  final int liveWormCount;
}

class DashboardOverview {
  const DashboardOverview({
    required this.metrics,
    required this.tasks,
    required this.alerts,
    required this.activeBatches,
  });

  final List<DashboardMetric> metrics;
  final List<DashboardTask> tasks;
  final List<DashboardAlert> alerts;
  final List<DashboardBatch> activeBatches;
}
