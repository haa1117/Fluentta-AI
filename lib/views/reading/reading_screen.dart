import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/reading_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/learning_lesson_tile.dart';
import 'package:fluentta_ai/widgets/learn_shared/learning_path_card.dart';
import 'package:provider/provider.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<ReadingViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: 'Reading',
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
          LearningPathCard(pathData: viewModel.pathData),
          SizedBox(height: AppSizes.spaceLg),
          ...viewModel.lessons.map(
            (lesson) => LearningLessonTile(
              lesson: lesson,
              onTap: () => viewModel.openLesson(context, lesson),
            ),
          ),
        ],
      ),
    );
  }
}
