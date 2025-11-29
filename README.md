# clean_ressource_tracker

The Clean Ressource Tracker in a Flutter plugin project.
It provides annotations and generators to generate a cpu active time measure decorator for an
abstract class and a matching builder

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

This package is not yet deployed at flutter. This means, that the installing process differs from
other plugins.
If you want to use this plugin, you can integrate it in you flutter app with adding the following
statement to your pubspec.yaml:

``` yaml
  clean_ressource_tracker:
    git:
      url: git@github.com-private:ETCE-LAB/clean_ressource_tracker.git
```

As an requirements, you have to install [build_runner](https://pub.dev/packages/build_runner) to your dev dependencies.
To do this, run ```dart pub add --dev build_runner``` 

Then make sure you call ```dart pub get``` as usual to get the dependencies.

Since a generator is used in this plugin, add the following lines to you build.yaml in your project root. If your project does not contain this file, create it.

```yaml
targets:
  $default:
    builders:
      clean_ressource_tracker|measure_cpu:
        generate_for:
         - lib/**/*.dart
      clean_ressource_tracker|create_builder:
        generate_for:
          - lib/**/*.dart
```
Adjust the ```lib/**/*.dart``` path to match your file origin you want to create the files (if annotated)  for.

## Use the generators

To use the generators, annotate an abstract class with ```MeasureCpuActiveTime``` to create a cpu active time measuring decorator and/or with ```@WithBuilder``` to create a builder for this class

Your file can look like this afterwards:

``` dart
import 'package:clean_ressource_tracker/clean_ressource_tracker.dart';

@MeasureCpuActiveTime()
@WithBuilder()
abstract class CountService {
  int count(int initialValue);
}
```

To generate the files, run ```dart run build_runner build``` in your projects root directory

This command should generate a ```[your_annotated_file].builder.dart``` and a ```[your_annotated_file].cpu_active_time_generator.dart```

Now, you will get some import errors because the new classes don't have the original file imported.
To fix this problem and not modify the generated classes, add 
```dart
part 'count_service.cpu_active_time.decorator.dart';
part 'count_service.builder.dart';
```
above your annotated class. 

The construction of the object with the builder, the decorator and a functional implementation of the interface can look like this:

```dart
final ic = GetIt.instance;

Future<void> initDependencies() async {
  ic.registerLazySingleton<CountService>(
    () => CountServiceBuilder(
      CountRepository(),
    ).add((s) => CountServiceCpuActiveTimeDecorator(s)).build(),
  );
}
```


