import 'package:flutter/material.dart';
import '../card_cafe.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // viewmodel.login("senha", usuario);
            print("Menu button pressed");
          },
          icon: Icon(Icons.menu),
          tooltip: 'Menu',
        ),
        title: const Text('The Sensory Pour'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(radius: 16),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChoiceChip(
                    backgroundColor: Colors.blue,
                    label: Text("Espresso"),
                    selected: true,
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text("Brewed"), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text("Cold Brew"), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text("Option 4"), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text("Espresso"), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text("Brewed"), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text("Cold Brew"), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text("Option 4"), selected: false),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MeuCard(
                      imagePath: 'assets/images/image_1.jpg',
                      title: 'Coffee Title $index',
                      description: 'Description for coffee $index',
                    ),
                  );
                },
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
