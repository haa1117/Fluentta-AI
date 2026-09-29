import 'package:connectivity_plus/connectivity_plus.dart';

/// Shared online/offline check. [ConnectivityResult.none] means no usable
/// interface; Wi‑Fi / mobile / ethernet all count as online.
class NetworkStatus {
  NetworkStatus._();

  /// Updated by [ConnectivityViewModel]. AdMob and other sync code can read
  /// this without an extra plugin round-trip.
  static bool lastKnownOnline = true;

  static bool hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  static Future<bool> isOnline([Connectivity? connectivity]) async {
    final result = await (connectivity ?? Connectivity()).checkConnectivity();
    return hasConnection(result);
  }
}
