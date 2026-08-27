import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

class UpdateNameViewModel extends ChangeNotifier {
  UpdateNameViewModel(this._authRepository, String? fullName) {
    final parts = _splitName(fullName);
    firstNameController.text = parts.$1;
    lastNameController.text = parts.$2;
    firstNameController.addListener(notifyListeners);
    lastNameController.addListener(notifyListeners);
  }

  final AuthRepository _authRepository;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isFormValid => firstNameController.text.trim().isNotEmpty;

  (String, String) _splitName(String? fullName) {
    final trimmed = (fullName ?? '').trim();
    if (trimmed.isEmpty) return ('', '');
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return (parts.first, '');
    return (parts.first, parts.sublist(1).join(' '));
  }

  String _buildFullName() {
    final first = firstNameController.text.trim();
    final last = lastNameController.text.trim();
    if (last.isEmpty) return first;
    return '$first $last';
  }

  Future<bool> save(VoidCallback onSuccess) async {
    if (_isLoading || !isFormValid) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.updateProfileName(_buildFullName());
      onSuccess();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getErrorMessage(Object error, AppLocalizations l10n) =>
      AuthExceptionHandler.getMessage(error, l10n);

  @override
  void dispose() {
    firstNameController.removeListener(notifyListeners);
    lastNameController.removeListener(notifyListeners);
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
