import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locora_mobile/config/router_config.dart';
import 'package:locora_mobile/main.dart';

void main() {
  testWidgets('Locora app renders widget tree smoke test', (tester) async {
    final testRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('SMOKE_OK')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appRouterProvider.overrideWithValue(testRouter)],
        child: const LocoraApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SMOKE_OK'), findsOneWidget);
  });
}
