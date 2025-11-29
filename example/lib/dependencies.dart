import 'package:get_it/get_it.dart';

import 'bloc/counter_bloc.dart';
import 'domain/count_service.dart';
import 'infrastructure/count_repository.dart';

/// Dependency injection file
final ic = GetIt.instance;

Future<void> initDependencies() async {
  // Blocs
  ic.registerFactory<CounterBloc>(() => CounterBloc(ic()));
  // Services
  ic.registerLazySingleton<CountService>(
    () => CountServiceBuilder(
      CountRepository(),
    ).add((s) => CountServiceCpuActiveTimeDecorator(s)).build(),
  );
}
