import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: AssignmentShellRoute.page,
          initial: true,
          children: [
            AutoRoute(page: CompetitorsRoute.page, initial: true),
            AutoRoute(page: JudgesRoute.page),
            AutoRoute(page: RingSetupRoute.page),
            AutoRoute(page: AssignmentsRoute.page),
          ],
        ),
        AutoRoute(page: RingEditorRoute.page),
        AutoRoute(page: JudgeEditorRoute.page),
      ];
}
