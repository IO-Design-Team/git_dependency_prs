import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:git_dep_check/git_dependency_reference.dart';
import 'package:github/github.dart' hide GitReference;
import 'package:pub_api_client/pub_api_client.dart';
import 'package:yaml/yaml.dart';

final magentaPen = AnsiPen()..magenta();
final greenPen = AnsiPen()..green();
final yellowPen = AnsiPen()..yellow();
final redPen = AnsiPen()..red();

final pub = PubClient();
final github = GitHub();

void main() async {
  final pubspec = await loadYaml(
      File('../safeguard_flutter/safeguard_live/pubspec.yaml')
          .readAsStringSync());
  final gitDependencies = {
    ...filterGitDependencies('dependencies', pubspec['dependencies']),
    ...filterGitDependencies('dev_dependencies', pubspec['dev_dependencies']),
    ...filterGitDependencies(
      'dependency_overrides',
      pubspec['dependency_overrides'],
    ),
  }.values;

  for (final dependency in gitDependencies) {
    // await checkPrs(pubspec, dependency);
  }
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

    final prs = value['git']?['prs'] as List?;
    if (prs == null) {
      continue;
    }
    print(prs);
  }

  return gitDependencies;
}

// Future<void> checkPrs(PubSpec pubspec, GitDependencyReference reference) async {
//   final prUrls =
//       pubspec.unParsedYaml![reference.location.yamlKey][reference.name]['prs'];
//   if (prUrls == null) {
//     print(yellowPen('No PRs listed for ${reference.name}'));
//     return;
//   }

//   for (final prUrl in prUrls) {
//     final parts = prUrl.split('/');
//     final owner = parts[parts.length - 3];
//     final name = parts[parts.length - 2];
//     final number = parts.last;

//     final pr =
//         await github.pullRequests.get(RepositorySlug(owner, name), number);
//     if (pr.state == 'closed') {
//       print(redPen('PR $prUrl is closed'));
//     } else {
//       print(greenPen('PR $prUrl is open'));
//     }
//   }
// }
