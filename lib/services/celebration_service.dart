import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/models/celebration_factory.dart';

import '../models/celebration_factory.dart';
import '../providers/celebration_provider.dart';

class CelebrationService {
  CelebrationService(this.ref);

  final Ref ref;

  void allTasksCompleted() {
    ref
        .read(celebrationProvider.notifier)
        .enqueue(CelebrationFactory.allTasksCompleted());
  }

  // void levelUp(int level) {
  //   ref
  //       .read(celebrationProvider.notifier)
  //       .enqueue(CelebrationEvent.levelUp(level));
  // }

  void streak(int streak) {
    ref
        .read(celebrationProvider.notifier)
        .enqueue(CelebrationFactory.streak(streak));
  }

  // void achievement(String title) {
  //   ref
  //       .read(celebrationProvider.notifier)
  //       .enqueue(CelebrationEvent.achievement(title));
  // }
}

final celebrationServiceProvider = Provider((ref) => CelebrationService(ref));
