import 'package:workmanager/workmanager.dart';

import 'sync_service.dart';

const _syncTaskName = 'com.rxforcesfa.sync';
const _syncTaskTag = 'sync';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == _syncTaskName) {
      return SyncService.performSync();
    }
    return true;
  });
}

Future<void> initializeWorkmanager() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    _syncTaskName,
    _syncTaskName,
    tag: _syncTaskTag,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );
}
