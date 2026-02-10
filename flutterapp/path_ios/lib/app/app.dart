import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';

import '../app/services.dart';
import '../app/app_theme.dart';
import '../router/app_router.dart';
import '../state/auth_state.dart';

class PathIosApp extends StatefulWidget {
  const PathIosApp({super.key, required this.services, required this.auth});

  final AppServices services;
  final AuthState auth;

  @override
  State<PathIosApp> createState() => _PathIosAppState();
}

class _PathIosAppState extends State<PathIosApp> {
  late final GoRouter _router;
  StreamSubscription<String>? _intentTextStreamSubscription;
  String _lastHandled = '';

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(widget.auth);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupShareListeners();
    });
  }

  @override
  void dispose() {
    _intentTextStreamSubscription?.cancel();
    super.dispose();
  }

  void _setupShareListeners() {
    // Cold start: app launched from share sheet.
    ReceiveSharingIntentPlus.getInitialText().then((value) {
      _handleSharedText(value);
    });

    // Warm: app already in memory.
    _intentTextStreamSubscription = ReceiveSharingIntentPlus.getTextStream().listen(
      (value) => _handleSharedText(value),
      onError: (err) {
        debugPrint('ReceiveSharingIntentPlus.getTextStream error: $err');
      },
    );
  }

  void _handleSharedText(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return;
    if (raw == _lastHandled) return;
    _lastHandled = raw;

    final url = _extractFirstHttpUrl(raw);
    if (url == null) {
      // If the share is not a URL, still forward the raw value as url param;
      // NotificationPage will validate and show an error on import.
      final target = '/notification?url=${Uri.encodeQueryComponent(raw)}';
      _openTarget(target);
      ReceiveSharingIntentPlus.reset();
      return;
    }

    final target = '/notification?url=${Uri.encodeQueryComponent(url)}';
    _openTarget(target);
    ReceiveSharingIntentPlus.reset();
  }

  void _openTarget(String target) {
    _router.go(target);
  }

  String? _extractFirstHttpUrl(String text) {
    final match = RegExp(r'(https?:\/\/[^\s]+)', caseSensitive: false).firstMatch(text);
    if (match == null) return null;
    final candidate = (match.group(1) ?? '').trim();
    final uri = Uri.tryParse(candidate);
    final ok = uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;
    return ok ? candidate : null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: widget.services),
        ChangeNotifierProvider.value(value: widget.auth),
      ],
      child: MaterialApp.router(
        title: 'path',
        theme: AppTheme.light(),
        builder: (context, child) {
          return ExcludeSemantics(child: child ?? const SizedBox.shrink());
        },
        routerConfig: _router,
      ),
    );
  }
}
