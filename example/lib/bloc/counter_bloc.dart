import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/count_service.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CountService countService;

  CounterBloc(this.countService) : super(CounterInitial()) {
    on<Count>(_onCount);
  }

  void _onCount(Count event, emit) async {
    emit(CounterLoading());

    int result = await countService.count(event.initialNumber);
    emit(CounterLoaded(count: result));
  }
}
