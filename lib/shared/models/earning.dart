class Earning {
  final String id;
  final DateTime date;
  final double value;
  final String? platform;
  final int? numberOfRides;
  final double? hoursWorked;
  final String? notes;

  Earning({
    required this.id,
    required this.date,
    required this.value,
    this.platform,
    this.numberOfRides,
    this.hoursWorked,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'value': value,
      'platform': platform,
      'numberOfRides': numberOfRides,
      'hoursWorked': hoursWorked,
      'notes': notes,
    };
  }

  factory Earning.fromMap(Map<String, dynamic> map) {
    return Earning(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      value: (map['value'] as num).toDouble(),
      platform: map['platform'] as String?,
      numberOfRides: map['numberOfRides'] as int?,
      hoursWorked: (map['hoursWorked'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
    );
  }
}


