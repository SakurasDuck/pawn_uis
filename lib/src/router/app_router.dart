import 'package:auto_route/auto_route.dart';

import '../uis/home.dart';
import '../uis/simple_1/view.dart';
import '../uis/simple_1/step_1/view.dart';
import '../uis/simple_1/step_2/view.dart';

import '../uis/simple_2/custom_sliver.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: Home.page, initial: true),
        AutoRoute(
          page: Example_1.page,
        ),
        AutoRoute(page: Step_one.page),
        AutoRoute(page: Step_two.page),
        AutoRoute(page: Custom_sliver.page),
      ];
}
