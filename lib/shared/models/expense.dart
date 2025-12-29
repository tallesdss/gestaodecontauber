class Expense {
  final String id;
  final DateTime date;
  final String category;
  final double value;
  final String description;
  final double? liters; // Apenas para categoria fuel
  final String? receiptImagePath;
  final String? notes;

  Expense({
    required this.id,
    required this.date,
    required this.category,
    required this.value,
    required this.description,
    this.liters,
    this.receiptImagePath,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'category': category,
      'value': value,
      'description': description,
      'liters': liters,
      'receiptImagePath': receiptImagePath,
      'notes': notes,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      category: map['category'] as String,
      value: (map['value'] as num).toDouble(),
      description: map['description'] as String,
      liters: (map['liters'] as num?)?.toDouble(),
      receiptImagePath: map['receiptImagePath'] as String?,
      notes: map['notes'] as String?,
    );
  }
}

