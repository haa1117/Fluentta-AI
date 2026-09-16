import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/services/ai_backend_service.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/pronunciation_assessment_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/open_chat_view_model.dart';
import 'package:fluentta_ai/widgets/chat/chat_input_area.dart';
import 'package:fluentta_ai/widgets/chat/chat_message_bubble.dart';
import 'package:fluentta_ai/widgets/chat/chat_mode_toggle.dart';
import 'package:fluentta_ai/widgets/chat/chat_quick_starters.dart';
import 'package:fluentta_ai/widgets/chat/out_of_hearts_dialog.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class OpenChatPracticeScreen extends StatelessWidget {
  const OpenChatPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolve localized strings here — the provider `create` callback runs with
    // a context that can't depend on inherited widgets.
    final greeting = context.l10n.chatGreeting;
    // Tutor uses the learner's setup CEFR. Lesson paths stay B1-capped for free.
    final cefrLevel = context.read<EntitlementsService>().setupLevel().code;
    final goal = context.read<LocalStorage>().englishGoal;
    final nativeLanguage = context.read<LocaleViewModel>().languageCode;
    return ChangeNotifierProvider(
      create: (providerContext) => OpenChatViewModel(
        homeViewModel: providerContext.read<HomeViewModel>(),
        aiBackendService: providerContext.read<AiBackendService>(),
        speechService: providerContext.read<PronunciationAssessmentService>(),
        progressSyncService: providerContext.read<ProgressSyncService>(),
        textToSpeechService: providerContext.read<TextToSpeechService>(),
        localStorage: providerContext.read<LocalStorage>(),
        greeting: greeting,
        cefrLevel: cefrLevel,
        goal: goal,
        nativeLanguage: nativeLanguage,
      ),
      child: const _OpenChatPracticeBody(),
    );
  }
}

class _OpenChatPracticeBody extends StatefulWidget {
  const _OpenChatPracticeBody();

  @override
  State<_OpenChatPracticeBody> createState() => _OpenChatPracticeBodyState();
}

