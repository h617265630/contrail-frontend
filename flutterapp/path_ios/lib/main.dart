import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/services.dart';
import 'app/token_holder.dart';
import 'state/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
