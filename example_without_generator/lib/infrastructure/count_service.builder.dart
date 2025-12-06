import '../domain/count_service.dart';

class CountServiceBuilder {
  final CountService _inner;
  CountServiceBuilder(this._inner);
  final List<Function(CountService)> _decorators = [];
  // append a decorator
  CountServiceBuilder add(Function(CountService) decorator) {
    _decorators.add(decorator);
    return this;
  }

  // stack all decorators
  CountService build() {
    var result = _inner;
    for (final decorator in _decorators) {
      result = decorator(result);
    }
    return result;
  }
}
