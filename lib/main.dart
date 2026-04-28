import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'core/config/ad_config.dart';
import 'core/constants/hive_constants.dart';
import 'core/router/app_router.dart';
import 'core/services/share_intent_service.dart';
import 'features/links/data/models/link_model.dart';

/// Global navigator key for navigation from services
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(LinkModelAdapter());

  // Open Hive boxes
  await Hive.openBox<LinkModel>(HiveBoxNames.links);

  // Initialize Share Intent Service
  final shareIntentService = ShareIntentService();
  await shareIntentService.initialize();

  // Initialize Ads
  await AdManager.initialize();

  // Create router
  final router = createAppRouter();

  runApp(
    ProviderScope(
      child: _ShareIntentListener(
        service: shareIntentService,
        router: router,
        child: LinkStoreApp(router: router),
      ),
    ),
  );
}

/// Widget that listens to share intent events and navigates accordingly
class _ShareIntentListener extends StatefulWidget {
  final ShareIntentService service;
  final GoRouter router;
  final Widget child;

  const _ShareIntentListener({
    required this.service,
    required this.router,
    required this.child,
  });

  @override
  State<_ShareIntentListener> createState() => _ShareIntentListenerState();
}

class _ShareIntentListenerState extends State<_ShareIntentListener> {
  late final StreamSubscription<String?> _subscription;

  @override
  void initState() {
    super.initState();

    // Handle initial shared URL (from cold start)
    final initialUrl = widget.service.lastSharedUrl;
    if (initialUrl != null) {
      _navigateToAddLink(initialUrl);
    }

    // Listen for subsequent shared URLs (when app is running)
    _subscription = widget.service.sharedUrlStream.listen((url) {
      if (url != null && mounted) {
        _navigateToAddLink(url);
      }
    });
  }

  void _navigateToAddLink(String url) {
    widget.router.go('/add?url=${Uri.encodeComponent(url)}');
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class LinkStoreApp extends StatelessWidget {
  final GoRouter router;
  const LinkStoreApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    // Custom Theme Colors extracted from App Icon
    const Color primaryDark = Color(0xFF6C5CE7);
    const Color primaryMedium = Color(0xFF8B7CF1);
    const Color primaryLight = Color(0xFFA29BFE);
    const Color primaryExtraLight = Color(0xFFC4BFFF);
    const Color background = Color(0xFFFAFAFF);
    const Color surface = Colors.white;
    const Color textPrimary = Color(0xFF2D3436);
    const Color textSecondary = Color(0xFF636E72);
    
    // Gradient Colors for AppBar matching the logo
    const Color appBarGradientStart = Color(0xFF00D9FF); // Cyan from logo
    const Color appBarGradientEnd = Color(0xFF9D50FF);   // Purple from logo
    const Color appBarBackground = Color(0xFF12183D);    // Dark navy background from logo

    return MaterialApp.router(
      title: 'LinkStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryDark,
          brightness: Brightness.light,
          primary: primaryDark,
          onPrimary: Colors.white,
          secondary: primaryMedium,
          onSecondary: Colors.white,
          surface: surface,
          onSurface: textPrimary,
          background: background,
          onBackground: textPrimary,
        ),

        // App Bar Theme
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 2,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        // Card Theme
        cardTheme: CardThemeData(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: primaryDark.withOpacity(0.08),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          highlightElevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryDark,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryDark,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryMedium, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: primaryExtraLight.withOpacity(0.5),
          selectedColor: primaryDark,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Text Theme
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            height: 1.2,
            color: textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            color: textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: textSecondary,
          ),
          labelLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),

        // General Theme Settings
        splashFactory: InkRipple.splashFactory,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: router,
    );
  }
}
