import 'package:coffe_plus/features/cart/stores/cart_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests de edge case para `CartStore.applyPromo` — Requirement 6.7.
///
/// Verificam o comportamento de tratamento de erro do Promo_Code descrito no
/// design: `applyPromo` NÃO lança; em caso de código inválido define
/// [CartStore.promoError] com mensagem e mantém [CartStore.appliedDiscountCents]
/// em 0; em caso de código válido aplica o desconto e limpa [promoError].
void main() {
  group('CartStore.applyPromo (edge cases) — Req 6.7', () {
    test(
      'invalid promo code sets promoError, keeps discount at 0, does not throw',
      () {
        final store = CartStore();

        expect(() => store.applyPromo('NOPE'), returnsNormally);

        expect(store.promoError, isNotNull);
        expect(store.promoError, isNotEmpty);
        expect(store.appliedDiscountCents, equals(0));
      },
    );

    test(
      'valid promo code (SENSORY10) applies discount and clears promoError',
      () {
        final store = CartStore();

        store.applyPromo('SENSORY10');

        expect(store.appliedDiscountCents, greaterThan(0));
        expect(store.promoError, isNull);
      },
    );

    test(
      'applying invalid code after a valid one resets discount and sets error',
      () {
        final store = CartStore();

        store.applyPromo('SENSORY10');
        expect(store.appliedDiscountCents, greaterThan(0));
        expect(store.promoError, isNull);

        store.applyPromo('NOPE');
        expect(store.appliedDiscountCents, equals(0));
        expect(store.promoError, isNotNull);
      },
    );
  });
}
