
import '../domain/count_service.dart';

class CountRepository extends CountService {
  @override
  Future<int> count(int initialValue) {
    var result = initialValue+1;
    return Future.value(result);
  }
}
