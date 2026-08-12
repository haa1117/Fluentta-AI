// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Fluenta';

  @override
  String get aiEnglishTutor => 'Tutor de inglés con IA';

  @override
  String get speakWithAiTutor => 'Habla inglés con tu tutor de IA.';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Omitir';

  @override
  String get continueBtn => 'Continuar';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get open => 'Abrir';

  @override
  String get start => 'Iniciar';

  @override
  String get previous => 'Anterior';

  @override
  String get finishLesson => 'Terminar lección';

  @override
  String get startNextLesson => 'Iniciar siguiente lección';

  @override
  String lessonProgress(int number) {
    return 'PROGRESO DE LA LECCIÓN $number';
  }

  @override
  String lessonTitle(int number) {
    return 'Lección $number';
  }

  @override
  String get lessonPhase => 'FASE DE LA LECCIÓN';

  @override
  String get completed => 'Completado';

  @override
  String get inProgress => 'En progreso';

  @override
  String get locked => 'Bloqueado';

  @override
  String get notStarted => 'No iniciado';

  @override
  String wordsProgress(int done, int total, String status) {
    return '$done/$total palabras • $status';
  }

  @override
  String lessonsCompleted(int done, int total) {
    return '$done / $total lecciones completadas';
  }

  @override
  String get completedLessonsReview =>
      'Las lecciones completadas permanecen abiertas para repasar.';

  @override
  String get lessonContentSoon => 'Contenido de la lección próximamente';

  @override
  String openingCategory(String title) {
    return 'Abriendo $title...';
  }

  @override
  String get onboardingTitle1 => 'Conoce a tu tutor de inglés con IA';

  @override
  String get onboardingDesc1 =>
      'Practica inglés chateando o hablando \n con tu tutor personal de IA';

  @override
  String get onboardingTitle2 => 'Obtén correcciones instantáneas';

  @override
  String get onboardingDesc2 =>
      'Corrige gramática, vocabulario y oraciones mientras practicas';

  @override
  String get onboardingTitle3 => 'Mejora cada día';

  @override
  String get onboardingDesc3 =>
      'Mejora tu inglés con práctica diaria y seguimiento simple';

  @override
  String get chooseYourLanguage => 'Elige tu idioma';

  @override
  String get personalizeExperience =>
      'Personalizamos tu experiencia de aprendizaje';

  @override
  String get suggestedForYou => 'Sugerido para ti';

  @override
  String get otherLanguages => 'Otros idiomas';

  @override
  String get recommendedRegion => 'Recomendado según tu región';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Francés';

  @override
  String get signInWithEmail => 'Iniciar sesión con email';

  @override
  String get signInSubtitle => 'Continúa tu viaje de aprendizaje de inglés.';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get createAccountSubtitle =>
      'Guarda tu progreso en todos los dispositivos';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get enterYourName => 'Ingresa tu nombre';

  @override
  String get minEightChars => 'Mín. 8 caracteres';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get rememberPassword => '¿Recuerdas tu contraseña? ';

  @override
  String get forgotPasswordTitle => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa el email vinculado a tu cuenta.\n Te enviaremos un código de verificación.';

  @override
  String get sendVerificationCode => 'Enviar código de verificación';

  @override
  String get verificationEmailSent =>
      'Email de verificación enviado con éxito.';

  @override
  String get checkYourEmail => 'Revisa tu email';

  @override
  String otpSentTo(String email) {
    return 'Enviamos un código de 4 dígitos a $email';
  }

  @override
  String get verifyCode => 'Verificar código';

  @override
  String get verificationCodeResent => 'Código de verificación reenviado.';

  @override
  String get didntReceiveCode => '¿No recibiste el código? ';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get passwordUpdated => '¡Contraseña actualizada!';

  @override
  String get passwordUpdatedDesc =>
      'Tu contraseña se actualizó correctamente.\nAhora puedes iniciar sesión con tu nueva contraseña';

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String get accountCreatedTitle => '¡Cuenta creada!';

  @override
  String get accountCreatedDesc =>
      'Tu cuenta se creó correctamente.\nConfiguremos tus preferencias de aprendizaje.';

  @override
  String get orContinueWith => 'O continuar con';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta? ';

  @override
  String get setupGoalTitle => '¿Cuál es tu objetivo en inglés?';

  @override
  String get setupGoalSubtitle => 'Tu tutor creará práctica según tu objetivo.';

  @override
  String get setupLevelTitle => 'Elige tu punto de partida';

  @override
  String get setupLevelSubtitle =>
      'Personalizaremos las lecciones según tu nivel.';

  @override
  String get setupDailyTitle => 'Establece tu meta diaria';

  @override
  String get setupDailySubtitle =>
      'La práctica diaria construye fluidez real en inglés.';

  @override
  String get goalTravel => 'Viajes';

  @override
  String get goalTravelSub => 'Conversación local fácil';

  @override
  String get goalWork => 'Trabajo';

  @override
  String get goalWorkSub => 'Domina el inglés laboral';

  @override
  String get goalExam => 'Examen';

  @override
  String get goalExamSub => 'IELTS, TOEFL y entrevistas';

  @override
  String get goalEveryday => 'Inglés cotidiano';

  @override
  String get goalEverydaySub => 'Practica conversación natural';

  @override
  String get levelBeginner => 'Principiante';

  @override
  String get levelBeginnerSub => 'A1 · Nuevo en lo básico';

  @override
  String get levelElementary => 'Elemental';

  @override
  String get levelElementarySub => 'A2 · Puede usar palabras simples';

  @override
  String get levelIntermediate => 'Intermedio';

  @override
  String get levelIntermediateSub =>
      'B1 · Puede mantener conversaciones simples';

  @override
  String get levelAdvanced => 'Avanzado';

  @override
  String get levelAdvancedSub => 'B2+ · Cómodo en la mayoría de situaciones';

  @override
  String get daily5 => '5 minutos';

  @override
  String get daily5Sub => 'Perfecto para días ocupados';

  @override
  String get daily10 => '10 minutos';

  @override
  String get daily10Sub => 'Mejor para progreso constante';

  @override
  String get daily15 => '15 minutos';

  @override
  String get daily15Sub => 'Aprende más con práctica enfocada';

  @override
  String get daily20 => '20 minutos';

  @override
  String get daily20Sub => 'Para mejorar más rápido';

  @override
  String get navHome => 'Inicio';

  @override
  String get navLearn => 'Aprender';

  @override
  String get navSpeak => 'Hablar';

  @override
  String get navProfile => 'Perfil';

  @override
  String get readyToPractice => '¿Listo para practicar?';

  @override
  String get journeyContinues => 'Tu viaje de inglés continúa aquí.';

  @override
  String get learnAndGrow => 'Aprende y crece';

  @override
  String get vocabulary => 'Vocabulario';

  @override
  String get vocabularySub => '5 palabras para repasar';

  @override
  String get grammar => 'Gramática';

  @override
  String get grammarSub => 'Práctica rápida';

  @override
  String get reading => 'Lectura';

  @override
  String get readingSub => 'Texto corto';

  @override
  String get savedWords => 'Palabras guardadas';

  @override
  String get savedWordsSub => '12 palabras para repasar';

  @override
  String get yourLevel => 'Tu nivel';

  @override
  String get beginnerLevel => 'Principiante';

  @override
  String get speakTitle => 'Hablar';

  @override
  String get speakSubtitle => 'Practica hablar con tu tutor de IA';

  @override
  String get speakComingSoon => 'Práctica oral próximamente';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileSettings => 'Ajustes';

  @override
  String get profileSettingsSub => 'Preferencias de la app';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get user => 'Usuario';

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String vocabularyPathTitle(String level) {
    return 'Ruta de vocabulario $level';
  }

  @override
  String get vocabularyPathSub =>
      'Aprende 50 palabras básicas útiles\npaso a paso.';

  @override
  String grammarPathTitle(String level) {
    return 'Ruta de gramática $level';
  }

  @override
  String get grammarPathSub =>
      'Aprende reglas gramaticales simples\npaso a paso.';

  @override
  String readingPathTitle(String level) {
    return 'Ruta de lectura $level';
  }

  @override
  String get readingPathSub => 'Lee textos cortos en inglés\npaso a paso.';

  @override
  String get previousWord => 'Palabra anterior';

  @override
  String get nextWord => 'Siguiente palabra';

  @override
  String get listen => 'Escuchar';

  @override
  String get save => 'Guardar';

  @override
  String get meaning => 'SIGNIFICADO';

  @override
  String get example => 'EJEMPLO';

  @override
  String wordIndex(int index) {
    return 'Palabra .$index';
  }

  @override
  String wordsLearned(int count) {
    return '$count palabras aprendidas';
  }

  @override
  String lessonCompletedSuccess(int number) {
    return 'Completaste la lección $number \n con éxito';
  }

  @override
  String grammarLessonCompleted(int number) {
    return 'Completaste la lección de gramática $number con éxito';
  }

  @override
  String readingLessonCompleted(int number) {
    return 'Completaste la lección de lectura $number con éxito';
  }

  @override
  String get learnedUseOf => 'Has aprendido el uso de';

  @override
  String get youHaveLearned => 'Has aprendido';

  @override
  String get quickTip => 'Consejo rápido';

  @override
  String get fluentaTip => 'Consejo Fluenta';

  @override
  String playingWord(String word) {
    return 'Reproduciendo \"$word\"...';
  }

  @override
  String get wordSaved => '¡Palabra guardada!';

  @override
  String get wordRemoved => 'Eliminada de palabras guardadas';

  @override
  String get aiTutor => 'Tutor IA';

  @override
  String get howToPracticeToday => '¿Cómo quieres\npracticar hoy?';

  @override
  String get openChatPractice => 'Abrir práctica de chat';

  @override
  String get openChatPracticeSub =>
      'Conversación libre con feedback instantáneo';

  @override
  String get startAiChat => 'Iniciar chat IA';

  @override
  String get roleplayScenarios => 'Escenarios de roleplay';

  @override
  String get openingChatPractice => 'Abriendo práctica de chat...';

  @override
  String selectedScenario(String title) {
    return 'Seleccionado: $title';
  }

  @override
  String get lesson1DailyWords => 'Palabras diarias';

  @override
  String get lesson2WorkplaceWords => 'Palabras del trabajo';

  @override
  String get lesson3TravelWords => 'Palabras de viaje';

  @override
  String get lesson1DailyRoutine => 'Rutina diaria';

  @override
  String get lesson2OfficeDialogue => 'Diálogo de oficina';

  @override
  String get lesson3TravelStory => 'Historia de viaje';

  @override
  String get lessonRestaurantTalk => 'Conversación en restaurante';

  @override
  String get lessonFamilyStory => 'Historia familiar';

  @override
  String get lessonShoppingStory => 'Historia de compras';

  @override
  String get lessonDoctorVisit => 'Visita al médico';

  @override
  String get lessonWorkEmail => 'Email de trabajo';

  @override
  String get lessonWeekendPlan => 'Plan de fin de semana';

  @override
  String get lessonDirections => 'Direcciones';

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
  String get presentSimpleLearned => 'Present Simple aprendido';

  @override
  String get officeDialogueLearned => 'Diálogo de oficina aprendido';

  @override
  String get generalOfficeConversation => 'Conversación general de oficina';

  @override
  String get presentSimpleSummary => 'He, she, it, I, you, we';

  @override
  String get grammarStepIYouWe => 'I You We';

  @override
  String get grammarStepIYouWeDesc => 'Usa el verbo base con I, you y we.';

  @override
  String get grammarStepIYouWeFormula => 'I / You / We + verbo';

  @override
  String get grammarStepHeSheIt => 'He, She, It';

  @override
  String get grammarStepHeSheItDesc =>
      'Con he, she e it, añade \'s\' al verbo.';

  @override
  String get grammarStepHeSheItFormula => 'He / She / It + verbo + s';

  @override
  String get grammarTipNoS => 'No uses \'s\' con i, you, we o they.';

  @override
  String get grammarTipNeedS => 'He, she e it normalmente necesitan \'s\'.';

  @override
  String readingDialoguePart(int part) {
    return 'Diálogo parte $part';
  }

  @override
  String get readingManager => 'Manager';

  @override
  String get readingYou => 'Tú';

  @override
  String get readingManagerLine => '\"Can you join the meeting at 10?\"';

  @override
  String get readingYouLine => '\"Yes, I can join the meeting.\"';

  @override
  String get readingFluentaTipText =>
      '¡Intenta decir en voz alta la respuesta \'You\' para practicar pronunciación de oficina!';

  @override
  String get levelA1 => 'A1';

  @override
  String get levelA2 => 'A2';

  @override
  String get levelB1 => 'B1';

  @override
  String get levelB2 => 'B2+';
}
