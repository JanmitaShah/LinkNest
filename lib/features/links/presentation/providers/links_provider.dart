import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/link_local_datasource.dart';
import '../../data/repositories/link_repository_impl.dart';
import '../../domain/link_entity.dart';
import '../../domain/link_repository.dart';
import '../../domain/link_usecases.dart';

/// Provider for local data source
final linkLocalDataSourceProvider = Provider<LinkLocalDataSource>((ref) {
  return LinkLocalDataSource();
});

/// Provider for link repository
final linkRepositoryProvider = Provider<LinkRepository>((ref) {
  final localDataSource = ref.watch(linkLocalDataSourceProvider);
  return LinkRepositoryImpl(localDataSource);
});

/// Provider for add link use case
final addLinkUseCaseProvider = Provider<AddLinkUseCase>((ref) {
  final repository = ref.watch(linkRepositoryProvider);
  return AddLinkUseCase(repository);
});

/// Provider for get all links use case
final getAllLinksUseCaseProvider = Provider<GetAllLinksUseCase>((ref) {
  final repository = ref.watch(linkRepositoryProvider);
  return GetAllLinksUseCase(repository);
});

/// Provider for search links use case
final searchLinksUseCaseProvider = Provider<SearchLinksUseCase>((ref) {
  final repository = ref.watch(linkRepositoryProvider);
  return SearchLinksUseCase(repository);
});

/// State notifier for managing links list
class LinksNotifier extends StateNotifier<AsyncValue<List<LinkEntity>>> {
  final GetAllLinksUseCase _getAllLinksUseCase;
  final SearchLinksUseCase _searchLinksUseCase;
  final AddLinkUseCase _addLinkUseCase;

  LinksNotifier({
    required GetAllLinksUseCase getAllLinksUseCase,
    required SearchLinksUseCase searchLinksUseCase,
    required AddLinkUseCase addLinkUseCase,
  })  : _getAllLinksUseCase = getAllLinksUseCase,
        _searchLinksUseCase = searchLinksUseCase,
        _addLinkUseCase = addLinkUseCase,
        super(const AsyncValue.loading()) {
    loadLinks();
  }

  /// Load all links
  Future<void> loadLinks() async {
    state = const AsyncValue.loading();
    try {
      final links = await _getAllLinksUseCase();
      state = AsyncValue.data(links);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Add a new link
  Future<void> addLink(LinkEntity link) async {
    try {
      await _addLinkUseCase(link);
      await loadLinks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Search links
  Future<void> searchLinks(String query) async {
    state = const AsyncValue.loading();
    try {
      final links = await _searchLinksUseCase(query);
      state = AsyncValue.data(links);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for links state notifier
final linksNotifierProvider =
    StateNotifierProvider<LinksNotifier, AsyncValue<List<LinkEntity>>>((ref) {
  return LinksNotifier(
    getAllLinksUseCase: ref.watch(getAllLinksUseCaseProvider),
    searchLinksUseCase: ref.watch(searchLinksUseCaseProvider),
    addLinkUseCase: ref.watch(addLinkUseCaseProvider),
  );
});

/// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');