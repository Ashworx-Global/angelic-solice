---
name: git-commit
description: "Create git commits with Conventional Commits, sensitive-file guardrails, and Copilot co-author trailer. Use when asked to commit, prepare commit message, or run /git-commit."
argument-hint: "Describe the intent of the commit, e.g. 'add top nav and routing'"
user-invocable: true
---

# Git Commit Skill

## Purpose

Create safe, high-quality commits with a consistent format:
- Conventional Commit message style
- Sensitive-data guardrails
- Co-author trailer for GitHub Copilot

## Required Rules

1. Use Conventional Commits:
- Format: `<type>(<scope>): <subject>`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`, `revert`
- Subject must be lowercase, imperative, and <= 72 chars when possible.

2. Add co-author trailer to every commit created through this workflow:
- `Co-authored-by: GitHub Copilot <copilot@github.com>`

3. Sensitive-file guardrail is mandatory:
- Detect potentially sensitive files/content before commit.
- If sensitive files are detected, do NOT include them automatically.
- Stage and commit all non-sensitive files.
- Ask the user explicitly whether each sensitive file should be included.

## Sensitive Detection Heuristics

Treat a file as sensitive if either condition is true:
1. File path/name suggests secrets, for example:
- `.env`, `.env.*`, `secrets`, `credentials`, `token`, `key`, `cert`, `private`, `p12`, `jks`, `keystore`, `firebase_options.dart`

2. Staged/unstaged diff content matches secret-like patterns, for example:
- `api_key`, `apikey`, `secret`, `client_secret`, `access_token`, `refresh_token`, `connection_string`, `password`
- `AKIA[0-9A-Z]{16}`
- `-----BEGIN (RSA|EC|OPENSSH|PRIVATE) KEY-----`

## Workflow

1. Inspect repo status and diff.
2. Classify changed files into:
- Safe to commit
- Potentially sensitive
3. If sensitive files exist:
- Stage only safe files first.
- Propose commit message for safe files.
- Ask user whether to include each sensitive file (yes/no per file).
4. Build Conventional Commit message:
- Choose type/scope based on actual changes.
- Keep subject concise.
- Add optional body when useful.
- Add Copilot co-author trailer.
5. Commit and report result.

## Commit Message Template

```text
<type>(<scope>): <subject>

<optional body>

Co-authored-by: GitHub Copilot <copilot@github.com>
```

## Notes

- If the user provides a specific message, normalize it into Conventional Commit format.
- If no scope is obvious, omit scope: `<type>: <subject>`.
- Never expose full secret values in summaries.
