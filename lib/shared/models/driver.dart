class Driver {
  final String? id;
  final String? userId;
  final String name;
  final double monthlyGoal;
  final String? avatarUrl;
  final DateTime? memberSince;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Driver({
    this.id,
    this.userId,
    required this.name,
    required this.monthlyGoal,
    this.avatarUrl,
    this.memberSince,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'name': name,
      'monthlyGoal': monthlyGoal,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'memberSince': memberSince != null
          ? _dateOnlyIso8601(memberSince!)
          : null,
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] as String?,
      userId: map['userId'] as String?,
      name: map['name'] as String,
      monthlyGoal: (map['monthlyGoal'] as num).toDouble(),
      avatarUrl: map['avatarUrl'] as String?,
      memberSince: map['memberSince'] != null
          ? _parseDate(map['memberSince'] as String)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  /// Formata apenas a data (YYYY-MM-DD) para campos date do Supabase.
  static String _dateOnlyIso8601(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  static DateTime _parseDate(String value) {
    final parsed = DateTime.parse(value);
    return DateTime.utc(parsed.year, parsed.month, parsed.day);
  }
}
