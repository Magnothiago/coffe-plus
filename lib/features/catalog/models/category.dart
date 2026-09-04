/// Classificação de produtos do cardápio (Req 2.1).
///
/// Cada [Category] representa um grupo de bebidas/itens exibido como filtro na
/// tela de Menu ("Explorar Sabores").
enum Category {
  /// Bebidas à base de espresso.
  espresso,

  /// Bebidas/itens preparados por infusão (brewed).
  brewed,

  /// Bebidas geladas de extração a frio (cold brew).
  coldBrew,
}
