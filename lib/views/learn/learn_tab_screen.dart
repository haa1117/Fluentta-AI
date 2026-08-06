import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/learn_view_model.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';
import 'package:fluentta_ai/widgets/learn/learn_category_card.dart';
import 'package:fluentta_ai/widgets/learn/learn_level_card.dart';
import 'package:provider/provider.dart';

class LearnTabScreen extends StatelessWidget {
  const LearnTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final learnViewModel = context.read<LearnViewModel>();
    context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Learn & grow',
        showActionButton: false,

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

            const LearnLevelCard(),
            SizedBox(height: AppSizes.spaceMd),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.spaceMd,
                crossAxisSpacing: AppSizes.spaceMd,
                childAspectRatio: 1.15,
              ),
              itemCount: LearnViewModel.categories.length,
              itemBuilder: (context, index) {
                final category = LearnViewModel.categories[index];
                return LearnCategoryCard(
                  category: category,
                  onTap: () =>
                      learnViewModel.openCategory(context, category),
                );
              },
            ),

            SizedBox(height: AppSizes.spaceXxl+AppSizes.spaceLg),
            const HomeBannerAd(),
          ],
        ),
      ),
    );
  }
}
