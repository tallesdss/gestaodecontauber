class Expense {
  final String id;
  final String? userId;
  final DateTime date;
  final String category;
  final double value;
  final String description;
  final double? liters; // Apenas para categoria fuel
  final String? receiptImagePath;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    required this.id,
    this.userId,
    required this.date,
    required this.category,
    required this.value,
    required this.description,
    this.liters,
    this.receiptImagePath,
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
      'category': category,
      'value': value,
      'description': description,
      'liters': liters,
      'receiptImagePath': receiptImagePath,
      'notes': notes,
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      userId: map['userId'] as String?,
      date: _parseDate(map['date'] as String),
      category: map['category'] as String,
      value: (map['value'] as num).toDouble(),
      description: map['description'] as String,
      liters: (map['liters'] as num?)?.toDouble(),
      receiptImagePath: map['receiptImagePath'] as String?,
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
