import 'package:supabase_flutter/supabase_flutter.dart';

/// Acesso centralizado ao cliente Supabase.
/// Usar em todas as operações (auth, tabelas, storage, RPC).
/// Garantir que o usuário está logado antes de CRUD com [Supabase.instance.client.auth.currentUser].
///
/// Ref: backend.md § 7.1, § 7.2.
SupabaseClient get supabaseClient => Supabase.instance.client;
