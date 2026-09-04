// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MenuStore on MenuStoreBase, Store {
  Computed<List<Product>>? _$filteredProductsComputed;

  @override
  List<Product> get filteredProducts =>
      (_$filteredProductsComputed ??= Computed<List<Product>>(
        () => super.filteredProducts,
        name: 'MenuStoreBase.filteredProducts',
      )).value;

  late final _$selectedCategoryAtom = Atom(
    name: 'MenuStoreBase.selectedCategory',
    context: context,
  );

  @override
  Category get selectedCategory {
    _$selectedCategoryAtom.reportRead();
    return super.selectedCategory;
  }

  @override
  set selectedCategory(Category value) {
    _$selectedCategoryAtom.reportWrite(value, super.selectedCategory, () {
      super.selectedCategory = value;
    });
  }

  late final _$MenuStoreBaseActionController = ActionController(
    name: 'MenuStoreBase',
    context: context,
  );

  @override
  void selectCategory(Category category) {
    final _$actionInfo = _$MenuStoreBaseActionController.startAction(
      name: 'MenuStoreBase.selectCategory',
    );
    try {
      return super.selectCategory(category);
    } finally {
      _$MenuStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedCategory: ${selectedCategory},
filteredProducts: ${filteredProducts}
    ''';
  }
}
