# E2E Testing Skill

## Trigger Words
"e2e test", "end-to-end test", "Playwright test", "browser test", "integration test", "test automation", "test suite", "user flow test"

## Workflow: Setup → Page Objects → Tests → CI

### Phase 1: Project Setup

```bash
# Install Playwright
npm init playwright@latest
# or add to existing project
npm install -D @playwright/test
npx playwright install
```

**playwright.config.ts**
```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ['json', { outputFile: 'test-results/results.json' }],
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'on-first-retry',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'mobile', use: { ...devices['iPhone 14'] } },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### Phase 2: Page Object Model

**Structure:**
```
e2e/
├── fixtures/
│   └── base.ts          # Custom fixtures
├── pages/
│   ├── BasePage.ts
│   ├── LoginPage.ts
│   └── DashboardPage.ts
├── helpers/
│   └── test-data.ts     # Factory functions
├── auth.setup.ts        # Auth state setup
├── login.spec.ts
└── dashboard.spec.ts
```

**Base Page:**
```typescript
import { type Page, type Locator } from '@playwright/test';

export class BasePage {
  constructor(protected page: Page) {}

  async waitForPageLoad() {
    await this.page.waitForLoadState('networkidle');
  }

  getByTestId(id: string): Locator {
    return this.page.getByTestId(id);
  }
}
```

**Page Object Example:**
```typescript
import { type Page, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class LoginPage extends BasePage {
  private emailInput = this.getByTestId('email-input');
  private passwordInput = this.getByTestId('password-input');
  private submitButton = this.getByTestId('login-submit');
  private errorMessage = this.getByTestId('login-error');

  constructor(page: Page) {
    super(page);
  }

  async goto() {
    await this.page.goto('/login');
    await this.waitForPageLoad();
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }
}
```

### Phase 3: Custom Fixtures

```typescript
// e2e/fixtures/base.ts
import { test as base } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';
import { DashboardPage } from '../pages/DashboardPage';

type Pages = {
  loginPage: LoginPage;
  dashboardPage: DashboardPage;
};

export const test = base.extend<Pages>({
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },
  dashboardPage: async ({ page }, use) => {
    await use(new DashboardPage(page));
  },
});

export { expect } from '@playwright/test';
```

### Phase 4: Test Patterns

```typescript
import { test, expect } from '../fixtures/base';

test.describe('Login', () => {
  test('successful login redirects to dashboard', async ({ loginPage, page }) => {
    await loginPage.goto();
    await loginPage.login('user@test.com', 'password123');
    await expect(page).toHaveURL('/dashboard');
  });

  test('invalid credentials show error', async ({ loginPage }) => {
    await loginPage.goto();
    await loginPage.login('wrong@test.com', 'wrong');
    await loginPage.expectError('Invalid credentials');
  });

  test('empty form shows validation errors', async ({ loginPage }) => {
    await loginPage.goto();
    await loginPage.login('', '');
    await loginPage.expectError('Email is required');
  });
});
```

### Phase 5: Auth State Reuse

```typescript
// e2e/auth.setup.ts
import { test as setup, expect } from '@playwright/test';
import path from 'node:path';

const authFile = path.join(__dirname, '../.auth/user.json');

setup('authenticate', async ({ page }) => {
  await page.goto('/login');
  await page.getByTestId('email-input').fill('test@example.com');
  await page.getByTestId('password-input').fill('password123');
  await page.getByTestId('login-submit').click();
  await page.waitForURL('/dashboard');
  await page.context().storageState({ path: authFile });
});
```

### Phase 6: CI Configuration

```yaml
# .github/workflows/e2e.yml
name: E2E Tests
on: [push, pull_request]
jobs:
  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 7
```

## Test Writing Rules
- ALWAYS use `data-testid` attributes for selectors — never CSS classes or tag structure
- ALWAYS use Page Object Model — never inline selectors in test files
- ALWAYS test user-visible behavior, not implementation details
- ALWAYS use `expect` assertions — never rely on absence of errors
- PREFER `getByRole`, `getByLabel`, `getByText` over `getByTestId` when semantically meaningful
- NEVER use `page.waitForTimeout()` — use proper waiters (`waitForURL`, `waitForSelector`, `expect().toBeVisible()`)
- NEVER hardcode test data — use factory functions or fixtures
- ALWAYS clean up test state — tests must be independent and repeatable
- RUN tests in parallel by default — isolate state per test
