# Requirements Document

## Introduction

Esta feature ("coffee-shop-app") transforma o projeto Flutter existente "coffe_plus" em um aplicativo de cafeteria artesanal chamado "The Sensory Pour". A entrega abrange duas frentes:

1. **Arquitetura**: adoção de MobX (gerência de estado reativa), GetIt + injectable (injeção de dependências), json_serializable (serialização de modelos) e build_runner (geração de código), organizados sob a estrutura por features já existente.
2. **Telas**: Login, Menu (Explorar Sabores), Detalhes do Produto, e Carrinho de Compras, seguindo o design de tema café artesanal (paleta marrom/creme, tipografia serifada nos títulos) e reaproveitando as imagens presentes em `assets/images/`.

O escopo é de front-end/cliente: as telas, seus estados e o fluxo de navegação. A autenticação social (Google/Apple), checkout de pagamento e persistência remota são representados na interface, mas a integração com serviços externos reais está fora do escopo desta feature (tratados como stubs/mocks locais).

## Glossary

- **App**: O aplicativo Flutter "coffe_plus" / "The Sensory Pour" como um todo.
- **DI_Container**: O contêiner de injeção de dependências baseado em GetIt configurado via injectable.
- **Login_Store**: Store MobX responsável pelo estado da tela de Login (email, senha, visibilidade da senha, "remember me", estado de submissão).
- **Menu_Store**: Store MobX responsável pelo estado da tela de Menu (categoria selecionada, lista de produtos filtrada).
- **Product_Detail_Store**: Store MobX responsável pelo estado da tela de Detalhes do Produto (tamanho, leite, adoçamento, quantidade, preço calculado).
- **Cart_Store**: Store MobX responsável pelo estado do Carrinho (itens, subtotal, imposto, total, código promocional).
- **Product**: Modelo de dados de um item do cardápio (id, nome, descrição, preço base, imagem, categoria, tags, flag "featured").
- **Cart_Item**: Modelo de dados de um item adicionado ao carrinho (produto, tamanho, leite, adoçamento, quantidade, preço unitário calculado).
- **Category**: Classificação de produtos (Espresso, Brewed, Cold Brew).
- **Size_Option**: Opção de tamanho de bebida (8oz, 12oz, 16oz).
- **Milk_Option**: Opção de leite (Whole Milk, Oat Milk, Almond Milk), cada uma com um acréscimo de preço.
- **Sweetness_Option**: Nível de adoçamento (None, Light, Regular).
- **Promo_Code**: Código promocional aplicável ao total do pedido.
- **Bottom_Nav**: Barra de navegação inferior com destinos Home, Menu, Cart, Profile.
- **Line_Total**: Preço de um Cart_Item = preço unitário calculado × quantidade.
- **Subtotal**: Soma de todos os Line_Total no Carrinho.
- **Tax**: Imposto calculado sobre o Subtotal.
- **Total**: Subtotal + Tax − desconto do Promo_Code aplicado.

## Requirements

### Requirement 1: Configuração da Arquitetura e Dependências

**User Story:** Como desenvolvedor, quero uma arquitetura padronizada com gerência de estado, injeção de dependências e geração de código, para que as telas sejam construídas de forma consistente e testável.

#### Acceptance Criteria

1. THE App SHALL declarar as dependências mobx, flutter_mobx, get_it e injectable em `pubspec.yaml`.
2. THE App SHALL declarar as dependências de desenvolvimento build_runner, mobx_codegen, injectable_generator e json_serializable em `pubspec.yaml`.
3. THE App SHALL declarar a dependência json_annotation em `pubspec.yaml`.
4. WHEN o App é inicializado no `main`, THE DI_Container SHALL registrar todas as dependências injetáveis antes de a interface ser exibida.
5. THE DI_Container SHALL expor cada Store (Login_Store, Menu_Store, Product_Detail_Store, Cart_Store) como uma dependência resolvível.
6. WHEN o comando de geração de código (build_runner) é executado, THE App SHALL produzir os arquivos gerados de MobX, injectable e json_serializable sem erros de compilação.
7. THE App SHALL organizar o código-fonte sob `lib/features/{feature}` mantendo o padrão de organização por features existente.

