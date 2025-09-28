import 'package:common_component_sample/date_carousel.dart';
import 'package:flutter/material.dart';
import 'custom_top_snackbar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: const Text('Top SnackBar Demo')),
              body: Column(
                children: [
                  DateCarousel(),
                  const Center(child: Text('Top SnackBar Demo')),
                ],
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          TopSnackBarManager.showWithAnimation(
                            context,
                            'アニメーション付きのSnackBar',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('アニメーションあり'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          TopSnackBarManager.showWithoutAnimation(
                            context,
                            'アニメーションなしのSnackBar',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('アニメーションなし'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
