import 'package:flutter/material.dart';
import 'package:levelup_app/features/day_summaries/models/day_summary_model.dart';
import 'package:levelup_app/features/day_summaries/repositories/summary_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDaySummaryRepository implements DaySummaryRepository {
  final SupabaseClient supabase;

  SupabaseDaySummaryRepository(this.supabase);

  @override
  Future<List<DaySummary>> getSummaries() async {
    debugPrint("🔥 API -> get summary");
    final response = await supabase
        .from('day_summaries')
        .select()
        .order('date', ascending: false);

    return response.map((e) => DaySummary.fromMap(e)).toList();
  }
}
