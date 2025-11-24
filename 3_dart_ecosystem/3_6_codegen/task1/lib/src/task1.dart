import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

class LinesBuilder extends Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
    r'$package$': ['summary.g'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final String packageName = buildStep.inputId.package;

    final dartFiles = Glob('**/*.dart');

    final Map<String, int> linesOfCode = {};
    await for (final input in buildStep.findAssets(dartFiles)) {
      if (input.path.endsWith('.g.dart')) {
        continue;
      }
      final content = await buildStep.readAsString(input);
      final linesCount = content.split('\n').length;
      linesOfCode[input.path] = linesCount;
    }

    if (linesOfCode.isEmpty) {
      await buildStep.writeAsString(
        AssetId(packageName, 'summary.g'),
        'No Dart files found.',
      );
      return;
    }
    final totalLines = linesOfCode.values.reduce(
      (value, element) => value + element,
    );
    final sorted = linesOfCode.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    int indexOfLine = 0;

    final buffer = StringBuffer();
    buffer.writeln('Total lines of code: $totalLines\n');
    buffer.writeln('Lines of code by a file in descending order:');
    for (final mapEntry in sorted) {
      indexOfLine++;
      buffer.writeln('$indexOfLine. `${mapEntry.key}`: ${mapEntry.value}');
    }

    final outputId = AssetId(packageName, 'summary.g');
    await buildStep.writeAsString(outputId, buffer.toString());
  }
}
