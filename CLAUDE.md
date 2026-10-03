# Barron_to_Kindle — project context

Goal: deliver Barron's content (Gary's paid subscription) to a Kindle Colorsoft Signature as EPUB, by email.

## Current state (Oct 2026)

- `.github/workflows/barrons-magazine.yml` — weekly, uses Calibre's built-in "Barron's Magazine" recipe.
- `.github/workflows/barrons-latest.yml` — daily, uses custom `barrons-latest.recipe` with a username/password login.
- `barrons-full.recipe` — NEW. Copy of the current official recipe plus cookie-based auth. Meant to run **locally**, not in Actions.

## What we learned (don't re-try these)

- **GitHub Actions can't log in to Dow Jones.** The SSO login page returns `HTTP 412` to the runner, and article pages return a CAPTCHA ("One more step… complete the security check") with no solvable widget. Cloud IPs are blocked.
- **The built-in Barron's recipe is now snippet-only by design.** It was rewritten around Aug 2026: no login, no Googlebot/archive.is trick. It fetches cover + TOC + headline/byline/first paragraph. That is why deliveries since mid-Sept contain only links/snippets.
- The new recipe reads article JSON from `<script id="__NEXT_DATA__">`. `pageProps.articleData.body` is present only for logged-in subscribers; otherwise it falls back to `pageProps.snippet`.
- Same-owner sites (WSJ, IBD/investors.com) block the same way (403/CAPTCHA).
- Kindle needs **EPUB** (MOBI is rejected with E001). Use `--output-profile kindle_oasis`.
- Email: Gmail SMTP `smtp.gmail.com:587` + STARTTLS + 16-char app password. Type the password by hand (a pasted non-breaking space caused a UnicodeEncodeError). GMX doesn't support app passwords.
- Commits need the noreply email: `glamperi@users.noreply.github.com` (GH007 otherwise).

## Running the full-text recipe

1. Log in to barrons.com in Chrome; export barrons.com cookies in Netscape format ("Get cookies.txt LOCALLY") to `~/barrons-cookies.txt` (or set `BARRONS_COOKIES`).
2. `ebook-convert barrons-full.recipe barrons.epub --output-profile kindle_oasis`
3. Read the last log line: `Articles with full text: N | snippet only: M`. Snippets → re-export cookies. "CAPTCHA page" warnings → session flagged.

Cookies expire every few weeks. **Never commit the cookies file.**

## Open next steps

- Verify the cookie recipe returns full text.
- If it works: add a local send script (reuse the Gmail code from the workflows) and schedule it on the Mac (launchd/cron).
- Decide whether to disable the Actions schedules, since they can only produce snippets now.
