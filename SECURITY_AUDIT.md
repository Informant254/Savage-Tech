# Celestia Security Audit

## Scope

This review covers the fork's repository structure, deployment metadata, GitHub Actions configuration, secret-handling files, and the readability/auditability of the core runtime.

## Current status

**Status: PARTIALLY HARDENED / CORE RUNTIME NOT FULLY VERIFIED**

The deployment surface has been improved, but the main application source remains heavily obfuscated. Obfuscation is not proof of malicious behavior, but it prevents a normal source review from establishing what credentials, messages, files, and remote endpoints the runtime may access.

## Findings

### 1. Core runtime is heavily obfuscated — HIGH

`server.js`, `settings.js`, and `bot.js` are unusually large and/or obfuscated. This makes security-sensitive behavior difficult to review, including:

- outbound network requests;
- session/credential access;
- dynamic code execution;
- downloaded code or update mechanisms;
- filesystem access;
- owner/admin command handling.

**Action:** treat the runtime as unverified until a readable upstream source or successful deobfuscation/review is available. Test with a secondary WhatsApp account and non-sensitive hosting credentials.

### 2. GitHub release workflow had write permission on every main push — MEDIUM

The upstream workflow granted `contents: write` and automatically created releases on pushes to `main`. It also contained an extremely large codename list that made review unnecessarily difficult.

**Action taken:** replaced it with a small, manually triggered release workflow. Repository write permission is now only used when a maintainer explicitly starts a release.

### 3. Session secret handling — MEDIUM

The bot requires `SESSION_ID`, which represents WhatsApp authentication material.

**Action taken:** deployment docs now instruct users to keep it in host environment/config vars. `.env`, `creds.json`, session folders, logs, and owner data remain excluded from Git.

### 4. No declared upstream license — LEGAL / DISTRIBUTION RISK

The upstream repository currently declares no license. A public GitHub repository is not automatically an open-source license grant.

**Action taken:** preserved upstream attribution in the README and added a warning not to assume commercial redistribution/relicensing rights.

### 5. Dependency trust is not yet fully established — MEDIUM

The runtime depends on packages including `spencer-baileys` and `spencer-btns`. Their behavior has not been independently audited in this review.

**Action:** review dependency provenance and run dependency auditing before production use. Prefer inspecting installs with lifecycle scripts disabled first:

```bash
npm install --ignore-scripts
npm audit --omit=dev
```

## Hardened changes in this branch

- Created isolated `celestia-hardening` branch.
- Repointed Heroku metadata and deployment links to `Informant254/Savage-Tech`.
- Rebranded deployment documentation as Celestia while preserving upstream attribution.
- Marked the package as private to reduce accidental npm publication.
- Added syntax and dependency-audit scripts.
- Replaced the oversized push-triggered release workflow with a manual release workflow.
- Added a read-only CI security check.
- Added `.env.example` without secrets.

## Production gate

Do **not** call this runtime fully trusted yet. Before using a primary WhatsApp account or selling hosted instances, complete at least one of these:

1. obtain readable source from the upstream author and review it;
2. deobfuscate and review the runtime successfully;
3. replace the opaque runtime with a clean implementation whose network, filesystem, and credential behavior can be audited.

Until then, deployment should be considered experimental.
