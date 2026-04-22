import '../../domain/link_entity.dart';
import '../../domain/link_repository.dart';
import '../datasources/link_local_datasource.dart';
import '../models/link_model.dart';

/// Implementation of LinkRepository using local Hive storage
class LinkRepositoryImpl implements LinkRepository {
  final LinkLocalDataSource _localDataSource;

  LinkRepositoryImpl(this._localDataSource);

  @override
  Future<List<LinkEntity>> getAllLinks() async {
    final models = await _localDataSource.getAllLinks();
    // Sort by creation date, newest first
    models.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addLink(LinkEntity link) async {
    final model = LinkModel.fromEntity(link);
    await _localDataSource.addLink(model);
  }

  @override
  Future<List<LinkEntity>> searchLinks(String query) async {
    if (query.isEmpty) {
      return getAllLinks();
    }
    final models = await _localDataSource.searchLinks(query);
    // Sort by creation date, newest first
    models.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return models.map((model) => model.toEntity()).toList();
  }
}