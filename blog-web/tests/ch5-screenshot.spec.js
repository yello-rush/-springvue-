import { test, expect } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';

const SCREENSHOT_DIR = path.resolve(__dirname, '../../docs/images/ch5');

const ADMIN_BASE_URL = process.env.ADMIN_BASE_URL || 'http://localhost:3000';
const WEB_BASE_URL = process.env.WEB_BASE_URL || 'http://localhost:3001';

const ADMIN_USERNAME = process.env.ADMIN_USERNAME || '';
const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || '';
const WEB_EMAIL = process.env.WEB_EMAIL || '';
const WEB_PASSWORD = process.env.WEB_PASSWORD || '';
const WEB_SECURITY_CODE = process.env.WEB_SECURITY_CODE || '';

const FORGOT_WRONG_SECURITY_CODE = process.env.FORGOT_WRONG_SECURITY_CODE || '0000';
const FORGOT_NEW_PASSWORD = process.env.FORGOT_NEW_PASSWORD || 'Test@123456';

function webRoute(routePath) {
  const normalized = routePath.startsWith('/') ? routePath : `/${routePath}`;
  return `${WEB_BASE_URL}/#${normalized}`;
}

function ensureEnv(name, value) {
  if (!value) {
    throw new Error(`缺少环境变量: ${name}`);
  }
}

async function saveShot(page, filename) {
  await page.waitForTimeout(300);
  await page.screenshot({
    path: path.join(SCREENSHOT_DIR, filename),
    fullPage: true
  });
}

async function waitForToast(page, text) {
  const toast = page.locator('.el-message__content', { hasText: text }).first();
  await expect(toast).toBeVisible({ timeout: 12000 });
}

async function composeBeforeAfter(context, beforeBuffer, afterBuffer, outPath) {
  const composePage = await context.newPage();
  const beforeBase64 = beforeBuffer.toString('base64');
  const afterBase64 = afterBuffer.toString('base64');
  await composePage.setViewportSize({ width: 1600, height: 2200 });
  await composePage.setContent(`
    <html>
      <body style="margin:0;padding:24px;background:#f5f7fa;font-family:Arial,sans-serif;">
        <h2 style="margin:0 0 16px;color:#333;">单条标记已读前后对比</h2>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
          <div style="background:#fff;border:1px solid #ddd;padding:8px;">
            <div style="font-weight:700;margin-bottom:8px;">标记前</div>
            <img style="width:100%;height:auto;" src="data:image/png;base64,${beforeBase64}" />
          </div>
          <div style="background:#fff;border:1px solid #ddd;padding:8px;">
            <div style="font-weight:700;margin-bottom:8px;">标记后</div>
            <img style="width:100%;height:auto;" src="data:image/png;base64,${afterBase64}" />
          </div>
        </div>
      </body>
    </html>
  `);
  await composePage.screenshot({ path: outPath, fullPage: true });
  await composePage.close();
}

async function adminLogin(page) {
  ensureEnv('ADMIN_USERNAME', ADMIN_USERNAME);
  ensureEnv('ADMIN_PASSWORD', ADMIN_PASSWORD);

  await page.goto(`${ADMIN_BASE_URL}/login`, { waitUntil: 'domcontentloaded' });
  await page.getByPlaceholder('请输入用户名').fill(ADMIN_USERNAME);
  await page.getByPlaceholder('请输入密码').fill(ADMIN_PASSWORD);
  await page.locator('button.login-button').click();

  await page.waitForURL((url) => !url.pathname.includes('/login'), { timeout: 15000 });
  await page.goto(`${ADMIN_BASE_URL}/message/message`, { waitUntil: 'networkidle' });
  await expect(page.getByText('系统消息推送')).toBeVisible({ timeout: 15000 });
}

