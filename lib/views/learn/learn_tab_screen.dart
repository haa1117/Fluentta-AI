import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/learn_view_model.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';
import 'package:fluentta_ai/widgets/common/cefr_level_bar.dart';
import 'package:fluentta_ai/widgets/learn/learn_category_card.dart';
import 'package:fluentta_ai/widgets/learn/learn_level_card.dart';
import 'package:provider/provider.dart';

class LearnTabScreen extends StatelessWidget {
  const LearnTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final learnViewModel = context.watch<LearnViewModel>();
    context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBarWidget(
        title: l10n.learnAndGrow,
        showActionButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.horizontalPadding,
          AppSizes.spaceMd,
          AppSizes.horizontalPadding,
          AppSizes.spaceLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CefrLevelBar(
              totalXp: learnViewModel.totalXp,
              selectedLevel: learnViewModel.selectedLevel,
              onLevelSelected: learnViewModel.selectLevel,
            ),
            SizedBox(height: AppSizes.spaceMd),
            const LearnLevelCard(),
            SizedBox(height: AppSizes.spaceMd),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.spaceMd,
                crossAxisSpacing: AppSizes.spaceMd,
                childAspectRatio: 1.05,
              ),
              itemCount: learnViewModel.categories.length,
              itemBuilder: (context, index) {
                final category = learnViewModel.categories[index];
                return LearnCategoryCard(
                  category: category,
                  onTap: () =>
                      learnViewModel.openCategory(context, category),
                );
              },
            ),
            SizedBox(height: AppSizes.spaceLg),
            const HomeBannerAd(placement: AdPlacement.learnBanner),
          ],
        ),
      ),
    );
  }
}
