import 'package:clean_ressource_tracker/platform_channel/cpu_active_time_platform_channel.dart';

import '../domain/count_service.dart';

class CountServiceCpuActiveTimeDecorator extends CountService {
  final CountService _inner;
  CountServiceCpuActiveTimeDecorator(this._inner);
  @override
  Future<int> count(int initialValue) async {
    final start = await CPUActiveTImePlatformChannel.getCPUTime();
    final result = await _inner.count(initialValue);
    final end = await CPUActiveTImePlatformChannel.getCPUTime();
    print("CPU time for count: ${end - start}ms");
    return result;
  }
}
