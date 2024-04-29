
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
ScrollController getScrollController(GetScrollControllerRef ref) =>
    ScrollController();