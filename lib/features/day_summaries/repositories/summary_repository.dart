import '../models/day_summary_model.dart';

abstract class DaySummaryRepository {
  Future<List<DaySummary>> getSummaries();
}
