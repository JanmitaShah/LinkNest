import 'package:hive/hive.dart';
import '../../../../core/constants/hive_constants.dart';
import '../models/link_model.dart';

/// Local data source for links using Hive
class LinkLocalDataSource {
  Box<LinkModel>? _box;

  Future<Box<LinkModel>> get box async {
    _box ??= await Hive.openBox<LinkModel>(HiveBoxNames.links);
    return _box!;
  }

  /// Get all links from local storage
  Future<List<LinkModel>> getAllLinks() async {
    final linkBox = await box;
    return linkBox.values.toList();
  }

  /// Add a new link to local storage
  Future<void> addLink(LinkModel link) async {
    final linkBox = await box;
    await linkBox.put(link.id, link);
  }

  /// Search links by query
  Future<List<LinkModel>> searchLinks(String query) async {
    final linkBox = await box;
    final lowercaseQuery = query.toLowerCase();
    
    return linkBox.values.where((link) {
      final titleMatch = link.title.toLowerCase().contains(lowercaseQuery);
      final notesMatch = link.notes.toLowerCase().contains(lowercaseQuery);
      final tagsMatch = link.tags.any(
        (tag) => tag.toLowerCase().contains(lowercaseQuery),
      );
      return titleMatch || notesMatch || tagsMatch;
    }).toList();
  }

  /// Delete a link from local storage
  Future<void> deleteLink(String linkId) async {
    final linkBox = await box;
    await linkBox.delete(linkId);
  }
}
