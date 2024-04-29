import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

part 'providers.g.dart';

@riverpod
Future<List<String>> getSubTitles(GetSubTitlesRef ref) async {
  await Future.delayed(const Duration(milliseconds: 200));
  return List.generate(20, (index) => 'subTitle $index');
}

@riverpod
Future<Map<String, List<String>>> getContent(GetContentRef ref) async {
  await Future.delayed(const Duration(milliseconds: 200));
  return {
    for (var item in List.generate(20, (index) => 'subTitle $index'))
      item:
          List.generate(Random().nextInt(10) + 10, (index) => 'content $index')
  };
}

@riverpod
class CurrentSubTitle extends _$CurrentSubTitle {
  @override
  String? build() => null;

  void init(String subTitle) => state = subTitle;

  void change(String subTitle) => state = subTitle;
}

@riverpod
// ignore: unsupported_provider_value
class GetScrollControl extends _$GetScrollControl {
  @override
  ScrollController build(ScrollController? outerController) =>
      outerController ?? ScrollController();
}

@riverpod
SliverObserverController sliverController(
        SliverControllerRef ref, ScrollController outerController) =>
    SliverObserverController(
      controller: outerController,
    );


@riverpod
// ignore: unsupported_provider_value
ScrollController titleController(TitleControllerRef ref) => ScrollController();