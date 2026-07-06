import 'package:flutter_riverpod/flutter_riverpod.dart';

// Phase 0 Riverpod sample provider to validate DI/state wiring.
final appStatusProvider = Provider<String>((ref) {
  return 'ready';
});
