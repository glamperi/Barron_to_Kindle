# Barron's to Kindle

GitHub Actions that fetch Barron's content and send it to your Kindle.

## Workflows

### 1. Barron's Magazine (Weekly)
- **File:** `.github/workflows/barrons-magazine.yml`
- **Schedule:** Every Saturday at 7 AM EST
- **Content:** Weekly print magazine edition
- Uses Calibre's built-in recipe

### 2. Barron's Latest (Daily)
- **File:** `.github/workflows/barrons-latest.yml`  
- **Schedule:** Weekdays at 7 AM and 5 PM EST
- **Content:** Real-time news, Markets, Stocks
- Uses custom `barrons-latest.recipe`

Both can also be triggered manually from the Actions tab.

## Setup

### 1. Fork or clone this repository

### 2. Configure GitHub Secrets

Go to your repository's **Settings → Secrets and variables → Actions** and add:

| Secret | Description |
|--------|-------------|
| `BARRONS_USERNAME` | Your Barron's login email |
| `BARRONS_PASSWORD` | Your Barron's password |
| `GMAIL_USERNAME` | Your Gmail address |
| `GMAIL_APP_PASSWORD` | Your Gmail app password ([create one here](https://myaccount.google.com/apppasswords)) |
| `KINDLE_EMAIL` | Your Kindle email (e.g., `yourname@kindle.com`) |

### 3. Approve your sending email in Amazon

1. Go to [Amazon's Manage Your Content and Devices](https://www.amazon.com/hz/mycd/myx#/home/settings/payment)
2. Go to **Preferences → Personal Document Settings**
3. Under **Approved Personal Document E-mail List**, add your Gmail address

### 4. Run the workflows

- Go to the **Actions** tab in your repository
- Select either workflow
- Click **Run workflow**

## Adding More Publications

To add another publication, create a new workflow file in `.github/workflows/` following the same pattern. You can use any of Calibre's built-in recipes or create custom `.recipe` files.

## Customizing the Schedule

Edit the `cron` expressions in the workflow files. Format: `minute hour day month weekday`

Examples:
- `0 12 * * 6` — Saturdays at 12 PM UTC
- `0 12 * * 1-5` — Weekdays at 12 PM UTC
- `0 */6 * * *` — Every 6 hours

Use [crontab.guru](https://crontab.guru/) to build cron expressions.

## Troubleshooting

### Authentication failures
- Verify your Barron's credentials work on the website
- Barron's uses the same login as WSJ if you have a bundled subscription

### Email not arriving on Kindle
- Ensure your Gmail is in Amazon's approved senders list
- Check your Kindle email address is correct
- Files may take a few minutes to appear

### Recipe errors
- The magazine workflow uses Calibre's built-in recipe (maintained by the community)
- The latest workflow uses a custom recipe in this repo

## Notes

- Runs on GitHub's free tier (2,000 minutes/month for private repos, unlimited for public)
- Your credentials are stored securely as GitHub encrypted secrets
