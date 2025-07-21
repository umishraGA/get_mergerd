import 'dart:io';
import 'dart:async';

/// A script to check if the project follows the widget organization rules
void main() async {
  print('Checking widget organization rules...');

  final libDir = Directory('lib');
  if (!await libDir.exists()) {
    print('Error: lib directory not found');
    exit(1);
  }

  final issues = <String>[];
  final featuresDir = Directory('${libDir.path}/features');

  if (await featuresDir.exists()) {
    await for (final featureDir
        in featuresDir.list().where((entity) => entity is Directory)) {
      final widgetDir = Directory('${featureDir.path}/widgets');

      // Check if the feature has a widgets directory
      if (!await widgetDir.exists()) {
        issues.add(
            'Feature ${featureDir.path} does not have a widgets directory');
        continue;
      }

      // Check main page files for complex widgets
      await for (final file in Directory(featureDir.path)
          .list(recursive: false)
          .where((entity) => entity is File && entity.path.endsWith('.dart'))) {
        final content = await File(file.path).readAsString();

        // Simple heuristic: if a page file has too many widget definitions or complex UI,
        // it might be violating the rule
        if (content.contains('class') &&
            (content.contains('Container(') ||
                content.contains('Column(') ||
                content.contains('Row('))) {
          // Count the number of widget constructor calls
          final containerCount = _countOccurrences(content, 'Container(');
          final columnCount = _countOccurrences(content, 'Column(');
          final rowCount = _countOccurrences(content, 'Row(');

          // If there are too many widget constructors, it might be a complex UI
          if (containerCount + columnCount + rowCount > 5) {
            issues.add(
                'File ${file.path} might have complex UI that should be extracted to widgets folder');
          }
        }
      }

      // Check widget files naming convention
      await for (final file in widgetDir
          .list(recursive: true)
          .where((entity) => entity is File && entity.path.endsWith('.dart'))) {
        final fileName = file.path.split(Platform.pathSeparator).last;

        if (!fileName.endsWith('Widget.dart') &&
            !fileName.contains('_widget')) {
          issues.add(
              'Widget file ${file.path} does not follow naming convention (should end with Widget.dart)');
        }
      }
    }
  } else {
    print('Warning: features directory not found');
  }

  if (issues.isEmpty) {
    print('✅ All widget organization rules are followed!');
  } else {
    print('❌ Found ${issues.length} issues:');
    for (final issue in issues) {
      print('  - $issue');
    }
    exit(1);
  }
}

int _countOccurrences(String text, String pattern) {
  int count = 0;
  int index = 0;
  while (true) {
    index = text.indexOf(pattern, index);
    if (index == -1) break;
    count++;
    index += pattern.length;
  }
  return count;
}
