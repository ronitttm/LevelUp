import 'package:flutter/material.dart';

class CelebrationEvent {
  final String id;

  final String title;

  final String subtitle;

  final String animation;

  final IconData icon;

  final Color primaryColor;

  final Duration duration;

  const CelebrationEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.animation,
    required this.icon,
    required this.primaryColor,
    this.duration = const Duration(seconds: 5),
  });
}
