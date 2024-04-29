
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pawn_uis/src/router/app_router.dart';

@RoutePage(
  name: 'example_1',
)
class Example1 extends StatelessWidget {
  const Example1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examples'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Step 1'),
            onTap: () {
              AutoRouter.of(context).push(const Step_one());
            },
          ),
          ListTile(
            title: const Text('Step 2'),
            onTap: () {
              AutoRouter.of(context).push(const Step_two());
            },
          )
        ],
      ),
    );
  }
}