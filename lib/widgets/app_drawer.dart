import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_task_screen.dart';
import '../screens/calendar_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "LevelUp 🚀",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// 🏠 Home
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),

          /// ➕ Add Task
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add Task"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskScreen()),
              );
            },
          ),

          // Calender nav
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text("Calendar"),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
