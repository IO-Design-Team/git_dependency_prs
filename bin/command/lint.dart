import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:git_dependency_prs/git_dependency_reference.dart';
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

    final issues = <GitDependencyReference, List<String>>{};

    for (final dependency in gitDependencies) {
      if (!dependency.ignore.contains('gdp_placement') &&
          dependency.location != 'dependency_overrides') {
        issues[dependency] ??= [];
        issues[dependency]!.add('Not in dependency_overrides');
      }

      if (!dependency.ignore.contains('gdp_specify_prs') &&dependency.prs.isEmpty) {
        issues[dependency] ??= [];
        issues[dependency]!.add('No PRs specified');
      }
    }

    for (final dependency in issues.keys) {
      print(redPen('${dependency.name} (${dependency.location})'));
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
