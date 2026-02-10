import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  static const _accentBlue = Color(0xFF8ECBFF);

  String _activeKeyForLocation(String location) {
    if (location.startsWith('/resources')) return 'resource';
    if (location.startsWith('/notification')) return 'message';
    if (location.startsWith('/account')) return 'me';
    if (location.startsWith('/my-paths') || location.startsWith('/createpath') || location.startsWith('/learningpath')) return 'path';
    if (location == '/home' || location == '/' || location.startsWith('/home')) return 'path';
    return 'path';
  }

  Future<void> _openPlusActions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const Icon(Icons.add_box_outlined),
                  title: const Text('Add Resource'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    context.go('/my-resources/add');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.route_outlined),
                  title: const Text('Create Path'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    context.go('/createpath');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navItem({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String activeKey,
    required String currentKey,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isActive = currentKey == activeKey;
    final color = isActive ? theme.colorScheme.onSurface : theme.hintColor;
    final indicatorColor = isActive ? theme.colorScheme.onSurface : Colors.transparent;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                height: 2,
                width: 26,
                color: indicatorColor,
              ),
              const SizedBox(height: 8),
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 6),
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentKey = _activeKeyForLocation(location);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Material(
          color: theme.colorScheme.surface,
          child: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme.colorScheme.outline, width: 1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 68,
              child: Row(
                children: [
                  _navItem(
                    context: context,
                    label: 'Path',
                    icon: Icons.route_outlined,
                    activeKey: 'path',
                    currentKey: currentKey,
                    onTap: () => context.go('/my-paths'),
                  ),
                  _navItem(
                    context: context,
                    label: 'Resource',
                    icon: Icons.explore_outlined,
                    activeKey: 'resource',
                    currentKey: currentKey,
                    onTap: () => context.go('/resources'),
                  ),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: InkWell(
                          onTap: () => _openPlusActions(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _accentBlue,
                              border: Border.all(color: _accentBlue, width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 26),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _navItem(
                    context: context,
                    label: 'Message',
                    icon: Icons.chat_bubble_outline,
                    activeKey: 'message',
                    currentKey: currentKey,
                    onTap: () => context.go('/notification'),
                  ),
                  _navItem(
                    context: context,
                    label: 'Me',
                    icon: Icons.person_outline,
                    activeKey: 'me',
                    currentKey: currentKey,
                    onTap: () => context.go('/account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
