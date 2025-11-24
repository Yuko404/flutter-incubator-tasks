import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/generator.dart';

Builder jsonBuilder(BuilderOptions options) {
  return PartBuilder(
    <Generator>[SerializationGenerator()],
    '.my.dart',
    header: "// GENERATED CODE - DO NOT MODIFY BY HAND",
  );
}
