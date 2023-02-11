import 'package:flutter/material.dart';
import 'package:pdf_generator/pages/create_contract.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: CreateContract(),
    );
  }
}
