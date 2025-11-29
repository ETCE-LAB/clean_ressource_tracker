
import 'package:clean_ressource_tracker/clean_ressource_tracker.dart';

part 'count_service.builder.dart';
part 'count_service.cpu_active_time.decorator.dart';

@MeasureCpuActiveTime()
@WithBuilder()
abstract class CountService {
  Future<int> count(int initialValue);
}
