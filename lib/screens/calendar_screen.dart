import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/top_bar.dart';
import 'package:drift/drift.dart' hide Column;

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
        return Colors.grey.shade300;
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

  Widget statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),

      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),

          const SizedBox(height: 8),

          Text(
            value,

            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.read(databaseProvider);

    final int daysInMonth = getDaysInMonth(selectedYear, selectedMonth);

    return FutureBuilder<List<DaySummary>>(
      future: db.select(db.daySummaries).get(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final allHistory = snapshot.data!;

        final filteredHistory = allHistory.where((history) {
          return history.date.month == selectedMonth &&
              history.date.year == selectedYear;
        }).toList();

        final Map<int, DaySummary> historyMap = {
          for (var history in filteredHistory) history.date.day: history,
        };

        /// longest streak
        int longestStreak = 0;
        int current = 0;

        final sortedHistory = [...allHistory]
          ..sort((a, b) => a.date.compareTo(b.date));

        for (final day in sortedHistory) {
          if (day.completedTasks > 0) {
            current++;

            if (current > longestStreak) {
              longestStreak = current;
            }
          } else {
            current = 0;
          }
        }

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

                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 18),

                  /// MONTH + YEAR
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),

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
                          padding: const EdgeInsets.symmetric(horizontal: 14),

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
                                        history.completedTasks > 0;

                                    return GestureDetector(
                                      onTap: () async {
                                        if (history == null) {
                                          return;
                                        }

                                        final selectedDate = DateTime(
                                          selectedYear,
                                          selectedMonth,
                                          day,
                                        );

                                        final nextDay = selectedDate.add(
                                          const Duration(days: 1),
                                        );

                                        final dayTasks =
                                            await (db.select(db.tasks)..where(
                                                  (tbl) =>
                                                      tbl.appDay
                                                          .isBiggerOrEqualValue(
                                                            selectedDate,
                                                          ) &
                                                      tbl.appDay
                                                          .isSmallerThanValue(
                                                            nextDay,
                                                          ),
                                                ))
                                                .get();

                                        final totalTasks = dayTasks.length;

                                        final completedTasks = dayTasks
                                            .where((task) => task.isCompleted)
                                            .length;

                                        final completionPercentage =
                                            totalTasks == 0
                                            ? 0
                                            : ((completedTasks / totalTasks) *
                                                      100)
                                                  .toInt();

                                        if (!mounted) return;

                                        showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: "Day Detail",
                                          barrierColor: Colors.black54,
                                          transitionDuration: const Duration(
                                            milliseconds: 250,
                                          ),

                                          pageBuilder: (_, __, ___) {
                                            return Scaffold(
                                              backgroundColor: Colors.black45,

                                              body: Center(
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                    20,
                                                  ),

                                                  padding: const EdgeInsets.all(
                                                    20,
                                                  ),

                                                  constraints:
                                                      const BoxConstraints(
                                                        maxWidth: 500,
                                                        maxHeight: 760,
                                                      ),

                                                  decoration: BoxDecoration(
                                                    color: Colors.white,

                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          34,
                                                        ),
                                                  ),

                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,

                                                    children: [
                                                      /// HEADER
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,

                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},

                                                            icon: const Icon(
                                                              Icons.menu,

                                                              color: Colors
                                                                  .deepPurple,

                                                              size: 30,
                                                            ),
                                                          ),

                                                          const Text(
                                                            "Day Detail",

                                                            style: TextStyle(
                                                              fontSize: 24,

                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,

                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),

                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .deepPurple
                                                                    .shade50,

                                                            child: IconButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),

                                                              icon: const Icon(
                                                                Icons.close,

                                                                color: Colors
                                                                    .deepPurple,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                        height: 20,
                                                      ),

                                                      /// DATE
                                                      Center(
                                                        child: Text(
                                                          "$day ${months[selectedMonth - 1]} $selectedYear",

                                                          style:
                                                              const TextStyle(
                                                                fontSize: 30,

                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,

                                                                color: Colors
                                                                    .deepPurple,
                                                              ),
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 24,
                                                      ),

                                                      Divider(
                                                        color: Colors
                                                            .grey
                                                            .shade300,
                                                      ),

                                                      const SizedBox(
                                                        height: 18,
                                                      ),

                                                      /// STATS
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: statCard(
                                                              "Total Tasks",

                                                              "$totalTasks",
                                                            ),
                                                          ),

                                                          const SizedBox(
                                                            width: 14,
                                                          ),

                                                          Expanded(
                                                            child: statCard(
                                                              "Completed Tasks",

                                                              "$completedTasks",
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                        height: 22,
                                                      ),

                                                      /// COMPLETION + MOOD
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                24,
                                                              ),

                                                          border: Border.all(
                                                            color: Colors
                                                                .grey
                                                                .shade300,
                                                          ),
                                                        ),

                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        18,

                                                                    vertical:
                                                                        18,
                                                                  ),

                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,

                                                                children: [
                                                                  const Text(
                                                                    "Completion",

                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),

                                                                  Text(
                                                                    "$completionPercentage%",

                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          18,

                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,

                                                                      color: Colors
                                                                          .deepPurple,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            Divider(
                                                              height: 1,

                                                              color: Colors
                                                                  .grey
                                                                  .shade300,
                                                            ),

                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        18,

                                                                    vertical:
                                                                        18,
                                                                  ),

                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,

                                                                children: [
                                                                  const Text(
                                                                    "Mood",

                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),

                                                                  Text(
                                                                    getMoodLabel(
                                                                      mood,
                                                                    ),

                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          18,

                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,

                                                                      color: Colors
                                                                          .deepPurple,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 24,
                                                      ),

                                                      /// TASKS
                                                      const Text(
                                                        "Tasks",

                                                        style: TextStyle(
                                                          fontSize: 26,

                                                          fontWeight:
                                                              FontWeight.bold,

                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 14,
                                                      ),

                                                      Expanded(
                                                        child: dayTasks.isEmpty
                                                            ? const Center(
                                                                child: Text(
                                                                  "No tasks found",
                                                                ),
                                                              )
                                                            : ListView.builder(
                                                                itemCount:
                                                                    dayTasks
                                                                        .length,

                                                                itemBuilder: (context, index) {
                                                                  final task =
                                                                      dayTasks[index];

                                                                  return Container(
                                                                    margin:
                                                                        const EdgeInsets.only(
                                                                          bottom:
                                                                              14,
                                                                        ),

                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          14,

                                                                      vertical:
                                                                          8,
                                                                    ),

                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            20,
                                                                          ),

                                                                      border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                      ),
                                                                    ),

                                                                    child: Row(
                                                                      children: [
                                                                        Checkbox(
                                                                          value:
                                                                              task.isCompleted,

                                                                          onChanged:
                                                                              null,

                                                                          activeColor:
                                                                              Colors.deepPurple,
                                                                        ),

                                                                        Expanded(
                                                                          child: Text(
                                                                            task.title,

                                                                            style: TextStyle(
                                                                              fontSize: 18,

                                                                              decoration: task.isCompleted
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

                                                      const SizedBox(
                                                        height: 18,
                                                      ),

                                                      /// XP
                                                      Container(
                                                        width: double.infinity,

                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 18,

                                                              vertical: 18,
                                                            ),

                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .deepPurple
                                                              .shade50,

                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                22,
                                                              ),
                                                        ),

                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,

                                                          children: [
                                                            const Text(
                                                              "Points earned :",

                                                              style: TextStyle(
                                                                fontSize: 22,

                                                                color: Colors
                                                                    .deepPurple,
                                                              ),
                                                            ),

                                                            Text(
                                                              "${history.xpEarned} XP",

                                                              style: const TextStyle(
                                                                fontSize: 22,

                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,

                                                                color: Colors
                                                                    .deepPurple,
                                                              ),
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

                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),

                                        decoration: BoxDecoration(
                                          color: bgColor,

                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),

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
                                                color: Colors.orange.withValues(
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

                                                  fontWeight: FontWeight.bold,

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
                                                        color:
                                                            Colors.deepPurple,

                                                        shape: BoxShape.circle,
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
                              "🔥 Longest streak maintained: $longestStreak days",

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
