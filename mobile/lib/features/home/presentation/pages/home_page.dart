import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locora_mobile/features/auth/presentation/providers.dart';
import 'package:locora_mobile/features/home/presentation/providers.dart';
import 'package:locora_mobile/features/settings/presentation/providers.dart';
import 'package:locora_mobile/l10n/app_localizations.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final status = ref.watch(appStatusProvider);
    final userId = ref.watch(currentUserIdProvider) ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
            icon: const Icon(Icons.dark_mode_outlined),
            tooltip: l10n.toggleTheme,
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language_outlined),
            onSelected: (locale) {
              ref.read(localeProvider.notifier).setLocale(locale);
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<Locale>(
                  value: Locale('tr'),
                  child: Text('TR'),
                ),
                PopupMenuItem<Locale>(
                  value: Locale('en'),
                  child: Text('EN'),
                ),
              ];
            },
          ),
          IconButton(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout_outlined),
            tooltip: l10n.signOut,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.emptyHomeTitle),
              const SizedBox(height: 8),
              Text('${l10n.statusLabel}: $status'),
              const SizedBox(height: 8),
              Text('User: $userId'),
            ],
          ),
        ),
      ),
    );
  }
}
