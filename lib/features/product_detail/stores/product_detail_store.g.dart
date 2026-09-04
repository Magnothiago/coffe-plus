// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductDetailStore on ProductDetailStoreBase, Store {
  Computed<int>? _$unitPriceCentsComputed;

  @override
  int get unitPriceCents => (_$unitPriceCentsComputed ??= Computed<int>(
    () => super.unitPriceCents,
    name: 'ProductDetailStoreBase.unitPriceCents',
  )).value;
  Computed<int>? _$totalPriceCentsComputed;

  @override
  int get totalPriceCents => (_$totalPriceCentsComputed ??= Computed<int>(
    () => super.totalPriceCents,
    name: 'ProductDetailStoreBase.totalPriceCents',
  )).value;

  late final _$sizeAtom = Atom(
    name: 'ProductDetailStoreBase.size',
    context: context,
  );

  @override
  SizeOption get size {
    _$sizeAtom.reportRead();
    return super.size;
  }

  @override
  set size(SizeOption value) {
    _$sizeAtom.reportWrite(value, super.size, () {
      super.size = value;
    });
  }

  late final _$milkAtom = Atom(
    name: 'ProductDetailStoreBase.milk',
    context: context,
  );

  @override
  MilkOption get milk {
    _$milkAtom.reportRead();
    return super.milk;
  }

  @override
  set milk(MilkOption value) {
    _$milkAtom.reportWrite(value, super.milk, () {
      super.milk = value;
    });
  }

  late final _$sweetnessAtom = Atom(
    name: 'ProductDetailStoreBase.sweetness',
    context: context,
  );

  @override
  SweetnessOption get sweetness {
    _$sweetnessAtom.reportRead();
    return super.sweetness;
  }

  @override
  set sweetness(SweetnessOption value) {
    _$sweetnessAtom.reportWrite(value, super.sweetness, () {
      super.sweetness = value;
    });
  }

  late final _$quantityAtom = Atom(
    name: 'ProductDetailStoreBase.quantity',
    context: context,
  );

  @override
  int get quantity {
    _$quantityAtom.reportRead();
    return super.quantity;
  }

  @override
  set quantity(int value) {
    _$quantityAtom.reportWrite(value, super.quantity, () {
      super.quantity = value;
    });
  }

  late final _$ProductDetailStoreBaseActionController = ActionController(
    name: 'ProductDetailStoreBase',
    context: context,
  );

  @override
  void selectSize(SizeOption option) {
    final _$actionInfo = _$ProductDetailStoreBaseActionController.startAction(
      name: 'ProductDetailStoreBase.selectSize',
    );
    try {
      return super.selectSize(option);
    } finally {
      _$ProductDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectMilk(MilkOption option) {
    final _$actionInfo = _$ProductDetailStoreBaseActionController.startAction(
      name: 'ProductDetailStoreBase.selectMilk',
    );
    try {
      return super.selectMilk(option);
    } finally {
      _$ProductDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectSweetness(SweetnessOption option) {
    final _$actionInfo = _$ProductDetailStoreBaseActionController.startAction(
      name: 'ProductDetailStoreBase.selectSweetness',
    );
    try {
      return super.selectSweetness(option);
    } finally {
      _$ProductDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$ProductDetailStoreBaseActionController.startAction(
      name: 'ProductDetailStoreBase.increment',
    );
    try {
      return super.increment();
    } finally {
      _$ProductDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrement() {
    final _$actionInfo = _$ProductDetailStoreBaseActionController.startAction(
      name: 'ProductDetailStoreBase.decrement',
    );
    try {
      return super.decrement();
    } finally {
      _$ProductDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
size: ${size},
milk: ${milk},
sweetness: ${sweetness},
quantity: ${quantity},
unitPriceCents: ${unitPriceCents},
totalPriceCents: ${totalPriceCents}
    ''';
  }
}
