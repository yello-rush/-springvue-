import { test, expect } from '@playwright/test';

test.describe('Shiyi Blog E2E Tests', () => {
  
  test('Web Portal - Homepage loads successfully', async ({ page }) => {
    console.log('Navigating to Web Portal...');
    const response = await page.goto('http://localhost:3001/');
    expect(response.status()).toBe(200);
    
    // wait for page to load
    await page.waitForLoadState('networkidle');
    
    // Check if title or certain elements are visible
    // Since we don't know the exact title, we'll just check if body is visible
    const body = await page.locator('body');
    await expect(body).toBeVisible();
    console.log('Web Portal Homepage loaded.');
  });

  test('Admin Portal - Login page loads successfully', async ({ page }) => {
    console.log('Navigating to Admin Portal...');
    const response = await page.goto('http://localhost:3000/');
    // it might redirect to login, so we just check if it's successful
    expect(response.ok()).toBeTruthy();
    
    await page.waitForLoadState('networkidle');
    
    const body = await page.locator('body');
    await expect(body).toBeVisible();
    console.log('Admin Portal loaded.');
  });

  test('Backend API - Article list returns data', async ({ request }) => {
    console.log('Testing Backend API...');
    const response = await request.get('http://localhost:8800/api/article/list');
    expect(response.status()).toBe(200);
    const body = await response.json();
    expect(body.data.records.length).toBeGreaterThan(0);
    console.log('Backend Article API returned data correctly.');
  });

  test('Web Portal - Article list renders properly', async ({ page }) => {
    console.log('Navigating to Web Portal and checking article list...');
    await page.goto('http://localhost:3001/');
    
    // Wait for the loader to disappear and content to appear
    await page.waitForSelector('.post-card', { state: 'visible', timeout: 10000 });
    
    // Verify that at least one article card is present
    const cards = await page.locator('.post-card').count();
    expect(cards).toBeGreaterThan(0);
    console.log(`Web Portal rendered ${cards} articles.`);
  });
});
