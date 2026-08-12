// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Fluenta';

  @override
  String get aiEnglishTutor => 'Tuteur d\'anglais IA';

  @override
  String get speakWithAiTutor => 'Parlez anglais avec votre tuteur IA.';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get continueBtn => 'Continuer';

  @override
  String get getStarted => 'Commencer';

  @override
  String get open => 'Ouvrir';

  @override
  String get start => 'Démarrer';

  @override
  String get previous => 'Précédent';

  @override
  String get finishLesson => 'Terminer la leçon';

  @override
  String get startNextLesson => 'Commencer la leçon suivante';

  @override
  String lessonProgress(int number) {
    return 'PROGRESSION LEÇON $number';
  }

  @override
  String lessonTitle(int number) {
    return 'Leçon $number';
  }

  @override
  String get lessonPhase => 'PHASE DE LA LEÇON';

  @override
  String get completed => 'Terminé';

  @override
  String get inProgress => 'En cours';

  @override
  String get locked => 'Verrouillé';

  @override
  String get notStarted => 'Non commencé';

  @override
  String wordsProgress(int done, int total, String status) {
    return '$done/$total mots • $status';
  }

  @override
  String lessonsCompleted(int done, int total) {
    return '$done / $total leçons terminées';
  }

  @override
  String get completedLessonsReview =>
      'Les leçons terminées restent ouvertes pour révision.';

  @override
  String get lessonContentSoon => 'Contenu de la leçon bientôt disponible';

  @override
  String openingCategory(String title) {
    return 'Ouverture de $title...';
  }

  @override
  String get onboardingTitle1 => 'Rencontrez votre tuteur d\'anglais IA';

  @override
  String get onboardingDesc1 =>
      'Pratiquez l\'anglais en discutant ou en parlant \n avec votre tuteur IA personnel';

  @override
  String get onboardingTitle2 => 'Obtenez des corrections instantanées';

  @override
  String get onboardingDesc2 =>
      'Corrigez grammaire, vocabulaire et phrases pendant la pratique';

  @override
  String get onboardingTitle3 => 'Progressez chaque jour';

  @override
  String get onboardingDesc3 =>
      'Améliorez votre anglais avec une pratique quotidienne';

  @override
  String get chooseYourLanguage => 'Choisissez votre langue';

  @override
  String get personalizeExperience =>
      'Nous personnalisons votre expérience d\'apprentissage';

  @override
  String get suggestedForYou => 'Suggéré pour vous';

  @override
  String get otherLanguages => 'Autres langues';

  @override
  String get recommendedRegion => 'Recommandé selon votre région';

  @override
  String get languageUrdu => 'Ourdou';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get languageFrench => 'Français';

  @override
  String get signInWithEmail => 'Se connecter avec email';

  @override
  String get signInSubtitle =>
      'Continuez votre parcours d\'apprentissage de l\'anglais.';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createAccountSubtitle =>
      'Sauvegardez votre progression sur tous les appareils';

  @override
  String get emailAddress => 'Adresse email';

  @override
  String get password => 'Mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get enterYourName => 'Entrez votre nom';

  @override
  String get minEightChars => 'Min. 8 caractères';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get signIn => 'Se connecter';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get rememberPassword => 'Vous vous souvenez du mot de passe ? ';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordSubtitle =>
      'Entrez l\'email lié à votre compte.\n Nous vous enverrons un code de vérification.';

  @override
  String get sendVerificationCode => 'Envoyer le code de vérification';

  @override
  String get verificationEmailSent =>
      'Email de vérification envoyé avec succès.';

  @override
  String get checkYourEmail => 'Vérifiez votre email';

  @override
  String otpSentTo(String email) {
    return 'Nous avons envoyé un code à 4 chiffres à $email';
  }

  @override
  String get verifyCode => 'Vérifier le code';

  @override
  String get verificationCodeResent => 'Code de vérification renvoyé.';

  @override
  String get didntReceiveCode => 'Vous n\'avez pas reçu le code ? ';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour !';

  @override
  String get passwordUpdatedDesc =>
      'Votre mot de passe a été mis à jour.\nVous pouvez maintenant vous connecter';

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get accountCreatedTitle => 'Compte créé !';

  @override
  String get accountCreatedDesc =>
      'Votre compte a été créé avec succès.\nConfigurons vos préférences d\'apprentissage.';

  @override
  String get orContinueWith => 'Ou continuer avec';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get setupGoalTitle => 'Quel est votre objectif en anglais ?';

  @override
  String get setupGoalSubtitle =>
      'Votre tuteur créera des exercices selon votre objectif.';

  @override
  String get setupLevelTitle => 'Choisissez votre point de départ';

  @override
  String get setupLevelSubtitle =>
      'Nous personnaliserons les leçons selon votre niveau.';

  @override
  String get setupDailyTitle => 'Définissez votre objectif quotidien';

  @override
  String get setupDailySubtitle =>
      'Une petite pratique quotidienne développe la fluidité.';

  @override
  String get goalTravel => 'Voyage';

  @override
  String get goalTravelSub => 'Conversation locale facile';

  @override
  String get goalWork => 'Travail';

  @override
  String get goalWorkSub => 'Maîtriser l\'anglais professionnel';

  @override
  String get goalExam => 'Examen';

  @override
  String get goalExamSub => 'IELTS, TOEFL et entretiens';

  @override
  String get goalEveryday => 'Anglais quotidien';

  @override
  String get goalEverydaySub => 'Pratiquer la conversation naturelle';

  @override
  String get levelBeginner => 'Débutant';

  @override
  String get levelBeginnerSub => 'A1 · Nouveau aux bases';

  @override
  String get levelElementary => 'Élémentaire';

  @override
  String get levelElementarySub => 'A2 · Peut utiliser des mots simples';

  @override
  String get levelIntermediate => 'Intermédiaire';

  @override
  String get levelIntermediateSub => 'B1 · Peut tenir une conversation simple';

  @override
  String get levelAdvanced => 'Avancé';

  @override
  String get levelAdvancedSub =>
      'B2+ · À l\'aise dans la plupart des situations';

  @override
  String get daily5 => '5 minutes';

  @override
  String get daily5Sub => 'Parfait pour les journées chargées';

  @override
  String get daily10 => '10 minutes';

  @override
  String get daily10Sub => 'Idéal pour un progrès constant';

  @override
  String get daily15 => '15 minutes';

  @override
  String get daily15Sub => 'Apprenez plus avec une pratique ciblée';

  @override
  String get daily20 => '20 minutes';

  @override
  String get daily20Sub => 'Pour progresser plus vite';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLearn => 'Apprendre';

  @override
  String get navSpeak => 'Parler';

  @override
  String get navProfile => 'Profil';

  @override
  String get readyToPractice => 'Prêt à pratiquer ?';

  @override
  String get journeyContinues => 'Votre parcours d\'anglais continue ici.';

  @override
  String get learnAndGrow => 'Apprendre et progresser';

  @override
  String get vocabulary => 'Vocabulaire';

  @override
  String get vocabularySub => '5 mots à réviser';

  @override
  String get grammar => 'Grammaire';

  @override
  String get grammarSub => 'Pratique rapide';

  @override
  String get reading => 'Lecture';

  @override
  String get readingSub => 'Passage court';

  @override
  String get savedWords => 'Mots sauvegardés';

  @override
  String get savedWordsSub => '12 mots à réviser';

  @override
  String get yourLevel => 'Votre niveau';

  @override
  String get beginnerLevel => 'Débutant';

  @override
  String get speakTitle => 'Parler';

  @override
  String get speakSubtitle => 'Pratiquez avec votre tuteur IA';

  @override
  String get speakComingSoon => 'Pratique orale bientôt disponible';

  @override
  String get profileLanguage => 'Langue';

  @override
  String get profileSettings => 'Paramètres';

  @override
  String get profileSettingsSub => 'Préférences de l\'app';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get user => 'Utilisateur';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String vocabularyPathTitle(String level) {
    return 'Parcours vocabulaire $level';
  }

  @override
  String get vocabularyPathSub =>
      'Apprenez 50 mots débutants utiles\nétape par étape.';

  @override
  String grammarPathTitle(String level) {
    return 'Parcours grammaire $level';
  }

  @override
  String get grammarPathSub => 'Apprenez des règles simples\nétape par étape.';

  @override
  String readingPathTitle(String level) {
    return 'Parcours lecture $level';
  }

  @override
  String get readingPathSub =>
      'Lisez de courts passages en anglais\nétape par étape.';

  @override
  String get previousWord => 'Mot précédent';

  @override
  String get nextWord => 'Mot suivant';

  @override
  String get listen => 'Écouter';

  @override
  String get save => 'Sauvegarder';

  @override
  String get meaning => 'SIGNIFICATION';

  @override
  String get example => 'EXEMPLE';

  @override
  String wordIndex(int index) {
    return 'Mot .$index';
  }

  @override
  String wordsLearned(int count) {
    return '$count mots appris';
  }

  @override
  String lessonCompletedSuccess(int number) {
    return 'Vous avez terminé la leçon $number \n avec succès';
  }

  @override
  String grammarLessonCompleted(int number) {
    return 'Vous avez terminé la leçon de grammaire $number avec succès';
  }

  @override
  String readingLessonCompleted(int number) {
    return 'Vous avez terminé la leçon de lecture $number avec succès';
  }

  @override
  String get learnedUseOf => 'Vous avez appris l\'utilisation de';

  @override
  String get youHaveLearned => 'Vous avez appris';

  @override
  String get quickTip => 'Conseil rapide';

  @override
  String get fluentaTip => 'Conseil Fluenta';

  @override
  String playingWord(String word) {
    return 'Lecture de \"$word\"...';
  }

  @override
  String get wordSaved => 'Mot sauvegardé !';

  @override
  String get wordRemoved => 'Retiré des mots sauvegardés';

  @override
  String get aiTutor => 'Tuteur IA';

  @override
  String get howToPracticeToday =>
      'Comment voulez-vous\npratiquer aujourd\'hui ?';

  @override
  String get openChatPractice => 'Ouvrir la pratique chat';

  @override
  String get openChatPracticeSub => 'Conversation libre avec retour instantané';

  @override
  String get startAiChat => 'Démarrer le chat IA';

  @override
  String get roleplayScenarios => 'Scénarios de jeu de rôle';

  @override
  String get openingChatPractice => 'Ouverture de la pratique chat...';

  @override
  String selectedScenario(String title) {
    return 'Sélectionné : $title';
  }

  @override
  String get lesson1DailyWords => 'Mots du quotidien';

  @override
  String get lesson2WorkplaceWords => 'Mots du travail';

  @override
  String get lesson3TravelWords => 'Mots de voyage';

  @override
  String get lesson1DailyRoutine => 'Routine quotidienne';

  @override
  String get lesson2OfficeDialogue => 'Dialogue de bureau';

  @override
  String get lesson3TravelStory => 'Histoire de voyage';

  @override
  String get lessonRestaurantTalk => 'Conversation au restaurant';

  @override
  String get lessonFamilyStory => 'Histoire de famille';

  @override
  String get lessonShoppingStory => 'Histoire de shopping';

  @override
  String get lessonDoctorVisit => 'Visite chez le médecin';

  @override
  String get lessonWorkEmail => 'Email professionnel';

  @override
  String get lessonWeekendPlan => 'Plan du week-end';

  @override
  String get lessonDirections => 'Directions';

  @override
  String get lesson1IAmYouAre => 'I am / you are';

  @override
  String get lesson2PresentSimple => 'Present Simple';

  @override
  String get lessonArticles => 'A / an / The';

  @override
  String get lessonThisThat => 'This / That';

  @override
  String get lessonHeSheThey => 'He / She / They';

  @override
  String get lessonThereIsAre => 'There is / There are';

  @override
  String get lessonCanCannot => 'Can / Cannot';

  @override
  String get lessonHaveHas => 'Have / Has';

  @override
  String get lessonWasWere => 'Was / Were';

  @override
  String get lessonWillGoingTo => 'Will / Going to';

  @override
  String get presentSimpleLearned => 'Present Simple appris';

  @override
  String get officeDialogueLearned => 'Dialogue de bureau appris';

  @override
  String get generalOfficeConversation => 'Conversation de bureau générale';

  @override
  String get presentSimpleSummary => 'He, she, it, I, you, we';

  @override
  String get grammarStepIYouWe => 'I You We';

  @override
  String get grammarStepIYouWeDesc =>
      'Utilisez le verbe de base avec I, you et we.';

  @override
  String get grammarStepIYouWeFormula => 'I / You / We + verbe';

  @override
  String get grammarStepHeSheIt => 'He, She, It';

  @override
  String get grammarStepHeSheItDesc =>
      'Avec he, she et it, ajoutez \'s\' au verbe.';

  @override
  String get grammarStepHeSheItFormula => 'He / She / It + verbe + s';

  @override
  String get grammarTipNoS => 'N\'utilisez pas \'s\' avec i, you, we ou they.';

  @override
  String get grammarTipNeedS =>
      'He, she et it ont généralement besoin de \'s\'.';

  @override
  String readingDialoguePart(int part) {
    return 'Dialogue partie $part';
  }

  @override
  String get readingManager => 'Manager';

  @override
  String get readingYou => 'Vous';

  @override
  String get readingManagerLine => '\"Can you join the meeting at 10?\"';

  @override
  String get readingYouLine => '\"Yes, I can join the meeting.\"';

  @override
  String get readingFluentaTipText =>
      'Essayez de dire la réponse \'You\' à voix haute pour pratiquer la prononciation !';

  @override
  String get levelA1 => 'A1';

  @override
  String get levelA2 => 'A2';

  @override
  String get levelB1 => 'B1';

  @override
  String get levelB2 => 'B2+';
}
