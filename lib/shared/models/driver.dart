class Driver {
  final String name;
  final double monthlyGoal;
  final DateTime? memberSince;

  Driver({
    required this.name,
    required this.monthlyGoal,
    this.memberSince,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'monthlyGoal': monthlyGoal,
      'memberSince': memberSince?.toIso8601String(),
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      name: map['name'] as String,
      monthlyGoal: (map['monthlyGoal'] as num).toDouble(),
      memberSince: map['memberSince'] != null
          ? DateTime.parse(map['memberSince'] as String)
          : null,
    );
  }
}






