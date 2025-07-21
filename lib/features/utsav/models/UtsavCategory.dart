class UtsavCategory {
  final String id;
  final String name;
  final String? description;
  final String imagePath;
  final bool isPopular;

  const UtsavCategory({
    required this.id,
    required this.name,
    this.description,
    required this.imagePath,
    this.isPopular = false,
  });

  factory UtsavCategory.fromMap(Map<String, dynamic> map) {
    return UtsavCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      imagePath: map['imagePath'] as String,
      isPopular: map['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'isPopular': isPopular,
    };
  }
}
