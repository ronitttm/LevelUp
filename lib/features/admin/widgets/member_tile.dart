import 'package:flutter/material.dart';

import '../models/admin_user.dart';

class MemberTile extends StatelessWidget {
  final AdminUser member;
  final bool selected;
  final VoidCallback onTap;

  const MemberTile({
    super.key,
    required this.member,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: selected ? 5 : 1,
      color: selected ? Colors.deepPurple.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: selected ? Colors.deepPurple : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Text(
            member.displayName[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        title: Text(
          member.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        trailing: selected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
      ),
    );
  }
}
