import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(
          surfaceTintColor: Colors.transparent,
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('open dialog'),
              onPressed: () => context.goNamed(RoutingConfig.dialog.name),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('open bottom sheet'),
              onPressed: () => context.goNamed(RoutingConfig.bottomSheet.name),
            ),
          ],
        ),
      ),
    );
  }
}

final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: RoutingConfig.home.path,
      name: RoutingConfig.home.name,
      pageBuilder: (_, __) => const MaterialPage(child: Home()),
      routes: [
        GoRoute(
          path: RoutingConfig.dialog.path,
          name: RoutingConfig.dialog.name,
          pageBuilder: (_, __) => DialogPage(
            builder: (_) => const SampleContent(),
          ),
        ),
        GoRoute(
          path: RoutingConfig.bottomSheet.path,
          name: RoutingConfig.bottomSheet.name,
          pageBuilder: (_, __) => BottomSheetPage(
            builder: (_) => const SampleContent(),
          ),
        ),
      ],
    ),
  ],
);

enum RoutingConfig {
  home('/', 'home'),
  dialog('dialog', 'dialog'),
  bottomSheet('bottom-sheet', 'bottomSheet');

  final String path;
  final String name;

  const RoutingConfig(this.path, this.name);
}

class SampleContent extends StatelessWidget {
  const SampleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Sample Content'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: context.pop,
            child: const Text('close'),
          ),
        ],
      ),
    );
  }
}

class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes,
    );
  }
}

class BottomSheetPage<T> extends Page<T> {
  final WidgetBuilder builder;
  final Offset? anchorPoint;
  final String? barrierLabel;
  final CapturedThemes? themes;

  const BottomSheetPage({
    required this.builder,
    this.anchorPoint,
    this.barrierLabel,
    this.themes,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute(
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierLabel: barrierLabel,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height / 2,
      ),
      useSafeArea: true,
      showDragHandle: true,
      elevation: 1.0,
    );
  }
}
