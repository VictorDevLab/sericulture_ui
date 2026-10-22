import '../../lifecycle/domain/lifecycle_models.dart';
import '../domain/batch.dart';

String speciesLabel(SilkwormSpecies species) => switch (species) {
  SilkwormSpecies.eri => 'Eri (Samia ricini)',
  SilkwormSpecies.bombyxMori => 'Bombyx mori',
};

String statusLabel(BatchStatus status) => switch (status) {
  BatchStatus.active => 'Active',
  BatchStatus.mounting => 'Mounting',
  BatchStatus.cocooning => 'Cocooning',
  BatchStatus.harvested => 'Harvested',
  BatchStatus.closed => 'Closed',
};

String stageLabel(LifecycleStage stage) => switch (stage) {
  LifecycleStage.eggIncubation => 'Egg incubation',
  LifecycleStage.hatching => 'Hatching',
  LifecycleStage.firstInstar => '1st instar',
  LifecycleStage.secondInstar => '2nd instar',
  LifecycleStage.thirdInstar => '3rd instar',
  LifecycleStage.fourthInstar => '4th instar',
  LifecycleStage.fifthInstar => '5th instar',
  LifecycleStage.pupaeAndSpinning => 'Pupae / spinning',
  LifecycleStage.cocoonFormation => 'Cocoon formation',
  LifecycleStage.mothEmergenceAndEggLaying => 'Moth emergence / egg laying',
};
