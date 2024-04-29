import 'package:auto_route/auto_route.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../step_1/view.dart';
import 'providers.dart';

@RoutePage(
  name: 'step_two',
)
class StepTwo extends StatelessWidget {
  const StepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final control = ref.read(getScrollControllerProvider);
          return ExtendedNestedScrollView(
              // controller: control,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                return <Widget>[
                  const SliverToBoxAdapter(
                    child: Icon(
                      Icons.safety_divider,
                      size: 20,
                    ),
                  ),
                ];
              },
              body: Builder(
                  builder: (context) => StepOneBody(
                        outerController:
                            PrimaryScrollController.maybeOf(context),
                      )));
        },
      ),
    );
  }
}
