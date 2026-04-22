import 'link_entity.dart';

/// Abstract repository interface for links
abstract class LinkRepository {
  /// Get all saved links
  Future<List<LinkEntity>> getAllLinks();

  /// Add a new link
  Future<void> addLink(LinkEntity link);

  /// Search links by query (searches in title, tags, notes)
  Future<List<LinkEntity>> searchLinks(String query);
}