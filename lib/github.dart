import 'package:github/github.dart';

/// Access to github methods
class GitHubRepo {
  final _github = GitHub();

  final _pullRequestCache = <String, PullRequest>{};

  /// Fetch a PR by url
  Future<PullRequest> fetchPullRequest(String url) async {
    final cached = _pullRequestCache[url];
    if (cached != null) {
      return cached;
    }

    final parts = url.split('/');
    final owner = parts[parts.length - 4];
    final name = parts[parts.length - 3];
    final number = int.parse(parts.last);

    return _pullRequestCache[url] =
        await _github.pullRequests.get(RepositorySlug(owner, name), number);
  }
}
