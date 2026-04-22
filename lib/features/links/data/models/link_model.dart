import 'package:hive/hive.dart';
import '../../../../core/constants/hive_constants.dart';
import '../../domain/link_entity.dart';

part 'link_model.g.dart';

@HiveType(typeId: HiveTypeIds.link)
class LinkModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final String notes;

  @HiveField(6)
  final DateTime createdAt;

  LinkModel({
    required this.id,
    required this.url,
    required this.title,
    required this.categoryId,
    required this.tags,
    required this.notes,
    required this.createdAt,
  });

  /// Convert from domain entity to data model
  factory LinkModel.fromEntity(LinkEntity entity) {
    return LinkModel(
      id: entity.id,
      url: entity.url,
      title: entity.title,
      categoryId: entity.categoryId,
      tags: entity.tags,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to domain entity
  LinkEntity toEntity() {
    return LinkEntity(
      id: id,
      url: url,
      title: title,
      categoryId: categoryId,
      tags: tags,
      notes: notes,
      createdAt: createdAt,
    );
  }
}