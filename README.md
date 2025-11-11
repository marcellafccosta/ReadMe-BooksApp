# ReadMe: Seu Gerenciador de Leitura Pessoal 📚

ReadMe é um aplicativo iOS nativo, desenvolvido em **SwiftUI**, que tem como objetivo ajudar o usuário a gerenciar sua biblioteca digital e acompanhar o progresso de suas leituras. Ele permite a busca de livros online, a marcação de favoritos e o registro detalhado do seu progresso, incluindo anotações.

-----

## Tecnologias Utilizadas

O projeto foi construído utilizando as tecnologias mais modernas do ecossistema Apple:

  * **SwiftUI:** Para a construção da interface de usuário declarativa e responsiva.
  * **SwiftData:** Para a persistência de dados local, gerenciando favoritos, progresso e anotações.
  * **Google Books API:** Utilizada como fonte de dados para buscar informações e capas dos livros (como visto em `BooksService.swift` e `NetworkService.swift`).

-----

## Funcionalidades

O BooksApp oferece um conjunto de recursos para aprimorar sua experiência de leitura:

1.  **Busca e Estante de Livros:**

      * A tela inicial (`BookList.swift`) exibe livros obtidos através da Google Books API.
      * Permite pesquisar novos títulos ou autores.

2.  **Detalhes e Favoritos:**

      * Visualização detalhada do livro (`BookDetails.swift`).
      * Sistema de favoritos, onde é possível adicionar ou remover livros da sua lista pessoal (`FavoriteBookViewModel.swift`).

3.  **Acompanhamento de Progresso:**

      * Inicie o acompanhamento de um livro para registrar a página atual de leitura (`ProgressViewModel.swift`, `ProgressList.swift`).
      * Acompanhe o status com uma barra de progresso (visto em `BookDetails.swift` e `ProgressList.swift`).

4.  **Anotações de Leitura:**

      * Adicione anotações e notas para passagens importantes do livro (`AnnotationView.swift`).
      * As anotações podem incluir um número de página opcional e são persistidas com o SwiftData (`Annotation.swift`).

5.  **Experiência do Usuário:**

      * Suporte a multi-idiomas, incluindo **Inglês** e **Português Brasileiro** (localizado em `Localizable.xcstrings`).
      * Splash Screen durante o carregamento inicial (`SplashScreen.swift`).

-----

## Arquitetura e Estrutura

O projeto adota o padrão de arquitetura **MVVM (Model-View-ViewModel)**.

| Diretório | Descrição |
| :--- | :--- |
| `Model/` | Contém as estruturas de dados, incluindo modelos Codable para a API (`Book.swift`) e modelos `@Model` para persistência do SwiftData (`FavoriteBook.swift`, `ReadingProgress.swift`, `Annotation.swift`). |
| `Modules/` | Agrupa as *Views* e os *ViewModels* por funcionalidade (e.g., `Books`, `Favorites`, `Progress`, `Annotation`). |
| `Services/` | Camada de abstração para operações de rede. Inclui o `NetworkService.swift` (base para chamadas HTTP) e o `BooksService.swift` (específico para a Google Books API). |
| `Shared/` | Contém utilitários e componentes reutilizáveis, como a view de capa (`BookCoverView.swift`) e mensagens de erro localizadas (`ErrorMessages.swift`, `Localizable.xcstrings`). |
| `BooksAppTests/` | Contém os testes unitários para os modelos e ViewModels do projeto. |

-----

## Configuração e Instalação

Para rodar o projeto localmente, siga os passos abaixo.

### Pré-requisitos

  * Xcode (Versão 16.4 ou superior, conforme `project.pbxproj` e `BooksApp.xcscheme`).
  * macOS com suporte ao iOS 18.5+ (conforme as configurações de *deployment target*).

### Passos

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/marcellafccosta/ReadMe-BooksApp.git
    cd ReadMe-BooksApp/BooksApp
    ```

2.  **Abra no Xcode:**

    ```bash
    open BooksApp.xcodeproj
    ```

3.  **Execute o Projeto:**

      * Selecione o *target* `BooksApp` e um simulador ou dispositivo compatível.
      * Clique em `Run` (ou `⌘R`).

O projeto usará a API Key diretamente no `BookViewModel.swift`. Para a versão de produção, a chave da API deve ser protegida e gerenciada de forma mais segura.

-----

## Testes Unitários

O projeto inclui testes unitários para garantir a correta implementação da lógica de negócios e persistência de dados.

  * **Testes de Modelo:** (`Model/`) cobrem a criação de *fixtures* e as transformações de modelo.
  * **Testes de ViewModel:** (`Modules/`) cobrem as regras de negócio para Busca, Favoritos, Progresso e Anotações (e.g., `BookViewModelTest.swift`, `FavoriteBookViewModelTest.swift`, `ProgressViewModelTest.swift`, `AnnotationViewModelTest.swift`).

Você pode executar todos os testes usando o `TestPlan.xctestplan` referenciado no esquema (`BooksApp.xcscheme`).
