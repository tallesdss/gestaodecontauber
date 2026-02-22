/// Mapeamento oficial entre colunas do Supabase (snake_case) e campos Dart (camelCase).
///
/// Consultar este arquivo ao implementar:
/// - § 7.3 Camada de conversão (toSupabaseMap / fromSupabaseMap)
/// - § 7.6 Atualização dos modelos Dart
///
/// Ref: backend.md § 3.

class SupabaseFieldMapping {
  SupabaseFieldMapping._();

  // ---------------------------------------------------------------------------
  // drivers
  // ---------------------------------------------------------------------------

  /// Coluna Supabase → campo Dart
  static const Map<String, String> driversSupabaseToDart = {
    'id': 'id',
    'user_id': 'userId',
    'name': 'name',
    'monthly_goal': 'monthlyGoal',
    'member_since': 'memberSince',
    'created_at': 'createdAt',
    'updated_at': 'updatedAt',
  };

  /// Campo Dart → coluna Supabase
  static const Map<String, String> driversDartToSupabase = {
    'id': 'id',
    'userId': 'user_id',
    'name': 'name',
    'monthlyGoal': 'monthly_goal',
    'memberSince': 'member_since',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  };

  // ---------------------------------------------------------------------------
  // earnings
  // ---------------------------------------------------------------------------

  /// Coluna Supabase → campo Dart
  static const Map<String, String> earningsSupabaseToDart = {
    'id': 'id',
    'date': 'date',
    'value': 'value',
    'platform': 'platform',
    'number_of_rides': 'numberOfRides',
    'hours_worked': 'hoursWorked',
    'notes': 'notes',
    'created_at': 'createdAt',
    'updated_at': 'updatedAt',
  };

  /// Campo Dart → coluna Supabase
  static const Map<String, String> earningsDartToSupabase = {
    'id': 'id',
    'date': 'date',
    'value': 'value',
    'platform': 'platform',
    'numberOfRides': 'number_of_rides',
    'hoursWorked': 'hours_worked',
    'notes': 'notes',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  };

  // ---------------------------------------------------------------------------
  // expenses
  // ---------------------------------------------------------------------------

  /// Coluna Supabase → campo Dart
  static const Map<String, String> expensesSupabaseToDart = {
    'id': 'id',
    'date': 'date',
    'category': 'category',
    'value': 'value',
    'description': 'description',
    'liters': 'liters',
    'receipt_image_path': 'receiptImagePath',
    'notes': 'notes',
    'created_at': 'createdAt',
    'updated_at': 'updatedAt',
  };

  /// Campo Dart → coluna Supabase
  static const Map<String, String> expensesDartToSupabase = {
    'id': 'id',
    'date': 'date',
    'category': 'category',
    'value': 'value',
    'description': 'description',
    'liters': 'liters',
    'receiptImagePath': 'receipt_image_path',
    'notes': 'notes',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  };
}
