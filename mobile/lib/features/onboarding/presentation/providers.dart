import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locora_mobile/features/auth/presentation/providers.dart';
import 'package:locora_mobile/features/onboarding/data/datasources/discovery_profile_remote_data_source.dart';
import 'package:locora_mobile/features/onboarding/data/repositories/discovery_profile_repository_impl.dart';
import 'package:locora_mobile/features/onboarding/domain/entities/discovery_profile.dart';
import 'package:locora_mobile/features/onboarding/domain/repositories/discovery_profile_repository.dart';
import 'package:locora_mobile/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:locora_mobile/features/onboarding/domain/usecases/save_discovery_profile.dart';

final discoveryProfileRemoteDataSourceProvider =
    Provider<DiscoveryProfileRemoteDataSource>(
  (ref) => DiscoveryProfileRemoteDataSourceImpl(),
);

final discoveryProfileRepositoryProvider = Provider<DiscoveryProfileRepository>(
  (ref) => DiscoveryProfileRepositoryImpl(
    ref.watch(discoveryProfileRemoteDataSourceProvider),
  ),
);

final getOnboardingStatusUseCaseProvider = Provider<GetOnboardingStatus>(
  (ref) => GetOnboardingStatus(ref.watch(discoveryProfileRepositoryProvider)),
);

final saveDiscoveryProfileUseCaseProvider = Provider<SaveDiscoveryProfile>(
  (ref) => SaveDiscoveryProfile(ref.watch(discoveryProfileRepositoryProvider)),
);

final onboardingCompletedProvider = FutureProvider.family<bool, String>(
  (ref, userId) => ref.watch(getOnboardingStatusUseCaseProvider).call(userId),
);

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, AsyncValue<void>>(
  (ref) => OnboardingController(ref),
);

class OnboardingController extends StateNotifier<AsyncValue<void>> {
  OnboardingController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> saveProfile(DiscoveryProfile profile) async {
    final userId = _ref.read(currentUserIdProvider);
    final email = _ref.read(currentUserEmailProvider);

    if (userId == null || email == null || email.isEmpty) {
      state = AsyncError(
        StateError('User session is not available.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(saveDiscoveryProfileUseCaseProvider).call(
            userId: userId,
            email: email,
            profile: profile,
          ),
    );

    _ref.invalidate(onboardingCompletedProvider(userId));
  }
}
