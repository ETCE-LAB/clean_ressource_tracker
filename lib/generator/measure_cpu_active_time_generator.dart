import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

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
    final generatedClassName = "${element.name}CpuActiveTimeDecorator";
    // generate the code inside the buffer
    final buffer = StringBuffer();
    buffer.writeln("part of '${buildStep.inputId.pathSegments.last}';");
    buffer.writeln("class $generatedClassName extends ${element.name} {");
    buffer.writeln("  final ${element.name} _inner;");
    buffer.writeln("  $generatedClassName(this._inner);");

    // generate the code for all non static public methods
    for (final method in element.methods.where(
      (m) => m.isPublic && !m.isStatic,
    )) {
      final name = method.name;
      final returnType = method.returnType.getDisplayString();

      final nameAndTypeParams = method.formalParameters.map((p) {
        final type = p.type.getDisplayString();
        final name = p.name;
        return '$type $name';
      }).join(', ');

      final nameParams = method.formalParameters.map((p) => p.name).join(', ');

      buffer.writeln('  @override');
      buffer.writeln('  $returnType $name($nameAndTypeParams) async {');
      buffer.writeln('    final start = await CPUActiveTImePlatformChannel.getCPUTime();');

      buffer.writeln('    final result = await _inner.$name($nameParams);');
      buffer.writeln('    final end = await CPUActiveTImePlatformChannel.getCPUTime();');
      buffer.writeln('    print("CPU time for $name: \${end - start}ms");');
      buffer.writeln('    return result;');

      buffer.writeln('  }');
    }

    buffer.writeln('}');
    return buffer.toString();
  }
}
