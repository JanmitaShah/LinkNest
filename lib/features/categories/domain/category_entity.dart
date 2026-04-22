/// Entity representing a category
class Category {
  final String id;
  final String name;
  final String icon;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Predefined categories for Phase 1
class PredefinedCategories {
  static const List<Category> all = [
    Category(id: 'cooking', name: 'Cooking', icon: '🍳'),
    Category(id: 'health', name: 'Health', icon: '💊'),
    Category(id: 'yoga', name: 'Yoga', icon: '🧘'),
    Category(id: 'motivation', name: 'Motivation', icon: '🔥'),
    Category(id: 'tech', name: 'Tech', icon: '💻'),
    Category(id: 'music', name: 'Music', icon: '🎵'),
    Category(id: 'news', name: 'News', icon: '📰'),
    Category(id: 'other', name: 'Other', icon: '📌'),
  ];

  static Category getById(String id) {
    return all.firstWhere(
      (cat) => cat.id == id,
      orElse: () => all.last,
    );
  }
}