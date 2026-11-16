import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/features/startup/models/startup_model.dart';
import 'package:levelup_app/features/startup/providers/startup_repo_provider.dart';

final startupControllerProvider =
    AsyncNotifierProvider<StartupController, StartupResult?>(
      StartupController.new,
    );

class StartupController extends AsyncNotifier<StartupResult?> {
  @override
  Future<StartupResult?> build() async {
    return null;
  }

  Future<StartupResult> initializeApp() async {
    final repository = ref.read(startupRepositoryProvider);

    final result = await repository.syncUserDay();
    return result;
  }
}
