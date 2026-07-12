import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final int completedTasks;
  final int totalTasks;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isSmall = width < 360;

    return Container(
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Progress",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmall ? 13 : 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$completedTasks of $totalTasks tasks completed",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: isSmall ? 11 : 13,
                ),
              ),

              if (progress == 1)
                const Text(
                  "🎉 Perfect!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
