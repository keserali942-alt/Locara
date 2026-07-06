import 'package:flutter/material.dart';

class LaunchGatePage extends StatelessWidget {
  const LaunchGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
