import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/features/day_summaries/models/day_summary_model.dart';
import 'package:levelup_app/features/day_summaries/providers/summary_provider.dart';
import 'package:levelup_app/features/current_user/providers/current_user_provider.dart';
import 'package:levelup_app/features/day_summaries/widgets/day_summary_dialog.dart';

import '../widgets/common/app_drawer.dart';
import '../widgets/common/top_bar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final List<String> months = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  late List<int> years;

  @override
  void initState() {
    super.initState();

    years = List.generate(10, (index) => DateTime.now().year - 5 + index);
  }

  int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  Color getMoodColor(String mood) {
    switch (mood) {
      case "great":
        return Colors.green.shade700;

      case "good":
        return Colors.green.shade300;

      case "sad":
        return Colors.red.shade400;

      case "neutral":
      default:
        return Colors.grey;
    }
  }

  Color getTextColor(String mood) {
    switch (mood) {
      case "neutral":
        return Colors.black87;

      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final summariesAsync = ref.watch(daySummaryControllerProvider);

    final int daysInMonth = getDaysInMonth(selectedYear, selectedMonth);

    return currentUserAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),

      data: (user) {
        return summariesAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),

          error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),

          data: (allHistory) {
            final filteredHistory = allHistory.where((history) {
              return history.date.month == selectedMonth &&
                  history.date.year == selectedYear;
            }).toList();

            final Map<int, DaySummary> historyMap = {
              for (var history in filteredHistory) history.date.day: history,
            };

            /// longest streak

            return Scaffold(
              backgroundColor: const Color(0xFFF6F3FA),

              appBar: const TopBar(),
              drawer: const AppDrawer(),

              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// HEADER
                      const Text(
                        "Mood Calendar",

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// MONTH + YEAR
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: selectedMonth,
                                  isExpanded: true,

                                  items: List.generate(
                                    months.length,
                                    (index) => DropdownMenuItem(
                                      value: index + 1,
                                      child: Text(months[index]),
                                    ),
                                  ),

                                  onChanged: (value) {
                                    setState(() {
                                      selectedMonth = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: selectedYear,
                                  isExpanded: true,

                                  items: years
                                      .map(
                                        (year) => DropdownMenuItem(
                                          value: year,
                                          child: Text(year.toString()),
                                        ),
                                      )
                                      .toList(),

                                  onChanged: (value) {
                                    setState(() {
                                      selectedYear = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// CALENDAR
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),

                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),

                          child: Column(
                            children: [
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final width = constraints.maxWidth;

                                    final double aspectRatio = width < 380
                                        ? 0.92
                                        : width < 500
                                        ? 1
                                        : 1.1;

                                    return GridView.builder(
                                      physics: const BouncingScrollPhysics(),

                                      itemCount: daysInMonth,

                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 7,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: aspectRatio,
                                          ),

                                      itemBuilder: (context, index) {
                                        final day = index + 1;

                                        final history = historyMap[day];

                                        final mood = history?.mood ?? "neutral";

                                        final bgColor = getMoodColor(mood);

                                        final appDay = DateTime.now();

                                        final isToday =
                                            selectedMonth == appDay.month &&
                                            selectedYear == appDay.year &&
                                            day == appDay.day;

                                        final isStreakDay =
                                            history != null &&
                                            history.tasksCompleted > 0;

                                        return GestureDetector(
                                          onTap: () async {
                                            if (history == null) {
                                              return;
                                            }

                                            if (!mounted) return;
                                            showDialog(
                                              context: context,
                                              builder: (_) => DaySummaryDialog(
                                                history: history,
                                                months: months,
                                                selectedDate: DateTime(
                                                  selectedYear,
                                                  selectedMonth,
                                                  day,
                                                ),
                                              ),
                                            );
                                          },

                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),

                                            decoration: BoxDecoration(
                                              color: bgColor,

                                              borderRadius:
                                                  BorderRadius.circular(18),

                                              border: Border.all(
                                                color: isToday
                                                    ? Colors.deepPurple
                                                    : isStreakDay
                                                    ? Colors.orange
                                                    : Colors.transparent,

                                                width: isToday || isStreakDay
                                                    ? 3
                                                    : 0,
                                              ),

                                              boxShadow: [
                                                if (isStreakDay)
                                                  BoxShadow(
                                                    color: Colors.orange
                                                        .withValues(
                                                          alpha: 0.30,
                                                        ),

                                                    blurRadius: 12,
                                                    spreadRadius: 1,
                                                  ),
                                              ],
                                            ),

                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "$day",

                                                    style: TextStyle(
                                                      color: getTextColor(mood),

                                                      fontWeight:
                                                          FontWeight.bold,

                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),

                                                if (isToday)
                                                  Positioned(
                                                    top: 6,
                                                    right: 6,

                                                    child: Container(
                                                      width: 8,
                                                      height: 8,

                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors
                                                                .deepPurple,

                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 16),

                              /// LONGEST STREAK
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),

                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  "🔥 Longest streak maintained: ${user.longestStreak} days",

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// LEGEND
                      Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Mood Scale",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Wrap(
                              spacing: 18,
                              runSpacing: 12,

                              children: [
                                moodItem(Colors.green.shade700, "Great"),

                                moodItem(Colors.green.shade300, "Good"),

                                moodItem(Colors.grey.shade400, "Neutral"),

                                moodItem(Colors.red.shade400, "Sad"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget moodItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(
          width: 14,
          height: 14,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 8),

        Text(text),
      ],
    );
  }
}
