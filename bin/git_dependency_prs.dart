import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:git_dependency_prs/pens.dart';
import 'package:git_dependency_prs/git_dependency_reference.dart';
import 'package:yaml/yaml.dart';

import 'command/check.dart';
import 'command/lint.dart';

void main(List<String> arguments) async {
  final pubspec = await loadYaml(File('pubspec.yaml').readAsStringSync());
  final gitDependencies = {
    ...filterGitDependencies('dependencies', pubspec['dependencies']),
    ...filterGitDependencies('dev_dependencies', pubspec['dev_dependencies']),
    ...filterGitDependencies(
      'dependency_overrides',
      pubspec['dependency_overrides'],
    ),
  }.values;

  if (gitDependencies.isEmpty) {
    print(yellowPen('No git dependencies found'));
    exit(0);
  }

  final runner = CommandRunner(
    'git_dependency_prs',
    'Check on the status git dependency PRs',
  )
    ..addCommand(CheckCommand(gitDependencies))
    ..addCommand(LintCommand(gitDependencies));

  await runner.run(arguments);

  exit(0);
}

Map<String, GitDependencyReference> filterGitDependencies(
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

    final List<String> prs;
    final bool ignore;
    final prsValue = git['prs'];
    if (prsValue is String && prsValue == 'ignore') {
      prs = [];
      ignore = true;
    } else if (prsValue is List) {
      prs = prsValue.cast<String>();
      ignore = false;
    } else {
      prs = [];
      ignore = false;
    }

    gitDependencies[key] = GitDependencyReference(
      location: location,
      name: key,
      prs: prs,
      ignore: ignore,
    );
  }

  return gitDependencies;
}
