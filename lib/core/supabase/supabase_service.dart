import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_app_client.dart';
import 'supabase_field_mapping.dart';
import '../../shared/models/driver.dart';
import '../../shared/models/earning.dart';
import '../../shared/models/expense.dart';
import '../../shared/models/notification.dart';
import 'dart:typed_data';

class SupabaseService {
  SupabaseService._();

  // ---------------------------------------------------------------------------
  // Drivers
  // ---------------------------------------------------------------------------

  /// Obtém o perfil do motorista para o usuário logado.
  static Future<Driver?> getDriver() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await supabaseClient
        .from('drivers')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;

    final dartMap = SupabaseFieldMapping.fromSupabaseMap(
      response,
      SupabaseFieldMapping.driversSupabaseToDart,
    );
    return Driver.fromMap(dartMap);
  }

  /// Cria ou atualiza o perfil do motorista (upsert).
  static Future<void> upsertDriver(Driver driver) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');

    final driverMap = driver.toMap();
    // Garante que o user_id seja o do usuário logado
    driverMap['userId'] = userId;

    final supabaseMap = SupabaseFieldMapping.toSupabaseMap(
      driverMap,
      SupabaseFieldMapping.driversDartToSupabase,
    );

    await supabaseClient.from('drivers').upsert(
          supabaseMap,
          onConflict: 'user_id',
        );
  }

  // ---------------------------------------------------------------------------
  // Earnings
  // ---------------------------------------------------------------------------

  /// Lista ganhos com paginação e filtro de período opcional.
  static Future<List<Earning>> getEarnings({
    int from = 0,
    int to = 49,
    DateTime? start,
    DateTime? end,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    var query = supabaseClient
        .from('earnings')
        .select()
        .eq('user_id', userId);

    if (start != null) {
      query = query.gte('date', SupabaseFieldMapping.toSupabaseDate(start));
    }
    if (end != null) {
      query = query.lte('date', SupabaseFieldMapping.toSupabaseDate(end));
    }

    final List<dynamic> response = await query
        .order('date', ascending: false)
        .range(from, to);
    return response.map((map) {
      final dartMap = SupabaseFieldMapping.fromSupabaseMap(
        map,
        SupabaseFieldMapping.earningsSupabaseToDart,
      );
      return Earning.fromMap(dartMap);
    }).toList();
  }

  /// Cria um novo registro de ganho.
  static Future<void> createEarning(Earning earning) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    final map = earning.toMap();
    map['userId'] = userId;

    final supabaseMap = SupabaseFieldMapping.toSupabaseMap(
      map,
      SupabaseFieldMapping.earningsDartToSupabase,
    );

    await supabaseClient.from('earnings').insert(supabaseMap);
  }

  /// Atualiza um registro de ganho.
  static Future<void> updateEarning(Earning earning) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    final map = earning.toMap();
    // Remove o ID do body do update para evitar erro do Postgrest
    map.remove('id');

    final supabaseMap = SupabaseFieldMapping.toSupabaseMap(
      map,
      SupabaseFieldMapping.earningsDartToSupabase,
    );

    await supabaseClient
        .from('earnings')
        .update(supabaseMap)
        .eq('id', earning.id)
        .eq('user_id', userId);
  }

  /// Deleta um registro de ganho.
  static Future<void> deleteEarning(String id) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    await supabaseClient
        .from('earnings')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  // ---------------------------------------------------------------------------
  // Expenses
  // ---------------------------------------------------------------------------

  /// Lista despesas com paginação e filtros opcionais.
  static Future<List<Expense>> getExpenses({
    int from = 0,
    int to = 49,
    DateTime? start,
    DateTime? end,
    String? category,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    var query = supabaseClient
        .from('expenses')
        .select()
        .eq('user_id', userId);

    if (start != null) {
      query = query.gte('date', SupabaseFieldMapping.toSupabaseDate(start));
    }
    if (end != null) {
      query = query.lte('date', SupabaseFieldMapping.toSupabaseDate(end));
    }
    if (category != null) {
      query = query.eq('category', category);
    }

    final List<dynamic> response = await query
        .order('date', ascending: false)
        .range(from, to);
    return response.map((map) {
      final dartMap = SupabaseFieldMapping.fromSupabaseMap(
        map,
        SupabaseFieldMapping.expensesSupabaseToDart,
      );
      return Expense.fromMap(dartMap);
    }).toList();
  }

  /// Cria um novo registro de despesa.
  static Future<void> createExpense(Expense expense) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    final map = expense.toMap();
    map['userId'] = userId;

    final supabaseMap = SupabaseFieldMapping.toSupabaseMap(
      map,
      SupabaseFieldMapping.expensesDartToSupabase,
    );

    await supabaseClient.from('expenses').insert(supabaseMap);
  }

  /// Atualiza um registro de despesa.
  static Future<void> updateExpense(Expense expense) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    final map = expense.toMap();
    map.remove('id');

    final supabaseMap = SupabaseFieldMapping.toSupabaseMap(
      map,
      SupabaseFieldMapping.expensesDartToSupabase,
    );

    await supabaseClient
        .from('expenses')
        .update(supabaseMap)
        .eq('id', expense.id)
        .eq('user_id', userId);
  }

  /// Deleta um registro de despesa.
  static Future<void> deleteExpense(String id) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    // Primeiro buscamos o path da imagem para deletar do Storage se existir
    final expenseData = await supabaseClient
        .from('expenses')
        .select('receipt_image_path')
        .eq('id', id)
        .maybeSingle();

    if (expenseData != null && expenseData['receipt_image_path'] != null) {
      await deleteReceiptImage(expenseData['receipt_image_path']);
    }

    await supabaseClient
        .from('expenses')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  // ---------------------------------------------------------------------------
  // Storage (Receipts & Avatars)
  // ---------------------------------------------------------------------------

  /// Faz upload de uma imagem para o bucket 'receipts'.
  static Future<String> uploadReceiptImage(String path, List<int> bytes) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    // O path já deve ser o nome do arquivo final, ex: 'userid/expenses/uuid.jpg'
    await supabaseClient.storage.from('receipts').uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
        );

    return path;
  }

  /// Gera uma URL assinada para visualização temporária do comprovante.
  static Future<String> getReceiptSignedUrl(String path) async {
    return await supabaseClient.storage
        .from('receipts')
        .createSignedUrl(path, 60);
  }

  /// Deleta uma imagem do Storage.
  static Future<void> deleteReceiptImage(String path) async {
    await supabaseClient.storage.from('receipts').remove([path]);
  }

  /// Faz upload de uma imagem para o bucket 'avatars'.
  static Future<String> uploadAvatar(List<int> bytes) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    final path = '$userId/avatar.jpg';
    await supabaseClient.storage.from('avatars').uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
        );

    // Retorna a URL pública com um timestamp para evitar cache
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${supabaseClient.storage.from('avatars').getPublicUrl(path)}?t=$timestamp';
  }

  /// Deleta a imagem do avatar.
  static Future<void> deleteAvatar() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    final path = '$userId/avatar.jpg';
    await supabaseClient.storage.from('avatars').remove([path]);
  }

  // ---------------------------------------------------------------------------
  // RPC / Calculations
  // ---------------------------------------------------------------------------

  /// Chama a função RPC 'get_period_totals' para obter totais e lucro líquido.
  static Future<Map<String, double>> getPeriodTotals(
      DateTime start, DateTime end) async {
    final response = await supabaseClient.rpc(
      'get_period_totals',
      params: {
        'p_start': SupabaseFieldMapping.toSupabaseDate(start),
        'p_end': SupabaseFieldMapping.toSupabaseDate(end),
      },
    );

    // O retorno esperado é uma lista de um objeto: [{total_earnings: X, total_expenses: Y, net_profit: Z}]
    if (response is List && response.isNotEmpty) {
      final data = response.first;
      return {
        'totalEarnings': (data['total_earnings'] as num?)?.toDouble() ?? 0.0,
        'totalExpenses': (data['total_expenses'] as num?)?.toDouble() ?? 0.0,
        'netProfit': (data['net_profit'] as num?)?.toDouble() ?? 0.0,
      };
    }

    return {
      'totalEarnings': 0.0,
      'totalExpenses': 0.0,
      'netProfit': 0.0,
    };
  }

  /// Chama a função RPC 'get_daily_totals' para obter totais diários.
  static Future<List<Map<String, dynamic>>> getDailyTotals(
      DateTime start, DateTime end) async {
    final response = await supabaseClient.rpc(
      'get_daily_totals',
      params: {
        'p_start': SupabaseFieldMapping.toSupabaseDate(start),
        'p_end': SupabaseFieldMapping.toSupabaseDate(end),
      },
    );

    if (response is List) {
      return response.map((data) => {
        'date': DateTime.parse(data['total_date'] as String),
        'totalEarnings': (data['total_earnings'] as num?)?.toDouble() ?? 0.0,
        'totalExpenses': (data['total_expenses'] as num?)?.toDouble() ?? 0.0,
        'netProfit': (data['net_profit'] as num?)?.toDouble() ?? 0.0,
      }).toList();
    }

    return [];
  }

  /// Chama a função RPC 'get_expenses_by_category' para obter gastos por categoria.
  static Future<List<Map<String, dynamic>>> getExpensesByCategory(
      DateTime start, DateTime end) async {
    final response = await supabaseClient.rpc(
      'get_expenses_by_category',
      params: {
        'p_start': SupabaseFieldMapping.toSupabaseDate(start),
        'p_end': SupabaseFieldMapping.toSupabaseDate(end),
      },
    );

    if (response is List) {
      return response.map((data) => {
        'category': data['category'] as String,
        'totalValue': (data['total_value'] as num?)?.toDouble() ?? 0.0,
      }).toList();
    }
    return [];
  }

  // ---------------------------------------------------------------------------
  // History (Fase 7 Etapa B)
  // ---------------------------------------------------------------------------

  /// Retorna os anos distintos em que o motorista possui registros.
  static Future<List<int>> getAvailableYears() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabaseClient.rpc('get_available_years');

    if (response is List) {
      return response.map((row) => (row['year'] as num).toInt()).toList();
    }
    return [];
  }

  /// Retorna totais de ganhos e gastos para o período informado.
  /// Se [month] for null, consolida o ano inteiro.
  static Future<Map<String, double>> getHistorySummary(
      int year, {int? month}) async {
    final params = <String, dynamic>{'p_year': year};
    if (month != null) params['p_month'] = month;

    final response = await supabaseClient.rpc('get_history_summary', params: params);

    if (response is List && response.isNotEmpty) {
      final data = response.first;
      return {
        'totalEarnings': (data['total_earnings'] as num?)?.toDouble() ?? 0.0,
        'totalExpenses': (data['total_expenses'] as num?)?.toDouble() ?? 0.0,
      };
    }
    return {'totalEarnings': 0.0, 'totalExpenses': 0.0};
  }

  /// Retorna o breakdown mensal (ganhos, gastos, lucro por mês) de um dado ano.
  static Future<List<Map<String, dynamic>>> getMonthlyBreakdown(int year) async {
    final response = await supabaseClient.rpc(
      'get_monthly_breakdown',
      params: {'p_year': year},
    );

    if (response is List) {
      return response.map((row) => {
        'month':    (row['month']    as num).toInt(),
        'earnings': (row['earnings'] as num?)?.toDouble() ?? 0.0,
        'expenses': (row['expenses'] as num?)?.toDouble() ?? 0.0,
        'profit':   (row['profit']   as num?)?.toDouble() ?? 0.0,
      }).toList();
    }
    return [];
  }

  /// Retorna o breakdown semanal (ganhos, gastos, lucro por semana) de um dado mês/ano.
  static Future<List<Map<String, dynamic>>> getWeeklyBreakdown(
      int year, int month) async {
    final response = await supabaseClient.rpc(
      'get_weekly_breakdown',
      params: {'p_year': year, 'p_month': month},
    );

    if (response is List) {
      return response.map((row) => {
        'week':     (row['week']     as num).toInt(),
        'earnings': (row['earnings'] as num?)?.toDouble() ?? 0.0,
        'expenses': (row['expenses'] as num?)?.toDouble() ?? 0.0,
        'profit':   (row['profit']   as num?)?.toDouble() ?? 0.0,
      }).toList();
    }
    return [];
  }

  /// Busca as transações recentes (ganhos + gastos) de um dado período.
  /// Retorna uma lista mesclada ordenada por data decrescente (limite 10).
  static Future<List<Map<String, dynamic>>> getRecentTransactionsForHistory(
      int year, int month) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    final start = SupabaseFieldMapping.toSupabaseDate(DateTime(year, month, 1));
    final end   = SupabaseFieldMapping.toSupabaseDate(
      DateTime(year, month + 1, 0), // último dia do mês
    );

    final earningsResp = await supabaseClient
        .from('earnings')
        .select('id, date, value, platform')
        .eq('user_id', userId)
        .gte('date', start)
        .lte('date', end)
        .order('date', ascending: false)
        .limit(10);

    final expensesResp = await supabaseClient
        .from('expenses')
        .select('id, date, value, description, category')
        .eq('user_id', userId)
        .gte('date', start)
        .lte('date', end)
        .order('date', ascending: false)
        .limit(10);

    final List<Map<String, dynamic>> merged = [];

    for (final row in (earningsResp as List)) {
      final date = DateTime.parse(row['date'] as String);
      merged.add({
        'type':  'earning',
        'date':  date,
        'value': (row['value'] as num).toDouble(),
        'desc':  row['platform'] as String? ?? 'Ganho',
      });
    }
    for (final row in (expensesResp as List)) {
      final date = DateTime.parse(row['date'] as String);
      merged.add({
        'type':  'expense',
        'date':  date,
        'value': (row['value'] as num).toDouble(),
        'desc':  row['description'] as String? ??
                 row['category']    as String? ?? 'Despesa',
      });
    }

    // Ordena por data decrescente e limita a 10
    merged.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return merged.take(10).toList();
  }

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  /// Lista notificações do usuário logado.
  static Future<List<AppNotification>> getNotifications({
    int from = 0,
    int to = 49,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(from, to);

    return (response as List).map((map) {
      final dartMap = SupabaseFieldMapping.fromSupabaseMap(
        map,
        SupabaseFieldMapping.notificationsSupabaseToDart,
      );
      return AppNotification.fromMap(dartMap);
    }).toList();
  }

  /// Marca uma notificação como lida.
  static Future<void> markNotificationAsRead(String id) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    await supabaseClient
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id)
        .eq('user_id', userId);
  }

  /// Marca todas as notificações como lidas.
  static Future<void> markAllNotificationsAsRead() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    await supabaseClient
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId);
  }

  /// Deleta uma notificação.
  static Future<void> deleteNotification(String id) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Não autenticado');

    await supabaseClient
        .from('notifications')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  /// Conta notificações não lidas.
  static Future<int> getUnreadNotificationsCount() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return 0;

    final response = await supabaseClient
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false);

    return response.length;
  }
}
