import 'package:coffe_plus/features/menu/pages/menu_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/back.jpeg', fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.35)),
          Center(
            child: SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _LoginForm(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'The Sensory Pour',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Expirience artesal perfection',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        TextField(decoration: InputDecoration(labelText: 'Email')),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Checkbox(onChanged: (value) {}, value: false),
            const SizedBox(width: 8),
            const Text('Remember me'),
            const Spacer(),
            const Text('Forgot password?'),
          ],
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const MenuPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(60, 42, 33, 1),
            ),
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Divider(color: const Color.fromRGBO(60, 42, 33, 1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(color: const Color.fromRGBO(60, 42, 33, 1)),
              ),
            ),
            Expanded(
              child: Divider(color: const Color.fromRGBO(60, 42, 33, 1)),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: const Color.fromRGBO(60, 42, 33, 1),
                  ),
                ),
                onPressed: () {
                  print("Google button pressed");
                },
                icon: Icon(Icons.g_mobiledata),
                label: Text("Google"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: const Color.fromRGBO(60, 42, 33, 1),
                  ),
                ),
                onPressed: () {
                  print("Apple button pressed");
                },
                icon: Icon(Icons.apple),
                label: Text("Apple"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
