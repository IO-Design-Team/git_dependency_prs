Link PRs to git dependencies. Generate update timelines and enforce compliance.

## About

A lot of packages have necessary PRs that are not merged. This tool helps keep track of open PRs and display a timeline to help see if the changes may have been released so you can update your pubspec.

## Installation

```console
$ dart pub global activate git_dependency_prs
```

## Usage

### Pubspec

```yaml
dependency_overrides:
  package:
    git:
      prs:
        - https://github.com/owner/repo/pulls/14
      url: https://github.com/owner/repo
      ref: 616575ce3896f82ad942d6d11f9d0fdc25c0a8c5
```

### Print the update timeline

```console
$ git_dependency_prs check
package (dependency_overrides)
- 11 months ago: https://github.com/owner/repo/pull/503 was merged
- 11 months ago: https://github.com/owner/repo/pull/504 was merged
- 10 months ago: https://github.com/owner/repo/pull/511 was closed
- 10 months ago: https://github.com/owner/repo/pull/521 was created
- 10 months ago: https://github.com/owner/repo/pull/522 was created
- 7 months ago: Version 2.2.0 released (https://pub.dev/packages/package/changelog#220)
- 3 months ago: https://github.com/owner/repo/pull/610 was created
package (dependency_overrides)
- 27 days ago: Version 5.2.4 released (https://pub.dev/packages/package/changelog#524)
- 7 hours ago: https://github.com/owner/repo/pull/10317 was created
```

### Lint

```console
$ git_dependency_prs lint
package (dependencies)
- Not in dependency_overrides (gdp_placement)
- No PRs specified (gdp_specify_prs)
- Ref is missing or not a commit hash (gdp_specify_hash)
```

This will exit with status code 1 for use in CI

## Ignoring lint issues

```yaml
dependencies:
  # ignore: gdp_placement, gdp_specify_prs, gdp_specify_hash
  package:
    git: ...
```

## Troubleshooting

### API rate limit exceeded

If you see this, you need to pass a GitHub token:

```console
$ git_dependency_prs check -t <token>
```

Generate a token here: https://github.com/settings/personal-access-tokens/new