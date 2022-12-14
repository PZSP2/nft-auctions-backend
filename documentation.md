### Wykorzystane narzędzia - Backend

- Language: TypeScript, JavaScript
- Framework: Express.js
- JavaScript runtime environment: Node.js
- baza danych: PostgreSQL
- ORM: Prisma
- Blockchain: XRP Ledger
- Blockchain API: xrpl.js
- CI/CD: GitHub Actions
- Test-framework: Jest, Mocha/Chai
- Linter: ESLint

### Architektura - Backend

Backend zostanie zaimplementowany zgodnie z architekturą hexagonalną.
Umożliwi to łatwe rozszerzanie aplikacji o nowe funkcjonalności (w przyszłości), a także łatwe testowanie.
Aplikacja będzie podzielona na warstwy, które jedynie implementują interfejsy:

- Warstwa domeny - odpowiada za logikę biznesową
- Adaptery - odpowiadają za komunikację z zewnętrznymi systemami:
  _ Database adapter - odpowiada za komunikację z bazą danych
  _ Blockchain adapter - odpowiada za komunikację z blockchainem \* Rest adapter - odpowiada za komunikację przez REST API
  Korzystając z takiego podejścia, logika biznesowa operuje na abstrakcyjnych interfejsach. Co umożliwia łatwą zamianę systemu RDBMS lub Blockchainu

### Deployment

Aplikacja będzie uruchamiana na klastrze Kubernetes. Do konteneryzacji zostanie użyte oprogramowanie Docker wraz z docker-compose co pozwoli na łatwe uruchomienie wszystkich potrzebnych usług (baza danych, API). Zostaną utworzone dwa środowiska:

- dev - używane do testowania i rozwijania nowych feature'ów
- prod - używane do uruchomienia aplikacji w produkcji, do której dodawane zmiany muszą być odpowiednio przetestowane i uzgodnione z zespołem.
