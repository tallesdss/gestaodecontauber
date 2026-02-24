class Earning {
  final String id;
  final String? userId;
  final DateTime date;
  final double value;
  final String? platform;
  final int? numberOfRides;
  final double? hoursWorked;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Earning({
    required this.id,
    this.userId,
    required this.date,
    required this.value,
    this.platform,
    this.numberOfRides,
    this.hoursWorked,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  /// Formata apenas a data (YYYY-MM-DD) para o campo date do Supabase.
  static String _dateOnlyIso8601(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  static DateTime _parseDate(String value) {
    final parsed = DateTime.parse(value);
    return DateTime.utc(parsed.year, parsed.month, parsed.day);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (userId != null) 'userId': userId,
      'date': _dateOnlyIso8601(date),
      'value': value,
      'platform': platform,
      'numberOfRides': numberOfRides,
      'hoursWorked': hoursWorked,
      'notes': notes,
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
    };
  }

  factory Earning.fromMap(Map<String, dynamic> map) {
    return Earning(
      id: map['id'] as String,
      userId: map['userId'] as String?,
      date: _parseDate(map['date'] as String),
      value: (map['value'] as num).toDouble(),
      platform: map['platform'] as String?,
      numberOfRides: map['numberOfRides'] as int?,
      hoursWorked: (map['hoursWorked'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }
}
