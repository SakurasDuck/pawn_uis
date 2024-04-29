# pawn_uis

做一些UI布局练习

## 1. NestedScrollView +  SliverAppBar + 菜单二级联动  

  效果如下:  

<video controls>
    <source src="assets/videos/simple.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>  

上面效果可分为几部分:  

 1. app头部内容
 2. 自动收起的SliverAppBar的轮播图,推测效果是上拉往下滑收起,当滑到左侧第一项顶部时展开
 3. 二级联动菜单,左侧为菜单项,右侧为内容,点击左侧菜单项,右侧内容滚动到对应位置,右侧内容滚动时,左侧菜单项高亮,当内容滑动到下一项时,左侧菜单自动高亮下一项  

  实现步骤:  

第一步先实现3中的二级联动菜单  

1. 左侧为标题栏,右侧为内容栏(同时显示标题置顶),左侧点击时,右侧滚动到对应位置,右侧滑动到对应标题位置时,左侧自动高亮对应标题  
2. 布局,使用`Row`+`Expanded`,标题与内容栏的比例为1:3,左侧标题栏使用`ListView.builder`,`右侧内容栏使用CustomScrollView`,`itemBuilder`里面是`SliverMainAxisGroup(SliverPersistentHeader+SliverList)`实现对应的标题置顶,监听右侧滚动,滚动到对应位置时,左侧自动高亮对应标题  
3. 实现点击标题栏内容区滚动到指定位置,可以实现的方式有几种  
  a. 直接计算高度,因为demo内容高度固定,可以直接计算高度,然后滚动到对应位置  
  b. 使用scroll_to_index插件,可以实现点击滚动到对应位置  
  c. 使用scrollview_observer 插件,获取对应的项的context,然后通过`ListObserverController`传入context,然后滚动到对应位置(<span style="color:#569cd6">demo使用</span>)  

    在使用scrollview_observer插件时,发现在`CustomScrollView`中使用`SliverMainAxisGroup`时,无法使用其功能,查阅源码可知,其默认的查找以及定位是通过对应项的context.findRenderObject()来查找对应的`RenderSliverMultiBoxAdaptor`,从而找到对应的`parentData`,使用`SliverMainAxisGroup`时createRenderObject返回的是`RenderSliverMainAxisGroup`,所以无法找到对应的`RenderSliverMultiBoxAdaptor`,所以无法找到对应的`parentData`,所以无法实现滚动到对应位置,所以需要自定义处理,做法是改造控制器的滑动行为,将源码中涉及到对应使用`SliverMultiBoxAdaptorParentData`的替换为现有的`RenderSliverPinnedPersistentHeader`,并处理api不一致的问题  

4. 实现左侧自动高亮对应标题,可以通过监听右侧滚动,然后计算当前滚动到的位置,然后计算对应的标题,然后高亮对应标题:  
  这里也遇到相同的问题,`SliverViewObserver`插件无法监听到`SliverMainAxisGroup`的滚动,所以需要自定义处理,做法修改对应的接口,只需要重新定义`SliverViewObserver.extendedHandleObserve`context查找到对应的`ObserveModel`,这里的处理方式为当context对应的`RenderSliverPinnedPersistentHeader`固定在顶部,判断条件为`obj.parentData.paintOffset.dy == 0 && obj.geometry.layoutExtent == 0`,然后计算对应的标题,然后高亮对应标题

5. 实现滚动到指定标题时,左侧标题栏同步滚动到对应标题,这里可以通过`ScrollController`来实现,监听右侧滚动,然后计算对应的标题,然后滚动到对应标题  

第二步:  

  实现sliverAppbar效果,并实现与二级联动菜单的手势联动  

  1. 使用`extended_nested_scroll_view`插件,注意的是,使用`PrimaryScrollController.maybeOf(context)`获取innerController,然后传入StepOne中使用完成联动效果
  