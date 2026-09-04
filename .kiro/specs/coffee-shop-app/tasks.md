# Implementation Plan: coffee-shop-app ("The Sensory Pour")

## Overview

Este plano converte o design da feature em passos incrementais de código para o app Flutter `coffe_plus`. A ordem prioriza a base (dependências, DI, modelos, lógica pura) antes das Stores e telas, terminando com a fiação de navegação e os testes. Cada tarefa referencia os requisitos e/ou propriedades correspondentes do design. A implementação usa **Dart/Flutter** (linguagem definida no design), com MobX + GetIt/injectable + json_serializable e code gen via build_runner. Precificação sempre em centavos inteiros (`int`).

## Tasks

- [x] 1. Configurar dependências e geração de código
  - Adicionar em `dependencies` do `pubspec.yaml`: `mobx`, `flutter_mobx`, `get_it`, `injectable`, `json_annotation`
  - Adicionar em `dev_dependencies`: `build_runner`, `mobx_codegen`, `injectable_generator`, `json_serializable`
  - Adicionar `glados` em `dev_dependencies` (property-based testing)
  - Confirmar que a seção `flutter/assets` declara `assets/images/`
  - Rodar `flutter pub get`
  - _Requirements: 1.1, 1.2, 1.3, 1.7, 7.2_

- [x] 2. Configurar injeção de dependências (GetIt + injectable)
  - Criar `lib/di/injection.dart` com `getIt` e `configureDependencies()` anotado com `@InjectableInit()`
  - Refatorar `lib/main.dart` para chamar `configureDependencies()` antes de `runApp` e usar o tema do app
  - Gerar `injection.config.dart` via `dart run build_runner build --delete-conflicting-outputs`
  - _Requirements: 1.4, 1.5, 1.7_

- [x] 3. Implementar modelos de domínio e enums de opções
  - [x] 3.1 Criar enums de catálogo e opções
    - Criar `lib/features/catalog/models/category.dart` com `enum Category { espresso, brewed, coldBrew }`
    - Criar `lib/features/catalog/models/options.dart` com `SizeOption`, `MilkOption` (com `surchargeCents`: whole 0, oat 75, almond 75) e `SweetnessOption`
    - _Requirements: 2.1, 2.2, 5.2, 5.3, 5.4_

  - [x] 3.2 Implementar modelo Product com json_serializable
    - Criar `lib/features/catalog/models/product.dart` com `@JsonSerializable`, campos obrigatórios (id, name, description, basePriceCents, imagePath, category) e opcionais (tags, featured)
    - Implementar `fromJson`/`toJson` e igualdade por valor (`==`/`hashCode`) para suportar round-trip
    - _Requirements: 2.1, 2.3, 2.5_

  - [x] 3.3 Implementar modelo CartItem com json_serializable
    - Criar `lib/features/cart/models/cart_item.dart` com `@JsonSerializable(explicitToJson: true)`, Product aninhado, opções, `quantity`
    - Adicionar getters `unitPriceCents`/`lineTotalCents` (via PricingCalculator), `copyWith` e igualdade por valor
    - _Requirements: 2.2, 2.4_

  - [x] 3.4 Gerar código dos modelos
    - Rodar `dart run build_runner build --delete-conflicting-outputs` para produzir `product.g.dart` e `cart_item.g.dart`
    - _Requirements: 1.6, 2.3, 2.4_

  - [x] 3.5 Escrever property test para round-trip de Product
    - **Property 1: Product serialization round-trip**
    - Gerador `any.product`; comentário `// Feature: coffee-shop-app, Property 1`; >= 100 iterações
    - **Validates: Requirements 2.3**

  - [x] 3.6 Escrever property test para round-trip de CartItem
    - **Property 2: CartItem serialization round-trip**
    - Gerador `any.cartItem`; comentário `// Feature: coffee-shop-app, Property 2`; >= 100 iterações
    - **Validates: Requirements 2.4**

  - [x] 3.7 Escrever property test para campos obrigatórios ausentes
    - **Property 3: Missing required fields fail deserialization**
    - Remover cada campo obrigatório do JSON e esperar erro; comentário `// Feature: coffee-shop-app, Property 3`; >= 100 iterações
    - **Validates: Requirements 2.5**

  - [x] 3.8 Escrever unit tests de edge case para desserialização de Product
    - Cada campo obrigatório ausente ⇒ `Product.fromJson` lança (exemplos concretos)
    - _Requirements: 2.5_

