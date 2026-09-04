// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on CartStoreBase, Store {
  Computed<int>? _$subtotalCentsComputed;

  @override
  int get subtotalCents => (_$subtotalCentsComputed ??= Computed<int>(
    () => super.subtotalCents,
    name: 'CartStoreBase.subtotalCents',
  )).value;
  Computed<int>? _$taxCentsComputed;

  @override
  int get taxCents => (_$taxCentsComputed ??= Computed<int>(
    () => super.taxCents,
    name: 'CartStoreBase.taxCents',
  )).value;
  Computed<int>? _$totalCentsComputed;

  @override
  int get totalCents => (_$totalCentsComputed ??= Computed<int>(
    () => super.totalCents,
    name: 'CartStoreBase.totalCents',
  )).value;
  Computed<bool>? _$isEmptyComputed;

  @override
  bool get isEmpty => (_$isEmptyComputed ??= Computed<bool>(
    () => super.isEmpty,
    name: 'CartStoreBase.isEmpty',
  )).value;

  late final _$itemsAtom = Atom(name: 'CartStoreBase.items', context: context);

  @override
  ObservableList<CartItem> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<CartItem> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$promoCodeAtom = Atom(
    name: 'CartStoreBase.promoCode',
    context: context,
  );

  @override
  String get promoCode {
    _$promoCodeAtom.reportRead();
    return super.promoCode;
  }

  @override
  set promoCode(String value) {
    _$promoCodeAtom.reportWrite(value, super.promoCode, () {
      super.promoCode = value;
    });
  }

  late final _$appliedDiscountCentsAtom = Atom(
    name: 'CartStoreBase.appliedDiscountCents',
    context: context,
  );

  @override
  int get appliedDiscountCents {
    _$appliedDiscountCentsAtom.reportRead();
    return super.appliedDiscountCents;
  }

  @override
  set appliedDiscountCents(int value) {
    _$appliedDiscountCentsAtom.reportWrite(
      value,
      super.appliedDiscountCents,
      () {
        super.appliedDiscountCents = value;
      },
    );
  }

  late final _$promoErrorAtom = Atom(
    name: 'CartStoreBase.promoError',
    context: context,
  );

  @override
  String? get promoError {
    _$promoErrorAtom.reportRead();
    return super.promoError;
  }

  @override
  set promoError(String? value) {
    _$promoErrorAtom.reportWrite(value, super.promoError, () {
      super.promoError = value;
    });
  }

  late final _$CartStoreBaseActionController = ActionController(
    name: 'CartStoreBase',
    context: context,
  );

  @override
  void addItem(CartItem item) {
    final _$actionInfo = _$CartStoreBaseActionController.startAction(
      name: 'CartStoreBase.addItem',
    );
    try {
      return super.addItem(item);
    } finally {
      _$CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addProductWithDefaults(Product product) {
    final _$actionInfo = _$CartStoreBaseActionController.startAction(
      name: 'CartStoreBase.addProductWithDefaults',
    );
    try {
      return super.addProductWithDefaults(product);
    } finally {
      _$CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateQuantity(int index, int quantity) {
    final _$actionInfo = _$CartStoreBaseActionController.startAction(
      name: 'CartStoreBase.updateQuantity',
    );
    try {
      return super.updateQuantity(index, quantity);
    } finally {
      _$CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(int index) {
    final _$actionInfo = _$CartStoreBaseActionController.startAction(
      name: 'CartStoreBase.removeItem',
    );
    try {
      return super.removeItem(index);
    } finally {
      _$CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void applyPromo(String code) {
    final _$actionInfo = _$CartStoreBaseActionController.startAction(
      name: 'CartStoreBase.applyPromo',
    );
    try {
      return super.applyPromo(code);
    } finally {
      _$CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
items: ${items},
promoCode: ${promoCode},
appliedDiscountCents: ${appliedDiscountCents},
promoError: ${promoError},
subtotalCents: ${subtotalCents},
taxCents: ${taxCents},
totalCents: ${totalCents},
isEmpty: ${isEmpty}
    ''';
  }
}
