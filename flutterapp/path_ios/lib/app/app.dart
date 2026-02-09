import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/services.dart';
import '../app/app_theme.dart';
import '../router/app_router.dart';
import '../state/auth_state.dart';

class PathIosApp extends StatelessWidget {
  const PathIosApp({super.key, required this.services, required this.auth});

  final AppServices services;
  final AuthState auth;

  @override
  Widget build(BuildContext context) {
    final router = createAppRouter(auth);

    return MultiProvider(
      providers: [
        Provider.value(value: services),
        ChangeNotifierProvider.value(value: auth),
      ],
      child: MaterialApp.router(
        title: 'path',
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    );
  }
}
