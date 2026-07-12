import 'package:flutter/material.dart';

class XPCard extends StatelessWidget {
  final int level;
  final int xp;

  const XPCard({super.key, required this.level, required this.xp});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isSmall = width < 360;

    final xpRequired = level * 150;
    final remainingXp = xpRequired - xp;

    final progress = (xp / xpRequired).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: isSmall ? 18 : 22,
            backgroundColor: Colors.deepPurple,
            child: Text(
              "$level",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Level Progress",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.deepPurple.shade100,
                    valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "$xp / $xpRequired XP ($remainingXp XP until Level ${level + 1})",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: isSmall ? 11 : 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
