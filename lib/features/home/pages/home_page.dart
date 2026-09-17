/// Tela Home: lista de cafés obtida do backend (`GET /home/coffees`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../di/injection.dart';
import '../stores/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeStore _store = getIt<HomeStore>();

  @override
  void initState() {
    super.initState();
    _store.loadCoffees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('The Sensory Pour'),
      ),
      body: RefreshIndicator(
        onRefresh: _store.loadCoffees,
        child: Observer(
          builder: (_) {
            if (_store.isLoading && _store.coffees.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_store.errorMessage != null && _store.coffees.isEmpty) {
              return _ErrorView(
                message: _store.errorMessage!,
                onRetry: _store.loadCoffees,
              );
            }
            if (_store.coffees.isEmpty) {
              return ListView(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('Nenhum café disponível.')),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _store.coffees.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final coffee = _store.coffees[index];
                return Card(
                  child: ListTile(
                    title: Text(coffee.title),
                    subtitle: Text(coffee.description),
                    trailing: Text(
                      coffee.price,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
