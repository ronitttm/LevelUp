import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/celebration_event.dart';

class CelebrationNotifier extends StateNotifier<Queue<CelebrationEvent>> {
  CelebrationNotifier() : super(Queue<CelebrationEvent>());

  /// Add a celebration to the queue
  void enqueue(CelebrationEvent event) {
    final queue = Queue<CelebrationEvent>.from(state);

    queue.add(event);

    state = queue;
  }

  /// Remove current celebration
  void dequeue() {
    if (state.isEmpty) return;

    final queue = Queue<CelebrationEvent>.from(state);

    queue.removeFirst();

    state = queue;
  }

  /// Current celebration
  CelebrationEvent? get current => state.isEmpty ? null : state.first;

  /// Is anything waiting?
  bool get hasCelebration => state.isNotEmpty;

  /// Clear everything (useful later)
  void clear() {
    state = Queue<CelebrationEvent>();
  }
}

final celebrationProvider =
    StateNotifierProvider<CelebrationNotifier, Queue<CelebrationEvent>>((ref) {
      return CelebrationNotifier();
    });
