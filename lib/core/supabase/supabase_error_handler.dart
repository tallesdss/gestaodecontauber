import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseErrorHandler {
  static String mapError(dynamic error) {
    if (error is AuthException) {
      return _mapAuthError(error);
    } else if (error is PostgrestException) {
      return _mapPostgrestError(error);
    } else if (error is StorageException) {
      return _mapStorageError(error);
    }
    
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }

  static String _mapAuthError(AuthException error) {
    switch (error.message) {
      case 'Invalid login credentials':
        return 'E-mail ou senha incorretos.';
      case 'User already registered':
        return 'Este e-mail já está cadastrado.';
      case 'Email not confirmed':
        return 'Por favor, confirme seu e-mail antes de entrar.';
      case 'Password is too short':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'Invalid email':
        return 'O e-mail digitado é inválido.';
      default:
        // Mensagens comuns do GoTrue
        if (error.message.contains('rate limit')) {
          return 'Muitas tentativas. Tente novamente mais tarde.';
        }
        return error.message;
    }
  }

  static String _mapPostgrestError(PostgrestException error) {
    // Verificamos o código do erro (PostgreSQL Error Codes)
    switch (error.code) {
      case '23505': // unique_violation
        return 'Este registro já existe no sistema.';
      case '23503': // foreign_key_violation
        return 'Não foi possível completar a operação pois este item está sendo usado.';
      case '42P01': // undefined_table
        return 'Erro de configuração do banco de dados (tabela não encontrada).';
      case 'PGRST116': // JSON object expected, but 0 rows returned
        return 'Registro não encontrado.';
      default:
        return 'Erro ao acessar os dados. Tente novamente.';
    }
  }

  static String _mapStorageError(StorageException error) {
    switch (error.message) {
      case 'Entity too large':
        return 'O arquivo é muito grande. O limite é 5MB.';
      case 'Object already exists':
        return 'Já existe um arquivo com este nome.';
      default:
        return 'Erro ao processar o arquivo no servidor.';
    }
  }
}
