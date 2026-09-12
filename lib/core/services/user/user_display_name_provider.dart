import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/core/constants/app_constants.dart';
import 'package:simu/core/services/storage/key_value_storage.dart';

/// Reads the user's display name from storage (profile/auth will populate later).
final userDisplayNameProvider = FutureProvider<String>((ref) async {
  final storage = ref.watch(keyValueStorageProvider);
  final stored = await storage.getString(AppConstants.keyUserDisplayName);
  final trimmed = stored?.trim();
  if (trimmed != null && trimmed.isNotEmpty) {
    return trimmed;
  }
  return 'Friend';
});
