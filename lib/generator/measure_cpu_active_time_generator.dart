import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

/// Generator for the @MeasureCPUActiveTime annotation
/// Will create a Decorator extending the annotated Class
/// Will measure the CPU time before and after each method call and print the time difference
class MeasureCpuActiveTimeGenerator
    extends GeneratorForAnnotation<MeasureCpuActiveTime> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@MeasureCpuActiveTime kann nur auf Klassen angewendet werden.',
        element: element,
      );
    }
    // class signature, attributes and constructor
    final generatedClassName = "${element.name}CpuActiveTimeDecorator";
    final buffer = StringBuffer();
    buffer.writeln("part of '${buildStep.inputId.pathSegments.last}';");
    buffer.writeln("class $generatedClassName extends ${element.name} {");
    buffer.writeln("  final ${element.name} _inner;");
    buffer.writeln("  $generatedClassName(this._inner);");

    // generate the code for all non static public methods
    for (final method in element.methods.where(
      (m) => m.isPublic && !m.isStatic,
    )) {
      // get and save method signature
      final name = method.name;
      final returnType = method.returnType.getDisplayString();


      final nameAndTypeParams = method.formalParameters
          .map((p) {
            final type = p.type.getDisplayString();
            final name = p.name;
            return '$type $name';
          })
          .join(', ');

      final nameParams = method.formalParameters.map((p) => p.name).join(', ');

      buffer.writeln('  @override');
      if(method.returnType.isDartAsyncFuture){
        buffer.writeln('  $returnType $name($nameAndTypeParams) async {');
      } else{
        buffer.writeln('  $returnType $name($nameAndTypeParams) {');
      }
      if(method.returnType.isDartAsyncFuture){
        // start with measuring
        buffer.writeln(
          '    final start = await CPUActiveTImePlatformChannel.getCPUTime();',
        );
        // calling inner method
        buffer.writeln('    final result = await _inner.$name($nameParams);');
        // end measuring
        buffer.writeln(
          '    final end = await CPUActiveTImePlatformChannel.getCPUTime();',
        );
        // print CPU time difference
        buffer.writeln('    print("CPU time for $name: \${end - start}ms");');
        buffer.writeln('    return result;');
      } else{
        // calling inner method
        buffer.writeln('    final result = _inner.$name($nameParams);');
        buffer.writeln('    return result;');
      }


      buffer.writeln('  }');
    }

    buffer.writeln('}');
    return buffer.toString();
  }
}
