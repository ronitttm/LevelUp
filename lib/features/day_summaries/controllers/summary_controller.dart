import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/features/day_summaries/models/day_summary_model.dart';
import 'package:levelup_app/features/day_summaries/repositories/summary_repository.dart';
import '../providers/summary_provider.dart';

class DaySummaryController extends AsyncNotifier<List<DaySummary>> {
  DaySummaryRepository get _repository =>
      ref.read(daySummaryRepositoryProvider);

  @override
  Future<List<DaySummary>> build() async {
    print("DaySummaryController build");
    return _repository.getSummaries();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getSummaries());
  }
}
