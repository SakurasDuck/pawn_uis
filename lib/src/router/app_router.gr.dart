// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    Example_1.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Example1(),
      );
    },
    Home.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeView(),
      );
    },
    Step_one.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StepOne(),
      );
    },
    Step_two.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StepTwo(),
      );
    },
  };
}

/// generated route for
/// [Example1]
class Example_1 extends PageRouteInfo<void> {
  const Example_1({List<PageRouteInfo>? children})
      : super(
          Example_1.name,
          initialChildren: children,
        );

  static const String name = 'Example_1';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeView]
class Home extends PageRouteInfo<void> {
  const Home({List<PageRouteInfo>? children})
      : super(
          Home.name,
          initialChildren: children,
        );

  static const String name = 'Home';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StepOne]
class Step_one extends PageRouteInfo<void> {
  const Step_one({List<PageRouteInfo>? children})
      : super(
          Step_one.name,
          initialChildren: children,
        );

  static const String name = 'Step_one';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StepTwo]
class Step_two extends PageRouteInfo<void> {
  const Step_two({List<PageRouteInfo>? children})
      : super(
          Step_two.name,
          initialChildren: children,
        );

  static const String name = 'Step_two';

  static const PageInfo<void> page = PageInfo<void>(name);
}
