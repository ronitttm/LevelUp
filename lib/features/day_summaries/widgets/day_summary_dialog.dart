import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_radius.dart';
import '../../../core/app_spacing.dart';
import '../../../core/app_text.dart';
import '../../../core/responsive.dart';

import '../models/day_summary_model.dart';
import 'package:levelup_app/features/tasks/providers/tasks_for_date_provider.dart';

class DaySummaryDialog extends ConsumerWidget {
  final DaySummary history;
  final DateTime selectedDate;
  final List<String> months;

  const DaySummaryDialog({
    super.key,
    required this.history,
    required this.selectedDate,
    required this.months,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksForDateProvider(selectedDate));

    final totalTasks = history.tasksCreated;
    final completedTasks = history.tasksCompleted;
    final completionPercentage = history.completionPercentage.toInt();
    final mood = history.mood;

    final screenWidth = Responsive.width(context);
    final screenHeight = Responsive.height(context);

    final dialogWidth = Responsive.isDesktop(context)
        ? 520.0
        : Responsive.isTablet(context)
        ? screenWidth * .72
        : screenWidth * .94;

    final dialogHeight = Responsive.isDesktop(context)
        ? 760.0
        : screenHeight * .88;

    return tasksAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (dayTasks) {
        return Scaffold(
          backgroundColor: Colors.black45,
          body: SafeArea(
            child: Center(
              child: Container(
                width: dialogWidth,
                height: dialogHeight,
                margin: EdgeInsets.all(Responsive.wp(context, .03)),
                padding: Responsive.screenPadding(context),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(AppRadius.xl),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.deepPurple,
                          size: AppText.heading(context) + 8,
                        ),

                        AppSpacing.h16,

                        Expanded(
                          child: Text(
                            "Day Detail",
                            style: TextStyle(
                              fontSize: AppText.title(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),

                        CircleAvatar(
                          radius: Responsive.isMobile(context) ? 20 : 22,
                          backgroundColor: Colors.deepPurple.shade50,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.lg,

                    /// DATE
                    Center(
                      child: Text(
                        "${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppText.title(context) + 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),

                    AppSpacing.md,

                    Divider(color: Colors.grey.shade300),

                    AppSpacing.md,

                    /// STATS
                    Row(
                      children: [
                        Expanded(
                          child: statCard(
                            context,
                            "Total Tasks",
                            "$totalTasks",
                          ),
                        ),

                        AppSpacing.h16,

                        Expanded(
                          child: statCard(
                            context,
                            "Completed",
                            "$completedTasks",
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.lg,

                    /// COMPLETION + MOOD
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(AppRadius.large),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.wp(context, .045),
                              vertical: Responsive.hp(context, .02),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Completion",
                                  style: TextStyle(
                                    fontSize: AppText.heading(context),
                                  ),
                                ),
                                Text(
                                  "$completionPercentage%",
                                  style: TextStyle(
                                    fontSize: AppText.heading(context),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(height: 1, color: Colors.grey.shade300),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.wp(context, .045),
                              vertical: Responsive.hp(context, .02),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Mood",
                                  style: TextStyle(
                                    fontSize: AppText.heading(context),
                                  ),
                                ),
                                Text(
                                  getMoodLabel(mood),
                                  style: TextStyle(
                                    fontSize: AppText.heading(context),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppSpacing.lg,

                    /// TASKS
                    Text(
                      "Tasks",
                      style: TextStyle(
                        fontSize: AppText.title(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    AppSpacing.md,

                    Expanded(
                      child: dayTasks.isEmpty
                          ? Center(
                              child: Text(
                                "No tasks found",
                                style: TextStyle(
                                  fontSize: AppText.body(context),
                                ),
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: dayTasks.length,
                              separatorBuilder: (_, __) => AppSpacing.sm,
                              itemBuilder: (context, index) {
                                final task = dayTasks[index];

                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Responsive.wp(context, .035),
                                    vertical: Responsive.hp(context, .008),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      AppRadius.medium,
                                    ),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      IgnorePointer(
                                        child: Checkbox(
                                          value: task.completed,
                                          onChanged: (_) {},
                                          activeColor: Colors.deepPurple,
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: TextStyle(
                                            fontSize: AppText.body(context),
                                            decoration: task.completed
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    AppSpacing.md,

                    /// XP
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.wp(context, .045),
                        vertical: Responsive.hp(context, .02),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: const BorderRadius.all(AppRadius.large),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Points earned",
                              style: TextStyle(
                                fontSize: AppText.heading(context),
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),

                          Text(
                            "${history.xpEarned} XP",
                            style: TextStyle(
                              fontSize: AppText.heading(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget statCard(BuildContext context, String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.hp(context, .02),
        horizontal: Responsive.wp(context, .015),
      ),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: const BorderRadius.all(AppRadius.large),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppText.body(context)),
          ),

          AppSpacing.sm,

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 28 : 34,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getMoodLabel(String mood) {
    switch (mood) {
      case "great":
        return "Great 😄";

      case "good":
        return "Good 🙂";

      case "sad":
        return "Sad 😞";

      case "neutral":
      default:
        return "Neutral 😐";
    }
  }
}
