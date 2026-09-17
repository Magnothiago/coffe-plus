/// Tela de Login do app "The Sensory Pour" (Req 3).
///
/// Exibe um card central sobreposto à imagem de fundo `background_login.jpeg`,
/// com título serifado, campos EMAIL ADDRESS e PASSWORD (com toggle de olho),
/// checkbox "Remember me", validações derivadas dos computeds do [LoginStore],
/// links auxiliares, divisor "OR CONTINUE WITH" e botões Google/Apple.
///
/// A parte reativa (validação, visibilidade da senha, "remember me") é
/// observada via [Observer] (flutter_mobx). O estado vive no [LoginStore]
/// resolvido pelo DI_Container (`getIt<LoginStore>()`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/routing/app_routes.dart';
import '../../../di/injection.dart';
import '../stores/login_store.dart';

/// Página de Login.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Store MobX resolvida do DI_Container (Req 1.5).
  final LoginStore _store = getIt<LoginStore>();

  /// Indica se o cliente já tentou submeter o formulário. As mensagens de
  /// validação (Reqs 3.5, 3.6) só aparecem depois do primeiro toque em SIGN IN.
  bool _submitted = false;

  void _onSignInPressed() async {
    setState(() => _submitted = true);
    if (!_store.canSubmit) return;
    final success = await _store.login();
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home); // Req 3.7
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo (Req 3.1).
          Image.asset('assets/images/background_login.jpeg', fit: BoxFit.cover),
          // Overlay escuro para contraste do card.
          Container(color: Colors.black.withValues(alpha: 0.35)),
          // Card central.
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _LoginForm(
                    store: _store,
                    theme: theme,
                    submitted: _submitted,
                    onSignIn: _onSignInPressed,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Conteúdo do card de login.
class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.store,
    required this.theme,
    required this.submitted,
    required this.onSignIn,
  });

  final LoginStore store;
  final ThemeData theme;
  final bool submitted;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título serifado (Req 3.2) — usa o headline serifado do tema.
        Text(
          'The Sensory Pour',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Experience artisanal perfection.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        // Campo EMAIL ADDRESS (Reqs 3.2, 3.5).
        Observer(
          builder: (_) => TextField(
            key: const Key('login_email_field'),
            keyboardType: TextInputType.emailAddress,
            onChanged: store.setEmail,
            decoration: InputDecoration(
              labelText: 'EMAIL ADDRESS',
              hintText: 'you@example.com',
              prefixIcon: const Icon(Icons.email_outlined),
              errorText: (submitted && !store.isEmailValid)
                  ? 'Enter a valid email address'
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Campo PASSWORD com toggle de olho (Reqs 3.2, 3.3, 3.6).
        Observer(
          builder: (_) => TextField(
            key: const Key('login_password_field'),
            obscureText: store.obscurePassword,
            onChanged: store.setPassword,
            decoration: InputDecoration(
              labelText: 'PASSWORD',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                key: const Key('login_password_toggle'),
                icon: Icon(
                  store.obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: store.togglePasswordVisibility,
                tooltip: store.obscurePassword
                    ? 'Show password'
                    : 'Hide password',
              ),
              errorText: (submitted && !store.isPasswordValid)
                  ? 'Password is required'
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Remember me + Forgot Password (Reqs 3.4, 3.8).
        // Wrap (em vez de Row) evita overflow horizontal em telas estreitas,
        // permitindo que "Forgot Password?" quebre para a linha seguinte.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 4,
          children: [
            Observer(
              builder: (_) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    key: const Key('login_remember_me'),
                    value: store.rememberMe,
                    onChanged: (_) => store.toggleRememberMe(),
                  ),
                  const Text('Remember me'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {}, // Stub: fluxo de recuperação fora do escopo.
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Erro retornado pelo backend (400/401/rede) na última tentativa.
        Observer(
          builder: (_) => store.errorMessage == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    store.errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
        ),

        // Botão SIGN IN (Reqs 3.5, 3.6, 3.7).
        Observer(
          builder: (_) => ElevatedButton(
            key: const Key('login_sign_in_button'),
            onPressed: store.isLoading ? null : onSignIn,
            child: store.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('SIGN IN'),
          ),
        ),
        const SizedBox(height: 24),

        // Divisor "OR CONTINUE WITH" (Req 3.8).
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR CONTINUE WITH',
                style: theme.textTheme.labelSmall,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),

        // Botões Google e Apple (stubs) (Req 3.8).
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('login_google_button'),
                onPressed: () {}, // Stub: auth social fora do escopo.
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Google'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('login_apple_button'),
                onPressed: () {}, // Stub: auth social fora do escopo.
                icon: const Icon(Icons.apple),
                label: const Text('Apple'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Link para criar conta (Req 3.8).
        // Wrap evita overflow horizontal quando o texto não cabe em uma linha.
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text('New to The Sensory Pour? ', style: theme.textTheme.bodySmall),
            GestureDetector(
              onTap: () {}, // Stub: cadastro fora do escopo.
              child: Text(
                'Create an account',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
