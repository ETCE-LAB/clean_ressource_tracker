import 'package:flutter_test/flutter_test.dart';
import 'package:clean_ressource_tracker/clean_ressource_tracker.dart';
import 'package:clean_ressource_tracker/clean_ressource_tracker_platform_interface.dart';
import 'package:clean_ressource_tracker/clean_ressource_tracker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCleanRessourceTrackerPlatform
    with MockPlatformInterfaceMixin
    implements CleanRessourceTrackerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CleanRessourceTrackerPlatform initialPlatform = CleanRessourceTrackerPlatform.instance;

  test('$MethodChannelCleanRessourceTracker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCleanRessourceTracker>());
  });

  test('getPlatformVersion', () async {
    CleanRessourceTracker cleanRessourceTrackerPlugin = CleanRessourceTracker();
    MockCleanRessourceTrackerPlatform fakePlatform = MockCleanRessourceTrackerPlatform();
    CleanRessourceTrackerPlatform.instance = fakePlatform;

    expect(await cleanRessourceTrackerPlugin.getPlatformVersion(), '42');
  });
}
