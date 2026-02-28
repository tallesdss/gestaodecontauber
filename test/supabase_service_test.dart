import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ubercontrol/core/supabase/supabase_app_client.dart';
import 'package:ubercontrol/core/supabase/supabase_service.dart';
import 'package:ubercontrol/shared/models/driver.dart';
import 'package:ubercontrol/shared/models/earning.dart';

// Mocks
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}
class FakePostgrestTransformBuilder extends Fake implements PostgrestTransformBuilder<Map<String, dynamic>?> {
  final Map<String, dynamic>? _data;
  FakePostgrestTransformBuilder(this._data);

  @override
  Future<R> then<R>(FutureOr<R> Function(Map<String, dynamic>?) onValue, {Function? onError}) async {
    return onValue(_data);
  }
}

void main() {
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();

    when(() => mockClient.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('user-123');

    // Injetar mock
    mockSupabaseClient = mockClient;
  });

  group('SupabaseService - getDriver:', () {
    test('Retorna null se não houver usuário logado', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      final driver = await SupabaseService.getDriver();
      expect(driver, isNull);
    });

    test('Retorna driver corretamente se ele existir', () async {
      final mockData = {
        'id': 'drv-1',
        'user_id': 'user-123',
        'name': 'João',
        'monthly_goal': 5000.0,
        'member_since': '2023-01-01',
      };

      final fakeTransform = FakePostgrestTransformBuilder(mockData);

      when(() => mockClient.from('drivers')).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.select(any())).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.eq('user_id', 'user-123')).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer((_) => fakeTransform);

      final driver = await SupabaseService.getDriver();
      expect(driver, isNotNull);
      expect(driver!.name, 'João');
      expect(driver.monthlyGoal, 5000.0);
    });
  });

  group('SupabaseService - getEarnings:', () {
    test('Retorna lista vazia se não houver usuário logado', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      final earnings = await SupabaseService.getEarnings();
      expect(earnings, isEmpty);
    });
  });
}
