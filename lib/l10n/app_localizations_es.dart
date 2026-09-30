// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Fluenta AI';

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
  String lessonNamedTitle(int number, String title) {
    return 'Lección $number: $title';
  }

  @override
  String questionsProgress(int done, int total, String status) {
    return '$done/$total preguntas • $status';
  }

  @override
  String get learnUsefulPhrases => 'Aprende frases útiles con corrección de IA';

  @override
  String get sentencePractice => 'Práctica de oraciones';

  @override
  String get practiceConversing => 'Practica conversar';

  @override
  String get practiceConversingSub =>
      'Habla con tu tutor de IA por voz o texto y recibe correcciones al instante';

  @override
  String get talkAboutAnyTopic => 'Habla de cualquier tema con el tutor de IA';

  @override
  String get advancedRoleplay => 'Roleplay avanzado';

  @override
  String get advancedBadge => 'AVANZADO';

  @override
  String get upgradeToUnlockRoleplays =>
      'Pásate a Pro para desbloquear todos los escenarios de roleplay.';

  @override
  String get upgradeToPro => 'PASAR A PRO';

  @override
  String get scenarioNotFound => 'Escenario no encontrado';

  @override
  String roleplayTrackTitle(String scenario, String track) {
    return '$scenario $track';
  }

  @override
  String dayStreakLabel(int days) {
    return 'Racha de $days días';
  }

  @override
  String englishBasicsStep(int index, String label) {
    return '$index / $label';
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
  String get signInLink => 'Iniciar sesión';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get rememberPassword => '¿Recuerdas tu contraseña? ';

  @override
  String get forgotPasswordTitle => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa el email vinculado a tu cuenta.\n Te enviaremos un enlace de restablecimiento.';

  @override
  String get sendVerificationCode => 'Enviar enlace';

  @override
  String get verificationEmailSent =>
      'Enlace de restablecimiento enviado con éxito.';

  @override
  String get checkYourEmail => 'Revisa tu email';

  @override
  String otpSentTo(String email) {
    return 'Enviamos un enlace de restablecimiento a $email';
  }

  @override
  String get checkResetEmailInstructions =>
      'Abre tu email y toca el enlace. La app se abrirá para que puedas crear una nueva contraseña.';

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
  String get newToFluenta => '¿Nuevo en Fluenta? ';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithApple => 'Continuar con Apple';

  @override
  String get orLower => 'o';

  @override
  String get createAccountButton => 'Crear cuenta';

  @override
  String get createNewPasswordTitle => 'Crea una nueva contraseña';

  @override
  String get createNewPasswordSubtitle =>
      'Elige una contraseña segura que no hayas usado antes';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get enterNewPassword => 'Ingresa la nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get repeatPassword => 'Repite tu contraseña';

  @override
  String get updatePassword => 'Actualizar contraseña';

  @override
  String get accountCreatedSafeDesc =>
      'Tu progreso y plan de aprendizaje\nse guardarán de forma segura.';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String resendCodeIn(String time) {
    return 'Reenviar código en $time';
  }

  @override
  String get creatingAccountTitle => 'Creando tu cuenta...';

  @override
  String get creatingAccountSubtitle => 'Por favor espera un momento.';

  @override
  String get authErrorFillAllFields => 'Por favor completa todos los campos.';

  @override
  String get authErrorEnterPassword => 'Por favor ingresa tu contraseña.';

  @override
  String get authErrorPasswordMinEight =>
      'La contraseña debe tener al menos 8 caracteres.';

  @override
  String get authErrorInvalidEmail => 'Por favor ingresa un email válido.';

  @override
  String get authErrorUserDisabled => 'Esta cuenta ha sido deshabilitada.';

  @override
  String get authErrorUserNotFound =>
      'No se encontró una cuenta con este email.';

  @override
  String get authErrorWrongPassword =>
      'Contraseña incorrecta. Inténtalo de nuevo.';

  @override
  String get authErrorEmailInUse => 'Ya existe una cuenta con este email.';

  @override
  String get authErrorWeakPassword =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get authErrorInvalidCredential => 'Email o contraseña inválidos.';

  @override
  String get authErrorTooManyRequests =>
      'Demasiados intentos. Inténtalo más tarde.';

  @override
  String get authErrorNetwork => 'Error de red. Verifica tu conexión.';

  @override
  String get authErrorOperationNotAllowed =>
      'Este método de inicio de sesión no está habilitado.';

  @override
  String get authErrorInvalidVerificationCode =>
      'Código de verificación inválido.';

  @override
  String get authErrorExpiredActionCode =>
      'Este enlace de restablecimiento expiró. Solicita uno nuevo.';

  @override
  String get authErrorInvalidActionCode =>
      'Código de restablecimiento inválido. Solicita uno nuevo.';

  @override
  String get authErrorRequiresRecentLogin =>
      'Inicia sesión de nuevo para actualizar tu contraseña.';

  @override
  String get authErrorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get authErrorPermissionDenied =>
      'No se pudo guardar el perfil. Habilita Firestore en Firebase Console.';

  @override
  String get authErrorUnavailable =>
      'Firestore no está disponible. Verifica tu conexión.';

  @override
  String get authErrorNotFound =>
      'Base de datos Firestore no encontrada. Créala en Firebase Console.';

  @override
  String get authErrorSaveFailed =>
      'No se pudieron guardar los datos. Inténtalo de nuevo.';

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
  String get levelUpperIntermediate => 'Intermedio alto';

  @override
  String get levelUpperIntermediateSub => 'B2 · Puede interactuar con fluidez';

  @override
  String get levelAdvancedC1 => 'Avanzado';

  @override
  String get levelAdvancedC1Sub => 'C1 · Expresa ideas con fluidez';

  @override
  String get levelProficientC2 => 'Competente';

  @override
  String get levelProficientC2Sub => 'C2 · Dominio casi nativo';

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
  String get navSpeak => 'Juego de roles';

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
  String vocabularySubDynamic(int count) {
    return '$count palabras para repasar';
  }

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
  String savedWordsSubDynamic(int count) {
    return '$count palabras guardadas';
  }

  @override
  String get dailyVocabulary => 'Vocabulario Diario';

  @override
  String dailyVocabularySub(int count) {
    return '5 palabras nuevas • $count para repasar';
  }

  @override
  String dailyVocabularyDoneSub(int count) {
    return 'Listo por hoy • $count para repasar';
  }

  @override
  String get freeAndUnlimited => 'Gratis e ilimitado';

  @override
  String get startDailyVocabulary => 'Empezar vocabulario diario';

  @override
  String get todaysWords => 'Palabras de hoy';

  @override
  String todaysWordsDesc(int count) {
    return 'Aprende $count palabras nuevas elegidas para ti hoy.';
  }

  @override
  String get dailyVocabularyComplete => '¡Vocabulario diario completado!';

  @override
  String get learnTodaysWords => 'Aprender palabras de hoy';

  @override
  String get reviewTodaysWordsAgain => 'Practicar palabras de hoy otra vez';

  @override
  String get spacedRepetitionReview => 'Repaso de repetición espaciada';

  @override
  String spacedRepetitionReviewDesc(int count) {
    return 'Tienes $count palabras listas para repasar.';
  }

  @override
  String reviewWords(int count) {
    return 'Repasar palabras ($count)';
  }

  @override
  String get reviewSession => 'Sesión de repaso';

  @override
  String get revealMeaning => 'Mostrar significado';

  @override
  String get howWellDidYouKnow => '¿Qué tan bien conocías esta palabra?';

  @override
  String get srsAgain => 'Otra vez';

  @override
  String get srsGood => 'Bien';

  @override
  String get srsEasy => 'Fácil';

  @override
  String get reviewSessionComplete => '¡Sesión de repaso completada!';

  @override
  String get noSavedWords =>
      'Aún no hay palabras guardadas. Toca el marcador mientras aprendes.';

  @override
  String wordProgress(int current, int total) {
    return 'Palabra $current de $total';
  }

  @override
  String get meaningLabel => 'SIGNIFICADO';

  @override
  String get exampleLabel => 'EJEMPLO';

  @override
  String get yourLevel => 'Tu nivel';

  @override
  String get beginnerLevel => 'Principiante';

  @override
  String get speakTitle => 'Juego de roles';

  @override
  String get rolePlayTitle => 'Juego de roles';

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
  String learnPathEarnXp(int count, int xp) {
    return 'Aprende $count lecciones y gana +$xp XP';
  }

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
  String get listenUnavailable =>
      'La reproducción de audio no está disponible en este dispositivo.';

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
  String readingPassagePart(int part) {
    return 'Lectura parte $part';
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
  String get levelB2 => 'B2';

  @override
  String get levelC1 => 'C1';

  @override
  String get levelC2 => 'C2';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get hi => 'Hola,';

  @override
  String get a1Beginner => 'A1 Principiante';

  @override
  String get learningWithFluenta => 'Aprendiendo inglés con Fluentta';

  @override
  String dayStreak(int days) {
    return 'Día $days';
  }

  @override
  String get progressLabel => 'PROGRESO';

  @override
  String get freePlan => 'Plan gratuito';

  @override
  String heartsDaily(int count) {
    return '$count corazones al día';
  }

  @override
  String get upgradePremiumDesc =>
      'Actualiza para práctica AI ilimitada, corrección de pronunciación, roleplays completos y sin anuncios.';

  @override
  String get upgradeToPremium => 'Actualizar a Premium';

  @override
  String get yourStats => 'TUS ESTADÍSTICAS';

  @override
  String get xpEarned => 'XP ganados';

  @override
  String get xpAbbrev => 'XP';

  @override
  String get proMember => 'Miembro Pro';

  @override
  String get proMemberDesc =>
      'Corazones ilimitados, todos los roleplays, lecciones B2+ e informes semanales.';

  @override
  String heartsToday(int current, int daily) {
    return '$current/$daily corazones hoy';
  }

  @override
  String get weeklyProgressReportTitle => 'Informe de progreso semanal';

  @override
  String get streakLabel => 'Racha';

  @override
  String streakDaysCount(int count) {
    return '$count días';
  }

  @override
  String get wordsStat => 'Palabras';

  @override
  String get lessonsStat => 'Lecciones';

  @override
  String get correctionsStat => 'Correcciones';

  @override
  String get dailyGoal => 'Meta diaria';

  @override
  String get changeGoal => 'Cambiar meta';

  @override
  String minPerDay(int minutes) {
    return '$minutes min al día';
  }

  @override
  String minToday(int done, int total) {
    return '$done / $total min hoy';
  }

  @override
  String get settingsSection => 'AJUSTES';

  @override
  String get learningPreferences => 'Preferencias de aprendizaje';

  @override
  String get learningPreferencesSub => 'Repetir objetivo, nivel y meta diaria';

  @override
  String get savePreferences => 'Guardar preferencias';

  @override
  String get setupSaved => 'Tus preferencias se actualizaron';

  @override
  String get notificationsReminders => 'Notificaciones y recordatorios';

  @override
  String dailyReminderAt(String time) {
    return 'Recordatorio diario a las $time';
  }

  @override
  String get appAppearance => 'Apariencia de la app';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get supportLegal => 'SOPORTE Y LEGAL';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get contactSupport => 'Contactar soporte';

  @override
  String get rateApp => 'Valorar app';

  @override
  String get accountActions => 'ACCIONES DE CUENTA';

  @override
  String get accountSection => 'CUENTA';

  @override
  String get accountAndSecurity => 'Cuenta y seguridad';

  @override
  String get accountAndSecuritySub => 'Nombre, correo y contraseña';

  @override
  String get manageAccount => 'Administrar cuenta';

  @override
  String get manageAccountDesc =>
      'Administra la información asociada a tu perfil de Fluenta.';

  @override
  String get personalDetails => 'DATOS PERSONALES';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get emailLabel => 'Correo';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordMasked => '••••••••';

  @override
  String get yourNameTitle => 'Tu nombre';

  @override
  String get manageYourName => 'Administra tu nombre';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get nameUpdated => 'Nombre actualizado correctamente';

  @override
  String get emailScreenTitle => 'Correo';

  @override
  String get manageYourEmailAddress => 'Administra tu correo electrónico';

  @override
  String get emailCannotBeChanged =>
      'Tu correo electrónico no se puede cambiar.';

  @override
  String get currentEmailAddress => 'Correo electrónico actual';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get changePasswordSubtitle =>
      'Introduce tu contraseña actual y elige una nueva';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get enterCurrentPassword => 'Introduce la contraseña actual';

  @override
  String get passwordUpdatedSuccess => 'Contraseña actualizada correctamente';

  @override
  String get passwordChangeUnavailable =>
      'El cambio de contraseña no está disponible para cuentas de inicio social.';

  @override
  String get authErrorNameRequired => 'Introduce tu nombre.';

  @override
  String get signOutTitle => 'Cerrar sesión';

  @override
  String get signOutSub => 'Salir de tu cuenta';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountSub => 'Eliminar cuenta permanentemente';

  @override
  String get allowNotifications => 'Permitir notificaciones';

  @override
  String get allowNotificationsSub =>
      'Recibe recordatorios y actualizaciones de aprendizaje';

  @override
  String get practiceReminders => 'RECORDATORIOS DE PRÁCTICA';

  @override
  String get dailyReminder => 'Recordatorio diario';

  @override
  String get reminderTime => 'Hora del recordatorio';

  @override
  String get reminderTimeTitle => 'Hora del recordatorio';

  @override
  String get chooseReminderTime => 'Elige cuándo quieres practicar cada día.';

  @override
  String get saveReminder => 'Guardar recordatorio';

  @override
  String get cancelBtn => 'Cancelar';

  @override
  String get signOutQuestion => '¿Cerrar sesión?';

  @override
  String get signOutDialogMessage =>
      'Tu progreso guardado estará seguro. Necesitarás iniciar sesión de nuevo para sincronizar y restaurar el acceso premium';

  @override
  String get exitAppQuestion => '¿Salir de Fluenta?';

  @override
  String get exitAppMessage =>
      'Tu progreso está guardado. Vuelve cuando quieras para seguir aprendiendo.';

  @override
  String get keepLearning => 'Seguir aprendiendo';

  @override
  String get exitApp => 'Salir de la app';

  @override
  String get deleteAccountQuestion => '¿Eliminar cuenta?';

  @override
  String get deleteAccountDialogMessage =>
      'Esto eliminará permanentemente tu cuenta, progreso, palabras guardadas e historial de aprendizaje.';

  @override
  String get deleteAccountConfirmation => 'Confirmación de eliminación';

  @override
  String get warning => 'Advertencia';

  @override
  String get deleteWarningMessage =>
      'Esta acción eliminará permanentemente todo tu progreso, estadísticas y datos personales. No se puede deshacer.';

  @override
  String get understandPermanent => 'Entiendo que esta acción es permanente.';

  @override
  String get deleteAccountBtn => 'Eliminar cuenta';

  @override
  String get deleteMarketingNote =>
      'Eliminar tu cuenta también te dará de baja de todas las comunicaciones de marketing.';

  @override
  String get accountDeleted => 'Cuenta eliminada';

  @override
  String get accountDeletedMessage =>
      'Tu cuenta y datos de aprendizaje han sido eliminados.';

  @override
  String get sorryToSeeYouGo => 'Lamentamos verte partir';

  @override
  String get done => 'Listo';

  @override
  String get createAccountAnytime =>
      'Puedes crear tu cuenta en cualquier momento.';

  @override
  String englishExplanationsIn(String language) {
    return 'Explicaciones en inglés en $language';
  }

  @override
  String get lessonsQuickLink => 'Lecciones';

  @override
  String get correctionsQuickLink => 'Correcciones';

  @override
  String get openingSoon => 'Próximamente';

  @override
  String get upgradeComingSoon => 'Actualización premium próximamente';

  @override
  String get restoringPurchases => 'Restaurando compras...';

  @override
  String get speakWithAiTutorTitle => 'Habla con el Tutor IA';

  @override
  String get aiSpeakingTutor => 'Tutor de Conversación IA';

  @override
  String get aiPronunciationTutor => 'Tutor de Pronunciación IA';

  @override
  String get aiSpeakingTutorDesc =>
      'Habla por voz o texto y recibe correcciones al instante';

  @override
  String get startPractice => 'Comenzar práctica';

  @override
  String get tagVoice => 'Voz';

  @override
  String get tagText => 'Texto';

  @override
  String get tagCorrections => 'Correcciones';

  @override
  String get pronunciationPractice => 'Práctica de Pronunciación';

  @override
  String get pronunciationPracticeSub => 'Graba tu voz y recibe feedback';

  @override
  String get advertisement => 'PUBLICIDAD';

  @override
  String get bannerAdPlaceholder => 'Marcador de anuncio';

  @override
  String get openAiChatPractice => 'Abrir Chat de Práctica IA';

  @override
  String get pronunciation => 'Pronunciación';

  @override
  String get pronunciationPracticeDesc =>
      'Lee una frase, graba tu voz y recibe feedback.';

  @override
  String phraseOf(int current, int total) {
    return 'Frase $current de $total';
  }

  @override
  String get speakClearly => 'Habla claro y con naturalidad.';

  @override
  String get startRecording => 'Iniciar Grabación';

  @override
  String get heartPerPronunciation => '❤️ 1 corazón por pronunciación';

  @override
  String get recording => 'GRABANDO...';

  @override
  String get stopRecording => 'Detener Grabación';

  @override
  String get checkingPronunciation => 'Comprobando tu pronunciación...';

  @override
  String get checkingPronunciationSub =>
      'Escuchamos claridad, ritmo y precisión para darte feedback personalizado.';

  @override
  String get onlyTakesMoment => 'Esto solo toma un momento.';

  @override
  String get greatEffort => '¡Buen esfuerzo!';

  @override
  String pronunciationScoreMessage(int score) {
    return 'Tu pronunciación es más clara que el $score% de estudiantes de tu nivel. ¡Sigue así!';
  }

  @override
  String get wordFeedback => 'FEEDBACK DE PALABRAS';

  @override
  String confidencePercent(int percent) {
    return '$percent% Confianza';
  }

  @override
  String heardAs(String word) {
    return 'Escuchado: \"$word\"';
  }

  @override
  String focusOnSounds(String sounds) {
    return 'Enfócate en: $sounds';
  }

  @override
  String youSaid(String transcript) {
    return 'Dijiste: \"$transcript\"';
  }

  @override
  String get noSpeechDetected =>
      'No detectamos voz clara. Habla más fuerte e inténtalo de nuevo.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get nextPhrase => 'Siguiente Frase';

  @override
  String get finish => 'Finalizar';

  @override
  String get practiceComplete => 'Práctica Completa';

  @override
  String practicedPhrases(int count) {
    return 'Practicaste $count frases de pronunciación';
  }

  @override
  String get averageScore => 'PUNTUACIÓN MEDIA';

  @override
  String get phrasesLabel => 'Frases';

  @override
  String get bestWord => 'Mejor palabra';

  @override
  String get practiceMore => 'Practicar Más';

  @override
  String get backToSpeak => 'Volver a Role Play';

  @override
  String get openChatPracticeTitle => 'Abrir Chat de Práctica';

  @override
  String get textMode => 'Modo Texto';

  @override
  String get chatTextMode => 'Modo texto';

  @override
  String get chatVoiceMode => 'Modo voz';

  @override
  String get chatGreeting => '¡Hola! ¿Qué te gustaría practicar hoy?';

  @override
  String chatGreetingNamed(String name) {
    return '¡Hola, $name! ¿Qué te gustaría practicar hoy?';
  }

  @override
  String get chatQuickStarterLesson => 'Enséñame paso a paso';

  @override
  String get chatQuickStarterGrammar => 'Practicar gramática';

  @override
  String get chatQuickStarterDaily => 'Conversación cotidiana';

  @override
  String get chatQuickStarterWork => 'Inglés para el trabajo';

  @override
  String get chatQuickStarterOpenTopic => 'Solo charlar';

  @override
  String get chatQuickStarterTravel => 'Viajes';

  @override
  String get chatCorrectionLabel => 'CORRECCIÓN';

  @override
  String get chatYourSentence => 'Tu frase:';

  @override
  String get chatCorrectSentence => 'Frase correcta:';

  @override
  String get chatTipPrefix => 'Consejo:';

  @override
  String get chatTypeHint => 'Escribe tu texto aquí';

  @override
  String get chatHoldToSpeak => 'Mantén para hablar';

  @override
  String get chatListening => 'Escuchando...';

  @override
  String get chatReleaseToSend =>
      'Habla con libertad y suelta para enviar la voz';

  @override
  String get chatTapToSend => 'Habla con libertad y toca para enviar la voz';

  @override
  String get chatCancel => 'Cancelar';

  @override
  String get chatLock => 'Bloquear';

  @override
  String get chatSpeechUnavailable =>
      'Micrófono no disponible. Revisa los permisos.';

  @override
  String get chatNeedsInternet =>
      'El chat con IA necesita conexión a internet.';

  @override
  String get chatReadRepliesAloud => 'Leer respuestas en voz alta';

  @override
  String get chatPlay => 'Reproducir';

  @override
  String get chatPlaying => 'Reproduciendo';

  @override
  String get chatAiDisclaimer => 'Fluenta es IA y puede cometer errores.';

  @override
  String get outOfHearts => 'Te quedaste sin corazones';

  @override
  String get outOfHeartsSub =>
      'Corrige gramática, palabras y frases mientras practicas';

  @override
  String get getMoreHearts => 'OBTENER MÁS CORAZONES';

  @override
  String get goUnlimited => 'Ir Ilimitado';

  @override
  String get goUnlimitedSub =>
      'Práctica IA ilimitada\nSin anuncios • Corazones ilimitados';

  @override
  String get watchAd => 'Ver Anuncio';

  @override
  String get watchAdSub => 'Obtén +2 corazones al instante';

  @override
  String heartsRefilledMessage(int count) {
    return '+$count corazones añadidos. ¡Sigue practicando!';
  }

  @override
  String get heartRefillCapReached =>
      'Has usado todas tus recargas con anuncios de hoy. Vuelve mañana o pasa a ilimitado.';

  @override
  String get adNotAvailable =>
      'No hay anuncios disponibles ahora. Inténtalo de nuevo en un momento.';

  @override
  String get playingPhrase => 'Reproduciendo frase...';

  @override
  String get pronunciationUnavailable =>
      'El micrófono o el reconocimiento de voz no están disponibles en este dispositivo.';

  @override
  String get microphonePermissionDenied =>
      'Se necesita permiso del micrófono para practicar pronunciación.';

  @override
  String get scenarioJobInterviews => 'Entrevistas de Trabajo';

  @override
  String get scenarioOrderFood => 'Pedir Comida';

  @override
  String get scenarioAtAirport => 'En el Aeropuerto';

  @override
  String get scenarioDoctorVisit => 'Visita al Médico';

  @override
  String get scenarioSmallTalk => 'Conversación Casual';

  @override
  String get scenarioBusinessMeeting => 'Reunión de Negocios';

  @override
  String get learnAndPractice => 'Aprender y Practicar';

  @override
  String get quickCheck => 'Verificación Rápida';

  @override
  String get quickCheckSub => 'Responde preguntas de comprensión';

  @override
  String roleplayPracticeTitle(String title) {
    return 'Práctica de $title';
  }

  @override
  String get scenarioJobInterviewDetail => 'Entrevista de Trabajo';

  @override
  String get scenarioJobInterviewVocabSub =>
      'Aprende palabras clave de entrevistas';

  @override
  String get scenarioOrderFoodDetail => 'Pedir Comida';

  @override
  String get scenarioOrderFoodVocabSub =>
      'Aprende palabras clave de restaurantes';

  @override
  String get scenarioAtAirportDetail => 'En el Aeropuerto';

  @override
  String get scenarioAtAirportVocabSub => 'Aprende palabras clave de viajes';

  @override
  String get scenarioDoctorVisitDetail => 'Visita al Médico';

  @override
  String get scenarioDoctorVisitVocabSub => 'Aprende palabras clave médicas';

  @override
  String get scenarioSmallTalkDetail => 'Conversación Casual';

  @override
  String get scenarioSmallTalkVocabSub =>
      'Aprende palabras clave de conversación';

  @override
  String get scenarioBusinessMeetingDetail => 'Reunión de Negocios';

  @override
  String get scenarioBusinessMeetingVocabSub =>
      'Aprende palabras clave de reuniones';

  @override
  String get scenarioJobInterviewQuickSub =>
      'Responde preguntas de entrevistas de trabajo';

  @override
  String get scenarioOrderFoodQuickSub => 'Responde preguntas de restaurante';

  @override
  String get scenarioAtAirportQuickSub =>
      'Responde preguntas de viaje en el aeropuerto';

  @override
  String get scenarioDoctorVisitQuickSub =>
      'Responde preguntas de la visita al médico';

  @override
  String get scenarioSmallTalkQuickSub =>
      'Responde preguntas de conversación informal';

  @override
  String get scenarioBusinessMeetingQuickSub =>
      'Responde preguntas de reuniones de negocios';

  @override
  String roleplayQuestionsLearned(int count) {
    return '$count preguntas aprendidas';
  }

  @override
  String roleplayLessonCompleted(int lessonNumber) {
    return 'Has completado la lección $lessonNumber con éxito';
  }

  @override
  String get dialogue => 'Diálogo';

  @override
  String get comprehension => 'Comprensión';

  @override
  String get roleplayDialogueSub => 'Practica la conversación';

  @override
  String get roleplayComprehensionSub => 'Comprueba lo que has entendido';

  @override
  String roleplayXpPerLesson(int xp) {
    return '+$xp XP/lección';
  }

  @override
  String roleplayLevelLocked(int xp) {
    return 'Alcanza $xp XP para desbloquear este nivel';
  }

  @override
  String cefrLevelLockedLessons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Completa $count lecciones más del nivel anterior para desbloquear este.',
      one: 'Completa 1 lección más del nivel anterior para desbloquear este.',
    );
    return '$_temp0';
  }

  @override
  String cefrLevelLockedXp(int xp) {
    return 'Alcanza $xp XP para desbloquear este nivel';
  }

  @override
  String xpEarnedCelebration(int xp) {
    return '+$xp XP ganados';
  }

  @override
  String get boostYourXp => 'Aumenta tu XP';

  @override
  String get watchShortAd => 'Mira un anuncio corto';

  @override
  String boostXpButton(int xp) {
    return 'Aumentar +$xp XP';
  }

  @override
  String xpBoostApplied(int xp) {
    return '¡Bonificación de +$xp XP aplicada!';
  }

  @override
  String get customPlanReady => 'Tu plan personalizado está listo';

  @override
  String get customPlanReadySub =>
      'Basado en tu objetivo, nivel y tiempo diario de práctica.';

  @override
  String get planGoalLabel => 'OBJETIVO';

  @override
  String get planLevelLabel => 'NIVEL';

  @override
  String get planDailyLabel => 'DIARIO';

  @override
  String dailyMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get includedInPlan => 'Incluido en tu plan';

  @override
  String get featureUnlimitedConversation => 'Conversación ilimitada';

  @override
  String get featureUnlimitedGrammar => 'Correcciones gramaticales ilimitadas';

  @override
  String get featureAdvancedPronunciation =>
      'Retroalimentación avanzada de pronunciación';

  @override
  String get featurePersonalizedLessons =>
      'Lecciones personalizadas de inglés laboral';

  @override
  String get featureOfflineMode => 'Modo sin conexión';

  @override
  String get featureUnlimitedAiConversation => 'Conversación con IA ilimitada';

  @override
  String get featureUnlimitedPronunciationPractice =>
      'Práctica de pronunciación ilimitada';

  @override
  String get featureAllRoleplayScenarios => 'Todos los escenarios de roleplay';

  @override
  String get featureB2PlusContent => 'Contenido de lecciones B2+';

  @override
  String get featureWeeklyProgressReport => 'Informe de progreso semanal';

  @override
  String get featureUnlimitedStreakFreezes =>
      'Congelaciones de racha ilimitadas';

  @override
  String get featureStreakRepairPerMonth => '1 reparación de racha al mes';

  @override
  String get annualPlan => 'Plan Anual';

  @override
  String get threeDayFreeTrial => 'Prueba gratis de 3 días';

  @override
  String get sevenDayFreeTrial => 'Prueba gratis de 7 días';

  @override
  String get annualPrice => '\$39.99/año';

  @override
  String get annualPricePerMonth => 'Eso es \$3.33/mes';

  @override
  String get bestValue => 'MEJOR VALOR';

  @override
  String get weeklyPlan => 'Semanal';

  @override
  String get weeklyPrice => '\$2.49';

  @override
  String get monthlyPlan => 'Mensual';

  @override
  String get monthlyPrice => '\$6.99';

  @override
  String get lifetimePlan => 'De por vida';

  @override
  String get lifetimePrice => '\$79.99';

  @override
  String get oneTime => 'Una vez';

  @override
  String get orDivider => 'O';

  @override
  String get needExtraHearts => '¿Necesitas corazones extra?';

  @override
  String get smallPack => 'Paquete Pequeño';

  @override
  String get mediumPack => 'Paquete Mediano';

  @override
  String get largePack => 'Paquete Grande';

  @override
  String heartsCount(int count) {
    return '$count Corazones';
  }

  @override
  String startFreeTrialDays(int days) {
    return 'Iniciar prueba gratis de $days días';
  }

  @override
  String get cancelAnytimeNoCharge => 'Cancela cuando quieras. Sin cargo hoy';

  @override
  String get unlocksInstantly => 'Se desbloquea al instante.';

  @override
  String get terms => 'Términos';

  @override
  String get privacy => 'Privacidad';

  @override
  String get restore => 'Restaurar';

  @override
  String buyHeartsCount(int count) {
    return 'Comprar $count Corazones';
  }

  @override
  String get heartsOneTimePurchase =>
      'Compra única. Los corazones se añaden al instante.';

  @override
  String get tryProForLess => 'Prueba Pro por menos';

  @override
  String get fiftyOffFirstYear =>
      '50% de descuento el primer año: \$19.99 en lugar de \$39.99';

  @override
  String get fiftyPercentOff => '50% DTO.';

  @override
  String get annualPro => 'Pro Anual';

  @override
  String get annualProPrice => '\$19.99/año';

  @override
  String get annualProPriceStrikethrough => '\$39.99/año';

  @override
  String get firstYearOnly => 'Solo el primer año';

  @override
  String get sevenDayFreeTrialIncluded => 'Prueba gratis de 7 días incluida';

  @override
  String get specialOffer => 'OFERTA ESPECIAL';

  @override
  String get startSevenDayFreeTrial => 'Iniciar prueba gratis de 7 días';

  @override
  String heartsAddedTitle(int count) {
    return '$count Corazones Añadidos';
  }

  @override
  String get heartsAddedMessage =>
      'Tus corazones han sido añadidos. Estás listo para más chat AI, correcciones y práctica.';

  @override
  String get currentBalance => 'Saldo Actual';

  @override
  String currentHeartsBalance(int count) {
    return '$count Corazones';
  }

  @override
  String get startPracticing => 'Empezar a Practicar';

  @override
  String get oneHeartPerAiResponse => '1 corazón por respuesta AI';

  @override
  String get premiumUnlockedTitle => 'Premium desbloqueado';

  @override
  String get premiumUnlockedMessage =>
      'Ahora tienes práctica de IA ilimitada, revisiones de pronunciación, correcciones, juegos de rol y sin anuncios.';

  @override
  String get todaysLessonTitle => 'Lección de hoy';

  @override
  String get whatYouWillLearnToday => 'LO QUE APRENDERÁS HOY';

  @override
  String get startLessonButton => 'Iniciar lección';

  @override
  String get resumeLessonButton => 'Reanudar';

  @override
  String get whatYouHaveLearnedToday => 'LO QUE HAS APRENDIDO HOY';

  @override
  String get lessonCompleteTitle => '¡Lección completada!';

  @override
  String youLearnedLesson(String title) {
    return 'Aprendiste $title.';
  }

  @override
  String sentenceQuestionNumber(int number) {
    return 'Pregunta $number';
  }

  @override
  String get newlyUnlockedHeading => 'Acabas de desbloquear';

  @override
  String xpToGoBadge(int xp) {
    return '$xp XP restantes';
  }

  @override
  String notQuiteCorrectAnswer(String answer) {
    return 'No es correcto. La respuesta correcta es: $answer';
  }

  @override
  String get practiceLabel => 'Práctica';

  @override
  String get yourAnswerHint => 'Tu respuesta';

  @override
  String get checkAnswerButton => 'Comprobar';

  @override
  String get practiceCorrectFeedback => '¡Correcto!';

  @override
  String get translationFailed =>
      'No se pudo traducir. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get whatsUnlockedTitle => 'Lo que has desbloqueado';

  @override
  String xpTotalLabel(int xp) {
    return '$xp XP en total';
  }

  @override
  String get nothingUnlockedYet =>
      '¡Sigue aprendiendo para desbloquear niveles y escenarios de rol!';

  @override
  String nextUnlockLabel(String label, int xp) {
    return 'Siguiente: $label — $xp XP restantes';
  }

  @override
  String watchAdForXpSub(int xp) {
    return 'Obtén +$xp XP al instante';
  }

  @override
  String get xpBoostCapReached =>
      'Has usado todos tus impulsos de XP de hoy. Vuelve mañana.';

  @override
  String get youreOffline => 'Estás sin conexión';

  @override
  String get youreOfflineBody =>
      'Aún puedes continuar las lecciones guardadas sin conexión. El chat con IA, las comprobaciones de pronunciación, la sincronización y las compras necesitan internet';

  @override
  String get retryConnection => 'Reintentar conexión';

  @override
  String get continueOffline => 'Continuar sin conexión';

  @override
  String get featureNeedsInternet => 'Esto necesita una conexión a internet.';

  @override
  String get loadingAd => 'CARGANDO ANUNCIO';

  @override
  String get reportingApp => 'INFORMANDO A LA APP';

  @override
  String get allowNotificationsTitle => 'Sigue tu racha';

  @override
  String get allowNotificationsMessage =>
      'Activa las notificaciones para que Fluenta te recuerde practicar cada día.';

  @override
  String get allowNotificationsAllow => 'Permitir';

  @override
  String get allowNotificationsLater => 'Ahora no';

  @override
  String get updateAvailableTitle => 'Actualización disponible';

  @override
  String get updateAvailableMessage =>
      'Hay una versión nueva de Fluenta. Actualiza para obtener las últimas lecciones y correcciones.';

  @override
  String get updateNow => 'Actualizar';

  @override
  String get updateLater => 'Más tarde';

  @override
  String get connectToWatchAdTitle => 'Conéctate para ver un anuncio';

  @override
  String get connectToWatchAdMessage =>
      'Activa internet y luego reproduciremos el anuncio recompensado.';

  @override
  String get adLabel => 'Anuncio';

  @override
  String setupStepOf(int current, int total) {
    return 'PASO $current DE $total';
  }

  @override
  String get iapPurchaseFailed => 'La compra falló. Inténtalo de nuevo.';

  @override
  String get iapInvalidProduct => 'Selección de producto no válida.';

  @override
  String get iapBillingUnavailable =>
      'Google Play Billing no está disponible en este dispositivo.';

  @override
  String iapProductNotFound(String productId) {
    return 'Producto no encontrado en Play Store: $productId';
  }

  @override
  String get iapPurchaseInProgress => 'Ya hay otra compra en curso.';

  @override
  String get iapCouldNotStart => 'No se pudo iniciar la compra.';

  @override
  String get iapPurchaseTimedOut => 'La compra agotó el tiempo de espera.';

  @override
  String get iapPremiumRestored => 'Acceso Premium restaurado.';

  @override
  String get iapNoSubscriptionToRestore =>
      'No se encontró ninguna suscripción activa para restaurar.';

  @override
  String get iapPurchaseCanceled => 'Compra cancelada.';

  @override
  String get iapPremiumUnlocked => 'Premium desbloqueado.';

  @override
  String get iapUnknownProduct => 'Se compró un producto desconocido.';

  @override
  String get privacyOptions => 'Ajustes de privacidad';

  @override
  String get privacyOptionsSub => 'Gestiona tus opciones de anuncios y datos';

  @override
  String get tutorialTitle => 'Tutorial de la app';

  @override
  String get tutorialSubtitle => 'Descubre cómo usar la app';

  @override
  String get tutorialNext => 'Siguiente';

  @override
  String get tutorialDone => 'Entendido';

  @override
  String get tutorialClose => 'Cerrar tutorial';

  @override
  String tutorialStepCount(int current, int total) {
    return '$current de $total';
  }

  @override
  String get tutorialLearnTitle => 'Lecciones para cada habilidad';

  @override
  String get tutorialPronunciationTitle => 'Comprueba tu pronunciación';

  @override
  String get tutorialHeartsTitle => '¿Qué son los corazones?';

  @override
  String get tutorialPracticeTitle => 'Practica inglés aquí';

  @override
  String get tutorialPracticeBody =>
      'Abre la lección de hoy para practicar inglés cada día. Termínala para ganar XP y mantener tu racha.';

  @override
  String get tutorialAiChatTitle => 'Charla con tu tutor de IA';

  @override
  String get tutorialAiChatBody =>
      'Toca Iniciar chat IA y escribe o habla en inglés sobre cualquier tema para recibir correcciones al instante. Cada respuesta de la IA usa 1 corazón.';

  @override
  String get tutorialLearnBody =>
      'La pestaña Aprender tiene Vocabulario, Gramática y Lectura. Elige una lección y termínala para ganar XP.';

  @override
  String get tutorialLevelsTitle => 'Cómo se desbloquean los niveles';

  @override
  String get tutorialLevelsBody =>
      'Los niveles van de A1 hacia arriba. Termina las lecciones principales de un nivel y gana suficiente XP para desbloquear el siguiente. Toca un nivel bloqueado para ver qué te falta.';

  @override
  String get tutorialScenariosTitle => 'Dónde encontrar el juego de roles';

  @override
  String get tutorialScenariosBody =>
      'Abre la pestaña Juego de roles y desliza por los escenarios, como entrevistas de trabajo, pedir comida o el aeropuerto. Toca uno para practicar una conversación real.';

  @override
  String get tutorialPronunciationBody =>
      'Toca Comenzar práctica, lee la frase en voz alta y recibe una puntuación con comentarios. Inténtalo de nuevo para mejorar. Cada comprobación usa 1 corazón.';

  @override
  String get tutorialHeartsBody =>
      'Los corazones dan energía a las funciones de IA: cada respuesta de la IA y cada comprobación de pronunciación usa 1. Se recargan cada día. ¿Sin corazones? Mira un anuncio corto o pasa a Pro para tenerlos ilimitados.';

  @override
  String get tutorialProfileTitle => 'Tu perfil y ajustes';

  @override
  String get tutorialProfileBody =>
      'Sigue tu progreso, cambia el idioma y los recordatorios y gestiona Pro aquí. Puedes repetir este tutorial cuando quieras desde Soporte y legal.';

  @override
  String get moreApps => 'Más aplicaciones';

  @override
  String get moreAppsSub => 'Otras aplicaciones de Futurewatch';
}
