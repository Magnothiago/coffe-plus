// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:coffe_plus/di/injection.dart' as _i142;
import 'package:coffe_plus/features/cart/stores/cart_store.dart' as _i469;
import 'package:coffe_plus/features/catalog/data/local_product_data_source.dart'
    as _i419;
import 'package:coffe_plus/features/catalog/data/product_repository.dart'
    as _i378;
import 'package:coffe_plus/features/catalog/models/product.dart' as _i601;
import 'package:coffe_plus/features/login/stores/login_store.dart' as _i474;
import 'package:coffe_plus/features/menu/stores/menu_store.dart' as _i248;
import 'package:coffe_plus/features/product_detail/stores/product_detail_store.dart'
    as _i562;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final productDetailModule = _$ProductDetailModule();
    gh.factory<_i474.LoginStore>(() => _i474.LoginStore());
    gh.lazySingleton<_i469.CartStore>(() => _i469.CartStore());
    gh.lazySingleton<_i419.LocalProductDataSource>(
      () => const _i419.LocalProductDataSource(),
    );
    gh.lazySingleton<_i378.ProductRepository>(
      () => _i378.LocalProductRepository(gh<_i419.LocalProductDataSource>()),
    );
    gh.factory<_i248.MenuStore>(
      () => _i248.MenuStore(gh<_i378.ProductRepository>()),
    );
    gh.factoryParam<_i562.ProductDetailStore, _i601.Product, dynamic>(
      (product, _) => productDetailModule.productDetailStore(product),
    );
    return this;
  }
}

class _$ProductDetailModule extends _i142.ProductDetailModule {}