### Requirement 2: Modelos de Dados Serializáveis

**User Story:** Como desenvolvedor, quero modelos de dados serializáveis, para que produtos e itens de carrinho possam ser convertidos de e para JSON de forma confiável.

#### Acceptance Criteria

1. THE App SHALL definir o modelo Product com os campos id, nome, descrição, preço base, caminho da imagem, categoria, tags e indicador "featured".
2. THE App SHALL definir o modelo Cart_Item com referência ao Product, Size_Option, Milk_Option, Sweetness_Option e quantidade.
3. WHEN um Product válido é serializado para JSON e desserializado de volta, THE App SHALL produzir um Product equivalente ao original (propriedade round-trip).
4. WHEN um Cart_Item válido é serializado para JSON e desserializado de volta, THE App SHALL produzir um Cart_Item equivalente ao original (propriedade round-trip).
5. IF um JSON com campos obrigatórios ausentes é fornecido para desserialização de Product, THEN THE App SHALL sinalizar um erro de desserialização.

### Requirement 3: Tela de Login

**User Story:** Como cliente, quero entrar no aplicativo com meu email e senha, para que eu possa acessar o cardápio e fazer pedidos.

#### Acceptance Criteria

1. THE App SHALL exibir a tela de Login com um card central sobreposto à imagem de fundo `background_login.jpeg`.
2. THE App SHALL exibir o título "The Sensory Pour" com tipografia serifada e o campo EMAIL ADDRESS e o campo PASSWORD no card de Login.
3. WHEN o cliente toca no ícone de olho do campo PASSWORD, THE Login_Store SHALL alternar a visibilidade do texto da senha entre oculto e visível.
4. WHEN o cliente toca no checkbox "Remember me", THE Login_Store SHALL alternar o estado de "remember me" entre ativado e desativado.
5. IF o campo EMAIL ADDRESS não contém um endereço de email em formato válido quando o cliente toca em "SIGN IN", THEN THE App SHALL exibir uma mensagem de validação no campo EMAIL ADDRESS.
6. IF o campo PASSWORD está vazio quando o cliente toca em "SIGN IN", THEN THE App SHALL exibir uma mensagem de validação no campo PASSWORD.
7. WHEN o cliente toca em "SIGN IN" com EMAIL ADDRESS e PASSWORD válidos, THE App SHALL navegar para a tela de Menu.
8. THE App SHALL exibir o link "Forgot Password?", o divisor "OR CONTINUE WITH", os botões Google e Apple, e o link "New to The Sensory Pour? Create an account" na tela de Login.

### Requirement 4: Tela de Menu (Explorar Sabores)

**User Story:** Como cliente, quero explorar os produtos disponíveis por categoria, para que eu possa escolher o que pedir.

#### Acceptance Criteria

1. THE App SHALL exibir na tela de Menu uma app bar contendo um botão de menu, o título "The Sensory Pour" e um avatar.
2. THE App SHALL exibir os filtros de Category Espresso, Brewed e Cold Brew na tela de Menu.
3. THE App SHALL exibir a lista de produtos em cards contendo imagem, nome, descrição, preço e um botão "+".
4. WHERE um Product possui o indicador "featured" ativo, THE App SHALL exibir o badge "FEATURED" no card correspondente.
5. WHEN o cliente seleciona uma Category, THE Menu_Store SHALL atualizar a lista exibida para conter apenas os produtos daquela Category.
6. WHEN o cliente toca no card de um Product, THE App SHALL navegar para a tela de Detalhes do Produto correspondente.
7. WHEN o cliente toca no botão "+" de um Product, THE Cart_Store SHALL adicionar o Product ao Carrinho com as opções padrão.
8. THE App SHALL exibir a Bottom_Nav com os destinos Home, Menu, Cart e Profile na tela de Menu.
9. THE App SHALL popular a lista de produtos incluindo Signature Lavender Latte ($5.50), Double Espresso ($3.50), Iced Americano ($4.00), Butter Croissant ($4.50) e Pour Over V60 ($5.00).

