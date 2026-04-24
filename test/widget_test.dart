// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_nest/main.dart';
import 'package:link_nest/core/router/app_router.dart';
import 'package:link_nest/features/links/presentation/providers/links_provider.dart';
import 'package:link_nest/features/links/domain/link_repository.dart';
import 'package:link_nest/features/links/domain/link_entity.dart';

void main() {
  testWidgets('LinkNest app loads correctly', (WidgetTester tester) async {
    final router = createAppRouter();

    // Mock repository to avoid Hive initialization
    final mockRepository = MockLinkRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          linkRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: LinkNestApp(router: router),
      ),
    );

    // Verify that the app loads (the title should be visible)
    expect(find.text('LinkNest'), findsOneWidget);
  });
}

/// Mock implementation of LinkRepository for testing
class MockLinkRepository implements LinkRepository {
  @override
  Future<void> addLink(LinkEntity link) async {}

  @override
  Future<List<LinkEntity>> getAllLinks() async => [];

  @override
  Future<List<LinkEntity>> searchLinks(String query) async => [];
}
