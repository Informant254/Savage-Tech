# CELESTIA

A hardened deployment fork of the Savage-Tech WhatsApp bot, maintained under `Informant254/Savage-Tech`.

> **Security status:** the core runtime files in this upstream project are heavily obfuscated. This branch improves deployment hygiene and removes unsafe automation, but it does **not** make the opaque runtime fully auditable. Test with a secondary WhatsApp account before trusting it with a primary account.

## Deploy

### Heroku

[Deploy this fork to Heroku](https://heroku.com/deploy?template=https://github.com/Informant254/Savage-Tech)

Required environment variable:

```env
SESSION_ID=your_base64_session_here
```

The repository includes a `Procfile`, `app.json`, Docker support, and a Node.js start script.

### Render

Connect this repository in Render and use:

```text
Build command: npm install
Start command: npm start
```

### Koyeb

Use this repository as the deployment source:

```text
https://github.com/Informant254/Savage-Tech
```

## Local start

Requires Node.js 20.x.

```bash
npm install
npm start
```

Never commit `.env`, `creds.json`, session directories, logs, or owner/session data.

## Security notes

- `SESSION_ID` belongs in the hosting provider's environment/config vars, not in Git.
- The upstream runtime is obfuscated, so outbound requests and credential handling cannot be confidently reviewed from source alone.
- The original auto-release workflow had repository write permission on every push. This hardened branch replaces it with a manual release workflow.
- Dependency installation should be tested with `--ignore-scripts` during security review before normal deployment.
- Use a secondary WhatsApp account for initial testing.

See [`SECURITY_AUDIT.md`](SECURITY_AUDIT.md) for the current review.

## Upstream attribution

This repository is a fork of [`tysavage163/Savage-Tech`](https://github.com/tysavage163/Savage-Tech). Upstream authors retain their rights. The upstream repository currently does not declare a license, so do not assume you have permission to redistribute or commercially relicense its code beyond what GitHub's fork functionality permits.

## Maintainer

Fork maintained at [`Informant254/Savage-Tech`](https://github.com/Informant254/Savage-Tech).
