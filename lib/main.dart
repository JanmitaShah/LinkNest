import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/hive_constants.dart';
import 'core/router/app_router.dart';
import 'features/links/data/models/link_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(LinkModelAdapter());

  // Open Hive boxes
  await Hive.openBox<LinkModel>(HiveBoxNames.links);

  runApp(const ProviderScope(child: LinkNestApp()));
}

class LinkNestApp extends StatelessWidget {
  const LinkNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LinkNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}