- [x] 4. Implementar PricingCalculator (lógica pura em centavos)
  - [x] 4.1 Criar `lib/core/pricing/pricing_calculator.dart`
    - Implementar `unitPriceCents`, `lineTotalCents`, `subtotalCents`, `taxCents`, `totalCents` (com piso em 0)
    - _Requirements: 5.5, 5.8, 6.2, 6.4, 6.6_

  - [x] 4.2 Escrever property test para preço unitário com acréscimo de leite
    - **Property 6: Unit price includes milk surcharge**
    - Comentário `// Feature: coffee-shop-app, Property 6`; >= 100 iterações
    - **Validates: Requirements 5.5**

  - [x] 4.3 Escrever property test para line total = unit × quantity
    - **Property 8: Line total equals unit price times quantity**
    - Comentário `// Feature: coffee-shop-app, Property 8`; >= 100 iterações
    - **Validates: Requirements 5.8**

  - [x] 4.4 Escrever property test para subtotal = soma dos line totals
    - **Property 10: Subtotal is the sum of line totals**
    - Comentário `// Feature: coffee-shop-app, Property 10`; >= 100 iterações
    - **Validates: Requirements 6.2, 6.3, 6.4**

  - [x] 4.5 Escrever property test para total com piso em zero após desconto
    - **Property 11: Total clamps at zero after discount**
    - Comentário `// Feature: coffee-shop-app, Property 11`; >= 100 iterações
    - **Validates: Requirements 6.6**

- [x] 5. Implementar catálogo de produtos (repository + data source)
  - [x] 5.1 Criar LocalProductDataSource com catálogo mockado e resolver de imagem
    - Criar `lib/features/catalog/data/local_product_data_source.dart` com os 5 produtos (p1–p5) do design e mapa `id -> imagePath` usando apenas assets existentes
    - Implementar resolver de imagem com fallback para `assets/images/coffe.jpeg` quando ausente/não mapeado
    - _Requirements: 4.9, 7.1, 7.3_

  - [x] 5.2 Criar ProductRepository
    - Criar `lib/features/catalog/data/product_repository.dart` com interface `ProductRepository` (getAll, getByCategory, getById) e `LocalProductRepository` anotado `@LazySingleton(as: ProductRepository)`
    - `getByCategory` filtra `getAll()` pela categoria
    - _Requirements: 4.5, 4.9_

  - [x] 5.3 Regenerar DI para registrar o repositório
    - Rodar `dart run build_runner build --delete-conflicting-outputs` e confirmar registro do `ProductRepository`
    - _Requirements: 1.5, 1.6_

  - [x] 5.4 Escrever property test para filtro por categoria (soundness/completeness)
    - **Property 13: Category filter soundness and completeness**
    - Comentário `// Feature: coffee-shop-app, Property 13`; >= 100 iterações
    - **Validates: Requirements 4.5**

  - [x] 5.5 Escrever property test para resolução de imagem
    - **Property 15: Image resolution always yields an existing asset**
    - Verifica que o caminho resolvido pertence ao conjunto de assets existentes e usa o default quando ausente; comentário `// Feature: coffee-shop-app, Property 15`; >= 100 iterações
    - **Validates: Requirements 7.1, 7.3**

- [x] 6. Checkpoint - Garantir base compilando e testada
  - Garantir que todos os testes passam; rodar `flutter analyze` e `dart run build_runner build`. Perguntar ao usuário se surgirem dúvidas.

- [x] 7. Implementar LoginStore
  - [x] 7.1 Criar `lib/features/login/stores/login_store.dart`
    - Observables (email, password, obscurePassword, rememberMe), computeds (isEmailValid, isPasswordValid, canSubmit), actions (setEmail, setPassword, togglePasswordVisibility, toggleRememberMe); `@injectable`; `part 'login_store.g.dart'`
    - Gerar `login_store.g.dart` via build_runner
    - _Requirements: 1.5, 3.3, 3.4, 3.5, 3.6_

  - [x] 7.2 Escrever property test para paridade de toggles
    - **Property 4: Toggle parity**
    - Gerador `any.togglesSequence`; comentário `// Feature: coffee-shop-app, Property 4`; >= 100 iterações
    - **Validates: Requirements 3.3, 3.4**

  - [x] 7.3 Escrever property test para classificação de validade de email
    - **Property 5: Email validity classification**
    - Gerador `any.email`; comentário `// Feature: coffee-shop-app, Property 5`; >= 100 iterações
    - **Validates: Requirements 3.5, 3.6**

  - [x] 7.4 Escrever unit test de edge case para senha vazia/whitespace
    - Senha vazia/whitespace ⇒ `isPasswordValid` falso
    - _Requirements: 3.6_

