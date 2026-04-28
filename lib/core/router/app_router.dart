import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/links/presentation/screens/home_screen.dart';
import '../../features/links/presentation/screens/webview_screen.dart';
import '../../features/links/presentation/screens/add_link_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/banner_ad_widget.dart';

/// Creates the app router with optional navigator key
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Column(
            children: [
              Expanded(child: child),
              const BannerAdWidget(),
            ],
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/webview',
            name: 'webview',
            builder: (context, state) {
              final url = state.uri.queryParameters['url'] ?? '';
              final title = state.uri.queryParameters['title'] ?? 'Link';
              return WebViewScreen(url: url, title: title);
            },
          ),
          GoRoute(
            path: '/add',
            name: 'add',
            builder: (context, state) {
              final initialUrl = state.uri.queryParameters['url'];
              return AddLinkScreen(initialUrl: initialUrl);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
