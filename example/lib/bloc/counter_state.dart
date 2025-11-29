abstract class CounterState {}

class CounterInitial extends CounterState {}

class CounterLoaded extends CounterState {
  final int count;

  CounterLoaded({required this.count});
}

class CounterFailed extends CounterState {}

class CounterLoading extends CounterState {}
