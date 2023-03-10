import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:git_dependency_prs/git_dependency_reference.dart';
import 'package:git_dependency_prs/lint.dart';
import 'package:git_dependency_prs/pens.dart';
import 'package:git_dependency_prs/util.dart';

class LintCommand extends Command {
  @override
  final String name = 'lint';

  @override
  final String description = 'Error if any git dependencies specify no PRs';

  LintCommand();

  @override
  Future<void> run() async {
    final gitDependencies = await loadGitDependencies();

    final issues = <GitDependencyReference, List<GdpLint>>{};

    for (final dependency in gitDependencies) {
      final lints = GdpLint.fromDependency(dependency);
      if (lints.isNotEmpty) {
        issues[dependency] = lints;
      }
    }

    for (final dependency in issues.keys) {
      print(bluePen('${dependency.name} (${dependency.location})'));
      for (final issue in issues[dependency]!) {
        print('- ${redPen(issue)}');
      }
    }

    if (issues.isEmpty) {
      print(greenPen('No issues found'));
    } else {
      print(
        redPen(
          '\nSee https://pub.dev/packages/git_dependency_prs#ignoring-lint-issues for help',
        ),
      );
      exit(1);
    }
  }
}
