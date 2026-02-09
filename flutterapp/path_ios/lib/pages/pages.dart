// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../app/services.dart';
import '../core/api_client.dart';
import '../models/models.dart';
import '../state/auth_state.dart';
import '../widgets/html_reader_page.dart';
import '../widgets/in_app_webview_page.dart';

String _fmtDateTime(String v) {
  try {
    final dt = DateTime.parse(v).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  } catch (_) {
    return v;
  }
}

Future<void> _showError(BuildContext context, Object e) async {
  final msg = e is ApiException ? e.message : e.toString();
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('错误'),
      content: Text(msg),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
      ],
    ),
  );
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('错误')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(error?.toString() ?? 'Unknown error'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          if (auth.isAuthed)
            IconButton(
              onPressed: () => context.go('/account/user-info'),
              icon: const Icon(Icons.account_circle),
            )
          else
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('登录'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            title: const Text('Resource Library'),
            subtitle: const Text('/resources'),
            onTap: () => context.go('/resources'),
          ),
          ListTile(
            title: const Text('Learning Pool'),
            subtitle: const Text('/learningpool'),
            onTap: () => context.go('/learningpool'),
          ),
          ListTile(
            title: const Text('My Resources'),
            subtitle: const Text('/my-resources'),
            onTap: () => context.go('/my-resources'),
          ),
          ListTile(
            title: const Text('My Paths'),
            subtitle: const Text('/my-paths'),
            onTap: () => context.go('/my-paths'),
          ),
          ListTile(
            title: const Text('Create Path'),
            subtitle: const Text('/createpath'),
            onTap: () => context.go('/createpath'),
          ),
          ListTile(
            title: const Text('Creator'),
            subtitle: const Text('/creator'),
            onTap: () => context.go('/creator'),
          ),
          ListTile(
            title: const Text('Partical'),
            subtitle: const Text('/partical'),
            onTap: () => context.go('/partical'),
          ),
          ListTile(
            title: const Text('My Partical'),
            subtitle: const Text('/my-partical'),
            onTap: () => context.go('/my-partical'),
          ),
          ListTile(
            title: const Text('Account'),
            subtitle: const Text('/account'),
            onTap: () => context.go('/account/user-info'),
          ),
          ListTile(
            title: const Text('Notification'),
            subtitle: const Text('/notification'),
            onTap: () => context.go('/notification'),
          ),
          ListTile(
            title: const Text('Plan'),
            subtitle: const Text('/plan'),
            onTap: () => context.go('/plan'),
          ),
          ListTile(
            title: const Text('Tools'),
            subtitle: const Text('/tools'),
            onTap: () => context.go('/tools'),
          ),
          ListTile(
            title: const Text('Stack'),
            subtitle: const Text('/stack'),
            onTap: () => context.go('/stack'),
          ),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('/about'),
            onTap: () => context.go('/about'),
          ),
          const SizedBox(height: 16),
          if (auth.isAuthed)
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await context.read<AuthState>().logout();
                if (context.mounted) context.go('/login');
              },
            ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await context.read<AuthState>().login(username: _username.text.trim(), password: _password.text);
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _username,
            decoration: const InputDecoration(labelText: 'Username'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: Text(_loading ? 'Loading…' : 'Login'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go('/register'),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await context
          .read<AuthState>()
          .register(username: _username.text.trim(), email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      context.go('/login');
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username')),
          const SizedBox(height: 12),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: Text(_loading ? 'Loading…' : 'Register'),
          ),
        ],
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Public paths/resources should avoid sensitive content and include a clear title/description for discoverability.',
        ),
      ),
    );
  }
}

class ResourceLibraryPage extends StatefulWidget {
  const ResourceLibraryPage({super.key});

  @override
  State<ResourceLibraryPage> createState() => _ResourceLibraryPageState();
}

