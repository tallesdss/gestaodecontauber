import 'package:supabase_flutter/supabase_flutter.dart';

/// Cliente mock para testes unitários
SupabaseClient? _mockClient;

/// Permite injetar um mock do SupabaseClient nos testes
set mockSupabaseClient(SupabaseClient client) {
  _mockClient = client;
}

/// Acesso centralizado ao cliente Supabase.
/// Usar em todas as operações (auth, tabelas, storage, RPC).
/// Garantir que o usuário está logado antes de CRUD com [Supabase.instance.client.auth.currentUser].
///
/// Ref: backend.md § 7.1, § 7.2.
SupabaseClient get supabaseClient => _mockClient ?? Supabase.instance.client;
