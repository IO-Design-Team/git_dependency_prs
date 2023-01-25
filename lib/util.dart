import 'dart:io';

import 'package:git_dependency_prs/git_dependency_reference.dart';
import 'package:git_dependency_prs/pens.dart';
import 'package:yaml/yaml.dart';

/// Get all git dependencies from the local pubspec.yaml
Future<Iterable<GitDependencyReference>> loadGitDependencies() async {
  final pubspec = await loadYaml(File('pubspec.yaml').readAsStringSync());
  final gitDependencies = {
    ..._filterGitDependencies('dependencies', pubspec['dependencies']),
    ..._filterGitDependencies('dev_dependencies', pubspec['dev_dependencies']),
    ..._filterGitDependencies(
      'dependency_overrides',
      pubspec['dependency_overrides'],
    ),
  }.values;

  if (gitDependencies.isEmpty) {
    print(yellowPen('No git dependencies found'));
    exit(0);
  }

  return gitDependencies;
}

Map<String, GitDependencyReference> _filterGitDependencies(
  String location,
  YamlMap? dependencies,
) {
  if (dependencies == null) {
    return {};
  }

  final gitDependencies = <String, GitDependencyReference>{};
  for (final dependency in dependencies.entries) {
    final key = dependency.key;
    final value = dependency.value;
    if (value is! Map) continue;
    final git = value['git'];
    if (git == null) continue;

    final prs = git['prs'] as List? ?? [];
    final ignoreLints = git['ignore_lints'] as bool?;

    gitDependencies[key] = GitDependencyReference(
      location: location,
      name: key,
      prs: prs.cast<String>(),
      ignoreLints: ignoreLints ?? false,
    );
  }

  return gitDependencies;
}
