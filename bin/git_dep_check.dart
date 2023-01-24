import 'package:ansicolor/ansicolor.dart';
import 'package:git_dep_check/git_dependency_reference.dart';
import 'package:github/github.dart' hide GitReference;
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec/pubspec.dart';

final magentaPen = AnsiPen()..magenta();
final greenPen = AnsiPen()..green();
final yellowPen = AnsiPen()..yellow();
final redPen = AnsiPen()..red();

void main() async {
  final pub = PubClient();
  final github = GitHub();

  final pubspec = await PubSpec.loadFile(
      '../safeguard_flutter/safeguard_live/pubspec.yaml');
  final gitDependencies = {
    ...filterGitDependencies(
      DependencyLocation.dependencies,
      pubspec.dependencies,
    ),
    ...filterGitDependencies(
      DependencyLocation.devDependencies,
      pubspec.devDependencies,
    ),
    ...filterGitDependencies(
      DependencyLocation.dependencyOverrides,
      pubspec.dependencyOverrides,
    ),
  }.values;

  for (final dependency in gitDependencies) {
    await checkPrs(pubspec, dependency);
  }
}

Map<String, GitDependencyReference> filterGitDependencies(
  DependencyLocation location,
  Map<String, DependencyReference> dependencies,
) {
  final copy = Map.from(dependencies);
  copy.removeWhere((k, v) => v is! GitReference);
  return copy
      .cast<String, GitReference>()
      .map((k, v) => MapEntry(k, GitDependencyReference(k, location, v)));
}

Future<void> checkPrs(PubSpec pubspec, GitDependencyReference reference) async {
  final prUrls =
      pubspec.unParsedYaml![reference.location.yamlKey][reference.name]['prs'];
  if (prUrls == null) {
    print(yellowPen('No PRs listed for ${reference.name}'));
    return;
  }

  for (final prUrl in prUrls) {
    
  }
}
