import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/share_intent_service.dart';

/// Provider for ShareIntentService
final shareIntentServiceProvider = Provider<ShareIntentService>((ref) {
  return ShareIntentService();
});

/// Provider for the shared URL stream
final sharedUrlStreamProvider = StreamProvider<String?>((ref) {
  final service = ref.watch(shareIntentServiceProvider);
  return service.sharedUrlStream;
});

/// Provider for the last shared URL
final lastSharedUrlProvider = Provider<String?>((ref) {
  final service = ref.watch(shareIntentServiceProvider);
  return service.lastSharedUrl;
});
