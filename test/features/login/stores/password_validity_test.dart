import 'package:coffe_plus/features/login/stores/login_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testes de exemplo (edge case) para a validação de senha do [LoginStore]
/// (Req 3.6). Uma senha vazia ou composta apenas por whitespace deve ser
/// classificada como inválida; uma senha real deve ser válida.
void main() {
  group('LoginStore.isPasswordValid (Req 3.6)', () {
    late LoginStore store;

    setUp(() => store = LoginStore());

    test('senha vazia => isPasswordValid falso', () {
      store.setPassword('');

      expect(store.isPasswordValid, isFalse);
    });

    test('senha padrão (não digitada) => isPasswordValid falso', () {
      // Estado inicial: password == ''.
      expect(store.isPasswordValid, isFalse);
    });

    test('senha só com espaços => isPasswordValid falso', () {
      store.setPassword('   ');

      expect(store.isPasswordValid, isFalse);
    });

    test('senha só com whitespace (tabs/newlines) => isPasswordValid falso',
        () {
      store.setPassword('\t \n');

      expect(store.isPasswordValid, isFalse);
    });

    test('senha real => isPasswordValid verdadeiro', () {
      store.setPassword('s3nh4-v4lid4');

      expect(store.isPasswordValid, isTrue);
    });

    test('senha com whitespace nas bordas mas conteúdo => verdadeiro', () {
      store.setPassword('  abc  ');

      expect(store.isPasswordValid, isTrue);
    });
  });
}
