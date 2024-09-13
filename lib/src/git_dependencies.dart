import 'dart:collection';
import 'dart:io';

import 'package:git_dependency_prs/src/git_dependency_reference.dart';
import 'package:git_dependency_prs/src/lint.dart';
import 'package:yaml/yaml.dart';

/// Methods for reading git dependencies
abstract final class GitDependencies {
  const GitDependencies._();

  /// Get all git dependencies from the local pubspec.yaml
  static Iterable<GitDependencyReference> fromPubspec([
    String location = 'pubspec.yaml',
  ]) {
    return fromString(File(location).readAsStringSync());
  }

  /// Get all git dependencies from the given yaml string
  static Iterable<GitDependencyReference> fromString(String content) {
    final ignores = <String, List<String>>{};
    final lines = Queue<String>.from(content.split('\n'));
    while (lines.isNotEmpty) {
      final line = lines.removeFirst();
      // If this is the last line, break
      if (lines.isEmpty) break;

      if (line.trim().startsWith('# ignore:')) {
        final ignored = line
            .split(':')[1]
            .split(',')
            .map((e) => e.trim())
            .map(GdpLint.fromCode)
            .whereType<GdpLint>()
            .toList();
        final package = lines.removeFirst().trim().split(':').first;
        ignores[package] = ignored;
      }
    }

    final pubspec = loadYaml(content);

    final gitDependencies = {
      ..._filterGitDependencies(
        'dependencies',
        pubspec['dependencies'],
        ignores,
      ),
      ..._filterGitDependencies(
        'dev_dependencies',
        pubspec['dev_dependencies'],
        ignores,
      ),
      ..._filterGitDependencies(
        'dependency_overrides',
        pubspec['dependency_overrides'],
        ignores,
      ),
    }.values;

    return gitDependencies;
  }

  static Map<String, GitDependencyReference> _filterGitDependencies(
    String location,
    YamlMap? dependencies,
    Map<String, List<GdpLint>> ignores,
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

      final List<String> prs;
      final String? ref;
      if (git is! Map) {
        prs = [];
        ref = null;
      } else {
        final list = git['prs'] as List? ?? [];
        prs = list.cast<String>();
        ref = git['ref'] as String?;
      }

      gitDependencies[key] = GitDependencyReference(
        location: location,
        name: key,
        prs: prs,
        ref: ref,
        ignore: ignores[key] ?? [],
      );
    }

    return gitDependencies;
  }
}
