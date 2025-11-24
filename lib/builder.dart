import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator/measure_cpu_active_time_generator.dart';
import 'generator/with_builder_generator.dart';

/// builder to call the @MeasureCpuActiveTimeGenerator and save the result with
/// the file name extension .cpu_active_time.decorator.dart
Builder measureCpuActiveTimeBuilder(BuilderOptions options) => LibraryBuilder(
  MeasureCpuActiveTimeGenerator(),
  generatedExtension: ".cpu_active_time.decorator.dart",
);

/// builder to call the @WithBuilderGenerator and save the result with
/// the file name extension .builder.dart
Builder withBuilder(BuilderOptions options) =>
    LibraryBuilder(WithBuilderGenerator(), generatedExtension: ".builder.dart");
