---
name: github-package-visibility
description: Change GitHub package visibility with the Playwright MCP browser session. Use when asked to make private GitHub packages public, flip package visibility in bulk, verify whether the browser session is already logged in, or avoid slow manual page-by-page package settings clicks.
---

# GitHub Package Visibility

Use this skill for GitHub Packages visibility changes that are safer to drive from the web UI than ad-hoc clicking.

## Scope

This workflow is validated for personal-account container packages under URLs like:

- `https://github.com/<owner>?tab=packages&visibility=private`
- `https://github.com/users/<owner>/packages/container/<package-slug>/settings`

If the package type is not `container`, inspect one package manually first and confirm the settings flow matches before bulk changes.

## Guardrails

- Use Playwright MCP and rely on the existing signed-in browser session when available.
- Before bulk changes, verify login by opening the filtered packages page and confirming the owner/profile context matches the intended account.
- Never include account names, package names, confirmation strings, copied HTML, or screenshots from a live run in the committed skill, PR body, or examples. Use placeholders only.
- Change one package first and verify the settings page updates to the target state before batching.
- Work in small batches, preferably 10-15 packages at a time, so failures are isolated and retries are cheap.
- Verify the final state from the filtered package page itself, not only from per-package settings pages.

## Fast Path

GitHub package pages keep background requests alive, so `networkidle` waits and page-by-page scraping are slower than necessary.

1. Navigate to `https://github.com/<owner>?tab=packages&visibility=private` with Playwright.
2. Verify the page is authenticated and the owner is correct.
3. Use `browser_run_code` to fetch the filtered HTML with in-page `fetch(..., { credentials: "include" })`, parse it with `DOMParser`, and collect package links plus the `Next` pagination link.
4. Build a deduplicated list of package slugs from those fetched pages.
5. Process the package settings pages in batches with `browser_run_code`:
   - open `https://github.com/users/<owner>/packages/container/${encodeURIComponent(slug)}/settings`
   - skip if the page already says the package is at the target visibility
   - click `Change visibility`
   - select the target radio button
   - fill the confirmation textbox with the exact package slug
   - submit and wait for the target-state text on the settings page
6. Re-check the filtered package list with in-page `fetch`; success is `0 packages` and zero remaining package links.

## Manual Probe

When the flow is unverified for a package type or account shape:

1. Open one package page from the filtered list.
2. Open `Package settings`.
3. Open `Change visibility` in the danger zone.
4. Confirm the dialog requires:
   - a target radio button
   - the exact package slug typed into a confirmation textbox
   - a final confirmation button

Then switch to the fast path for the remaining packages.

## Playwright Patterns

List remaining private packages without waiting on GitHub background traffic:

```js
async (page) => {
  const origin = "https://github.com";
  const seenPages = new Set();
  const seenPackages = new Set();
  let url = "https://github.com/<owner>?tab=packages&visibility=private";

  while (url && !seenPages.has(url)) {
    seenPages.add(url);
    const { links, nextHref } = await page.evaluate(async currentUrl => {
      const res = await fetch(currentUrl, { credentials: "include" });
      const html = await res.text();
      const doc = new DOMParser().parseFromString(html, "text/html");
      const links = [...doc.querySelectorAll('a[href*="/users/<owner>/packages/container/package/"]')]
        .map((a) => a.getAttribute("href"))
        .filter(Boolean);
      const next = [...doc.querySelectorAll("a")].find((a) => a.textContent?.trim() === "Next");
      return { links, nextHref: next?.getAttribute("href") || null };
    }, url);

    for (const href of links) {
      seenPackages.add(href.startsWith("http") ? href.replace(origin, "") : href);
    }
    url = nextHref ? (nextHref.startsWith("http") ? nextHref : origin + nextHref) : null;
  }

  return [...seenPackages].map((path) => decodeURIComponent(path.split("/package/")[1]));
}
```

Change a batch to public:

```js
async (page) => {
  const owner = "<owner>";
  const packages = ["<package-slug-1>", "<package-slug-2>"];
  page.setDefaultTimeout(10000);
  const changed = [];
  const skipped = [];
  const errors = [];

  for (const pkg of packages) {
    try {
      const url = `https://github.com/users/${owner}/packages/container/${encodeURIComponent(pkg)}/settings`;
      await page.goto(url, { waitUntil: "domcontentloaded" });
      const mainText = await page.locator("main").textContent();

      if (mainText.includes("This package is currently public.")) {
        skipped.push(pkg);
        continue;
      }

      await page.getByRole("button", { name: "Change visibility" }).click();
      await page.getByRole("heading", { name: "Change package visibility" }).waitFor({ state: "visible" });
      await page.getByRole("radio", { name: /Public Make this package visible to anyone\./ }).click();

      const dialog = page.getByRole("dialog");
      await dialog.getByRole("textbox").fill(pkg);
      await dialog.getByRole("button", { name: "I understand the consequences, change package visibility" }).click();
      await page.getByText("This package is currently public.").waitFor({ state: "visible" });

      changed.push(pkg);
    } catch (error) {
      errors.push({ pkg, error: String(error) });
    }
  }

  return { changed, skipped, errors };
}
```

Verify completion from the private filter:

```js
async (page) => {
  const url = "https://github.com/<owner>?tab=packages&visibility=private";
  return await page.evaluate(async currentUrl => {
    const res = await fetch(currentUrl, { credentials: "include" });
    const html = await res.text();
    const doc = new DOMParser().parseFromString(html, "text/html");
    const links = [...doc.querySelectorAll('a[href*="/users/<owner>/packages/container/package/"]')];
    const bodyText = doc.body?.innerText || "";
    return {
      remainingCount: links.length,
      emptyState: bodyText.match(/0 packages|No packages|We couldn't find any packages/i)?.[0] || null,
    };
  }, url);
}
```

## Reporting

Report:

- how many packages changed
- how many were already at the target state
- any package-specific errors
- the final verification result from the filtered package list
