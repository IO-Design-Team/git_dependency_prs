import 'package:args/command_runner.dart';
import 'package:git_dependency_prs/src/git_dependency_reference.dart';
import 'package:git_dependency_prs/src/github.dart';
import 'package:git_dependency_prs/src/lints.dart';
import 'package:git_dependency_prs/src/pens.dart';
import 'package:git_dependency_prs/src/pub.dart';
import 'package:git_dependency_prs/src/git_dependencies.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class CheckCommand extends Command<int> {
  @override
  final String name = 'check';

  @override
  final String description = 'Check the status of git dependency PRs';

  final dateFormat = DateFormat('yyyy-MM-dd');

  CheckCommand() {
    argParser.addOption('git-token', abbr: 't', help: 'GitHub API token');
  }

  late final GitHubRepo github;

  @override
  Future<int> run() async {
    github = GitHubRepo(gitToken: argResults?['git-token']);

    final gitDependencies = GitDependencies.fromPubspec();
    if (gitDependencies.isEmpty) {
      print(yellowPen('No git dependencies found'));
      return 0;
    }

    for (final dependency in gitDependencies) {
      await checkPrs(dependency);
    }

    return 0;
  }

  Future<void> checkPrs(GitDependencyReference dependency) async {
    print(bluePen('${dependency.name} (${dependency.location})'));

    final lints = GdpLints.fromDependency(dependency);
    for (final lint in lints) {
      print('- ${redPen(lint)}');
    }

    final messages = <TimestampedMessage>[];
    final latest = await PubRepo.fetchLatestRelease(dependency.name);

    if (latest != null) {
      final versionFragment = latest.version.replaceAll(RegExp(r'[^0-9]'), '');
      final changelogUrl =
          'https://pub.dev/packages/${dependency.name}/changelog#$versionFragment';
      messages.add(
        TimestampedMessage(
          latest.published,
          greenPen('Version ${latest.version} released ($changelogUrl)'),
        ),
      );
    } else {
      print('- ${redPen('No releases found')}');
    }

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

    for (final message in messages) {
      // This is for display only
      // ignore: prefer_timestamps
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
}

class TimestampedMessage {
  final DateTime timestamp;
  final String message;

  TimestampedMessage(this.timestamp, this.message);
}
