// ignore_for_file: avoid_print script messages

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart' as yaml;

/// post publish hook.
///
/// - compose and push a git tag with the app version
Future<void> main(List<String> args) async {
  final version = await _version();
  await _createAndPushGitTag(version, version);
}

/// return the `pubspec.yaml`
Future<yaml.YamlMap> _readPubspec() async {
  final yamlStr =
      await File(p.joinAll([Directory.current.path, 'pubspec.yaml']))
          .readAsString();

  return yaml.loadYaml(yamlStr) as yaml.YamlMap;
}

Future<String> _version() async {
  final pubspec = await _readPubspec();
  return pubspec['version'] as String;
}

Future<void> _createAndPushGitTag(String tagName, String commitMessage) async {
  // tag
  var result = await Process.run('git', ['tag', tagName, '-m', commitMessage]);
  if (result.exitCode != 0) {
    print('Error during git tag: ${result.stderr}');
    return;
  }

  // push
  result = await Process.run('git', ['push', 'origin', tagName]);
  if (result.exitCode != 0) {
    print('Error during git push tag: ${result.stderr}');
    return;
  }
}
