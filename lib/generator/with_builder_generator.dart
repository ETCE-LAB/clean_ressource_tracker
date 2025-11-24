import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';


/// Generator for the @WithBuilder annotation
/// Will create a Builder for the annotated class
/// Will provide an add method to cluster  decorators and
/// a build method to return the constructed object
class WithBuilderGenerator extends GeneratorForAnnotation<WithBuilder> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@WithRBuilder kann nur auf Klassen angewendet werden.',
        element: element,
      );
    }

    // class signature, attributes and constructor
    final generatedClassName = "${element.name}Builder";
    // generate the code inside the buffer
    final buffer = StringBuffer();
    buffer.writeln("part of '${buildStep.inputId.pathSegments.last}';");
    buffer.writeln("class $generatedClassName {");
    buffer.writeln("  final ${element.name} _inner;");
    buffer.writeln("  $generatedClassName(this._inner);");

    // private attribute
    buffer.writeln("  final List<Function(${element.name})> _decorators = [];");

    // method to add decorators
    buffer.writeln("  // append a decorator");
    buffer.writeln("  $generatedClassName add(");
    buffer.writeln("    Function(${element.name}) decorator) {");
    buffer.writeln("    _decorators.add(decorator);");
    buffer.writeln("    return this;");
    buffer.writeln("  }");

    // method to build the object
    buffer.writeln("  // stack all decorators");
    buffer.writeln("  ${element.name} build() {");
    buffer.writeln("    var result = _inner;");
    buffer.writeln("    for (final decorator in _decorators) {");
    buffer.writeln("      result = decorator(result);");
    buffer.writeln("    }");

    buffer.writeln("   return result;");
    buffer.writeln("  }");
    buffer.writeln('}');
    return buffer.toString();
  }
}
