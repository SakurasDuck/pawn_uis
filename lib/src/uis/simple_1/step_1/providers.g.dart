// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getSubTitlesHash() => r'd672f7e960f44ef44a8e8413ef2a78cd9c140207';

/// See also [getSubTitles].
@ProviderFor(getSubTitles)
final getSubTitlesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  getSubTitles,
  name: r'getSubTitlesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getSubTitlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetSubTitlesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$getContentHash() => r'82d08c003e31530dbba2f64fd43c632986a4202a';

/// See also [getContent].
@ProviderFor(getContent)
final getContentProvider =
    AutoDisposeFutureProvider<Map<String, List<String>>>.internal(
  getContent,
  name: r'getContentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getContentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetContentRef = AutoDisposeFutureProviderRef<Map<String, List<String>>>;
String _$sliverControllerHash() => r'3c235563266e0058287460d55d6c3741ecf88dae';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [sliverController].
@ProviderFor(sliverController)
const sliverControllerProvider = SliverControllerFamily();

/// See also [sliverController].
class SliverControllerFamily extends Family<SliverObserverController> {
  /// See also [sliverController].
  const SliverControllerFamily();

  /// See also [sliverController].
  SliverControllerProvider call(
    ScrollController outerController,
  ) {
    return SliverControllerProvider(
      outerController,
    );
  }

  @override
  SliverControllerProvider getProviderOverride(
    covariant SliverControllerProvider provider,
  ) {
    return call(
      provider.outerController,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sliverControllerProvider';
}

/// See also [sliverController].
class SliverControllerProvider
    extends AutoDisposeProvider<SliverObserverController> {
  /// See also [sliverController].
  SliverControllerProvider(
    ScrollController outerController,
  ) : this._internal(
          (ref) => sliverController(
            ref as SliverControllerRef,
            outerController,
          ),
          from: sliverControllerProvider,
          name: r'sliverControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sliverControllerHash,
          dependencies: SliverControllerFamily._dependencies,
          allTransitiveDependencies:
              SliverControllerFamily._allTransitiveDependencies,
          outerController: outerController,
        );

  SliverControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.outerController,
  }) : super.internal();

  final ScrollController outerController;

  @override
  Override overrideWith(
    SliverObserverController Function(SliverControllerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SliverControllerProvider._internal(
        (ref) => create(ref as SliverControllerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        outerController: outerController,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<SliverObserverController> createElement() {
    return _SliverControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SliverControllerProvider &&
        other.outerController == outerController;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, outerController.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SliverControllerRef on AutoDisposeProviderRef<SliverObserverController> {
  /// The parameter `outerController` of this provider.
  ScrollController get outerController;
}

class _SliverControllerProviderElement
    extends AutoDisposeProviderElement<SliverObserverController>
    with SliverControllerRef {
  _SliverControllerProviderElement(super.provider);

  @override
  ScrollController get outerController =>
      (origin as SliverControllerProvider).outerController;
}

String _$titleControllerHash() => r'1bec3ec406a118927be18b0b69b45c53ada807d8';

/// See also [titleController].
@ProviderFor(titleController)
final titleControllerProvider = AutoDisposeProvider<ScrollController>.internal(
  titleController,
  name: r'titleControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$titleControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TitleControllerRef = AutoDisposeProviderRef<ScrollController>;
String _$currentSubTitleHash() => r'9a2c240a69b9796d73fc7c8438fb9eddabeb8c18';

/// See also [CurrentSubTitle].
@ProviderFor(CurrentSubTitle)
final currentSubTitleProvider =
    AutoDisposeNotifierProvider<CurrentSubTitle, String?>.internal(
  CurrentSubTitle.new,
  name: r'currentSubTitleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSubTitleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSubTitle = AutoDisposeNotifier<String?>;
String _$getScrollControlHash() => r'9cfc64fe2d0815927fd6424acb0d66c88264c4dc';

abstract class _$GetScrollControl
    extends BuildlessAutoDisposeNotifier<ScrollController> {
  late final ScrollController? outerController;

  ScrollController build(
    ScrollController? outerController,
  );
}

/// See also [GetScrollControl].
@ProviderFor(GetScrollControl)
const getScrollControlProvider = GetScrollControlFamily();

/// See also [GetScrollControl].
class GetScrollControlFamily extends Family<ScrollController> {
  /// See also [GetScrollControl].
  const GetScrollControlFamily();

  /// See also [GetScrollControl].
  GetScrollControlProvider call(
    ScrollController? outerController,
  ) {
    return GetScrollControlProvider(
      outerController,
    );
  }

  @override
  GetScrollControlProvider getProviderOverride(
    covariant GetScrollControlProvider provider,
  ) {
    return call(
      provider.outerController,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getScrollControlProvider';
}

/// See also [GetScrollControl].
class GetScrollControlProvider extends AutoDisposeNotifierProviderImpl<
    GetScrollControl, ScrollController> {
  /// See also [GetScrollControl].
  GetScrollControlProvider(
    ScrollController? outerController,
  ) : this._internal(
          () => GetScrollControl()..outerController = outerController,
          from: getScrollControlProvider,
          name: r'getScrollControlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getScrollControlHash,
          dependencies: GetScrollControlFamily._dependencies,
          allTransitiveDependencies:
              GetScrollControlFamily._allTransitiveDependencies,
          outerController: outerController,
        );

  GetScrollControlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.outerController,
  }) : super.internal();

  final ScrollController? outerController;

  @override
  ScrollController runNotifierBuild(
    covariant GetScrollControl notifier,
  ) {
    return notifier.build(
      outerController,
    );
  }

  @override
  Override overrideWith(GetScrollControl Function() create) {
    return ProviderOverride(
      origin: this,
      override: GetScrollControlProvider._internal(
        () => create()..outerController = outerController,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        outerController: outerController,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<GetScrollControl, ScrollController>
      createElement() {
    return _GetScrollControlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetScrollControlProvider &&
        other.outerController == outerController;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, outerController.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetScrollControlRef on AutoDisposeNotifierProviderRef<ScrollController> {
  /// The parameter `outerController` of this provider.
  ScrollController? get outerController;
}

class _GetScrollControlProviderElement
    extends AutoDisposeNotifierProviderElement<GetScrollControl,
        ScrollController> with GetScrollControlRef {
  _GetScrollControlProviderElement(super.provider);

  @override
  ScrollController? get outerController =>
      (origin as GetScrollControlProvider).outerController;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
