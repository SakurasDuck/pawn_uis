import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pawn_uis/src/router/app_router.dart';

@RoutePage(
  name: 'home',
)
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examples'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('example 1'),
            onTap: () {
              AutoRouter.of(context).push(const Example_1());
            },
          ),
          ListTile(
            title: const Text('custom sliver'),
            onTap: () {
              AutoRouter.of(context).push(const Custom_sliver());
            },
          ),
        ],
      ),
    );
  }
}
