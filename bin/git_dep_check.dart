import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:git_dep_check/git_dependency_reference.dart';
import 'package:git_dep_check/pub.dart';
import 'package:yaml/yaml.dart';
import 'package:git_dep_check/github.dart';

final magentaPen = AnsiPen()..magenta();
final greenPen = AnsiPen()..green();
final yellowPen = AnsiPen()..yellow();
final redPen = AnsiPen()..red();
final bluePen = AnsiPen()..blue();

final pub = PubRepo();
final github = GitHubRepo();

final dateFormat = DateFormat('yyyy-MM-dd');

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

  for (final dependency in gitDependencies) {
    await checkPrs(dependency);
  }

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

    final prs = value['git']?['prs'] as List?;
    if (prs == null) continue;
    gitDependencies[key] =
        GitDependencyReference(location, key, prs.cast<String>());
  }

  return gitDependencies;
}

Future<void> checkPrs(GitDependencyReference dependency) async {
  final messages = <TimestampedMessage>[];

  final latest = await pub.fetchLatestRelease(dependency.name);
  messages.add(
    TimestampedMessage(
      latest.published,
      greenPen('Version ${latest.version} released'),
    ),
  );

  for (final url in dependency.prs) {
    final pr = await github.fetchPullRequest(url);

    if (pr.state == 'closed') {
      if (pr.merged == true) {
        messages.add(
          TimestampedMessage(
            pr.mergedAt!,
            magentaPen('${pr.htmlUrl} was merged'),
          ),
        );
      } else {
        messages.add(
          TimestampedMessage(
            pr.closedAt!,
            redPen('${pr.htmlUrl} was closed'),
          ),
        );
      }
    } else {
      messages.add(
        TimestampedMessage(
          pr.createdAt!,
          yellowPen('${pr.htmlUrl} was created'),
        ),
      );
    }
  }

  messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

  print(bluePen('${dependency.name} (${dependency.location})'));
  for (final message in messages) {
    final diff = DateTime.now().difference(message.timestamp);
    final String time;
    if (diff.inDays < 365) {
      time = timeago.format(message.timestamp);
    } else {
      time = dateFormat.format(message.timestamp);
    }
    print('- $time: ${message.message}');
  }
}

// TODO: Convert to record with Dart 3
class TimestampedMessage {
  final DateTime timestamp;
  final String message;

  TimestampedMessage(this.timestamp, this.message);
}
