Link PRs to git dependencies. Generate update timelines and enforce compliance.

## Features

### Print the update timeline

```console
$ git_dependency_prs check
logger_flutter (dependencies)
- ignored
google_maps_flutter (dependencies)
- 11 months ago: https://github.com/flutter/plugins/pull/4916 was created
- 10 months ago: https://github.com/flutter/plugins/pull/5274 was created
- 21 days ago: Version 2.2.3 released
google_maps_flutter_web (dependencies)
- 11 months ago: https://github.com/flutter/plugins/pull/4916 was created
- 10 months ago: https://github.com/flutter/plugins/pull/5274 was created
- 4 days ago: Version 0.4.0+5 released
google_maps_flutter_android (dependency_overrides)
- 11 months ago: https://github.com/flutter/plugins/pull/4916 was created
- 10 months ago: https://github.com/flutter/plugins/pull/5274 was created
- 4 days ago: Version 2.4.3 released
google_maps_flutter_platform_interface (dependency_overrides)
- 11 months ago: https://github.com/flutter/plugins/pull/4916 was created
- 10 months ago: https://github.com/flutter/plugins/pull/5274 was created
- 15 days ago: Version 2.2.5 released
stats (dependencies)
- 2021-03-15: Version 2.0.0 released
- 2021-12-09: https://github.com/kevmoo/stats/pull/16 was created
google_maps_flutter_ios (dependency_overrides)
- 11 months ago: https://github.com/flutter/plugins/pull/4916 was created
- 10 months ago: https://github.com/flutter/plugins/pull/5274 was created
- 15 days ago: Version 2.1.13 released
audio_streamer (dependency_overrides)
- 11 months ago: https://github.com/cph-cachet/flutter-plugins/pull/503 was merged
- 11 months ago: https://github.com/cph-cachet/flutter-plugins/pull/504 was merged
- 10 months ago: https://github.com/cph-cachet/flutter-plugins/pull/511 was closed
- 10 months ago: https://github.com/cph-cachet/flutter-plugins/pull/521 was created
- 10 months ago: https://github.com/cph-cachet/flutter-plugins/pull/522 was created
- 7 months ago: Version 2.2.0 released
- 3 months ago: https://github.com/cph-cachet/flutter-plugins/pull/610 was created
firebase_auth_web (dependency_overrides)
- 27 days ago: Version 5.2.4 released
- 7 hours ago: https://github.com/firebase/flutterfire/pull/10317 was created
```

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Troubleshooting

### API rate limit exceeded

If you see this, you need to pass a GitHub token:

```console
$ git_dependency_prs check -t <token>
```

Generate a token here: https://github.com/settings/personal-access-tokens/new