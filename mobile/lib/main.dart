import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locora_mobile/config/router_config.dart';
import 'package:locora_mobile/config/supabase_config.dart';
import 'package:locora_mobile/config/theme_config.dart';
import 'package:locora_mobile/features/settings/presentation/providers.dart';
import 'package:locora_mobile/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const ProviderScope(child: LocoraApp()));
}

class LocoraApp extends ConsumerWidget {
  const LocoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Locora',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.light,
      darkTheme: ThemeConfig.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    );
  }
}
