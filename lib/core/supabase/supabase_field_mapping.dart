// Mapeamento oficial entre colunas do Supabase (snake_case) e campos Dart (camelCase).
//
// Consultar este arquivo ao implementar:
// - § 7.3 Camada de conversão (toSupabaseMap / fromSupabaseMap)
// - § 7.6 Atualização dos modelos Dart
//
// Ref: backend.md § 3.

class SupabaseFieldMapping {
  SupabaseFieldMapping._();

  /// Converte um mapa Dart (camelCase) para um mapa Supabase (snake_case).
  ///
  /// Usa o [mapping] fornecido (ex: [driversDartToSupabase]) para traduzir as chaves.
  /// Valores que sejam [DateTime] são convertidos para string ISO8601 UTC.
  static Map<String, dynamic> toSupabaseMap(
    Map<String, dynamic> dartMap,
    Map<String, String> mapping,
  ) {
    final Map<String, dynamic> supabaseMap = {};
    dartMap.forEach((key, value) {
      final supabaseKey = mapping[key];
      if (supabaseKey != null) {
        var processedValue = value;

        // Garantia de conversão para DateTime se não tiver sido feito no model
        if (value is DateTime) {
          processedValue = value.toUtc().toIso8601String();
        }

        supabaseMap[supabaseKey] = processedValue;
      }
    });
    return supabaseMap;
  }

  /// Converte um mapa Supabase (snake_case) para um mapa Dart (camelCase).
  ///
  /// Usa o [mapping] fornecido (ex: [driversSupabaseToDart]) para traduzir as chaves.
  /// Garante que valores numéricos possam ser tratados como double no Dart.
  static Map<String, dynamic> fromSupabaseMap(
    Map<String, dynamic> supabaseMap,
    Map<String, String> mapping,
  ) {
    final Map<String, dynamic> dartMap = {};
    supabaseMap.forEach((key, value) {
      final dartKey = mapping[key];
      if (dartKey != null) {
        // No fromMap do model, costumamos usar (value as num).toDouble(),
        // mas aqui mantemos o valor bruto para o model processar.
        dartMap[dartKey] = value;
      }
    });
    return dartMap;
  }

  /// Converte DateTime para string 'YYYY-MM-DD'.
  static String toSupabaseDate(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  // ---------------------------------------------------------------------------
  // drivers
  // ---------------------------------------------------------------------------

  /// Coluna Supabase → campo Dart
  static const Map<String, String> driversSupabaseToDart = {
    'id': 'id',
    'user_id': 'userId',
    'name': 'name',
    'monthly_goal': 'monthlyGoal',
    'avatar_url': 'avatarUrl',
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
    'avatarUrl': 'avatar_url',
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
    'user_id': 'userId',
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
    'userId': 'user_id',
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
    'user_id': 'userId',
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
    'userId': 'user_id',
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
