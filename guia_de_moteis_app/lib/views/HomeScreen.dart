import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Ambos deve ter icon e texto
          ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.thunderstorm),
          ),
          TextButton(
            onPressed: () {},
            child: Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}
