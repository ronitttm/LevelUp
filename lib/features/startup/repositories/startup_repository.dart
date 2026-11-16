import 'package:levelup_app/features/startup/models/startup_model.dart';

abstract class StartupRepository {
  Future<StartupResult> syncUserDay();
}
