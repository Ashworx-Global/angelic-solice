---
name: "commit"
description: "Create a Conventional Commit with sensitive-file guardrails and Copilot co-author trailer."
argument-hint: "What should this commit accomplish?"
agent: "agent"
---
Use the repository's `git-commit` skill workflow to prepare and run a commit.

Requirements:
1. Review changed files and propose a Conventional Commit message.
2. Detect potentially sensitive files/content.
3. If sensitive files are found, commit all non-sensitive files first and ask me before including sensitive files.
4. Add this trailer to commits created through this workflow:
`Co-authored-by: GitHub Copilot <copilot@github.com>`
5. Show the final committed files and the final commit message.

User intent for this commit:
`$ARGUMENTS`