class _ResourceLibraryPageState extends State<ResourceLibraryPage> {
  bool _loading = true;
  String _error = '';
  List<DbResource> _resources = const [];
  List<Category> _categories = const [];
  int? _categoryId;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final res = await api.resourceApi.listPublic();
      final cats = await api.categoryApi.list();
      if (!mounted) return;
      setState(() {
        _resources = res;
        _categories = cats;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _categoryId == null
        ? _resources
        : _resources.where((r) => r.categoryId == _categoryId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error),
                        const SizedBox(height: 8),
                        FilledButton(onPressed: _load, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    if (_categories.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: DropdownButtonFormField<int?>(
                          initialValue: _categoryId,
                          decoration: const InputDecoration(labelText: 'Category'),
                          items: [
                            const DropdownMenuItem<int?>(value: null, child: Text('All')),
                            ..._categories.map(
                              (c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name)),
                            ),
                          ],
                          onChanged: (v) => setState(() => _categoryId = v),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (a, b) => const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final r = filtered[idx];
                          return ListTile(
                            title: Text(r.title),
                            subtitle: Text('${r.resourceType} · ${r.categoryName ?? '-'}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              final type = r.resourceType;
                              if (type == 'video') {
                                context.go('/resources/video/${r.id}');
                              } else if (type == 'document') {
                                context.go('/resources/document/${r.id}');
                              } else {
                                context.go('/resources/article/${r.id}');
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

class MyResourcesPage extends StatefulWidget {
  const MyResourcesPage({super.key});

  @override
  State<MyResourcesPage> createState() => _MyResourcesPageState();
}

class _MyResourcesPageState extends State<MyResourcesPage> {
  bool _loading = true;
  String _error = '';
  List<DbResource> _resources = const [];

  final _search = TextEditingController();
  bool _expandAll = true;
  final Set<String> _collapsedDeckKeys = <String>{};

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final res = await api.resourceApi.listMine();
      if (!mounted) return;
      setState(() => _resources = res);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _delete(int id) async {
    try {
      await context.read<AppServices>().resourceApi.deleteMine(id);
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  void _openResource(DbResource r) {
    if (r.resourceType == 'video') {
      context.go('/my-resources/video/${r.id}');
    } else if (r.resourceType == 'document') {
      context.go('/my-resources/document/${r.id}');
    } else {
      context.go('/my-resources/article/${r.id}');
    }
  }

  String _deckKey(DbResource r) {
    final raw = (r.categoryName ?? '').trim();
    return raw.isEmpty ? 'Other' : raw;
  }

  Map<String, List<DbResource>> _groupDecks(List<DbResource> list) {
    final map = <String, List<DbResource>>{};
    for (final r in list) {
      final k = _deckKey(r);
      (map[k] ??= <DbResource>[]).add(r);
    }
    final keys = map.keys.toList()..sort();
    return {for (final k in keys) k: map[k]!};
  }

  bool _isDeckExpanded(String deckKey) {
    if (_expandAll) return true;
    return !_collapsedDeckKeys.contains(deckKey);
  }

  void _toggleDeck(String deckKey) {
    if (_expandAll) return;
    setState(() {
      if (_collapsedDeckKeys.contains(deckKey)) {
        _collapsedDeckKeys.remove(deckKey);
      } else {
        _collapsedDeckKeys.add(deckKey);
      }
    });
  }

  void _toggleExpandAll() {
    setState(() {
      _expandAll = !_expandAll;
      if (_expandAll) {
        _collapsedDeckKeys.clear();
      }
    });
  }

  int _gridColumnsForWidth(double width) {
    const cardMin = 170.0;
    final cols = (width / cardMin).floor().clamp(1, 5);
    return cols;
  }

  Widget _buildResourceCard(BuildContext context, DbResource r, {required int delayMs}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final category = (r.categoryName ?? '').trim();
    final chipText = category.isEmpty ? '—' : category;

    return _StaggeredIn(
      delayMs: delayMs,
      child: InkWell(
        onTap: () => _openResource(r),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: r.thumbnail == null || r.thumbnail!.isEmpty
                    ? Container(color: scheme.surfaceContainerHighest)
                    : Image.network(
                        r.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: scheme.surfaceContainerHighest),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: scheme.outline, width: 1),
                        color: scheme.surface,
                      ),
                      child: Text(
                        chipText,
                        style: theme.textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '#${r.id.toString().padLeft(3, '0')}',
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Text(
                  r.title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Text(
                  (r.summary ?? '').trim().isEmpty ? '—' : r.summary!.trim(),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        r.platform,
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      r.resourceType,
                      style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 6),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      onSelected: (v) {
                        if (v == 'edit') {
                          context.go('/my-resources/${r.id}/edit');
                        } else if (v == 'delete') {
                          _delete(r.id);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ],
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
    final q = _search.text.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _resources
        : _resources.where((r) {
            final title = r.title.toLowerCase();
            final summary = (r.summary ?? '').toLowerCase();
            final category = (r.categoryName ?? '').toLowerCase();
            final platform = r.platform.toLowerCase();
            return title.contains(q) || summary.contains(q) || category.contains(q) || platform.contains(q);
          }).toList();

    final decks = _groupDecks(filtered);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collection'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_error)))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    Text(
                      '${filtered.length} resources in ${decks.length} decks',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _search,
                            decoration: const InputDecoration(
                              hintText: 'Search resources...',
                              prefixIcon: Icon(Icons.search, size: 18),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 40,
                          child: FilledButton(
                            onPressed: () => context.go('/my-resources/add'),
                            child: const Text('Add'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _toggleExpandAll,
                            child: Text(_expandAll ? '收起全部' : '展开全部'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    for (final entry in decks.entries) ...[
                      _DeckSection(
                        title: entry.key,
                        count: entry.value.length,
                        expanded: _isDeckExpanded(entry.key),
                        showChevron: !_expandAll,
                        onToggle: () => _toggleDeck(entry.key),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final cols = _gridColumnsForWidth(constraints.maxWidth);
                            final cards = entry.value;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.78,
                              ),
                              itemCount: cards.length,
                              itemBuilder: (context, i) {
                                final row = i ~/ cols;
                                final col = i % cols;
                                final delay = row * 260 + col * 70;
                                return _buildResourceCard(context, cards[i], delayMs: delay);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],
                ),
    );
  }
}

class _DeckSection extends StatelessWidget {
  const _DeckSection({
    required this.title,
    required this.count,
    required this.expanded,
    required this.child,
    required this.onToggle,
    required this.showChevron,
  });

  final String title;
  final int count;
  final bool expanded;
  final Widget child;
  final VoidCallback onToggle;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: showChevron ? onToggle : null,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '$count cards',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
              if (showChevron) ...[
                const SizedBox(width: 6),
                Icon(expanded ? Icons.expand_less : Icons.expand_more, color: theme.hintColor),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        AnimatedCrossFade(
          crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 220),
          firstChild: child,
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _StaggeredIn extends StatefulWidget {
  const _StaggeredIn({required this.child, required this.delayMs});
  final Widget child;
  final int delayMs;

  @override
  State<_StaggeredIn> createState() => _StaggeredInState();
}

class _StaggeredInState extends State<_StaggeredIn> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (!mounted) return;
      setState(() => _show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1 : 0,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _show ? Offset.zero : const Offset(-0.05, 0),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class AddResourcePage extends StatefulWidget {
  const AddResourcePage({super.key});

  @override
  State<AddResourcePage> createState() => _AddResourcePageState();
}

class _AddResourcePageState extends State<AddResourcePage> {
  final _url = TextEditingController();
  bool _public = false;
  double? _manualWeight;
  int? _categoryId;
  bool _loading = false;
  UrlExtractResponse? _extracted;
  List<Category> _categories = const [];
  List<UserFile> _files = const [];

  Future<void> _loadCats() async {
    final api = context.read<AppServices>();
    final cats = await api.categoryApi.list();
    final files = await api.userFileApi.listMine();
    if (!mounted) return;
    setState(() {
      _categories = cats;
      _files = files;
      _categoryId ??= cats.isNotEmpty ? cats.first.id : null;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _extract() async {
    setState(() => _loading = true);
    try {
      final api = context.read<AppServices>();
      final data = await api.resourceApi.extract(_url.text.trim());
      if (!mounted) return;
      setState(() => _extracted = data);
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    setState(() => _loading = true);
    try {
      final api = context.read<AppServices>();
      await api.resourceApi.createMineFromUrl(
        url: _url.text.trim(),
        categoryId: _categoryId,
        isPublic: _public,
        manualWeight: _manualWeight,
      );
      if (!mounted) return;
      context.go('/my-resources');
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Resource')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _url,
            decoration: const InputDecoration(labelText: 'URL'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            initialValue: _categoryId,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories
                .map((c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name)))
                .toList(growable: false),
            onChanged: (v) => setState(() => _categoryId = v),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _public,
            onChanged: (v) => setState(() => _public = v),
            title: const Text('Publish (system public)'),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Manual weight (optional)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) => _manualWeight = double.tryParse(v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _loading ? null : _extract,
                  child: Text(_loading ? 'Loading…' : 'Extract metadata'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _loading ? null : _create,
                  child: Text(_loading ? 'Loading…' : 'Create'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_extracted != null) ...[
            Text('Title: ${_extracted!.title}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_extracted!.description ?? '—'),
          ],
          const SizedBox(height: 16),
          if (_files.isNotEmpty) ...[
            Text('My files (for reference)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._files.take(5).map((f) => Text('${f.title ?? f.originalFilename ?? 'file'} · ${f.fileType}')),
          ],
        ],
      ),
    );
  }
}

class MyResourceEditPage extends StatefulWidget {
  const MyResourceEditPage({super.key, required this.resourceId});
  final int resourceId;

  @override
  State<MyResourceEditPage> createState() => _MyResourceEditPageState();
}

class _MyResourceEditPageState extends State<MyResourceEditPage> {
  bool _loading = true;
  DbResourceDetail? _detail;
  final _title = TextEditingController();
  final _summary = TextEditingController();
  final _manualWeight = TextEditingController();

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final api = context.read<AppServices>();
      final d = await api.resourceApi.detailMine(widget.resourceId);
      if (!mounted) return;
      setState(() {
        _detail = d;
        _title.text = d.title;
        _summary.text = d.summary ?? '';
        _manualWeight.text = d.manualWeight?.toString() ?? '';
      });
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      final api = context.read<AppServices>();
      await api.resourceApi.updateMine(widget.resourceId, {
        'title': _title.text.trim(),
        'summary': _summary.text.trim(),
        'manual_weight': double.tryParse(_manualWeight.text.trim()),
      });
      if (!mounted) return;
      context.go('/my-resources');
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Resource')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _detail == null
              ? const Center(child: Text('Not found'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _summary,
                      decoration: const InputDecoration(labelText: 'Summary'),
                      minLines: 3,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _manualWeight,
                      decoration: const InputDecoration(labelText: 'Manual weight'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _save, child: const Text('Save')),
                  ],
                ),
    );
  }
}

class ResourceVideoPage extends StatefulWidget {
  const ResourceVideoPage({super.key, required this.resourceId, required this.isMine, this.pathItemId});
  final int resourceId;
  final bool isMine;
  final int? pathItemId;

  @override
  State<ResourceVideoPage> createState() => _ResourceVideoPageState();
}

class _ResourceVideoPageState extends State<ResourceVideoPage> {
  bool _loading = true;
  String _error = '';
  DbResourceDetail? _detail;
  int _progress = 0;
  bool _progressUpdating = false;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final d = widget.isMine
          ? await api.resourceApi.detailMine(widget.resourceId)
          : await api.resourceApi.detailPublic(widget.resourceId);

      int p = 0;
      if (widget.pathItemId != null) {
        try {
          final row = await api.progressApi.getMineForItem(widget.pathItemId!);
          p = row.progressPercentage;
        } catch (_) {
          p = 0;
        }
      }

      if (!mounted) return;
      setState(() {
        _detail = d;
        _progress = p;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveProgress(int v) async {
    if (widget.pathItemId == null) return;
    setState(() => _progressUpdating = true);
    try {
      final api = context.read<AppServices>();
      final row = await api.progressApi.upsertMine(pathItemId: widget.pathItemId!, progressPercentage: v);
      if (!mounted) return;
      setState(() => _progress = row.progressPercentage);
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _progressUpdating = false);
    }
  }

  Future<void> _openSource() async {
    final url = _detail?.sourceUrl;
    if (url == null || url.isEmpty) return;
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => InAppWebViewPage(url: url, title: _detail?.title ?? 'Video')),
    );
  }

  void _saveToPath() {
    if (_detail == null) return;
    context.go('/resources/${_detail!.resourceType}/${_detail!.id}/add-to-path');
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _detail == null
                  ? const Center(child: Text('Not found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(_detail!.title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(_detail!.summary ?? '—'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _saveToPath,
                                child: const Text('Save to path'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: _openSource,
                                child: const Text('Open'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (widget.pathItemId != null) ...[
                          Text('Progress: $_progress%'),
                          Slider(
                            value: _progress.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: _progressUpdating ? null : (v) => setState(() => _progress = v.round()),
                            onChangeEnd: _progressUpdating ? null : (v) => _saveProgress(v.round()),
                          ),
                          FilledButton(
                            onPressed: _progressUpdating ? null : () => _saveProgress(100),
                            child: const Text('Mark as complete'),
                          ),
                        ],
                      ],
                    ),
    );
  }
}

class ResourceDocumentPage extends StatefulWidget {
  const ResourceDocumentPage({super.key, required this.resourceId, required this.isMine, this.pathItemId});
  final int resourceId;
  final bool isMine;
  final int? pathItemId;

  @override
  State<ResourceDocumentPage> createState() => _ResourceDocumentPageState();
}

class _ResourceDocumentPageState extends State<ResourceDocumentPage> {
  bool _loading = true;
  String _error = '';
  DbResourceDetail? _detail;
  int _progress = 0;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final d = widget.isMine
          ? await api.resourceApi.detailMine(widget.resourceId)
          : await api.resourceApi.detailPublic(widget.resourceId);

      int p = 0;
      if (widget.pathItemId != null) {
        try {
          final row = await api.progressApi.getMineForItem(widget.pathItemId!);
          p = row.progressPercentage;
        } catch (_) {
          p = 0;
        }
      }

      if (!mounted) return;
      setState(() {
        _detail = d;
        _progress = p;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openReader() async {
    final url = _detail?.sourceUrl;
    if (url == null || url.isEmpty) return;
    try {
      final api = context.read<AppServices>();
      final data = await api.readerApi.extract(url);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HtmlReaderPage(title: data.title, html: data.contentHtml),
        ),
      );
    } catch (e) {
      await _showError(context, e);
    }
  }

  Future<void> _saveProgress(int v) async {
    if (widget.pathItemId == null) return;
    try {
      final api = context.read<AppServices>();
      final row = await api.progressApi.upsertMine(pathItemId: widget.pathItemId!, progressPercentage: v);
      if (!mounted) return;
      setState(() => _progress = row.progressPercentage);
    } catch (e) {
      await _showError(context, e);
    }
  }

  void _saveToPath() {
    if (_detail == null) return;
    context.go('/resources/${_detail!.resourceType}/${_detail!.id}/add-to-path');
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _detail == null
                  ? const Center(child: Text('Not found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(_detail!.title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(_detail!.summary ?? '—'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(onPressed: _saveToPath, child: const Text('Save to path')),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(onPressed: _openReader, child: const Text('Open reader')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (widget.pathItemId != null) ...[
                          Text('Progress: $_progress%'),
                          Slider(
                            value: _progress.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (v) => setState(() => _progress = v.round()),
                            onChangeEnd: (v) => _saveProgress(v.round()),
                          ),
                          FilledButton(onPressed: () => _saveProgress(100), child: const Text('Mark as complete')),
                        ],
                      ],
                    ),
    );
  }
}

class ResourceArticlePage extends StatefulWidget {
  const ResourceArticlePage({super.key, required this.resourceId, required this.isMine, this.pathItemId});
  final int resourceId;
  final bool isMine;
  final int? pathItemId;

  @override
  State<ResourceArticlePage> createState() => _ResourceArticlePageState();
}

class _ResourceArticlePageState extends State<ResourceArticlePage> {
  bool _loading = true;
  String _error = '';
  DbResourceDetail? _detail;
  int _progress = 0;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final d = widget.isMine
          ? await api.resourceApi.detailMine(widget.resourceId)
          : await api.resourceApi.detailPublic(widget.resourceId);

      int p = 0;
      if (widget.pathItemId != null) {
        try {
          final row = await api.progressApi.getMineForItem(widget.pathItemId!);
          p = row.progressPercentage;
        } catch (_) {
          p = 0;
        }
      }

      if (!mounted) return;
      setState(() {
        _detail = d;
        _progress = p;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openReader() async {
    final url = _detail?.sourceUrl;
    if (url == null || url.isEmpty) return;
    try {
      final api = context.read<AppServices>();
      final data = await api.readerApi.extract(url);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HtmlReaderPage(title: data.title, html: data.contentHtml),
        ),
      );
    } catch (e) {
      await _showError(context, e);
    }
  }

  Future<void> _saveProgress(int v) async {
    if (widget.pathItemId == null) return;
    try {
      final api = context.read<AppServices>();
      final row = await api.progressApi.upsertMine(pathItemId: widget.pathItemId!, progressPercentage: v);
      if (!mounted) return;
      setState(() => _progress = row.progressPercentage);
    } catch (e) {
      await _showError(context, e);
    }
  }

  void _saveToPath() {
    if (_detail == null) return;
    context.go('/resources/${_detail!.resourceType}/${_detail!.id}/add-to-path');
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _detail == null
                  ? const Center(child: Text('Not found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(_detail!.title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(_detail!.summary ?? '—'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: OutlinedButton(onPressed: _saveToPath, child: const Text('Save to path'))),
                            const SizedBox(width: 12),
                            Expanded(child: FilledButton(onPressed: _openReader, child: const Text('Open reader'))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (widget.pathItemId != null) ...[
                          Text('Progress: $_progress%'),
                          Slider(
                            value: _progress.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (v) => setState(() => _progress = v.round()),
                            onChangeEnd: (v) => _saveProgress(v.round()),
                          ),
                          FilledButton(onPressed: () => _saveProgress(100), child: const Text('Mark as complete')),
                        ],
                      ],
                    ),
    );
  }
}

class AddResourceToPathPage extends StatefulWidget {
  const AddResourceToPathPage({super.key, required this.resourceType, required this.resourceId});
  final String resourceType;
  final int resourceId;

  @override
  State<AddResourceToPathPage> createState() => _AddResourceToPathPageState();
}

class _AddResourceToPathPageState extends State<AddResourceToPathPage> {
  bool _loading = true;
  String _error = '';
  DbResourceDetail? _detail;
  List<PublicLearningPath> _paths = const [];
  int? _selectedPathId;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      DbResourceDetail d;
      try {
        d = await api.resourceApi.detailMine(widget.resourceId);
      } catch (_) {
        d = await api.resourceApi.detailPublic(widget.resourceId);
      }
      final paths = await api.learningPathApi.listMine();
      if (!mounted) return;
      setState(() {
        _detail = d;
        _paths = paths;
        _selectedPathId = paths.isNotEmpty ? paths.first.id : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    if (_selectedPathId == null || _detail == null) return;
    try {
      final api = context.read<AppServices>();
      await api.learningPathApi.addItem(_selectedPathId!, {
        'resource_id': _detail!.id,
      });
      if (!mounted) return;
      context.go('/learningpath/${_selectedPathId!}/edit');
    } catch (e) {
      await _showError(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add to path')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(_detail?.title ?? ''),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int?>(
                      initialValue: _selectedPathId,
                      decoration: const InputDecoration(labelText: 'My learning path'),
                      items: _paths.map((p) => DropdownMenuItem<int?>(value: p.id, child: Text(p.title))).toList(),
                      onChanged: (v) => setState(() => _selectedPathId = v),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _add, child: const Text('Add')),
                  ],
                ),
    );
  }
}

class LearningPoolPage extends StatefulWidget {
  const LearningPoolPage({super.key});

  @override
  State<LearningPoolPage> createState() => _LearningPoolPageState();
}

class _LearningPoolPageState extends State<LearningPoolPage> {
  bool _loading = true;
  String _error = '';
  List<PublicLearningPath> _paths = const [];

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final res = await api.learningPathApi.listPublic();
      if (!mounted) return;
      setState(() => _paths = res);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Pool'), actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView.separated(
                      itemCount: _paths.length,
                      separatorBuilder: (a, b) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final p = _paths[idx];
                    return ListTile(
                      title: Text(p.title),
                      subtitle: Text(p.categoryName ?? '-'),
                      onTap: () => context.go('/learningpath/${p.id}'),
                    );
                  },
                ),
    );
  }
}

class LearningPoolCategoryPage extends StatelessWidget {
  const LearningPoolCategoryPage({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Category: $category')),
      body: LearningPoolPage(key: ValueKey(category)),
    );
  }
}

class LearningPathDetailPage extends StatefulWidget {
  const LearningPathDetailPage({super.key, required this.learningPathId});
  final int learningPathId;

  @override
  State<LearningPathDetailPage> createState() => _LearningPathDetailPageState();
}

class _LearningPathDetailPageState extends State<LearningPathDetailPage> {
  bool _loading = true;
  String _error = '';
  PublicLearningPathDetail? _detail;
  List<LearningPathComment> _comments = const [];
  final _commentCtrl = TextEditingController();

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final d = await api.learningPathApi.publicDetail(widget.learningPathId);
      List<LearningPathComment> comments = const [];
      try {
        comments = await api.learningPathApi.listComments(widget.learningPathId);
      } catch (_) {
        comments = const [];
      }
      if (!mounted) return;
      setState(() {
        _detail = d;
        _comments = comments;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _attach() async {
    try {
      await context.read<AppServices>().learningPathApi.attachPublicToMe(widget.learningPathId);
      if (!mounted) return;
      context.go('/my-paths');
    } catch (e) {
      await _showError(context, e);
    }
  }

  Future<void> _postComment() async {
    final content = _commentCtrl.text.trim();
    if (content.isEmpty) return;
    try {
      await context.read<AppServices>().learningPathApi.postComment(widget.learningPathId, content);
      _commentCtrl.clear();
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  void _openItem(PathItem item) {
    if (item.resourceType == 'video') {
      context.go('/resources/video/${item.resourceId}?path_item_id=${item.id}');
    } else if (item.resourceType == 'document') {
      context.go('/resources/document/${item.resourceId}?path_item_id=${item.id}');
    } else {
      context.go('/resources/article/${item.resourceId}?path_item_id=${item.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Path'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
          if (auth.isAuthed) IconButton(onPressed: _attach, icon: const Icon(Icons.add_box)),
          if (auth.isAuthed)
            IconButton(
              onPressed: () => context.go('/learningpath/${widget.learningPathId}/linear'),
              icon: const Icon(Icons.view_agenda),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _detail == null
                  ? const Center(child: Text('Not found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(_detail!.title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(_detail!.description ?? '—'),
                        const SizedBox(height: 16),
                        Text('Items', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        ...(() {
                          final items = _detail!.pathItems.toList()
                            ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
                          return items
                              .map(
                                (i) => Card(
                                  child: ListTile(
                                    title: Text(i.title),
                                    subtitle: Text('${i.resourceType} · #${i.orderIndex}'),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => _openItem(i),
                                  ),
                                ),
                              )
                              .toList();
                        })(),
                        const SizedBox(height: 16),
                        Text('Comments', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        if (_comments.isEmpty) const Text('—'),
                        ..._comments.map(
                          (c) => ListTile(
                            title: Text(c.username),
                            subtitle: Text(c.content),
                            trailing: Text(_fmtDateTime(c.createdAt), style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ),
                        if (auth.isAuthed) ...[
                          const SizedBox(height: 12),
                          TextField(controller: _commentCtrl, decoration: const InputDecoration(labelText: 'Add comment')),
                          const SizedBox(height: 8),
                          FilledButton(onPressed: _postComment, child: const Text('Post')),
                        ],
                      ],
                    ),
    );
  }
}

class LearningPathLinearPage extends StatefulWidget {
  const LearningPathLinearPage({super.key, required this.learningPathId});
  final int learningPathId;

  @override
  State<LearningPathLinearPage> createState() => _LearningPathLinearPageState();
}

class _LearningPathLinearPageState extends State<LearningPathLinearPage> {
  bool _loading = true;
  String _error = '';
  PublicLearningPathDetail? _detail;
  Map<int, int> _progressByItem = const {};

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final d = await api.learningPathApi.mineDetail(widget.learningPathId);
      final progress = await api.progressApi.listMineForPath(widget.learningPathId);
      final map = <int, int>{for (final p in progress) p.pathItemId: p.progressPercentage};
      if (!mounted) return;
      setState(() {
        _detail = d;
        _progressByItem = map;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Linear'), actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _detail == null
                  ? const Center(child: Text('Not found'))
                  : ListView.separated(
                      itemCount: _detail!.pathItems.length,
                      separatorBuilder: (a, b) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final item = _detail!.pathItems.toList()..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
                        final it = item[idx];
                        final pct = _progressByItem[it.id] ?? 0;
                        return ListTile(
                          title: Text(it.title),
                          subtitle: Text('${it.resourceType} · $pct%'),
                          onTap: () {
                            if (it.resourceType == 'video') {
                              context.go('/my-resources/video/${it.resourceId}?path_item_id=${it.id}');
                            } else if (it.resourceType == 'document') {
                              context.go('/my-resources/document/${it.resourceId}?path_item_id=${it.id}');
                            } else {
                              context.go('/my-resources/article/${it.resourceId}?path_item_id=${it.id}');
                            }
                          },
                        );
                      },
                    ),
    );
  }
}

class MyPathsPage extends StatefulWidget {
  const MyPathsPage({super.key});

  @override
  State<MyPathsPage> createState() => _MyPathsPageState();
}

class _MyPathsPageState extends State<MyPathsPage> {
  bool _loading = true;
  String _error = '';
  List<PublicLearningPath> _paths = const [];

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final res = await api.learningPathApi.listMine();
      if (!mounted) return;
      setState(() => _paths = res);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete(int id) async {
    try {
      await context.read<AppServices>().learningPathApi.deleteMine(id);
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Paths'), actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView.separated(
                  itemCount: _paths.length,
                  separatorBuilder: (a, b) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final p = _paths[idx];
                    return ListTile(
                      title: Text(p.title),
                      subtitle: Text(p.categoryName ?? '-'),
                      onTap: () => context.go('/learningpath/${p.id}/edit'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'edit') {
                            context.go('/learningpath/${p.id}/edit');
                          } else if (v == 'detail') {
                            context.go('/learningpath/${p.id}');
                          } else if (v == 'delete') {
                            _delete(p.id);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'detail', child: Text('Detail')),
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class CreatePathPage extends StatefulWidget {
  const CreatePathPage({super.key});

  @override
  State<CreatePathPage> createState() => _CreatePathPageState();
}

class _CreatePathPageState extends State<CreatePathPage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  bool _public = false;
  int? _categoryId;
  List<Category> _categories = const [];
  bool _loading = false;

  Future<void> _loadCats() async {
    try {
      final cats = await context.read<AppServices>().categoryApi.list();
      if (!mounted) return;
      setState(() {
        _categories = cats;
        _categoryId ??= cats.isNotEmpty ? cats.first.id : null;
      });
    } catch (e) {
      await _showError(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _create() async {
    setState(() => _loading = true);
    try {
      final api = context.read<AppServices>();
      final p = await api.learningPathApi.create(
        title: _title.text.trim(),
        description: _desc.text.trim(),
        isPublic: _public,
        categoryId: _categoryId,
      );
      if (!mounted) return;
      context.go('/learningpath/${p.id}/edit');
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Path')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 12),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), minLines: 3, maxLines: 8),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            initialValue: _categoryId,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories.map((c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name))).toList(),
            onChanged: (v) => setState(() => _categoryId = v),
          ),
          const SizedBox(height: 12),
          SwitchListTile(value: _public, onChanged: (v) => setState(() => _public = v), title: const Text('Public')),
          const SizedBox(height: 16),
          FilledButton(onPressed: _loading ? null : _create, child: Text(_loading ? 'Loading…' : 'Create')),
        ],
      ),
    );
  }
}

class LearningPathEditPage extends StatefulWidget {
  const LearningPathEditPage({super.key, required this.learningPathId});
  final int learningPathId;

  @override
  State<LearningPathEditPage> createState() => _LearningPathEditPageState();
}

class _LearningPathEditPageState extends State<LearningPathEditPage> {
  bool _loading = true;
  String _error = '';
  PublicLearningPathDetail? _detail;
  List<DbResource> _myResources = const [];
  int? _selectedResourceId;

  final _title = TextEditingController();
  final _desc = TextEditingController();
  bool _public = false;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final d = await api.learningPathApi.mineDetail(widget.learningPathId);
      final res = await api.resourceApi.listMine();
      if (!mounted) return;
      setState(() {
        _detail = d;
        _myResources = res;
        _selectedResourceId = res.isNotEmpty ? res.first.id : null;
        _title.text = d.title;
        _desc.text = d.description ?? '';
        _public = d.isPublic;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveMeta() async {
    try {
      await context.read<AppServices>().learningPathApi.update(widget.learningPathId, {
        'title': _title.text.trim(),
        'description': _desc.text.trim(),
        'is_public': _public,
      });
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  Future<void> _addItem() async {
    if (_selectedResourceId == null) return;
    try {
      await context.read<AppServices>().learningPathApi.addItem(widget.learningPathId, {
        'resource_id': _selectedResourceId,
      });
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  Future<void> _removeItem(int resourceId) async {
    try {
      await context.read<AppServices>().learningPathApi.removeItem(widget.learningPathId, resourceId);
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Path'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () => context.go('/learningpath/${widget.learningPathId}'), icon: const Icon(Icons.open_in_new)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _detail == null
                  ? const Center(child: Text('Not found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
                        const SizedBox(height: 12),
                        TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), minLines: 3, maxLines: 8),
                        const SizedBox(height: 12),
                        SwitchListTile(value: _public, onChanged: (v) => setState(() => _public = v), title: const Text('Public')),
                        const SizedBox(height: 12),
                        FilledButton(onPressed: _saveMeta, child: const Text('Save meta')),
                        const SizedBox(height: 16),
                        Text('Add resource', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          initialValue: _selectedResourceId,
                          items: _myResources
                              .map((r) => DropdownMenuItem<int?>(value: r.id, child: Text('${r.title} (${r.resourceType})')))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedResourceId = v),
                        ),
                        const SizedBox(height: 8),
                        FilledButton(onPressed: _addItem, child: const Text('Add')),
                        const SizedBox(height: 16),
                        Text('Items', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        ...(() {
                          final items = _detail!.pathItems.toList()
                            ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
                          return items
                              .map(
                                (it) => Card(
                                  child: ListTile(
                                    title: Text(it.title),
                                    subtitle: Text('${it.resourceType} · resource #${it.resourceId}'),
                                    trailing: IconButton(
                                      onPressed: () => _removeItem(it.resourceId),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ),
                                ),
                              )
                              .toList();
                        })(),
                      ],
                    ),
    );
  }
}

class AccountShellPage extends StatelessWidget {
  const AccountShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('User Info'),
            subtitle: Text(auth.user?.username ?? ''),
            onTap: () => context.go('/account/user-info'),
          ),
          ListTile(
            title: const Text('My Resources'),
            onTap: () => context.go('/account/my-resources'),
          ),
          ListTile(
            title: const Text('My Paths'),
            onTap: () => context.go('/account/my-paths'),
          ),
          ListTile(
            title: const Text('Plan'),
            onTap: () => context.go('/account/plan'),
          ),
          ListTile(
            title: const Text('Change Password'),
            onTap: () => context.go('/account/change-password'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              await context.read<AuthState>().logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class AccountUserInfoPage extends StatefulWidget {
  const AccountUserInfoPage({super.key});

  @override
  State<AccountUserInfoPage> createState() => _AccountUserInfoPageState();
}

class _AccountUserInfoPageState extends State<AccountUserInfoPage> {
  final _displayName = TextEditingController();
  final _bio = TextEditingController();
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthState>().user;
    _displayName.text = user?.displayName ?? '';
    _bio.text = user?.bio ?? '';
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      await context.read<AuthState>().updateProfile(displayName: _displayName.text.trim(), bio: _bio.text.trim());
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() => _loading = true);
    try {
      final services = context.read<AppServices>();
      final url = await services.userApi.uploadAvatar(File(img.path));
      await context.read<AuthState>().updateProfile(avatarUrl: url);
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthState>().user;
    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty)
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.avatarUrl!),
              ),
            ),
          TextButton(onPressed: _loading ? null : _pickAvatar, child: const Text('Upload avatar')),
          TextField(controller: _displayName, decoration: const InputDecoration(labelText: 'Display name')),
          const SizedBox(height: 12),
          TextField(controller: _bio, decoration: const InputDecoration(labelText: 'Bio'), minLines: 3, maxLines: 8),
          const SizedBox(height: 16),
          FilledButton(onPressed: _loading ? null : _save, child: Text(_loading ? 'Loading…' : 'Save')),
        ],
      ),
    );
  }
}

class AccountChangePasswordPage extends StatefulWidget {
  const AccountChangePasswordPage({super.key});

  @override
  State<AccountChangePasswordPage> createState() => _AccountChangePasswordPageState();
}

class _AccountChangePasswordPageState extends State<AccountChangePasswordPage> {
  final _cur = TextEditingController();
  final _next = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await context.read<AuthState>().changePassword(currentPassword: _cur.text, newPassword: _next.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed')));
      context.pop();
    } catch (e) {
      await _showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _cur, decoration: const InputDecoration(labelText: 'Current password'), obscureText: true),
          const SizedBox(height: 12),
          TextField(controller: _next, decoration: const InputDecoration(labelText: 'New password'), obscureText: true),
          const SizedBox(height: 16),
          FilledButton(onPressed: _loading ? null : _submit, child: Text(_loading ? 'Loading…' : 'Submit')),
        ],
      ),
    );
  }
}

class AccountMyResourcesPage extends StatelessWidget {
  const AccountMyResourcesPage({super.key});

  @override
  Widget build(BuildContext context) => const MyResourcesPage();
}

class AccountMyPathsPage extends StatelessWidget {
  const AccountMyPathsPage({super.key});

  @override
  Widget build(BuildContext context) => const MyPathsPage();
}

class AccountPlanPage extends StatelessWidget {
  const AccountPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Account plan page (same as web AccountPlan.vue).'),
      ),
    );
  }
}

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  bool _loading = true;
  String _error = '';
  List<UserFile> _files = const [];
  List<UserImage> _images = const [];

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final files = await api.userFileApi.listMine();
      final imgs = await api.userImageApi.listMine();
      if (!mounted) return;
      setState(() {
        _files = files;
        _images = imgs;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _uploadFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['md', 'txt']);
    final path = result?.files.single.path;
    if (path == null) return;

    try {
      final api = context.read<AppServices>();
      await api.userFileApi.uploadMine(file: File(path));
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    try {
      final api = context.read<AppServices>();
      await api.userImageApi.uploadMine(file: File(img.path));
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  Future<void> _openFile(UserFile f) async {
    try {
      final api = context.read<AppServices>();
      final text = await api.userFileApi.fetchText(f.fileUrl);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(f.title ?? f.originalFilename ?? 'File')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: SelectableText(text),
            ),
          ),
        ),
      );
    } catch (e) {
      await _showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text('Files', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    FilledButton(onPressed: _uploadFile, child: const Text('Upload .md/.txt')),
                    const SizedBox(height: 8),
                    ..._files.map(
                      (f) => ListTile(
                        title: Text(f.title ?? f.originalFilename ?? 'file'),
                        subtitle: Text('${f.fileType} · ${_fmtDateTime(f.createdAt)}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _openFile(f),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Images', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    FilledButton(onPressed: _uploadImage, child: const Text('Upload image')),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _images
                          .take(12)
                          .map(
                            (img) => SizedBox(
                              width: 110,
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(img.imageUrl, fit: BoxFit.cover),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
    );
  }
}

class ParticalShellPage extends StatelessWidget {
  const ParticalShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Partical'),
          bottom: const TabBar(tabs: [Tab(text: 'Image'), Tab(text: 'Flashed Ideas')]),
        ),
        body: TabBarView(
          children: const [
            ParticalImagePage(),
            ParticalFlashedIdeasPage(),
          ],
        ),
      ),
    );
  }
}

class ParticalImagePage extends StatefulWidget {
  const ParticalImagePage({super.key});

  @override
  State<ParticalImagePage> createState() => _ParticalImagePageState();
}

class _ParticalImagePageState extends State<ParticalImagePage> {
  bool _loading = true;
  String _error = '';
  List<UserImage> _images = const [];

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final imgs = await context.read<AppServices>().userImageApi.listMine();
      if (!mounted) return;
      setState(() => _images = imgs);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error.isNotEmpty) return Center(child: Text(_error));
    if (_images.isEmpty) {
      return const Center(child: Text('暂无图片'));
    }
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(12),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: _images
          .map(
            (img) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(img.imageUrl, fit: BoxFit.cover),
            ),
          )
          .toList(),
    );
  }
}

class ParticalFlashedIdeasPage extends StatelessWidget {
  const ParticalFlashedIdeasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Flashed Ideas'));
  }
}

class MyParticalShellPage extends StatelessWidget {
  const MyParticalShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Partical'),
          bottom: const TabBar(tabs: [Tab(text: 'Home'), Tab(text: 'Image'), Tab(text: 'Flashed')]),
        ),
        body: TabBarView(
          children: const [
            MyParticalHomePage(),
            ParticalImagePage(),
            ParticalFlashedIdeasPage(),
          ],
        ),
      ),
    );
  }
}

class MyParticalHomePage extends StatelessWidget {
  const MyParticalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('My Partical Home'));
  }
}

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Plan page (same as web Plan.vue).'),
      ),
    );
  }
}

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  bool _loading = true;
  String _error = '';
  List<Category> _cats = const [];
  List<DbResource> _mine = const [];
  List<DbResource> _public = const [];
  List<PublicLearningPath> _myPaths = const [];
  List<PublicLearningPath> _publicPaths = const [];

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final api = context.read<AppServices>();
      final cats = await api.categoryApi.list();
      final mine = await api.resourceApi.listMine();
      final pub = await api.resourceApi.listPublic();
      final myPaths = await api.learningPathApi.listMine();
      final publicPaths = await api.learningPathApi.listPublic();
      if (!mounted) return;
      setState(() {
        _cats = cats;
        _mine = mine;
        _public = pub;
        _myPaths = myPaths;
        _publicPaths = publicPaths;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _deletePublic(int id) async {
    try {
      await context.read<AppServices>().resourceApi.deletePublic(id);
      await _load();
    } catch (e) {
      await _showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tools'), actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text('Categories: ${_cats.length}'),
                    const SizedBox(height: 8),
                    Text('My resources: ${_mine.length}'),
                    Text('Public resources: ${_public.length}'),
                    const SizedBox(height: 8),
                    Text('My paths: ${_myPaths.length}'),
                    Text('Public paths: ${_publicPaths.length}'),
                    const SizedBox(height: 16),
                    Text('Public resources (delete)', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ..._public.take(10).map(
                          (r) => ListTile(
                            title: Text(r.title),
                            subtitle: Text('${r.resourceType} · #${r.id}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deletePublic(r.id),
                            ),
                          ),
                        ),
                  ],
                ),
    );
  }
}

class StackPage extends StatelessWidget {
  const StackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Stack UI page (same as web stackUI/Stack.vue).'),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(title: const Text('Resources'), onTap: () => context.go('/about/resources')),
          ListTile(title: const Text('Learning Paths'), onTap: () => context.go('/about/learning-paths')),
          ListTile(title: const Text('Progress'), onTap: () => context.go('/about/progress')),
        ],
      ),
    );
  }
}

class AboutResourcesPage extends StatelessWidget {
  const AboutResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Resources')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('About resources page.'),
      ),
    );
  }
}

class AboutLearningPathsPage extends StatelessWidget {
  const AboutLearningPathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Learning Paths')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('About learning paths page.'),
      ),
    );
  }
}

class AboutProgressPage extends StatelessWidget {
  const AboutProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Progress')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('About progress page.'),
      ),
    );
  }
}

class DeckPage extends StatelessWidget {
  const DeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deck')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Deck page.'),
      ),
    );
  }
}

class UiUxProMaxPage extends StatelessWidget {
  const UiUxProMaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UiUxProMax')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('UiUxProMax page.'),
      ),
    );
  }
}
