# CELESTIA WhatsApp Bot

A maintained fork of Savage-Tech focused on cleaner deployment, safer secret handling, and a more reviewable release process.

> **Security note:** the core runtime inherited from upstream is heavily obfuscated. Deployment hardening has been applied, but the bot is **not yet considered fully security-audited**. Read [`SECURITY_AUDIT.md`](SECURITY_AUDIT.md) before using an important WhatsApp account.

## Repository

This fork is maintained at:

`https://github.com/Informant254/Savage-Tech`

Upstream lineage:

`https://github.com/tysavage163/Savage-Tech`

The fork keeps attribution to the upstream project while removing deploy buttons, pairing links, and contact links that would silently send users back to infrastructure controlled by the original repository owner.

## Runtime

- Node.js `>=20.19.0 <25`
- CommonJS
- Start command: `node server.js`
- WhatsApp session supplied through `SESSION_ID`

## Heroku deployment

### One-click deploy

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/Informant254/Savage-Tech)

The Heroku manifest asks for one required secret:

```text
SESSION_ID=your_session_id_here
```

Never paste a real session ID into GitHub, a public issue, a screenshot, or the repository files.

### Process configuration

The repository contains matching Heroku process definitions:

```text
web: node server.js
```

The Docker-based Heroku path also uses a `web` process and the same entry point.

## Local setup

```bash
git clone https://github.com/Informant254/Savage-Tech.git
cd Savage-Tech
npm install
cp .env.example .env
```

Then place your session value in `.env`:

```text
SESSION_ID=your_session_id_here
```

Start the bot:

```bash
npm start
```

## Docker

```bash
docker build -t celestia-bot .
docker run --rm --env-file .env celestia-bot
```

The container runs as a non-root user and installs production dependencies only.

## Releases

Releases are intentionally **manual**. The GitHub Actions release workflow no longer runs automatically on every push to `main` with repository write permission.

To publish a release, open **Actions → Manual Release → Run workflow** and provide a valid version tag such as:

```text
v1.6.1
```

The release archive excludes common credential, session, environment, and log files.

## Security status

The hardening pass currently covers:

- cleaned secret/session ignore rules
- exact top-level dependency versions
- non-root production Docker runtime
- consistent Heroku web process configuration
- manual-only release publishing
- safer release archive exclusions
- removal of upstream-controlled deploy/pairing/contact links from this fork's documentation

The main unresolved issue is the inherited obfuscated runtime. `server.js`, `settings.js`, and the unusually large `bot.js` still need readable-source review or replacement before this project should be treated as trusted production software.

See [`SECURITY_AUDIT.md`](SECURITY_AUDIT.md) for the full findings and next steps.

## Attribution

This repository is a fork of **Savage-Tech** by its upstream contributors. The CELESTIA branding and deployment-hardening changes in this fork do not erase that lineage.
