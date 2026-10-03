# Barron's to Kindle

Sends Barron's articles (full text, from my subscription) to my Kindle Colorsoft as an EPUB, by email. **Everything runs on my Mac.**

## The two commands

Run from the `Barron_to_Kindle` folder:

```bash
./send-to-kindle.sh latest      # today's newest articles
./send-to-kindle.sh magazine    # this week's print magazine
```

| Command | What you get | When to use it |
|---|---|---|
| `latest` | Newest articles from Barron's Latest News, Markets and Stocks pages (up to 20 each) | Any time — before heading out, at the cabana, etc. |
| `magazine` | The full weekly Barron's magazine issue: cover story, features, columns | Once a week, after the issue comes out (Saturday morning) |

Each run takes a few minutes, then the book shows up on the Kindle. A copy is also saved in `~/Documents/Barrons`. Each copy has the date and time in its title, so the Kindle never confuses it with an older one.

If the script says **"No full-text articles"**, the Barron's cookies have expired; see below. It won't send snippets.

## Files

| File | Purpose |
|---|---|
| `send-to-kindle.sh` | Builds the book and emails it to the Kindle |
| `barrons-latest-full.recipe` | Calibre recipe for the `latest` edition |
| `barrons-full.recipe` | Calibre recipe for the `magazine` edition |
| `CLAUDE.md` | Background notes for Claude Code |
| `~/.barrons-kindle.env` | Gmail + Kindle settings (on the Mac only, **not** in Git) |
| `~/barrons-cookies.txt` | Barron's login cookies (on the Mac only, **not** in Git) |

## Every few weeks: refresh the Barron's cookies

1. In Chrome, log in to barrons.com.
2. Click the puzzle-piece icon → **Get cookies.txt LOCALLY** → **Export** (Netscape format).
3. In Terminal:
   ```bash
   mv ~/Downloads/www.barrons.com_cookies.txt ~/barrons-cookies.txt
   ```

The cookies file can log in to my Barron's account. Treat it like a password.

## One-time setup (new Mac)

1. Install Calibre: `brew install --cask calibre`
2. Make the script runnable: `chmod +x send-to-kindle.sh`
3. Create `~/.barrons-kindle.env`:
   ```
   GMAIL_USER="you@gmail.com"
   GMAIL_APP_PASSWORD="abcdefghijklmnop"
   KINDLE_EMAIL="yourname@kindle.com"
   ```
   - The app password comes from myaccount.google.com → search **app passwords** (needs 2-Step Verification on). Remove the spaces, and type it rather than pasting.
   - Then lock it down: `chmod 600 ~/.barrons-kindle.env`
4. On Amazon (Manage Your Content and Devices → Preferences → Personal Document Settings), the Gmail address must be on the **Approved Personal Document E-mail List**.
5. Export the cookies (above).

## Why there are no GitHub Actions anymore

This project started as GitHub Actions that ran on a schedule in the cloud. Those workflows are **disabled** and can't be made to work:

- Dow Jones (Barron's owner) blocks GitHub's cloud servers: logins get `HTTP 412`, article pages return a CAPTCHA that can't be solved.
- Calibre's built-in Barron's recipe was rewritten in mid-2026 to fetch only headlines and first paragraphs, so the Actions were delivering snippet-only issues.

Full text only works with a logged-in session from my own browser, which is why it runs on the Mac with exported cookies. The old workflow files are still in `.github/workflows/` for reference.
