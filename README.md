
# ERP Project

## Project Overview
This project is an advanced ERP (Enterprise Resource Planning) system developed using **NestJS** and a modular **monorepo architecture** with **PNPM workspaces**. It is designed to support a complex, scalable system with multiple independent microservices for managing finance, inventory, HR, CRM, project management, and more.

The ERP is developed with best practices in mind, including **automated linting, formatting, testing,** and **pre-commit checks** to ensure high code quality and consistency.

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [Installation](#installation)
3. [Running the Project](#running-the-project)
4. [Scripts](#scripts)
5. [Configuration](#configuration)
6. [Environment Variables](#environment-variables)
7. [Docker Setup](#docker-setup)
8. [Testing](#testing)
9. [Contribution Guidelines](#contribution-guidelines)

---

## Project Structure

The project uses a **monorepo structure** with `PNPM workspaces` to manage multiple services efficiently. Here is a breakdown of the main directories:

```plaintext
erp-project/
├── apps/
│   ├── api-gateway/                 # API Gateway for request routing and authentication
│   ├── finance-service/             # Microservice for financial management
│   ├── inventory-service/           # Microservice for inventory management
│   ├── hr-service/                  # Microservice for human resources
│   ├── crm-service/                 # Microservice for customer relationship management
│   ├── project-management-service/  # Microservice for project management
│   └── analytics-service/           # Microservice for analytics and reporting
│
├── libs/
│   ├── common/                      # Shared utilities and helper functions
│   ├── database/                    # Database configuration and ORM setup
│   ├── event-bus/                   # Event bus for message brokering
│   └── security/                    # Security and authentication modules
│
├── config/                          # Project-wide configuration files
│   ├── env/                         # Environment-specific variables
│   ├── docker/                      # Docker configurations
│   └── ci-cd/                       # CI/CD pipeline configurations
│
├── .husky/                          # Husky git hooks for pre-commit checks
├── tsconfig.json                    # TypeScript configuration
├── .eslintrc.js                     # ESLint configuration
├── .prettierrc                      # Prettier configuration
├── docker-compose.yml               # Docker Compose file for containerized services
└── README.md                        # Project documentation
```

---

## Installation

### Prerequisites
- **Node.js** (v16 or higher)
- **PNPM** package manager
- **Docker** (optional but recommended for containerization)

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/erp-project.git
   cd erp-project
   ```

2. **Install Dependencies**:
   Run the following command to install dependencies across all workspaces:
   ```bash
   pnpm install --recursive
   ```

3. **Setup Husky Hooks**:
   Ensure husky hooks are installed for git pre-commit checks:
   ```bash
   pnpm prepare
   ```

---

## Running the Project

### Using Docker (Recommended)
The project includes a `docker-compose.yml` file for setting up the entire stack in containers.

```bash
docker-compose up --build
```

This will launch all services as defined in the `docker-compose.yml` file, including the API Gateway and individual microservices.

### Without Docker
You can run individual services directly using PNPM:
```bash
pnpm --filter api-gateway start
pnpm --filter finance-service start
```

For all services:
```bash
pnpm run start:all
```

---

## Scripts

The `package.json` file includes various scripts to streamline development and deployment.

```json
"scripts": {
    "preinstall": "npx only-allow pnpm",
    "prepare": "husky install",
    "install:all": "pnpm install --recursive",
    "lint": "eslint . --config eslint.config.js",
    "lint:fix": "eslint . --config eslint.config.js --fix",
    "format": "prettier --write 'apps/**/*.{js,ts}' 'libs/**/*.{js,ts}'",
    "format:check": "prettier --check 'apps/**/*.{js,ts}' 'libs/**/*.{js,ts}'",
    "type-check": "tsc --noEmit",
    "test": "jest --coverage",
    "test:watch": "jest --watch",
    "clean": "rm -rf apps/**/dist libs/**/dist",
    "build": "pnpm run clean && pnpm -r run build",
    "validate": "pnpm lint && pnpm type-check && pnpm format:check && pnpm test"
  },
```

- **`install:all`**: Installs dependencies across all workspaces.
- **`lint`, `lint:fix`**: Runs ESLint checks (optionally with fixes).
- **`format`, `format:check`**: Formats code or checks format without changing.
- **`type-check`**: Runs TypeScript's type-checking without emitting files.
- **`test`, `test:watch`**: Runs tests with Jest (coverage and watch mode).
- **`clean`**: Cleans up `dist` folders for fresh builds.
- **`build`**: Builds all applications and libraries.
- **`validate`**: Runs linting, type-checking, format checks, and tests.

---

## Configuration

### Environment Variables
Environment variables are stored in the `config/env/` directory. Duplicate the `.env.example` file to create environment-specific configurations:

```plaintext
NODE_ENV=development
PORT=3000
DATABASE_URL=your_database_url_here
```

Make sure to set up `.env` files for each environment (development, staging, production) as needed.

---

## Docker Setup

The project includes a `docker-compose.yml` for easy setup of all services in containers.

### Building and Running Services
To build and run the services:

```bash
docker-compose up --build
```

To stop and remove all containers:
```bash
docker-compose down
```

### Testing

Tests are written using **Jest** and **Supertest** (for API tests). You can run tests with coverage and watch mode.

- Run all tests with coverage:
  ```bash
  pnpm test
  ```

- Watch mode for tests (ideal for TDD):
  ```bash
  pnpm test:watch
  ```

---

## Contribution Guidelines

1. **Fork the Repository**: Create your branch from `main`.
2. **Create Descriptive Commits**: Use [Conventional Commits](https://www.conventionalcommits.org/) for consistency.
3. **Test Your Changes**: Ensure all tests pass locally before committing.
4. **Pull Requests**: Submit PRs with descriptions of the changes and references to issues (if any).

### Pre-commit Hooks
The project uses **Husky** and **lint-staged** to enforce linting, formatting, and testing on pre-commit to maintain code quality.

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Contact

For any inquiries, please reach out to `ferdiardiansa@gmail.com`.