async function webLogin(page) {
  ensureEnv('WEB_EMAIL', WEB_EMAIL);
  ensureEnv('WEB_PASSWORD', WEB_PASSWORD);

  await page.goto(webRoute('/'), { waitUntil: 'domcontentloaded' });
  await page.goto(webRoute('/login'), { waitUntil: 'domcontentloaded' });
  await page.getByPlaceholder('请输入邮箱').first().fill(WEB_EMAIL);
  await page.getByPlaceholder('请输入密码').first().fill(WEB_PASSWORD);
  await page.getByRole('button', { name: '登 录' }).click();

  await page.waitForURL((url) => !url.hash.includes('/login'), { timeout: 15000 });
  await expect(page.locator('.site-header')).toBeVisible({ timeout: 10000 });
}

test('第5章测试自动截图', async ({ browser }) => {
  test.setTimeout(10 * 60 * 1000);
  fs.mkdirSync(SCREENSHOT_DIR, { recursive: true });

  // 5.3.1 系统消息群发（后台）
  const adminContext = await browser.newContext({ viewport: { width: 1600, height: 1000 } });
  const adminPage = await adminContext.newPage();
  await adminLogin(adminPage);

  await adminPage.getByPlaceholder('请输入系统消息标题').fill('');
  await adminPage.getByPlaceholder('请输入系统消息内容').fill('');
  await adminPage.getByRole('button', { name: '向全体用户发送' }).click();
  await waitForToast(adminPage, '请输入消息标题');
  await saveShot(adminPage, 'fig5-1-send-validate.png');

  const messageTitle = `自动化测试系统消息-${Date.now()}`;
  await adminPage.getByPlaceholder('请输入系统消息标题').fill(messageTitle);
  await adminPage.getByPlaceholder('请输入系统消息内容').fill('这是用于第5章截图自动化的系统消息内容。');
  await adminPage.getByRole('button', { name: '向全体用户发送' }).click();
  await waitForToast(adminPage, '系统消息已发送至全体用户');
  await saveShot(adminPage, 'fig5-2-send-success.png');

  // 5.3.2 + 5.3.3 + 5.3.4 + 5.3.5（用户端）
  const webContext = await browser.newContext({ viewport: { width: 1600, height: 1000 } });
  const webPage = await webContext.newPage();
  await webLogin(webPage);

  // 5.3.1 用户端接收系统消息
  await webPage.goto(webRoute('/notifications?type=system'), { waitUntil: 'networkidle' });
  await expect(webPage.getByText('消息中心')).toBeVisible({ timeout: 15000 });
  await saveShot(webPage, 'fig5-3-user-receive.png');

  // 5.3.2 消息中心已读/未读
  await saveShot(webPage, 'fig5-4-notice-columns.png');

  const markReadBtn = webPage.getByRole('button', { name: '标为已读' }).first();
  const beforeMarkBuffer = await webPage.screenshot({ fullPage: true });
  if (await markReadBtn.count()) {
    await markReadBtn.click();
    await waitForToast(webPage, '已标记为已读');
  }
  await webPage.waitForTimeout(600);
  const afterMarkBuffer = await webPage.screenshot({ fullPage: true });
  await composeBeforeAfter(
    webContext,
    beforeMarkBuffer,
    afterMarkBuffer,
    path.join(SCREENSHOT_DIR, 'fig5-5-mark-read-before-after.png')
  );

  const markAllBtn = webPage.getByRole('button', { name: '全部标记已读' });
  if (await markAllBtn.isEnabled()) {
    await markAllBtn.click();
    await waitForToast(webPage, '已将所有消息标记为已读');
  }
  await saveShot(webPage, 'fig5-6-all-read-result.png');

  // 5.3.3 顶部消息交互
  await webPage.goto(webRoute('/'), { waitUntil: 'networkidle' });
  const messageButton = webPage.locator('.message-btn').first();
  await messageButton.click();
  await expect(webPage.locator('.message-dropdown')).toBeVisible();
  await saveShot(webPage, 'fig5-7-header-expand.png');

  await messageButton.click();
  await expect(webPage.locator('.message-dropdown')).toBeHidden();
  await saveShot(webPage, 'fig5-8-header-collapse.png');

  await messageButton.click();
  await webPage.locator('.message-btn-wrapper').hover();
  await webPage.mouse.move(2, 2);
  await webPage.waitForTimeout(320);
  await saveShot(webPage, 'fig5-9-header-autoclose.png');

  // 5.3.4 反馈提交
  await webPage.goto(webRoute('/user/profile?tab=feedback'), { waitUntil: 'networkidle' });
  await expect(webPage.getByText('意见反馈')).toBeVisible({ timeout: 15000 });

  await webPage.evaluate(() => {
    const root = document.querySelector('.profile-container');
    const vm = root && root.__vue__;
    if (vm && vm.feedbackForm) vm.feedbackForm.feedbackType = '';
  });
  await webPage.getByRole('button', { name: '提交反馈' }).click();
  await expect(webPage.getByText('请选择反馈类型')).toBeVisible({ timeout: 10000 });
  await saveShot(webPage, 'fig5-10-feedback-type-required.png');

  await webPage.evaluate(() => {
    const root = document.querySelector('.profile-container');
    const vm = root && root.__vue__;
    if (vm && vm.feedbackForm) {
      vm.feedbackForm.feedbackType = 'function_suggestion';
      vm.feedbackForm.content = '';
    }
  });
  await webPage.getByRole('button', { name: '提交反馈' }).click();
  await expect(webPage.getByText('请输入反馈内容')).toBeVisible({ timeout: 10000 });
  await saveShot(webPage, 'fig5-11-feedback-content-required.png');

  await webPage.getByPlaceholder('请详细描述您的问题或建议...').fill(`自动化反馈测试内容-${Date.now()}`);
  await webPage.getByPlaceholder('请留下您的联系邮箱，方便我们回复您').fill(WEB_EMAIL);
  await webPage.getByRole('button', { name: '提交反馈' }).click();
  await waitForToast(webPage, '感谢您的反馈！');
  await saveShot(webPage, 'fig5-12-feedback-success.png');

  // 5.3.5 找回密码
  ensureEnv('WEB_SECURITY_CODE', WEB_SECURITY_CODE);
  await webPage.goto(webRoute('/login'), { waitUntil: 'networkidle' });
  await webPage.getByText('忘记密码?').click();
  await expect(webPage.getByText('找回密码')).toBeVisible({ timeout: 10000 });

  await webPage.getByRole('button', { name: '重置密码' }).click();
  await expect(webPage.getByText('请输入邮箱')).toBeVisible({ timeout: 10000 });
  await expect(webPage.getByText('请输入4位安全码')).toBeVisible({ timeout: 10000 });
  await saveShot(webPage, 'fig5-13-forgot-empty.png');

  await webPage.getByPlaceholder('请输入注册邮箱').fill(WEB_EMAIL);
  await webPage.getByPlaceholder('请输入4位安全码').fill(FORGOT_WRONG_SECURITY_CODE);
  await webPage.getByPlaceholder('请输入新密码').fill(FORGOT_NEW_PASSWORD);
  await webPage.getByRole('button', { name: '重置密码' }).click();
  await expect(webPage.locator('.el-message__content')).toBeVisible({ timeout: 12000 });
  await saveShot(webPage, 'fig5-14-forgot-mismatch.png');

  await webPage.getByPlaceholder('请输入4位安全码').fill(WEB_SECURITY_CODE);
  await webPage.getByPlaceholder('请输入新密码').fill(FORGOT_NEW_PASSWORD);
  await webPage.getByRole('button', { name: '重置密码' }).click();
  await waitForToast(webPage, '密码重置成功');
  await saveShot(webPage, 'fig5-15-forgot-mail-success.png');

  await adminContext.close();
  await webContext.close();
});
