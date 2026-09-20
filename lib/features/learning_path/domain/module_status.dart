import 'module.dart';

enum ModuleStatus { locked, unlocked, completed }

/// A module is locked until every one of its prerequisites is completed
/// (US13/US17's "prérequis affichés" and roadmap lock/in-progress/done
/// states), pure so the unlock cascade is unit-testable without Firestore.
ModuleStatus resolveModuleStatus(Module module, Set<String> completedModuleIds) {
  if (completedModuleIds.contains(module.id)) return ModuleStatus.completed;
  final prerequisitesMet = module.prerequisiteIds.every(completedModuleIds.contains);
  return prerequisitesMet ? ModuleStatus.unlocked : ModuleStatus.locked;
}
