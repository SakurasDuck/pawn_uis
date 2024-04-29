import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:scrollview_observer/src/common/models/observe_scroll_child_model.dart';
import 'package:scrollview_observer/src/common/typedefs.dart';

class PinnedHeaderObserveModel extends ObserveModel {
  PinnedHeaderObserveModel({
    required super.visible,
    required super.viewport,
    required super.sliver,
    required this.index,
  }) : super(
          innerDisplayingChildModelList: [],
        );

  final int index;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is PinnedHeaderObserveModel) {
      return sliver == other.sliver &&
          visible == other.visible &&
          index == other.index;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return sliver.hashCode + index.hashCode + visible.hashCode;
  }
}

extension ScrollExt on SliverObserverController {
  Future<void> animateToPinnedHeader({
    required int index,
    required BuildContext context,
  }) {
    final Completer completer = Completer();
    _scrollToIndex(
      completer: completer,
      index: index,
      isFixedHeight: false,
      alignment: 0,
      padding: EdgeInsets.zero,
      sliverContext: context,
    );
    return completer.future;
  }

  Duration get _findingDuration => const Duration(milliseconds: 1);
  Curve get _findingCurve => Curves.ease;

  _scrollToIndex({
    required Completer completer,
    required int index,
    required bool isFixedHeight,
    required double alignment,
    required EdgeInsets padding,
    BuildContext? sliverContext,
    Duration? duration,
    Curve? curve,
    ObserverLocateIndexOffsetCallback? offset,
    ObserverRenderSliverType? renderSliverType,
  }) async {
    assert(alignment.clamp(0, 1) == alignment,
        'The [alignment] is expected to be a value in the range [0.0, 1.0]');
    assert(controller != null);
    var _controller = controller;
    final ctx = fetchSliverContext(sliverContext: sliverContext);
    if (ctx == null) {
      _handleScrollInterruption(context: ctx, completer: completer);
      return;
    }

    if (_controller == null || !_controller.hasClients) {
      _handleScrollInterruption(context: ctx, completer: completer);
      return;
    }

    var obj = ObserverUtils.findRenderObject(ctx);
    if (obj is! RenderSliverPinnedPersistentHeader) {
      _handleScrollInterruption(context: ctx, completer: completer);
      return;
    }

    final viewport = _findViewport(obj);
    if (viewport == null) {
      _handleScrollInterruption(context: ctx, completer: completer);
      return;
    }

    // Start executing scrolling task.
    _handleScrollStart(context: ctx);

    bool isAnimateTo = (duration != null) && (curve != null);

    // Before the next sliver is shown, it may have an incorrect value for
    // precedingScrollExtent, so we need to scroll around to get
    // precedingScrollExtent correctly.
    final objVisible = obj.geometry?.visible ?? false;
    if (!objVisible && viewport.offset.hasPixels) {
      final extremeScrollExtent = viewportExtremeScrollExtent(
        viewport: viewport,
        obj: obj,
      );
      final maxScrollExtent = extremeScrollExtent.rectify(obj);
      // If the target sliver does not paint any child because it is too far
      // away, we need to let the ScrollView scroll near it first.
      // https://github.com/LinXunFeng/flutter_scrollview_observer/issues/45

      final precedingScrollExtent = obj.constraints.precedingScrollExtent;
      final viewportOffset = viewport.offset.pixels.rectify(obj);
      final isHorizontal = obj.constraints.axis == Axis.horizontal;
      final viewportSize =
          isHorizontal ? viewport.size.width : viewport.size.height;
      final viewportBoundaryExtent =
          viewportSize * 0.5 + (viewport.cacheExtent ?? 0);
      if (precedingScrollExtent > (viewportOffset + viewportBoundaryExtent)) {
        double targetOffset = precedingScrollExtent - viewportBoundaryExtent;
        if (targetOffset > maxScrollExtent) targetOffset = maxScrollExtent;
        _controller.jumpTo(
          targetOffset.rectify(obj),
          // duration: _findingDuration,
          // curve: _findingCurve,
        );
        // await WidgetsBinding.instance.endOfFrame;
      }
    }
    // If the target sliver is already visible, we need to scroll to the
    // target sliver directly.

    final childLayoutOffset = obj.geometry?.layoutExtent ?? 0;
    final childSize = obj.geometry?.maxPaintExtent ?? 0;
    final targetOffset = _calculateTargetLayoutOffset(
      obj: obj,
      childLayoutOffset: childLayoutOffset,
      childSize: childSize,
      alignment: alignment,
      padding: padding,
      offset: offset,
    );
    if (isAnimateTo) {
      await _controller.animateTo(
        targetOffset,
        duration: duration,
        curve: curve,
      );
    } else {
      _controller.jumpTo(targetOffset);
    }
  }

  // var targetScrollChildModel = indexOffsetMap[ctx]?[index];
  // // There is a cache offset, scroll to the offset directly.
  // if (targetScrollChildModel != null) {
  //   _handleScrollDecision(context: ctx);
  //   var targetOffset = _calculateTargetLayoutOffset(
  //     obj: obj,
  //     childLayoutOffset: targetScrollChildModel.layoutOffset,
  //     childSize: targetScrollChildModel.size,
  //     alignment: alignment,
  //     padding: padding,
  //     offset: offset,
  //   );
  //   if (isAnimateTo) {
  //     await _controller.animateTo(
  //       targetOffset,
  //       duration: duration,
  //       curve: curve,
  //     );
  //   } else {
  //     _controller.jumpTo(targetOffset);
  //   }
  //   _handleScrollEnd(context: ctx, completer: completer);
  //   return;
  // }

