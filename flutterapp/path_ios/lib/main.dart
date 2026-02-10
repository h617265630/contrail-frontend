import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/services.dart';
import 'app/token_holder.dart';
import 'state/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    final msg = details.exceptionAsString();
    final isFlexOverflow = msg.contains('A RenderFlex overflowed by');
    if (isFlexOverflow) return;
    debugPrint(details.toString());
    FlutterError.presentError(details);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    final stack = details.stack?.toString();
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            stack == null || stack.isEmpty
                ? details.exceptionAsString()
                : '${details.exceptionAsString()}\n\n$stack',
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ),
    );
  };

  final tokenHolder = TokenHolder();
  final unauthorizedHandler = UnauthorizedHandler();

  late final AuthState auth;

  final services = await AppServices.create(
    tokenProvider: () => tokenHolder.token,
    onUnauthorized: () => unauthorizedHandler.call(),
  );

  auth = AuthState(services, tokenHolder);
  unauthorizedHandler.handler = auth.handleUnauthorized;

  await auth.initialize();

  runApp(PathIosApp(services: services, auth: auth));
}
