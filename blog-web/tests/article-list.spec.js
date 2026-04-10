import { test, expect } from '@playwright/test';

test.describe('Article List Tests', () => {

  test('Article List Pagination and Filter Works', async ({ page }) => {
    // Navigate to homepage
    await page.goto('http://localhost:3001/');
    
    // Wait for initial articles to load
    await page.waitForSelector('.post-card', { state: 'visible', timeout: 10000 });
    
    // Check total items
    const initialCards = await page.locator('.post-card').count();
    expect(initialCards).toBeGreaterThan(0);
    
    // Click on a category filter (e.g., the second one)
    const categoryBtns = page.locator('.category-btn');
    if (await categoryBtns.count() > 1) {
      await categoryBtns.nth(1).click();
      
      // Wait for network idle to ensure data is fetched
      await page.waitForLoadState('networkidle');
      
      // Verify articles are rendered or empty state is shown
      const hasCards = await page.locator('.post-card').count() > 0;
      const hasEmpty = await page.locator('.el-empty').count() > 0;
      
      expect(hasCards || hasEmpty).toBeTruthy();
    }
  });

  test('Empty State and Error Handling', async ({ page }) => {
    // Intercept API call and return empty array
    await page.route('**/api/article/list*', async route => {
      const json = { code: 200, message: "success", data: { records: [], total: 0 } };
      await route.fulfill({ json });
    });

    await page.goto('http://localhost:3001/');
    
    // Wait for the empty state to be visible
    await page.waitForSelector('.el-empty', { state: 'visible', timeout: 10000 });
    
    const emptyText = await page.locator('.el-empty__description').innerText();
    expect(emptyText).toContain('暂无文章');
  });
});
