import 'package:coffe_plus/features/login/stores/login_store.dart';
import 'package:glados/glados.dart';

import 'fake_auth_repository.dart';

/// Expressão regular de referência para o formato de email.
///
/// Espelha exatamente a regra usada pelo [LoginStore]: parte local sem espaços,
/// um `@`, um domínio e um TLD com ao menos dois caracteres. Serve como
/// verificação independente para a classificação de validade (Reqs 3.5, 3.6).
final RegExp _referenceEmailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

/// Gerador de emails em formato válido (`local@domain.tld`).
///
/// Combina partes local, domínio e TLD compostas apenas de letras, garantindo
/// que a string resultante corresponda ao formato de email esperado.
Generator<String> get anyValidEmail => any.combine3(
  any.nonEmptyLetters,
  any.nonEmptyLetters,
  any.nonEmptyLetters,
  (local, domain, tld) => '$local@$domain.${tld}x',
);

/// Gerador de strings claramente inválidas como email.
///
/// Cobre os casos citados na propriedade: strings sem `@`, sem domínio, vazias
/// ou compostas apenas de espaços em branco.
Generator<String> get anyInvalidEmail => any.oneOf([
  // Sem `@`: apenas letras.
  any.letters,
  // Sem domínio: termina em `@` logo após a parte local.
  any.nonEmptyLetters.map((local) => '$local@'),
  // Sem TLD: possui `@` e texto, mas sem `.tld`.
  any.combine2(
    any.nonEmptyLetters,
    any.nonEmptyLetters,
    (local, domain) => '$local@$domain',
  ),
  // Vazia.
  any.always(''),
  // Apenas espaços em branco.
  any.always('   '),
]);

/// Gerador `any.email`: mistura de emails válidos e strings inválidas.
Generator<String> get anyEmail => any.oneOf([anyValidEmail, anyInvalidEmail]);

void main() {
  // Feature: coffee-shop-app, Property 5
  //
  // Property 5: Email validity classification.
  //
  // For any string de email, `isEmailValid` é verdadeiro se e somente se a
  // string (após trim) corresponde ao formato de email; strings sem `@` ou sem
  // domínio são classificadas como inválidas.
  //
  // Validates: Requirements 3.5, 3.6
  Glados<String>(anyEmail, ExploreConfig(numRuns: 100)).test(
    'isEmailValid is true iff the trimmed string matches the email format',
    (email) {
      final store = LoginStore(const FakeAuthRepository())..email = email;

      // Verificação independente: aplica a mesma regra de formato sobre a
      // string após trim, sem depender da implementação do store.
      final expected = _referenceEmailRegex.hasMatch(email.trim());

      expect(store.isEmailValid, equals(expected));
    },
  );
}
