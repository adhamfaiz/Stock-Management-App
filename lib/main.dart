import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/product/views/product_list_screen.dart';
import 'features/analytics/views/analytics_screen.dart';
import 'features/scanner/views/barcode_scanner_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Stock Management'),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
                ),
              ),
            ],
          ),
          body: const ProductListScreen(),
        ),
      ),
    );
  }
}