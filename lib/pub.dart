import 'package:pub_api_client/pub_api_client.dart';

/// Access to pub methods
class PubRepo {
  PubRepo._();

  static final _pub = PubClient();

  /// Fetch the latest release for a package
  static Future<PackageVersion?> fetchLatestRelease(String package) async {
    try {
      final info = await _pub.packageInfo(package);
      return info.latest;
    } catch (e) {
      return null;
    }
  }
}