- [x] 8. Implementar ProductDetailStore
  - [x] 8.1 Criar `lib/features/product_detail/stores/product_detail_store.dart`
    - Observables (product, size, milk, sweetness, quantity com default Whole Milk), computeds (unitPriceCents, totalPriceCents via PricingCalculator), actions (selectSize, selectMilk, selectSweetness, increment, decrement com piso em 1, buildCartItem); `@injectable` com `@factoryParam Product`; gerar `.g.dart`
    - _Requirements: 1.5, 5.3, 5.5, 5.6, 5.7, 5.8, 5.9_

  - [x] 8.2 Escrever property test para invariante de piso de quantidade
    - **Property 7: Quantity floor invariant**
    - Gerador `any.incDecSequence`; comentário `// Feature: coffee-shop-app, Property 7`; >= 100 iterações
    - **Validates: Requirements 5.6, 5.7**

  - [x] 8.3 Escrever property test para CartItem preservar seleções
    - **Property 9: Added cart item preserves selections**
    - Comentário `// Feature: coffee-shop-app, Property 9`; >= 100 iterações
    - **Validates: Requirements 4.7, 5.9**

- [x] 9. Implementar CartStore
  - [x] 9.1 Criar `lib/features/cart/stores/cart_store.dart`
    - `@lazySingleton`; observables (items `ObservableList<CartItem>`, promoCode, appliedDiscountCents, promoError), computeds (subtotalCents, taxCents, totalCents, isEmpty), actions (addItem, addProductWithDefaults, updateQuantity, removeItem, applyPromo sem lançar); gerar `.g.dart`
    - _Requirements: 1.5, 4.7, 6.2, 6.3, 6.4, 6.6, 6.7, 6.8_

  - [x] 9.2 Escrever property test para disponibilidade de checkout espelhar carrinho vazio
    - **Property 12: Checkout availability mirrors cart emptiness**
    - Comentário `// Feature: coffee-shop-app, Property 12`; >= 100 iterações
    - **Validates: Requirements 6.8**

  - [x] 9.3 Escrever unit test de edge case para promo code inválido
    - Promo code inválido ⇒ `promoError` definido, `appliedDiscountCents` 0
    - _Requirements: 6.7_

- [x] 10. Implementar MenuStore
  - [x] 10.1 Criar `lib/features/menu/stores/menu_store.dart`
    - `@injectable`; observable (selectedCategory), computed (filteredProducts via ProductRepository), action (selectCategory); gerar `.g.dart`
    - _Requirements: 1.5, 4.5_

  - [x] 10.2 Regenerar DI e confirmar resolução de todas as Stores
    - Rodar build_runner; confirmar que `getIt` resolve LoginStore, MenuStore, ProductDetailStore, CartStore e ProductRepository
    - _Requirements: 1.5, 1.6_

  - [x] 10.3 Escrever smoke test de wiring de DI
    - Após `configureDependencies()`, `getIt` resolve LoginStore, MenuStore, ProductDetailStore, CartStore e ProductRepository
    - _Requirements: 1.4, 1.5_

- [x] 11. Implementar tema e roteamento
  - [x] 11.1 Criar `lib/core/theme/app_theme.dart`
    - Tema "The Sensory Pour" (paleta marrom/creme, tipografia serifada nos títulos)
    - _Requirements: 3.2_

  - [x] 11.2 Criar `lib/core/routing/app_routes.dart`
    - Rotas nomeadas `/login`, `/menu`, `/product-detail` (recebe Product), `/cart`; aplicar o tema no `MaterialApp` do `main.dart`
    - _Requirements: 3.7, 4.6, 6.9_

