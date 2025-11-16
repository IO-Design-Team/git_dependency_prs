import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:git_dependency_prs/analyzer_plugin/gdp_placement.dart';

/// The git_dependency_prs analyzer plugin
final plugin = GitDependencyPrsPlugin();

/// The git_dependency_prs analyzer plugin
class GitDependencyPrsPlugin extends Plugin {
  @override
  String get name => 'git_dependency_prs';

  @override
  void register(PluginRegistry registry) {
    registry..registerLintRule(GdpPlacement());
  }
}
