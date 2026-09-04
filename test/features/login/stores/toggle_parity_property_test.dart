// Feature: coffee-shop-app, Property 4
//
// Property 4: Toggle parity.
//
// *For any* estado booleano inicial (visibilidade de senha ou "remember me") e
// *for any* número de toggles aplicados, o estado final é igual ao inicial
// quando o número de toggles é par, e é o oposto quando é ímpar.
//
// Validates: Requirements 3.3, 3.4

import 'package:coffe_plus/features/login/stores/login_store.dart';
import 'package:glados/glados.dart';

void main() {
  // Gerador `any.togglesSequence`: número de toggles a aplicar, em faixa ampla
  // o bastante para cobrir contagens pares e ímpares (ver design/Property 4).
  final anyTogglesSequence = any.intInRange(0, 101); // [0, 100]

  // Property 4 aplicada a togglePasswordVisibility (Req 3.3).
  //
  // Estado inicial de `obscurePassword` é `true`. Após `n` toggles o valor
  // final deve ser igual ao inicial se `n` for par, e o oposto se `n` for ímpar.
  Glados<int>(
    anyTogglesSequence,
    ExploreConfig(numRuns: 100),
  ).test(
    'Property 4: togglePasswordVisibility respeita a paridade dos toggles',
    (toggleCount) {
      final store = LoginStore();
      final initial = store.obscurePassword;

      for (var i = 0; i < toggleCount; i++) {
        store.togglePasswordVisibility();
      }

      final expected = toggleCount.isEven ? initial : !initial;
      expect(
        store.obscurePassword,
        expected,
        reason:
            'obscurePassword após $toggleCount toggles deveria ser $expected',
      );
    },
  );

  // Property 4 aplicada a toggleRememberMe (Req 3.4).
  //
  // Estado inicial de `rememberMe` é `false`. Após `n` toggles o valor final
  // deve ser igual ao inicial se `n` for par, e o oposto se `n` for ímpar.
  Glados<int>(
    anyTogglesSequence,
    ExploreConfig(numRuns: 100),
  ).test(
    'Property 4: toggleRememberMe respeita a paridade dos toggles',
    (toggleCount) {
      final store = LoginStore();
      final initial = store.rememberMe;

      for (var i = 0; i < toggleCount; i++) {
        store.toggleRememberMe();
      }

      final expected = toggleCount.isEven ? initial : !initial;
      expect(
        store.rememberMe,
        expected,
        reason: 'rememberMe após $toggleCount toggles deveria ser $expected',
      );
    },
  );
}
