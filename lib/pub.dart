import 'package:pub_api_client/pub_api_client.dart';

/// Access to pub methods
class PubRepo {
  final _pub = PubClient();

  /// Fetch the latest release for a package
  Future<PackageVersion> fetchLatestRelease(String package) async {
    final info = await _pub.packageInfo(package);
    return info.latest;
  }
}