### Requirement 5: Tela de Detalhes do Produto

**User Story:** Como cliente, quero personalizar um produto e escolher a quantidade, para que eu adicione ao carrinho exatamente o que desejo.

#### Acceptance Criteria

1. THE App SHALL exibir na tela de Detalhes do Produto a imagem grande do Product, o nome, o preço, as tags e a descrição.
2. THE App SHALL exibir o seletor de Size_Option com as opções 8oz, 12oz e 16oz.
3. THE App SHALL exibir o seletor de Milk_Option com Whole Milk selecionado por padrão, Oat Milk (+$0.75) e Almond Milk (+$0.75).
4. THE App SHALL exibir o seletor de Sweetness_Option com as opções None, Light e Regular.
5. WHEN o cliente seleciona uma Milk_Option com acréscimo, THE Product_Detail_Store SHALL somar o acréscimo correspondente ao preço unitário exibido.
6. WHEN o cliente toca no controle de incremento de quantidade, THE Product_Detail_Store SHALL aumentar a quantidade em 1.
7. WHILE a quantidade é igual a 1, THE Product_Detail_Store SHALL manter a quantidade em 1 quando o cliente toca no controle de decremento.
8. THE App SHALL exibir no botão "ADD TO CART" o preço total calculado como preço unitário × quantidade.
9. WHEN o cliente toca em "ADD TO CART", THE Cart_Store SHALL adicionar ao Carrinho um Cart_Item com as opções e a quantidade selecionadas.

### Requirement 6: Tela de Carrinho de Compras (Your Cart)

**User Story:** Como cliente, quero revisar e ajustar os itens do meu pedido antes de finalizar, para que eu tenha controle sobre o que vou comprar.

#### Acceptance Criteria

1. THE App SHALL exibir na tela de Carrinho a lista de Cart_Item, cada um com imagem, nome, opções selecionadas, preço, controle de quantidade e ação de remover.
2. WHEN o cliente altera a quantidade de um Cart_Item, THE Cart_Store SHALL recalcular o Line_Total do Cart_Item, o Subtotal, o Tax e o Total.
3. WHEN o cliente toca na ação de remover de um Cart_Item, THE Cart_Store SHALL remover o Cart_Item do Carrinho e recalcular o Subtotal, o Tax e o Total.
4. THE Cart_Store SHALL calcular o Subtotal como a soma dos Line_Total de todos os Cart_Item.
5. THE App SHALL exibir o Order Summary com Subtotal, Tax e Total na tela de Carrinho.
6. WHEN o cliente insere um Promo_Code e toca em "APPLY", THE Cart_Store SHALL aplicar o desconto correspondente ao Total.
7. IF o Promo_Code informado é inválido quando o cliente toca em "APPLY", THEN THE App SHALL exibir uma mensagem indicando que o Promo_Code é inválido.
8. WHILE o Carrinho não contém nenhum Cart_Item, THE App SHALL desabilitar o botão "PROCEED TO CHECKOUT".
9. THE App SHALL exibir o botão "ADD ANOTHER ITEM", o botão "PROCEED TO CHECKOUT", o aviso informativo e a Bottom_Nav na tela de Carrinho.

### Requirement 7: Reaproveitamento de Assets de Imagem

**User Story:** Como desenvolvedor, quero reutilizar as imagens já presentes no projeto, para que o aplicativo tenha identidade visual sem adicionar novos arquivos de imagem.

#### Acceptance Criteria

1. THE App SHALL utilizar exclusivamente as imagens já existentes em `assets/images/` para fundos, produtos e ícones das telas.
2. THE App SHALL declarar o diretório `assets/images/` na seção de assets do `pubspec.yaml`.
3. IF um Product não possui uma imagem específica correspondente em `assets/images/`, THEN THE App SHALL exibir uma das imagens de café existentes como imagem padrão.
