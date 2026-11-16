import 'package:flutter/material.dart';

import '../models/admin_user.dart';

class MemberCard extends StatelessWidget {
  final AdminUser member;
  final VoidCallback onTap;

  const MemberCard({super.key, required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          radius: 24,
          child: Text(
            member.displayName[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        title: Text(
          member.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(member.role),

        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
