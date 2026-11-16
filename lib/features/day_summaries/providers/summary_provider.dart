import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/features/day_summaries/models/day_summary_model.dart';
import 'package:levelup_app/features/day_summaries/repositories/summary_repository.dart';
import 'package:levelup_app/features/day_summaries/repositories/supabase_summary_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/summary_controller.dart';

/// Repository
final daySummaryRepositoryProvider = Provider<DaySummaryRepository>((ref) {
  return SupabaseDaySummaryRepository(Supabase.instance.client);
});

/// Controller
final daySummaryControllerProvider =
    AsyncNotifierProvider<DaySummaryController, List<DaySummary>>(
      DaySummaryController.new,
    );
