import 'dart:io';

/// A script to create a new feature with proper widget organization
///
/// Usage: dart scripts/create_feature.dart <feature_name>
/// Example: dart scripts/create_feature.dart profile
void main(List<String> args) async {
  if (args.isEmpty) {
    print('Error: Feature name is required');
    print('Usage: dart scripts/create_feature.dart <feature_name>');
    exit(1);
  }

  final featureName = args[0];
  final featureNamePascalCase = _toPascalCase(featureName);

  print('Creating new feature: $featureNamePascalCase');

  // Create feature directory structure
  final featureDir = Directory('lib/features/$featureName');
  final widgetsDir = Directory('${featureDir.path}/widgets');

  await featureDir.create(recursive: true);
  await widgetsDir.create(recursive: true);

  // Copy template files
  await _copyAndReplaceTemplate(
    'templates/feature_template/FeaturePage.dart',
    '${featureDir.path}/${featureNamePascalCase}Page.dart',
    'Feature',
    featureNamePascalCase,
  );

  await _copyAndReplaceTemplate(
    'templates/feature_template/widgets/FeatureContentWidget.dart',
    '${widgetsDir.path}/${featureNamePascalCase}ContentWidget.dart',
    'Feature',
    featureNamePascalCase,
  );

  await _copyAndReplaceTemplate(
    'templates/feature_template/widgets/FeatureItemWidget.dart',
    '${widgetsDir.path}/${featureNamePascalCase}ItemWidget.dart',
    'Feature',
    featureNamePascalCase,
  );

  print('✅ Feature created successfully!');
  print('Feature directory: ${featureDir.path}');
  print('Widgets directory: ${widgetsDir.path}');
}

/// Converts a string to PascalCase
String _toPascalCase(String text) {
  if (text.isEmpty) return '';

  final words = text.split(RegExp(r'[_\s-]'));
  return words.map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join('');
}

/// Copies a template file and replaces placeholders
Future<void> _copyAndReplaceTemplate(
  String sourcePath,
  String targetPath,
  String placeholder,
  String replacement,
) async {
  final sourceFile = File(sourcePath);
  final targetFile = File(targetPath);

  if (!await sourceFile.exists()) {
    print('Error: Template file not found: $sourcePath');
    exit(1);
  }

  String content = await sourceFile.readAsString();
  content = content.replaceAll(placeholder, replacement);

  await targetFile.writeAsString(content);
  print('Created: $targetPath');
}
