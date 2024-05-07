import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pawn_uis/assets/assets.dart';

@RoutePage(
  name: 'custom_sliver',
)
class CustomSliverView extends StatelessWidget {
  const CustomSliverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
      //为了能使CustomScrollView拉到顶部时还能继续往下拉，必须让 physics 支持弹性效果
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        //我们需要实现的 SliverFlexibleHeader 组件
        SliverFlexibleHeader(
          visibleExtent: 200, // 初始状态在列表中占用的布局高度
          // 为了能根据下拉状态变化来定制显示的布局，我们通过一个 builder 来动态构建布局。
          builder: (context, availableHeight) {
            return Image(
                image: const AssetImage(Assets.assets_images_asset_gif),
                width: 50,
                height: availableHeight,
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
              );
          },
        ),
        // 构建一个list
        SliverList.builder(
          itemBuilder: (context, index) {
            return Container(
              height: 120,
              color: index.isEven ? Colors.white : Colors.grey[200],
              child: Center(
                child: Text('Item $index'),
              ),
            );
          },
          itemCount: 30,
        ),
      ],
    ),
    );
  }
}

typedef SliverFlexibleHeaderBuilder = Widget Function(
  BuildContext context,
  double maxExtent,
  //ScrollDirection direction,
);

class SliverFlexibleHeader extends StatelessWidget {
  const SliverFlexibleHeader({
    this.visibleExtent = 0,
    required this.builder,
    super.key,
  });

  final SliverFlexibleHeaderBuilder builder;
  final double visibleExtent;

  @override
  Widget build(BuildContext context) {
    return _SliverFlexibleHeader(
      visibleExtent: visibleExtent,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return builder(context, constraints.maxHeight);
        },
      ),
    );
  }
}

class _SliverFlexibleHeader extends SingleChildRenderObjectWidget {
  const _SliverFlexibleHeader({
    super.child,
    this.visibleExtent = 0,
    super.key,
  });
  final double visibleExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FlexibleHeaderRenderSliver(visibleExtent);
  }

  @override
  void updateRenderObject(
      BuildContext context, _FlexibleHeaderRenderSliver renderObject) {
    renderObject.visibleExtent = visibleExtent;
  }
}

class _FlexibleHeaderRenderSliver extends RenderSliverSingleBoxAdapter {
  _FlexibleHeaderRenderSliver(double visibleExtent)
      : _visibleExtent = visibleExtent;

  double _lastOverScroll = 0;
  double _lastScrollOffset = 0;
  bool  _reported = false;
  double? _scrollOffsetCorrection ;
  late double _visibleExtent = 0;

  set visibleExtent(double value) {
    // 可视长度发生变化，更新状态并重新布局
    if (_visibleExtent != value) {
        _lastOverScroll = 0;
      _reported = false;
      // 计算修正值
      _scrollOffsetCorrection = value - _visibleExtent;
      _visibleExtent = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    // 滑动距离大于_visibleExtent时则表示子节点已经在屏幕之外了
     if (_scrollOffsetCorrection != null) {
      geometry = SliverGeometry(
        //修正
        scrollOffsetCorrection: _scrollOffsetCorrection,
      );
      _scrollOffsetCorrection = null;
      return;
    }
    if (child == null || (constraints.scrollOffset > _visibleExtent)) {
      geometry = SliverGeometry(scrollExtent: _visibleExtent);
      return;
    }
    //当已经完全滑出屏幕时
    if (constraints.scrollOffset > _visibleExtent) {
      geometry = SliverGeometry(scrollExtent: _visibleExtent);
      // 通知 child 重新布局，注意，通知一次即可，如果不通知，滑出屏幕后，child 在最后
      // 一次构建时拿到的可用高度可能不为 0。因为使用者在构建子节点的时候，可能会依赖
      // "当前的可用高度是否为0" 来做一些特殊处理，比如记录是否子节点已经离开了屏幕，
      // 因此，我们需要在离开屏幕时确保LayoutBuilder的builder会被调用一次（构建子组件）。
      if (!_reported) {
        _reported = true;
        child!.layout(
          constraints.asBoxConstraints(maxExtent: 0),
          //我们不会使用自节点的 Size, 关于此参数更详细的内容见本书后面关于layout原理的介绍
          parentUsesSize: false,
        );
      }
      return;
    }

    //子组件回到了屏幕中，重置通知状态
    _reported = false;


    // 测试overlap,下拉过程中overlap会一直变化.
    double overScroll = constraints.overlap < 0 ? constraints.overlap.abs() : 0;
    var scrollOffset = constraints.scrollOffset;

    // 在Viewport中顶部的可视空间为该 Sliver 可绘制的最大区域。
    // 1. 如果Sliver已经滑出可视区域则 constraints.scrollOffset 会大于 _visibleExtent，
    //    这种情况我们在一开始就判断过了。
    // 2. 如果我们下拉超出了边界，此时 overScroll>0，scrollOffset 值为0，所以最终的绘制区域为
    //    _visibleExtent + overScroll.
    double paintExtent = _visibleExtent + overScroll - constraints.scrollOffset;
    // 绘制高度不超过最大可绘制空间
    paintExtent = min(paintExtent, constraints.remainingPaintExtent);

    //对子组件进行布局，关于 layout 详细过程我们将在本书后面布局原理相关章节详细介绍，现在只需知道
    //子组件通过 LayoutBuilder可以拿到这里我们传递的约束对象（ExtraInfoBoxConstraints）
    child!.layout(
      constraints.asBoxConstraints(maxExtent: paintExtent),
      parentUsesSize: false,
    );

    //最大为_visibleExtent，最小为 0
    double layoutExtent = min(_visibleExtent, paintExtent);

    //设置geometry，Viewport 在布局时会用到
    geometry = SliverGeometry(
      scrollExtent: layoutExtent,
      paintOrigin: -overScroll,
      paintExtent: paintExtent,
      maxPaintExtent: paintExtent,
      layoutExtent: layoutExtent,
    );
  }
}
