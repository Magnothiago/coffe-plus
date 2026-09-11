import 'package:flutter/material.dart';

class MeuCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const MeuCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(imagePath),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(padding: const EdgeInsets.all(8.0), child: Text(description)),
      ],
    );
  }
}
