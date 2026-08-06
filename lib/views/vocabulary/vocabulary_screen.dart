import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/vocabulary/vocabulary_lesson_tile.dart';
import 'package:fluentta_ai/widgets/vocabulary/vocabulary_path_card.dart';
import 'package:provider/provider.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<VocabularyViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: 'Vocabulary',
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.horizontalPadding,
          AppSizes.spaceMd,
          AppSizes.horizontalPadding,
          AppSizes.spaceLg,
        ),
        children: [
          const VocabularyPathCard(),
          SizedBox(height: AppSizes.spaceLg),
          ...viewModel.lessons.map(
            (lesson) => VocabularyLessonTile(
              lesson: lesson,
              onTap: () => viewModel.openLesson(context, lesson),
            ),
          ),
        ],
      ),
    );
  }
}
