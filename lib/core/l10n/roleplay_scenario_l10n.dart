import 'package:fluentta_ai/l10n/app_localizations.dart';

class RoleplayScenarioL10n {
  RoleplayScenarioL10n._();

  static String listTitle(AppLocalizations l10n, String id) {
    return switch (id) {
      'job_interviews' => l10n.scenarioJobInterviews,
      'order_food' => l10n.scenarioOrderFood,
      'at_airport' => l10n.scenarioAtAirport,
      'doctor_visit' => l10n.scenarioDoctorVisit,
      'small_talk' => l10n.scenarioSmallTalk,
      'business_meeting' => l10n.scenarioBusinessMeeting,
      _ => id,
    };
  }

  static String detailTitle(AppLocalizations l10n, String id) {
    return switch (id) {
      'job_interviews' => l10n.scenarioJobInterviewDetail,
      'order_food' => l10n.scenarioOrderFoodDetail,
      'at_airport' => l10n.scenarioAtAirportDetail,
      'doctor_visit' => l10n.scenarioDoctorVisitDetail,
      'small_talk' => l10n.scenarioSmallTalkDetail,
      'business_meeting' => l10n.scenarioBusinessMeetingDetail,
      _ => listTitle(l10n, id),
    };
  }

  static String practiceTitle(AppLocalizations l10n, String id) {
    return l10n.roleplayPracticeTitle(detailTitle(l10n, id));
  }

  static String vocabularySubtitle(AppLocalizations l10n, String id) {
    return switch (id) {
      'job_interviews' => l10n.scenarioJobInterviewVocabSub,
      'order_food' => l10n.scenarioOrderFoodVocabSub,
      'at_airport' => l10n.scenarioAtAirportVocabSub,
      'doctor_visit' => l10n.scenarioDoctorVisitVocabSub,
      'small_talk' => l10n.scenarioSmallTalkVocabSub,
      'business_meeting' => l10n.scenarioBusinessMeetingVocabSub,
      _ => l10n.scenarioJobInterviewVocabSub,
    };
  }
}
