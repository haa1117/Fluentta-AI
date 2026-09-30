import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

class RateAppService {
  RateAppService._();

  static final RateAppService instance = RateAppService._();

  final InAppReview _review = InAppReview.instance;

  Future<void> requestReview() async {
    try {
      if (await _review.isAvailable()) {
        await _review.requestReview();
        return;
      }
      await _review.openStoreListing();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('RateAppService.requestReview failed: $error');
      }
    }
  }
}