class _OpenChatPracticeBodyState extends State<_OpenChatPracticeBody> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || kDebugMode) return;
      final home = context.read<HomeViewModel>();
      if (home.lives <= 0 && !home.hasUnlimitedHearts) {
        showOutOfHeartsDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  bool _guardHearts() {
    if (kDebugMode) return true; // debug builds don't spend hearts
    final home = context.read<HomeViewModel>();
    if (!home.hasUnlimitedHearts && home.lives <= 0) {
      showOutOfHeartsDialog(context);
      return false;
    }
    return true;
  }

  Future<void> _sendText() async {
    if (!_guardHearts()) return;
    final vm = context.read<OpenChatViewModel>();
    final text = _controller.text;
    _controller.clear();
    await vm.sendText(text);
    if (!mounted) return;
    _handleError(vm);
    _scrollToEnd();
  }

  Future<void> _sendQuickStarter(String prompt) async {
    if (!_guardHearts()) return;
    final vm = context.read<OpenChatViewModel>();
    await vm.sendQuickStarter(prompt);
    if (!mounted) return;
    _handleError(vm);
    _scrollToEnd();
  }

  void _handleError(OpenChatViewModel vm) {
    final error = vm.error;
    if (error == null) return;
    vm.clearError();
    if (error == 'out_of_hearts') {
      showOutOfHeartsDialog(context);
      return;
    }
    if (error == 'speech_unavailable') {
      SnackbarHelper.showError(context, _speechUnavailableMessage);
      return;
    }
    if (error == 'offline') {
      SnackbarHelper.showError(
        context,
        AppLocalizations.of(context).chatNeedsInternet,
      );
      return;
    }
    SnackbarHelper.showError(context, error);
  }

  String get _speechUnavailableMessage =>
      AppLocalizations.of(context).chatSpeechUnavailable;

  List<String> _quickStarterLabels(AppLocalizations l10n) => [
        l10n.chatQuickStarterLesson,
        l10n.chatQuickStarterGrammar,
        l10n.chatQuickStarterDaily,
        l10n.chatQuickStarterWork,
        l10n.chatQuickStarterOpenTopic,
      ];

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final vm = context.watch<OpenChatViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        title: l10n.openChatPracticeTitle,
        showBackButton: true,
        centerTitle: true,
        showActionButton: true,
        showHearts: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceMd),
            if (!vm.isOnline)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.horizontalPadding,
                  0,
                  AppSizes.horizontalPadding,
                  AppSizes.spaceMd,
                ),
                child: Text(
                  l10n.chatNeedsInternet,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
              child: Row(
                children: [
                  Expanded(
                    child: ChatModeToggle(
                      mode: vm.inputMode,
                      onChanged: vm.setInputMode,
                      textLabel: l10n.chatTextMode,
                      voiceLabel: l10n.chatVoiceMode,
                    ),
                  ),
                  SizedBox(width: AppSizes.w(10)),
                  _SpeakToggleButton(
                    enabled: vm.speakReplies,
                    tooltip: l10n.chatReadRepliesAloud,
                    onTap: vm.toggleSpeakReplies,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.spaceMd),
            Expanded(child: _buildChatArea(vm, l10n)),
            _buildInputArea(vm, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea(OpenChatViewModel vm, AppLocalizations l10n) {
    final messages = vm.messages;
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(
        AppSizes.w(20),
        AppSizes.h(4),
        AppSizes.w(20),
        AppSizes.h(16),
      ),
      itemCount:
          messages.length + ((vm.isSending || vm.isTranscribing) ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= messages.length) {
          return Padding(
            padding: EdgeInsets.only(top: AppSizes.h(16), left: AppSizes.w(52)),
            child: _TypingIndicator(),
          );
        }

        final message = messages[index];
        final originalUserText = (index > 0 && messages[index - 1].isUser)
            ? messages[index - 1].text
            : null;

        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : AppSizes.h(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatMessageBubble(
                message: message,
                originalUserText: originalUserText,
                correctionLabel: l10n.chatCorrectionLabel,
                yourSentenceLabel: l10n.chatYourSentence,
                correctSentenceLabel: l10n.chatCorrectSentence,
                tipPrefix: l10n.chatTipPrefix,
                isSpeaking: vm.speakingIndex == index,
                onSpeak: message.isUser ? null : () => vm.speakMessage(index),
                playLabel: l10n.chatPlay,
                playingLabel: l10n.chatPlaying,
              ),
              if (index == 0 && vm.showQuickStarters)
                ChatQuickStarters(
                  labels: _quickStarterLabels(l10n),
                  onSelected: _sendQuickStarter,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea(OpenChatViewModel vm, AppLocalizations l10n) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: vm.inputMode == ChatInputMode.text
          ? Padding(
              key: const ValueKey('text-input'),
              padding: EdgeInsets.fromLTRB(
                AppSizes.w(24),
                AppSizes.h(4),
                AppSizes.w(24),
                AppSizes.h(16),
              ),
              child: ChatTextInputBar(
                controller: _controller,
                hintText: l10n.chatTypeHint,
                footerLabel: l10n.oneHeartPerAiResponse,
                enabled: !vm.isSending && vm.isOnline,
                onSend: _sendText,
              ),
            )
          : ChatVoiceInputPanel(
              key: const ValueKey('voice-input'),
              state: vm.voiceState,
              holdToSpeakLabel: l10n.chatHoldToSpeak,
              listeningLabel: l10n.chatListening,
              releaseHintLabel: l10n.chatReleaseToSend,
              tapHintLabel: l10n.chatTapToSend,
              cancelLabel: l10n.chatCancel,
              lockLabel: l10n.chatLock,
              footerLabel: l10n.oneHeartPerAiResponse,
              onBegin: () {
                if (!_guardHearts()) return;
                if (!vm.isOnline) {
                  SnackbarHelper.showError(context, l10n.chatNeedsInternet);
                  return;
                }
                vm.beginVoiceCapture();
              },
              onCancel: vm.cancelVoiceCapture,
              onLock: vm.lockVoiceCapture,
              onFinish: () async {
                await vm.finishVoiceCapture();
                if (!mounted) return;
                _handleError(vm);
                _scrollToEnd();
              },
            ),
    );
  }
}

class _SpeakToggleButton extends StatelessWidget {
  const _SpeakToggleButton({
    required this.enabled,
    required this.tooltip,
    required this.onTap,
  });

  final bool enabled;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppSizes.h(50),
          height: AppSizes.h(50),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.brandDarkSoftColor
                : AppColors.brandLightSoftColor,
            borderRadius: BorderRadius.circular(AppSizes.w(999)),
          ),
          child: Icon(
            enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            size: AppSizes.sp(22),
            color: enabled
                ? AppColors.primaryColor
                : (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      '•  •  •',
      style: TextStyle(
        fontFamily: AppFonts.plusJakartaSans,
        fontSize: AppSizes.sp(18),
        color:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
    );
  }
}
