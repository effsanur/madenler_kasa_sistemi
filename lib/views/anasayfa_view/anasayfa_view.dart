import 'package:flutter/material.dart';

class AnasayfaView extends StatelessWidget {
  const AnasayfaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Maden Arama',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
