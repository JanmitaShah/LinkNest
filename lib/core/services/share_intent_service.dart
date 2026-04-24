import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// Service responsible for handling share intents from other apps
/// Supports both cold start (initial share) and running state (ongoing shares)
class ShareIntentService {
  static final ShareIntentService _instance = ShareIntentService._internal();
  factory ShareIntentService() => _instance;
  ShareIntentService._internal();

  final _sharedUrlController = StreamController<String?>.broadcast();
  Stream<String?> get sharedUrlStream => _sharedUrlController.stream;

  String? _lastSharedUrl;
  String? get lastSharedUrl => _lastSharedUrl;

  /// Initialize the share intent listener
  /// Call this during app startup
  Future<void> initialize() async {
    // Get initial shared media (for cold start)
    final initialMedia = await ReceiveSharingIntent.instance.getInitialMedia();
    if (initialMedia.isNotEmpty) {
      final url = _extractUrlFromMedia(initialMedia);
      if (url != null) {
        _lastSharedUrl = url;
        _sharedUrlController.add(url);
      }
    }

    // Listen for ongoing shared media (when app is running)
    ReceiveSharingIntent.instance.getMediaStream().listen(
      (List<SharedMediaFile> sharedMedia) {
        final url = _extractUrlFromMedia(sharedMedia);
        if (url != null) {
          _lastSharedUrl = url;
          _sharedUrlController.add(url);
        }
      },
      onError: (error) {
        // Handle error silently or log
        _sharedUrlController.add(null);
      },
    );
  }

  /// Extract the first valid URL from shared media list
  String? _extractUrlFromMedia(List<SharedMediaFile> mediaFiles) {
    for (final file in mediaFiles) {
      // Prefer items with type url or text
      if (file.type == SharedMediaType.url || file.type == SharedMediaType.text) {
        final url = _extractUrlFromText(file.path);
        if (url != null) return url;
      }
    }
    // If none found with those types, try all files
    for (final file in mediaFiles) {
      final url = _extractUrlFromText(file.path);
      if (url != null) return url;
    }
    return null;
  }

  /// Extract the first valid URL from given text
  /// Handles plain URLs and text containing URLs
  String? _extractUrlFromText(String text) {
    if (text.trim().isEmpty) return null;

    // URL regex pattern - matches http/https URLs (case-insensitive)
    final urlRegex = RegExp(
      r'https?://(?:[-\w.])+(?:[:\d]+)?(?:/(?:[\w/_.])*(?:\?(?:[\w&=%.])*)?(?:#(?:[\w.])*)?)?',
      caseSensitive: false,
    );

    final match = urlRegex.firstMatch(text);
    if (match != null) {
      final candidate = match.group(0);
      if (candidate != null) {
        final uri = Uri.tryParse(candidate);
        if (uri != null && uri.hasScheme && uri.hasAuthority) {
          return candidate;
        }
      }
    }

    // If no URL pattern found, check if the text itself is a valid URL
    final trimmed = text.trim();
    if (trimmed.startsWith('http://', 0) || trimmed.startsWith('https://', 0)) {
      final uri = Uri.tryParse(trimmed);
      if (uri != null && uri.hasScheme && uri.hasAuthority) {
        return trimmed;
      }
    }

    return null;
  }

  /// Clear the last shared URL after it's been processed
  void clearSharedUrl() {
    _lastSharedUrl = null;
  }

  /// Dispose resources
  void dispose() {
    _sharedUrlController.close();
  }
}
