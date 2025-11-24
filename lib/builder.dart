import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator/measure_cpu_active_time_generator.dart';
import 'generator/with_builder_generator.dart';

Builder measureCpuActiveTimeBuilder(BuilderOptions options) => LibraryBuilder(
  MeasureCpuActiveTimeGenerator(),
  generatedExtension: ".cpu_active_time.decorator.dart",
);

Builder withBuilder(BuilderOptions options) =>
    LibraryBuilder(WithBuilderGenerator(), generatedExtension: ".builder.dart");
