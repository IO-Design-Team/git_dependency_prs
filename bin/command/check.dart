import 'package:args/command_runner.dart';
import 'package:git_dependency_prs/git_dependency_reference.dart';
import 'package:git_dependency_prs/github.dart';
import 'package:git_dependency_prs/lint.dart';
import 'package:git_dependency_prs/pens.dart';
import 'package:git_dependency_prs/pub.dart';
import 'package:git_dependency_prs/util.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class CheckCommand extends Command {
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
  Future<void> run() async {
    github = GitHubRepo(gitToken: argResults?['git-token']);

    final gitDependencies = await loadGitDependencies();
    for (final dependency in gitDependencies) {
      await checkPrs(dependency);
    }
  }

  Future<void> checkPrs(GitDependencyReference dependency) async {
    print(bluePen('${dependency.name} (${dependency.location})'));

    final lints = GdpLint.fromDependency(dependency);
    for (final lint in lints) {
      print('- ${redPen(lint)}');
    }

    final messages = <TimestampedMessage>[];
    final latest = await PubRepo.fetchLatestRelease(dependency.name);

    if (latest != null) {
      messages.add(
        TimestampedMessage(
          latest.published,
          greenPen('Version ${latest.version} released'),
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