  // Because it is fixed height, the offset can be directly calculated for
  // locating.
  // if (isFixedHeight) {
  //   _handleScrollToIndexForFixedHeight(
  //     completer: completer,
  //     ctx: ctx,
  //     obj: obj,
  //     index: index,
  //     alignment: alignment,
  //     padding: padding,
  //     duration: duration,
  //     curve: curve,
  //     offset: offset,
  //     renderSliverType: renderSliverType,
  //   );
  //   return;
  // }

  /// Update the [indexOffsetMap] property.
  _updateIndexOffsetMap({
    required BuildContext ctx,
    required int index,
    required double childLayoutOffset,
    required double childSize,
  }) {
    // No need to cache
    if (!cacheJumpIndexOffset) return;
    // To cache offset
    final map = indexOffsetMap[ctx] ?? {};
    map[index] = ObserveScrollChildModel(
      layoutOffset: childLayoutOffset,
      size: childSize,
    );
    indexOffsetMap[ctx] = map;
  }

  /// Getting target safety layout offset for scrolling to index.
  /// This can avoid jitter.
  double _calculateTargetLayoutOffset({
    required RenderSliverPinnedPersistentHeader obj,
    required double childLayoutOffset,
    required double childSize,
    required double alignment,
    required EdgeInsets padding,
    ObserverLocateIndexOffsetCallback? offset,
  }) {
    final precedingScrollExtent = obj.constraints.precedingScrollExtent;
    double targetItemLeadingPadding = childSize * alignment;
    var targetOffset =
        childLayoutOffset + precedingScrollExtent + targetItemLeadingPadding;
    double scrollOffset = 0;
    double remainingBottomExtent = 0;
    double needScrollExtent = 0;

    if (this is SliverObserverController) {
      final viewport = _findViewport(obj);
      if (viewport != null && viewport.offset.hasPixels) {
        scrollOffset = viewport.offset.pixels.rectify(obj);
        final extremeScrollExtent = viewportExtremeScrollExtent(
          viewport: viewport,
          obj: obj,
        );
        final maxScrollExtent = extremeScrollExtent.rectify(obj);
        remainingBottomExtent = maxScrollExtent - scrollOffset;
        needScrollExtent = childLayoutOffset +
            precedingScrollExtent +
            targetItemLeadingPadding -
            scrollOffset;
      }
    } else {
      final constraints = obj.constraints;
      final isVertical = constraints.axis == Axis.vertical;
      final trailingPadding = isVertical ? padding.bottom : padding.right;
      final viewportExtent = constraints.viewportMainAxisExtent;
      final geometry = obj.geometry;
      // The (estimated) total scrollable extent of this sliver.
      double scrollExtent = geometry?.scrollExtent ?? 0;
      scrollOffset = obj.constraints.scrollOffset;
      remainingBottomExtent = scrollExtent +
          precedingScrollExtent +
          trailingPadding -
          scrollOffset -
          viewportExtent;
      needScrollExtent = childLayoutOffset +
          precedingScrollExtent +
          targetItemLeadingPadding -
          scrollOffset;
    }

    final outerOffset = offset?.call(targetOffset) ?? 0;
    needScrollExtent = needScrollExtent - outerOffset;
    // The bottom remaining distance is satisfied to go completely scrolling.
    bool isEnoughScroll = remainingBottomExtent >= needScrollExtent;
    if (!isEnoughScroll) {
      targetOffset = remainingBottomExtent + scrollOffset;
    } else {
      targetOffset = needScrollExtent + scrollOffset;
    }
    // The remainingBottomExtent may be negative when the scrollView has too
    // few items.
    targetOffset = targetOffset.clamp(0, double.maxFinite);
    return targetOffset.rectify(obj);
  }

  /// Find out the viewport
  RenderViewportBase? _findViewport(RenderSliverPinnedPersistentHeader obj) {
    return ObserverUtils.findViewport(obj);
  }

  /// Getting the extreme scroll extent of viewport.
  /// The [maxScrollExtent] will be returned when growthDirection is forward.
  /// The [minScrollExtent] will be returned when growthDirection is reverse.
  double viewportExtremeScrollExtent({
    required RenderViewportBase viewport,
    required RenderSliverPinnedPersistentHeader obj,
  }) {
    final offset = viewport.offset;
    if (offset is! ScrollPosition) {
      return 0;
    }
    return obj.isForwardGrowthDirection
        ? offset.maxScrollExtent
        : offset.minScrollExtent;
  }

  /// Called when starting the scrolling task.
  _handleScrollStart({
    required BuildContext? context,
  }) {
    innerIsHandlingScroll = true;
    ObserverScrollStartNotification().dispatch(context);
  }

  /// Called when the scrolling task is interrupted.
  ///
  /// For example, the conditions are not met, or the item with the specified
  /// index cannot be found, etc.
  _handleScrollInterruption({
    required BuildContext? context,
    required Completer completer,
  }) {
    innerIsHandlingScroll = false;
    completer.complete();
    ObserverScrollInterruptionNotification().dispatch(context);
  }

  /// Called when the item with the specified index has been found.
  _handleScrollDecision({
    required BuildContext? context,
  }) {
    ObserverScrollDecisionNotification().dispatch(context);
  }

  /// Called after completing the scrolling task.
  _handleScrollEnd({
    required BuildContext? context,
    required Completer completer,
  }) {
    if (innerNeedOnceObserveCallBack != null) {
      ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) {
        innerIsHandlingScroll = false;
        innerNeedOnceObserveCallBack!();
        completer.complete();
        ObserverScrollEndNotification().dispatch(context);
      });
    } else {
      innerIsHandlingScroll = false;
      completer.complete();
      ObserverScrollEndNotification().dispatch(context);
    }
  }
}

