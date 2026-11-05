class Mission {
  const Mission({
    required this.id,
    required this.title,
    required this.category,
    required this.points,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
    this.isCustom = false,
  });

  final String id;
  final String title;
  final String category;
  final int points;
  final DateTime createdAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool isCustom;

  Mission copyWith({
    String? title,
    String? category,
    int? points,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Mission(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      points: points ?? this.points,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      isCustom: isCustom,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'points': points,
        'createdAt': createdAt.toIso8601String(),
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'isCustom': isCustom,
      };

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      points: json['points'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }
}
