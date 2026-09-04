/// Store MobX da tela de Login (Reqs 1.5, 3.3, 3.4, 3.5, 3.6).
///
/// Mantém o estado reativo do formulário de login — email, senha, visibilidade
/// da senha e "remember me" — e deriva a validação por computeds
/// ([isEmailValid], [isPasswordValid], [canSubmit]). Registrada via
/// `@injectable` (factory: nova instância por tela) e resolvível pelo
/// DI_Container.
library;

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

/// Expressão regular usada para classificar o formato de um endereço de email.
///
/// Exige uma parte local sem espaços, um `@`, um domínio e um TLD com ao menos
/// dois caracteres. Strings sem `@` ou sem domínio são classificadas como
/// inválidas (Reqs 3.5, 3.6).
final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

/// Store da tela de Login.
@injectable
class LoginStore = LoginStoreBase with _$LoginStore;

/// Base observável de [LoginStore].
abstract class LoginStoreBase with Store {
  /// Email digitado pelo cliente.
  @observable
  String email = '';

  /// Senha digitada pelo cliente.
  @observable
  String password = '';

  /// Indica se o texto da senha está oculto (Req 3.3).
  @observable
  bool obscurePassword = true;

  /// Indica se a opção "Remember me" está ativada (Req 3.4).
  @observable
  bool rememberMe = false;

  /// Verdadeiro se o [email] (após trim) tem formato de email válido (Req 3.5).
  @computed
  bool get isEmailValid => _emailRegex.hasMatch(email.trim());

  /// Verdadeiro se a [password] não está vazia nem contém apenas espaços em
  /// branco (Req 3.6). Senhas vazias ou compostas somente por whitespace são
  /// classificadas como inválidas.
  @computed
  bool get isPasswordValid => password.trim().isNotEmpty;

  /// Verdadeiro quando email e senha são válidos, habilitando o SIGN IN.
  @computed
  bool get canSubmit => isEmailValid && isPasswordValid;

  /// Atualiza o [email] com o [value] informado.
  @action
  void setEmail(String value) => email = value;

  /// Atualiza a [password] com o [value] informado.
  @action
  void setPassword(String value) => password = value;

  /// Alterna a visibilidade do texto da senha entre oculto e visível (Req 3.3).
  @action
  void togglePasswordVisibility() => obscurePassword = !obscurePassword;

  /// Alterna o estado de "Remember me" entre ativado e desativado (Req 3.4).
  @action
  void toggleRememberMe() => rememberMe = !rememberMe;
}
