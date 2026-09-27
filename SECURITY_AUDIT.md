# Security audit notes

Audit branch: `hardening/heroku-audit`

## Summary

This fork has received a deployment-hardening pass, but the core bot should **not** be described as fully audited or trusted yet. The main runtime files (`server.js`, `settings.js`, and the very large `bot.js`) are heavily obfuscated or otherwise difficult to review statically. Obfuscation is not proof of malicious behavior, but it prevents a meaningful source-level trust review.

## Findings

### 1. Core runtime is heavily obfuscated

`server.js` and `settings.js` contain generated variable names, encoded string tables, anti-analysis style wrappers, and other obfuscation patterns. `bot.js` is also unusually large. This makes it impractical to verify every outbound request, session-handling path, command handler, or update mechanism from source alone.

**Status:** unresolved risk.

**Recommendation:** replace the obfuscated runtime with readable source, or deobfuscate and review it before treating the bot as production-trusted.

### 2. No package lockfile is present

The repository does not currently contain `package-lock.json`. Without a lockfile, fresh installs can resolve different transitive dependency versions over time.

**Mitigation applied:** top-level dependencies in `package.json` are pinned to exact versions instead of caret ranges.

**Recommendation:** generate and commit a reviewed `package-lock.json` from a clean environment, then switch container builds from `npm install` to `npm ci`.

### 3. Custom WhatsApp packages are part of the trust boundary

The bot depends on `spencer-baileys` and `spencer-btns` rather than only the broadly used upstream Baileys package. These packages execute inside the same process as the WhatsApp session and therefore have access to sensitive runtime data.

**Status:** requires separate dependency review.

### 4. Release workflow previously ran automatically with write permission

The previous workflow triggered on every push to `main` and used a token with `contents: write` to create releases. The workflow also contained a very large generated codename list that made review unnecessarily difficult.

**Mitigation applied:** release creation is now manual-only through `workflow_dispatch`, validates the requested tag, scopes repository write permission to the release job, and excludes common secret/session files from the release archive.

### 5. Secrets and session data

The repository already ignored several secret/session files, but the ignore file contained duplicates and did not cover all release/runtime artifacts consistently.

**Mitigation applied:** `.gitignore` was cleaned up and now excludes `.env*` (while allowing `.env.example`), WhatsApp credentials, session directories, owner data, logs, release archives, and `spence.key`.

### 6. Deployment configuration was inconsistent

`Procfile` declared a `web` process while `heroku.yml` declared only a Docker `worker` process.

**Mitigation applied:** `heroku.yml` now declares the Docker process as `web` and runs `node server.js`, matching `Procfile` and `package.json`.

### 7. Container hardening

The previous image ran the application as root and installed all dependency classes.

**Mitigation applied:** the Docker image now uses a slim Node 20 base, sets production mode, installs production dependencies only, copies runtime files with non-root ownership, and runs as the built-in `node` user.

## What this audit does NOT prove

This pass does not prove that the bot is free of credential exfiltration, hidden remote commands, unsafe downloader behavior, malicious update logic, or other runtime behavior concealed by obfuscation. A trustworthy verdict requires readable source or controlled dynamic analysis of the obfuscated code and its dependencies.

## Before production use

1. Generate and review a lockfile in a clean environment.
2. Run `npm audit` and inspect the full dependency tree.
3. Review or replace `spencer-baileys` and `spencer-btns`.
4. Deobfuscate or replace `server.js`, `settings.js`, and `bot.js` with readable source.
5. Test with a disposable WhatsApp account and isolated hosting environment before using any important account.
6. Verify all outbound domains and network requests during runtime.

The safest long-term direction is to rebuild the runtime from readable, maintained components rather than continuing to trust opaque generated code.
