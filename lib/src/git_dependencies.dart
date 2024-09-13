import 'dart:collection';
import 'dart:io';

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:git_dependency_prs/src/git_dependency_reference.dart';
import 'package:git_dependency_prs/src/lints.dart';
import 'package:source_span/source_span.dart';
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
    final ignores = <String, Set<LintCode>>{};
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
            .map(GdpLints.fromCode)
            .whereType<LintCode>()
            .toSet();
        final package = lines.removeFirst().trim().split(':').first;
        ignores[package] = ignored;
      }
    }

    final pubspec = loadYaml(content);

    final gitDependencies = {
      ..._filterGitDependencies(
        location: 'dependencies',
        dependencies: pubspec['dependencies'],
        ignores: ignores,
        rawYaml: content,
      ),
      ..._filterGitDependencies(
        location: 'dev_dependencies',
        dependencies: pubspec['dev_dependencies'],
        ignores: ignores,
        rawYaml: content,
      ),
      ..._filterGitDependencies(
        location: 'dependency_overrides',
        dependencies: pubspec['dependency_overrides'],
        ignores: ignores,
        rawYaml: content,
      ),
    }.values;

    return gitDependencies;
  }

  static Map<String, GitDependencyReference> _filterGitDependencies({
    required String location,
    required YamlMap? dependencies,
    required Map<String, Set<LintCode>> ignores,
    required String rawYaml,
  }) {
    if (dependencies == null) {
      return {};
    }

    final locationOffset =
        rawYaml.indexOf(RegExp('^$location:\$', multiLine: true));

    final gitDependencies = <String, GitDependencyReference>{};
    for (final dependency in dependencies.entries) {
      final key = dependency.key as String;
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

      final offset = rawYaml.indexOf('$key:', locationOffset);

      gitDependencies[key] = GitDependencyReference(
        location: location,
        name: key,
        prs: prs,
        ref: ref,
        ignore: ignores[key] ?? {},
        span: SourceSpan(
          SourceLocation(offset),
          SourceLocation(offset + key.length),
          key,
        ),
      );
    }

    return gitDependencies;
  }
}
