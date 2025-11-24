import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:task2/src/annotations.dart';

class SerializationGenerator
    extends GeneratorForAnnotation<JsonSerializableForTask> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final buffer = StringBuffer();
    final classElement = element as ClassElement;

    _generateFromJson(classElement, buffer);
    _generateToJson(classElement, buffer);

    return buffer.toString();
  }

  void _generateFromJson(ClassElement classElement, StringBuffer buffer) {
    const dateTimeChecker = TypeChecker.fromUrl('dart:core#DateTime');
    const intChecker = TypeChecker.fromUrl('dart:core#int');
    const durationChecker = TypeChecker.fromUrl('dart:core#Duration');
    const uriChecker = TypeChecker.fromUrl('dart:core#Uri');

    String? className = classElement.name;
    buffer.writeln(
      "$className _\$${className}FromJson(Map<String, dynamic> json) => $className(",
    );
    List<FieldElement> fields = classElement.fields;
    for (final field in fields) {
      final String? fieldName = field.name;
      if (fieldName == null) {
        continue;
      }
      final DartType fieldType = field.type;
      final String fieldTypeName = field.type.getDisplayString();
      final isNullable = field.type.nullabilitySuffix != NullabilitySuffix.none;
      if (dateTimeChecker.isExactlyType(fieldType)) {
        if (isNullable) {
          buffer.writeln(
            "$fieldName: json['$fieldName'] == null ? null : DateTime.parse(json['$fieldName'] as String),",
          );
        } else {
          buffer.writeln(
            "$fieldName: DateTime.parse(json['$fieldName'] as String),",
          );
        }
      } else if (intChecker.isExactlyType(fieldType)) {
        buffer.writeln("  $fieldName: (json['$fieldName'] as num).toInt(),");
      } else if (durationChecker.isExactlyType(fieldType)) {
        buffer.writeln(
          "  $fieldName: const DurationStringConverter().fromJson(",
        );
        buffer.writeln("    json['$fieldName'] as String),");
      } else if (uriChecker.isExactlyType(fieldType)) {
        buffer.writeln("$fieldName: Uri.parse(json['$fieldName'] as String),");
      } else {
        buffer.writeln("  $fieldName: json['$fieldName'] as $fieldTypeName,");
      }
    }
    buffer.writeln(");\n");
  }

  void _generateToJson(ClassElement classElement, StringBuffer buffer) {
    const dateTimeChecker = TypeChecker.fromUrl('dart:core#DateTime');
    const durationChecker = TypeChecker.fromUrl('dart:core#Duration');
    const uriChecker = TypeChecker.fromUrl('dart:core#Uri');

    String? className = classElement.name;

    buffer.writeln(
      "Map<String, dynamic> _\$${className}ToJson($className instance) => <String, dynamic>{",
    );

    List<FieldElement> fields = classElement.fields;

    for (final field in fields) {
      final String? fieldName = field.name;
      if (fieldName == null) {
        continue;
      }
      final DartType fieldType = field.type;
      final isNullable = field.type.nullabilitySuffix != NullabilitySuffix.none;
      final access = isNullable ? '?.' : '.';

      if (dateTimeChecker.isExactlyType(fieldType)) {
        buffer.writeln(
          "  '$fieldName': instance.$fieldName${access}toIso8601String(),",
        );
      } else if (durationChecker.isExactlyType(fieldType)) {
        if (isNullable) {
          buffer.writeln(
            " '$fieldName': instance.$fieldName == null ? null : const DurationStringConverter().toJson(instance.$fieldName!),",
          );
        } else {
          buffer.writeln(
            " '$fieldName': const DurationStringConverter().toJson(instance.$fieldName),",
          );
        }
      } else if (uriChecker.isExactlyType(fieldType)) {
        buffer.writeln(
          "  '$fieldName': instance.$fieldName${access}toString(),",
        );
      } else {
        buffer.writeln("  '$fieldName': instance.$fieldName,");
      }
    }
    buffer.writeln("};\n");
  }
}
