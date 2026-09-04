import 'package:coffe_plus/core/routing/app_routes.dart';
import 'package:coffe_plus/core/theme/app_theme.dart';
import 'package:coffe_plus/di/injection.dart';
import 'package:flutter/material.dart';

void main() {
  // Registra todas as dependências injetáveis antes de a interface ser exibida
  // (Req 1.4).
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Sensory Pour',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
