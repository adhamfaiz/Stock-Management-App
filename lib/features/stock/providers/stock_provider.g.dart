// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockHistoryHash() => r'e00502a859a79cbf67877a625ad88f16f59a28af';

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

/// See also [stockHistory].
@ProviderFor(stockHistory)
const stockHistoryProvider = StockHistoryFamily();

/// See also [stockHistory].
class StockHistoryFamily extends Family<AsyncValue<List<StockHistory>>> {
  /// See also [stockHistory].
  const StockHistoryFamily();

  /// See also [stockHistory].
  StockHistoryProvider call(
    int productId,
  ) {
    return StockHistoryProvider(
      productId,
    );
  }

  @override
  StockHistoryProvider getProviderOverride(
    covariant StockHistoryProvider provider,
  ) {
    return call(
      provider.productId,
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
  String? get name => r'stockHistoryProvider';
}

/// See also [stockHistory].
class StockHistoryProvider
    extends AutoDisposeFutureProvider<List<StockHistory>> {
  /// See also [stockHistory].
  StockHistoryProvider(
    int productId,
  ) : this._internal(
          (ref) => stockHistory(
            ref as StockHistoryRef,
            productId,
          ),
          from: stockHistoryProvider,
          name: r'stockHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockHistoryHash,
          dependencies: StockHistoryFamily._dependencies,
          allTransitiveDependencies:
              StockHistoryFamily._allTransitiveDependencies,
          productId: productId,
        );

  StockHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final int productId;

  @override
  Override overrideWith(
    FutureOr<List<StockHistory>> Function(StockHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StockHistoryProvider._internal(
        (ref) => create(ref as StockHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<StockHistory>> createElement() {
    return _StockHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockHistoryProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StockHistoryRef on AutoDisposeFutureProviderRef<List<StockHistory>> {
  /// The parameter `productId` of this provider.
  int get productId;
}

class _StockHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<StockHistory>>
    with StockHistoryRef {
  _StockHistoryProviderElement(super.provider);

  @override
  int get productId => (origin as StockHistoryProvider).productId;
}

String _$stockNotifierHash() => r'605f7e50a038751d486914899f73bcd1290f4f09';

/// See also [StockNotifier].
@ProviderFor(StockNotifier)
final stockNotifierProvider =
    AutoDisposeAsyncNotifierProvider<StockNotifier, List<Stock>>.internal(
  StockNotifier.new,
  name: r'stockNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stockNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StockNotifier = AutoDisposeAsyncNotifier<List<Stock>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
