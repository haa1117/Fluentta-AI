import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/vocabulary_word_entry.dart';
import 'package:fluentta_ai/data/repositories/saved_words_repository.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/viewmodels/saved_words_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class SavedWordsScreen extends StatelessWidget {
  const SavedWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => SavedWordsViewModel(
        savedWordsRepository: ctx.read<SavedWordsRepository>(),
        textToSpeechService: ctx.read<TextToSpeechService>(),
      ),
      child: const _SavedWordsBody(),
    );
  }
}

class _SavedWordsBody extends StatelessWidget {
  const _SavedWordsBody();

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final vm = context.watch<SavedWordsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.savedWords,
        showBackButton: true,
        centerTitle: true,
      ),
      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : vm.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.horizontalPadding),
                    child: Text(
                      l10n.noSavedWords,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(15),
                        color: AppColors.profileSubtitleColor,
                        height: 1.45,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.horizontalPadding,
                    AppSizes.spaceMd,
                    AppSizes.horizontalPadding,
                    AppSizes.spaceLg,
                  ),
                  itemCount: vm.words.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppSizes.h(10)),
                  itemBuilder: (context, index) {
                    final word = vm.words[index];
                    return _SavedWordTile(
                      word: word,
                      isListening: vm.isListening(word.id),
                      onListen: () => vm.listenWord(word),
                      onRemove: () => vm.removeWord(word.id),
                    );
                  },
                ),
    );
  }
}

class _SavedWordTile extends StatelessWidget {
  const _SavedWordTile({
    required this.word,
    required this.isListening,
    required this.onListen,
    required this.onRemove,
  });

  final VocabularyWordEntry word;
  final bool isListening;
  final VoidCallback onListen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlueColor,
                      ),
                    ),
                    Text(
                      word.phonetic,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onListen,
                icon: Icon(
                  isListening
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.bookmark_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(8)),
          Text(
            word.meaning,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(13),
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSizes.h(8)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.w(12)),
            decoration: BoxDecoration(
              color: AppColors.homeCardLavender,
              borderRadius: BorderRadius.circular(AppSizes.w(10)),
            ),
            child: Text(
              word.example,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(12),
                color: AppColors.profileSubtitleColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
