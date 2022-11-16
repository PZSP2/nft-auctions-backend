### Wykorzystane narzędzia - Backend
* Language: TypeScript, JavaScript
* Framework: Hapi - z racji faktu, że większość działania backendu opiera się na interakcji z blockchainem bez udziału użytkownika, został wybrany framework Hapi, który zapewnia zarówno bezpieczne działanie oraz szybkość implementacji.  
* JavaScript runtime environment: Node.js
* baza danych: PostgreSQL
* ORM: Prisma 
* Blockchain: XRP Ledger
* Blockchain API: xrpl.js
* CI/CD: GitHub Actions
* Test-framework: Hapi-lab
* Linter: ESLint


### Architektura - Backend
Backend zostanie zaimplementowany zgodnie z architekturą hexagonalną. 
Umożliwi to łatwe rozszerzanie aplikacji o nowe funkcjonalności (w przyszłości), a także łatwe testowanie.
Aplikacja będzie podzielona na warstwy, które jedynie implementują interfejsy:
* Warstwa domeny - odpowiada za logikę biznesową
* Adaptery - odpowiadają za komunikację z zewnętrznymi systemami:
    * Database adapter - odpowiada za komunikację z bazą danych
    * Blockchain adapter - odpowiada za komunikację z blockchainem
    * Rest adapter - odpowiada za komunikację przez REST API
Korzystając z takiego podejścia, logika biznesowa operuje na abstrakcyjnych interfejsach. Co umożliwia łatwą zamianę systemu RDBMS lub Blockchainu

### Deployment
Aplikacja będzie uruchamiana na klastrze Kubernetes. Do konteneryzacji zostanie użyte oprogramowanie Docker wraz z docker-compose co pozwoli na łatwe uruchomienie wszystkich potrzebnych usług (baza danych, API). Zostaną utworzone dwa środowiska:
* dev - używane do testowania i rozwijania nowych feature'ów
* prod - używane do uruchomienia aplikacji w produkcji, do której dodawane zmiany muszą być odpowiednio przetestowane i uzgodnione z zespołem.  