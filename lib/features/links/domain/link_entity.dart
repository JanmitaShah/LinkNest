/// Entity representing a saved link
class LinkEntity {
  final String id;
  final String url;
  final String title;
  final String categoryId;
  final List<String> tags;
  final String notes;
  final DateTime createdAt;

  const LinkEntity({
    required this.id,
    required this.url,
    required this.title,
    required this.categoryId,
    required this.tags,
    required this.notes,
    required this.createdAt,
  });

  LinkEntity copyWith({
    String? id,
    String? url,
    String? title,
    String? categoryId,
    List<String>? tags,
    String? notes,
    DateTime? createdAt,
  }) {
    return LinkEntity(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}