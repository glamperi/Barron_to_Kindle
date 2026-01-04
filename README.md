# Barron's to Kindle

A GitHub Action that fetches the latest Barron's Magazine using your subscription and sends it to your Kindle.

## What It Fetches

Uses Calibre's built-in **Barron's Magazine** recipe to fetch the weekly print edition with your subscription credentials.

## Setup

### 1. Fork or copy this repository

### 2. Configure GitHub Secrets

Go to your repository's **Settings → Secrets and variables → Actions** and add the following secrets:

| Secret | Description |
|--------|-------------|
| `BARRONS_USERNAME` | Your Barron's login email |
| `BARRONS_PASSWORD` | Your Barron's password |
| `GMAIL_USERNAME` | Your Gmail address |
| `GMAIL_APP_PASSWORD` | Your Gmail app password ([create one here](https://myaccount.google.com/apppasswords)) |
| `KINDLE_EMAIL` | Your Kindle email (e.g., `yourname@kindle.com`) |

### 3. Approve your sending email in Amazon

1. Go to [Amazon's Manage Your Content and Devices](https://www.amazon.com/hz/mycd/myx)
2. Go to **Preferences → Personal Document Settings**
3. Under **Approved Personal Document E-mail List**, add your `FROM_EMAIL`

### 4. Run the workflow

- Go to the **Actions** tab in your repository
- Select **Barron's to Kindle**
- Click **Run workflow**

## Optional: Automatic scheduling

To receive Barron's automatically (e.g., every Saturday), uncomment the schedule section in the workflow file:

```yaml
schedule:
  - cron: '0 8 * * 6'  # 8 AM UTC every Saturday
```

## Troubleshooting

### "Recipe not found" error
Calibre's built-in recipes are included by default. If you encounter issues, you may need to download the recipe file manually from [Calibre's recipe repository](https://github.com/kovidgoyal/calibre/tree/master/recipes).

### Authentication failures
- Verify your Barron's credentials work on the website
- Barron's uses the same login as WSJ if you have a bundled subscription

### Email not arriving on Kindle
- Ensure the sending email is in your approved senders list on Amazon
- Check your Kindle's email address is correct (find it in Amazon device settings)
- Files may take a few minutes to appear

## Notes

- This uses Calibre's built-in Barron's recipe which is maintained by the Calibre community
- The workflow runs on GitHub's free tier (2,000 minutes/month for private repos, unlimited for public)
- Your credentials are stored securely as GitHub encrypted secrets
