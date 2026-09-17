/// Dublê mínimo de [AuthRepository] para testes de [LoginStore] que não
/// exercitam o fluxo de login em si (validação de campos, toggles, etc.).
library;

import 'package:coffe_plus/features/login/data/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository();

  @override
  Future<String> login({required String login, required String senha}) =>
      throw UnimplementedError('Não utilizado neste teste.');
}
