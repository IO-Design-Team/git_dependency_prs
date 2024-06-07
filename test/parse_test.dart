import 'package:git_dependency_prs/lint.dart';
import 'package:git_dependency_prs/util.dart';
import 'package:test/test.dart';

void main() {
  test('parse', () {
    final dependencies = loadGitDependencies('test_resources/test.yaml');
    expect(dependencies.length, 4);

    var dependency = dependencies.elementAt(0);
    expect(dependency.location, 'dependencies');
    expect(dependency.name, 'package_git');
    expect(dependency.prs, ['https://github.com/owner/repo/pulls/14']);
    expect(dependency.ref, '616575ce3896f82ad942d6d11f9d0fdc25c0a8c5');
    expect(dependency.ignore, GdpLint.values);

    dependency = dependencies.elementAt(1);
    expect(dependency.location, 'dependencies');
    expect(dependency.name, 'package_git_no_map');
    expect(dependency.prs, []);
    expect(dependency.ref, null);
    expect(dependency.ignore, isEmpty);

    dependency = dependencies.elementAt(2);
    expect(dependency.location, 'dev_dependencies');
    expect(dependency.name, 'package_git_dev');
    expect(dependency.prs, ['https://github.com/owner/repo/pulls/14']);
    expect(dependency.ref, '616575ce3896f82ad942d6d11f9d0fdc25c0a8c5');
    expect(dependency.ignore, GdpLint.values);

    dependency = dependencies.elementAt(3);
    expect(dependency.location, 'dependency_overrides');
    expect(dependency.name, 'package_git_override');
    expect(dependency.prs, ['https://github.com/owner/repo/pulls/14']);
    expect(dependency.ref, '616575ce3896f82ad942d6d11f9d0fdc25c0a8c5');
    expect(dependency.ignore, GdpLint.values);
  });
}
