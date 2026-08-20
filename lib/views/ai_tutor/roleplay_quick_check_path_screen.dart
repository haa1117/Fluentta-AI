import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/roleplay_quick_check_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/learning_lesson_tile.dart';
import 'package:fluentta_ai/widgets/learn_shared/learning_path_card.dart';
import 'package:provider/provider.dart';

class RoleplayQuickCheckPathScreen extends StatelessWidget {
  const RoleplayQuickCheckPathScreen({super.key, required this.scenarioId});

  final String scenarioId;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return ChangeNotifierProvider(
      create: (context) => RoleplayQuickCheckViewModel(
        scenarioId,
        context.read(),
        context.read(),
        context.read(),
        context.read(),
      ),
      child: Consumer<RoleplayQuickCheckViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackgroundColor,
              appBar: AppBarWidget(
                title: l10n.quickCheck,
                showBackButton: true,
                centerTitle: true,
                showActionButton: false,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.scaffoldBackgroundColor,
            appBar: AppBarWidget(
              title: l10n.quickCheck,
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
        },
      ),
    );
  }
}
