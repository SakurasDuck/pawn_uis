import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import 'model.dart';
import 'providers.dart';

@RoutePage(
  name: 'step_one',
)
class StepOne extends StatelessWidget {
  const StepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1'),
      ),
      body: const StepOneBody(),
    );
  }
}

class StepOneBody extends StatelessWidget {
  const StepOneBody({this.outerController, super.key});

  final ScrollController? outerController;

  @override
  Widget build(BuildContext context) {
    final Map<int, BuildContext> sliverContexts = {};
    return Consumer(builder: (_, ref, __) {
      final scrollControl = ref.read(getScrollControlProvider(outerController));
      return Row(
        children: [
          //标题列表
          Expanded(
            flex: 1,
            child: Consumer(
              builder: (context, ref, child) {
                final subTitles = ref.watch(getSubTitlesProvider);
                return subTitles.when(
                    data: (data) => ListView.builder(
                        controller: ref.watch(titleControllerProvider),
                        itemBuilder: (context, index) =>
                            Consumer(builder: (context, ref, child) {
                              String? currentSubTitle =
                                  ref.watch(currentSubTitleProvider);
                              currentSubTitle ??= data[0];
                              return ListTile(
                                title: Text(data[index],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: currentSubTitle == data[index]
                                            ? Colors.blue
                                            : Colors.black)),
                                onTap: () {
                                  ref
                                      .read(currentSubTitleProvider.notifier)
                                      .change(
                                        data[index],
                                      );
                                  final control = ref.read(
                                      sliverControllerProvider(scrollControl));
                                  control.animateToPinnedHeader(
                                    index: index,
                                    context: sliverContexts[index]!,
                                  );
                                },
                              );
                            }),
                        itemCount: data.length),
                    error: (error, stack) => Center(
                          child: Text(error.toString()),
                        ),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ));
              },
            ),
          ),
          //内容列表
          Expanded(
              flex: 3,
              child: Consumer(
                builder: (context, ref, child) {
                  final content = ref.watch(getContentProvider);
                  return content.when(
                      data: (data) {
                        return SliverViewObserver(
                            controller: ref
                                .read(sliverControllerProvider(scrollControl)),
                            sliverContexts: () {
                              return sliverContexts.values.toList();
                            },
                            extendedHandleObserve: (context) {
                              // 完全自定义你的观察逻辑
                              final _obj =
                                  ObserverUtils.findRenderObject(context);
                              if (_obj is RenderSliverPinnedPersistentHeader) {
                                final viewport =
                                    ObserverUtils.findViewport(_obj);
                                final index = sliverContexts.values
                                    .toList()
                                    .indexOf(context);
                                if (viewport == null) return null;
                                // The geometry.visible is not absolutely reliable.
                                if (!(_obj.geometry?.visible ?? false) ||
                                    _obj.constraints.remainingPaintExtent <
                                        1e-10) {
                                  return PinnedHeaderObserveModel(
                                      sliver: _obj,
                                      viewport: viewport,
                                      visible: false,
                                      index: index);
                                }

                                //判断当前pinnedheader是否固定在顶部

                                final isPinnedHeader = _obj
                                            .geometry?.layoutExtent ==
                                        0 &&
                                    _obj.parentData
                                        is SliverPhysicalContainerParentData &&
                                    (_obj.parentData
                                                as SliverPhysicalContainerParentData)
                                            .paintOffset
                                            .dy ==
                                        0;

                                if (isPinnedHeader) {
                                  return PinnedHeaderObserveModel(
                                      sliver: _obj,
                                      viewport: viewport,
                                      visible: true,
                                      index: index);
                                } else {
                                  return PinnedHeaderObserveModel(
                                      sliver: _obj,
                                      viewport: viewport,
                                      visible: false,
                                      index: index);
                                }
                              }

                              return null;
                            },
                            onObserveAll: (model) {
                              for (var item in model.entries) {
                                if (item.value.visible) {
                                  ref
                                      .read(currentSubTitleProvider.notifier)
                                      .change(data.keys.elementAt(sliverContexts
                                          .values
                                          .toList()
                                          .indexOf(item.key)));
                                  ref.read(titleControllerProvider).animateTo(
                                      50.0 *
                                          sliverContexts.values
                                              .toList()
                                              .indexOf(item.key),
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.ease);
                                  break;
                                }
                              }
                            },
                            child: CustomScrollView(
                              controller: scrollControl,
                              slivers: [
                                for (int i = 0; i < data.entries.length; i++)
                                  SliverMainAxisGroup(
                                    slivers: [
                                      SliverPersistentHeader(
                                        pinned: true,
                                        delegate: SubtitleHeadlerDelegate(
                                            data.entries.elementAt(i).key,
                                            (context, title) {
                                          sliverContexts.addAll({i: context});
                                        }),
                                      ),
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              (context, index) => ListTile(
                                                    title: Text(
                                                        data.entries
                                                            .elementAt(i)
                                                            .value[index],
                                                        style: const TextStyle(
                                                            fontSize: 15)),
                                                  ),
                                              childCount: data.entries
                                                  .elementAt(i)
                                                  .value
                                                  .length))
                                    ],
                                  )
                              ],
                            ));
                      },
                      error: (error, stack) => Center(
                            child: Text(error.toString()),
                          ),
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ));
                },
              ))
        ],
      );
    });
  }
}

class SubtitleHeadlerDelegate extends SliverPersistentHeaderDelegate {
  const SubtitleHeadlerDelegate(this.title, this.getContentCallback);
  final String title;

  final void Function(BuildContext context, String title) getContentCallback;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //执行获取context的回调
    getContentCallback(context, title);
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  double get maxExtent => minExtent;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is SubtitleHeadlerDelegate && oldDelegate.title != title;
  }
}
