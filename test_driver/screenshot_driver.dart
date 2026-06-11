import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

String _fileNameFor(String screenshotName, [Map<String, Object?>? args]) {
  final dynamic customFileName = args?['fileName'];
  String fileName;
  if (customFileName is String && customFileName.trim().isNotEmpty) {
    fileName = customFileName;
  } else {
    fileName = screenshotName;
  }

  fileName = fileName.replaceFirst(RegExp(r'\.(png|jpg|jpeg)$'), '');
  return '$fileName.jpg';
}

Future<void> _convertToJpeg(String inputPath, String outputPath) async {
  final result = await Process.run(
    'sips',
    [
      '-s',
      'format',
      'jpeg',
      '-s',
      'formatOptions',
      'best',
      inputPath,
      '--out',
      outputPath,
    ],
  );
  if (result.exitCode != 0) {
    throw ProcessException(
      'sips',
      [
        '-s',
        'format',
        'jpeg',
        '-s',
        'formatOptions',
        'best',
        inputPath,
        '--out',
        outputPath,
      ],
      '${result.stdout}\n${result.stderr}',
      result.exitCode,
    );
  }
}

Future<void> main() async {
  final String outputRoot =
      Platform.environment['SCREENSHOT_OUTPUT_DIR'] ?? Directory.current.path;
  final String platform =
      Platform.environment['SCREENSHOT_PLATFORM'] ?? 'unknown_platform';
  final String deviceSlug =
      Platform.environment['SCREENSHOT_DEVICE_SLUG'] ?? 'unknown_device';

  final Directory outputDir = Directory('$outputRoot/$platform/$deviceSlug')
    ..createSync(recursive: true);

  await integrationDriver(
    onScreenshot:
        (
          String screenshotName,
          List<int> screenshotBytes, [
          Map<String, Object?>? args,
        ]) async {
          final File image = File(
            '${outputDir.path}/${_fileNameFor(screenshotName, args)}',
          );
          final tempPng = File('${image.path}.tmp.png');
          await tempPng.writeAsBytes(screenshotBytes);
          await _convertToJpeg(tempPng.path, image.path);
          await tempPng.delete();
          return true;
        },
    writeResponseOnFailure: true,
  );
}