- [x] 12. Implementar telas e navegação
  - [x] 12.1 Refatorar LoginPage para usar LoginStore
    - Refatorar `lib/features/login/pages/login_page.dart`: fundo `background_login.jpeg` + card central, título serifado, campos EMAIL/PASSWORD com toggle de olho, checkbox Remember me, validações via computeds, links (Forgot Password, Create account), divisor OR CONTINUE WITH, botões Google/Apple; navegar para Menu quando `canSubmit`
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8_

  - [x] 12.2 Implementar MenuPage e ProductCard
    - Criar `lib/features/menu/pages/menu_page.dart` e `lib/features/menu/widgets/product_card.dart`: app bar (menu, título, avatar), filtros de Category, cards (imagem, nome, descrição, preço, botão "+", badge FEATURED conforme flag), Bottom_Nav; tocar card navega para detalhes; "+" chama `addProductWithDefaults`
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.6, 4.7, 4.8, 4.9_

  - [x] 12.3 Implementar ProductDetailPage
    - Criar `lib/features/product_detail/pages/product_detail_page.dart`: hero/nome/preço/tags/descrição, seletores Size/Milk/Sweetness com defaults, controle de quantidade, botão ADD TO CART exibindo total; ao tocar adiciona CartItem e volta
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9_

  - [x] 12.4 Implementar CartPage e CartLine
    - Criar `lib/features/cart/pages/cart_page.dart` e `lib/features/cart/widgets/cart_line.dart`: lista de itens (imagem, nome, opções, preço, quantidade, remover), Order Summary (Subtotal/Tax/Total), campo Promo + APPLY com erro, ADD ANOTHER ITEM, PROCEED TO CHECKOUT desabilitado quando vazio, aviso, Bottom_Nav
    - _Requirements: 6.1, 6.2, 6.3, 6.5, 6.6, 6.7, 6.8, 6.9_

  - [x] 12.5 Escrever property test para badge FEATURED (lógica de decisão)
    - **Property 14: Featured badge reflects the flag**
    - Testa a função de decisão de exibição do badge sem renderizar UI; comentário `// Feature: coffee-shop-app, Property 14`; >= 100 iterações
    - **Validates: Requirements 4.4**

  - [x] 12.6 Escrever widget tests para Login e navegação
    - Presença de background + card, título serifado, campos, links e botões; navegação para Menu com credenciais válidas
    - _Requirements: 3.1, 3.2, 3.7, 3.8_

  - [x] 12.7 Escrever widget tests para Menu
    - App bar, filtros, cards com campos, catálogo/preços, Bottom_Nav; navegação ao tocar card
    - _Requirements: 4.1, 4.2, 4.3, 4.6, 4.8, 4.9_

  - [x] 12.8 Escrever widget tests para ProductDetail
    - Hero/nome/preço/tags/descrição, seletores e defaults
    - _Requirements: 5.1, 5.2, 5.3, 5.4_

  - [x] 12.9 Escrever widget tests para Cart
    - Lista de itens, order summary, botões e Bottom_Nav
    - _Requirements: 6.1, 6.5, 6.9_

- [x] 13. Checkpoint final - Garantir que tudo compila e passa
  - Rodar `flutter analyze`, `dart run build_runner build --delete-conflicting-outputs` e `flutter test`. Garantir que todos os testes passam; perguntar ao usuário se surgirem dúvidas.

## Notes

- Tarefas marcadas com `*` são opcionais (testes) e podem ser puladas para um MVP mais rápido.
- Cada tarefa referencia requisitos específicos para rastreabilidade; testes de propriedade referenciam a propriedade do design.
- Todas as 15 propriedades do design estão cobertas: P1 (3.5), P2 (3.6), P3 (3.7), P4 (7.2), P5 (7.3), P6 (4.2), P7 (8.2), P8 (4.3), P9 (8.3), P10 (4.4), P11 (4.5), P12 (9.2), P13 (5.4), P14 (12.5), P15 (5.5).
- Cada teste property-based roda com glados em >= 100 iterações e é anotado com `// Feature: coffee-shop-app, Property {n}`.
- Precificação sempre em centavos inteiros; formatação para exibição ($X.XX) ocorre só na camada de UI.
- Comandos de longa duração (dev server/watch) devem ser executados manualmente; use `flutter test` para execução única.

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1"] },
    { "id": 1, "tasks": ["2", "3.1", "4.1"] },
    { "id": 2, "tasks": ["3.2", "4.2", "4.3", "4.4", "4.5"] },
    { "id": 3, "tasks": ["3.3", "5.1"] },
    { "id": 4, "tasks": ["3.4", "5.2", "11.1", "11.2"] },
    { "id": 5, "tasks": ["3.5", "3.6", "3.7", "3.8", "5.3", "5.4", "5.5", "7.1", "9.1", "10.1"] },
    { "id": 6, "tasks": ["7.2", "7.3", "7.4", "8.1", "9.2", "9.3", "10.2"] },
    { "id": 7, "tasks": ["8.2", "8.3", "10.3", "12.1", "12.2", "12.3", "12.4"] },
    { "id": 8, "tasks": ["12.5", "12.6", "12.7", "12.8", "12.9"] }
  ]
}
```
