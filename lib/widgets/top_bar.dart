import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("LevelUp"),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 16,
            child: Icon(Icons.person, size: 18),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}