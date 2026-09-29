import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/network/network_status.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';

/// App-wide connectivity. Drives the offline gate, ad hiding, and chat lock.
class ConnectivityViewModel extends ChangeNotifier {
  ConnectivityViewModel({
    Connectivity? connectivity,
    ProgressSyncService? progressSyncService,
  })  : _connectivity = connectivity ?? Connectivity(),
        _progressSyncService = progressSyncService {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChange);
    unawaited(_refresh());
  }

  final Connectivity _connectivity;
  final ProgressSyncService? _progressSyncService;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isOnline = true;
  bool _continueOffline = false;

  bool get isOnline => _isOnline;

  /// Full-screen Figma card: offline and the learner has not chosen to continue.
  bool get showOfflinePrompt => !_isOnline && !_continueOffline;

  void continueOffline() {
    if (_continueOffline) return;
    _continueOffline = true;
    notifyListeners();
  }

  Future<bool> retryConnection() async {
    final online = await _refresh();
    return online;
  }

  Future<void> _onChange(List<ConnectivityResult> results) async {
    await _apply(NetworkStatus.hasConnection(results));
  }

  Future<bool> _refresh() async {
    final online = await NetworkStatus.isOnline(_connectivity);
    await _apply(online);
    return online;
  }

  Future<void> _apply(bool online) async {
    final wasOnline = _isOnline;
    NetworkStatus.lastKnownOnline = online;
    if (_isOnline == online) {
      if (!online && !_continueOffline) notifyListeners();
      return;
    }

    _isOnline = online;
    if (online) {
      _continueOffline = false;
      AdMobService.instance.refreshAfterEntitlementsChange();
      unawaited(_progressSyncService?.syncOnConnectivityRestored());
    } else {
      AdMobService.instance.notifyListeners();
    }

    if (kDebugMode && wasOnline != online) {
      debugPrint('Connectivity: ${online ? 'online' : 'offline'}');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
