class Category {
  final String id;
  final String name;
  final String imagePath;
  final bool isTrending;

  const Category({
    required this.id,
    required this.name,
    required this.imagePath,
    this.isTrending = false,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      isTrending: map['isTrending'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'isTrending': isTrending,
    };
  }
}
