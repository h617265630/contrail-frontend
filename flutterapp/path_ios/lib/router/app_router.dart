import 'package:go_router/go_router.dart';

import '../pages/pages.dart';
import '../state/auth_state.dart';

GoRouter createAppRouter(AuthState auth) {
  bool requiresAuth(String location) {
    final protectedPrefixes = <String>[
      '/my-resources',
      '/my-paths',
      '/createpath',
      '/learningpath/',
      '/account',
      '/creator',
      '/partical',
      '/my-partical',
      '/tools',
    ];

    for (final p in protectedPrefixes) {
      if (location == p || location.startsWith(p)) return true;
    }
    return false;
  }

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: auth,
    redirect: (context, state) {
      if (auth.initializing) return null;

      final loc = state.uri.path;
      final isAuthRoute = loc == '/login' || loc == '/register';
      if (!auth.isAuthed && requiresAuth(loc) && !isAuthRoute) {
        return '/login';
      }
      if (auth.isAuthed && isAuthRoute) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/home',
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/notification',
        name: 'notification',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: '/creator',
        name: 'creator',
        builder: (context, state) => const CreatorPage(),
      ),
      GoRoute(
        path: '/deck',
        name: 'deck',
        builder: (context, state) => const DeckPage(),
      ),
      GoRoute(
        path: '/learningpool',
        name: 'learningpool',
        builder: (context, state) => const LearningPoolPage(),
      ),
      GoRoute(
        path: '/learningpool/category/:category',
        name: 'learningpool-category',
        builder: (context, state) {
          final category = state.pathParameters['category'] ?? '';
          return LearningPoolCategoryPage(category: category);
        },
      ),
      GoRoute(
        path: '/my-paths',
        name: 'my-paths',
        builder: (context, state) => const MyPathsPage(),
      ),
      GoRoute(
        path: '/createpath',
        name: 'createpath',
        builder: (context, state) => const CreatePathPage(),
      ),
      GoRoute(
        path: '/resources',
        name: 'resources',
        builder: (context, state) => const ResourceLibraryPage(),
      ),
      GoRoute(
        path: '/my-resources',
        name: 'my-resources',
        builder: (context, state) => const MyResourcesPage(),
      ),
      GoRoute(
        path: '/my-resources/add',
        name: 'add-resource',
        builder: (context, state) => const AddResourcePage(),
      ),
      GoRoute(
        path: '/my-resources/:id/edit',
        name: 'my-resource-edit',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return MyResourceEditPage(resourceId: id ?? 0);
        },
      ),
      // Resource detail (my)
      GoRoute(
        path: '/my-resources/video/:id',
        name: 'my-resource-video',
        builder: (context, state) => ResourceVideoPage(
          resourceId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          isMine: true,
          pathItemId: int.tryParse(state.uri.queryParameters['path_item_id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/my-resources/document/:id',
        name: 'my-resource-document',
        builder: (context, state) => ResourceDocumentPage(
          resourceId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          isMine: true,
          pathItemId: int.tryParse(state.uri.queryParameters['path_item_id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/my-resources/article/:id',
        name: 'my-resource-article',
        builder: (context, state) => ResourceArticlePage(
          resourceId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          isMine: true,
          pathItemId: int.tryParse(state.uri.queryParameters['path_item_id'] ?? ''),
        ),
      ),
      // Resource detail (public)
      GoRoute(
        path: '/resources/video/:id',
        name: 'resource-video',
        builder: (context, state) => ResourceVideoPage(
          resourceId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          isMine: false,
          pathItemId: int.tryParse(state.uri.queryParameters['path_item_id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/resources/document/:id',
        name: 'resource-document',
        builder: (context, state) => ResourceDocumentPage(
          resourceId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          isMine: false,
          pathItemId: int.tryParse(state.uri.queryParameters['path_item_id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/resources/article/:id',
        name: 'resource-article',
        builder: (context, state) => ResourceArticlePage(
          resourceId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          isMine: false,
          pathItemId: int.tryParse(state.uri.queryParameters['path_item_id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/resources/:type/:id/add-to-path',
        name: 'resource-add-to-path',
        builder: (context, state) {
          final type = state.pathParameters['type'] ?? '';
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return AddResourceToPathPage(resourceType: type, resourceId: id);
        },
      ),
      // Learning path routes
      GoRoute(
        path: '/learningpath/:id',
        name: 'learningpath',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return LearningPathDetailPage(learningPathId: id);
        },
      ),
      GoRoute(
        path: '/learningpath/:id/detail',
        name: 'learningpath-detail',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return LearningPathDetailPage(learningPathId: id);
        },
      ),
      GoRoute(
        path: '/learningpath/:id/linear',
        name: 'learningpath-linear',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return LearningPathLinearPage(learningPathId: id);
        },
      ),
      GoRoute(
        path: '/learningpath/:id/edit',
        name: 'learningpath-edit',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return LearningPathEditPage(learningPathId: id);
        },
      ),
      // Account
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountShellPage(),
        routes: [
          GoRoute(
            path: 'my-resources',
            name: 'account-my-resources',
            builder: (context, state) => const AccountMyResourcesPage(),
          ),
          GoRoute(
            path: 'my-paths',
            name: 'account-my-paths',
            builder: (context, state) => const AccountMyPathsPage(),
          ),
          GoRoute(
            path: 'user-info',
            name: 'account-user-info',
            builder: (context, state) => const AccountUserInfoPage(),
          ),
          GoRoute(
            path: 'plan',
            name: 'account-plan',
            builder: (context, state) => const AccountPlanPage(),
          ),
          GoRoute(
            path: 'change-password',
            name: 'account-change-password',
            builder: (context, state) => const AccountChangePasswordPage(),
          ),
        ],
      ),
      // Partical
      GoRoute(
        path: '/partical',
        builder: (context, state) => const ParticalShellPage(),
      ),
      GoRoute(
        path: '/my-partical',
        builder: (context, state) => const MyParticalShellPage(),
      ),
      GoRoute(
        path: '/plan',
        name: 'plan',
        builder: (context, state) => const PlanPage(),
      ),
      GoRoute(
        path: '/tools',
        name: 'tools',
        builder: (context, state) => const ToolsPage(),
      ),
      GoRoute(
        path: '/stack',
        name: 'stack',
        builder: (context, state) => const StackPage(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/about/resources',
        name: 'about-resources',
        builder: (context, state) => const AboutResourcesPage(),
      ),
      GoRoute(
        path: '/about/learning-paths',
        name: 'about-learning-paths',
        builder: (context, state) => const AboutLearningPathsPage(),
      ),
      GoRoute(
        path: '/about/progress',
        name: 'about-progress',
        builder: (context, state) => const AboutProgressPage(),
      ),
      GoRoute(
        path: '/uiux',
        name: 'uiux',
        builder: (context, state) => const UiUxProMaxPage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
}
