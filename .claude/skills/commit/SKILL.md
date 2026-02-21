---
name: commit
description: Create a conventional commit for staged changes in this Flutter project
disable-model-invocation: true
allowed-tools: Bash(git *)
---

## Commit Assistant

Staged changes:
!`git diff --cached`

Staged files:
!`git diff --cached --name-only`

Recent commits (for style reference):
!`git log --oneline -10`

---

Analyze the staged changes above and create a conventional commit.

## Commit Message Rules

### Format
```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

### Types
| Type | When to use |
|------|-------------|
| `feat` | New feature, new UseCase, new screen, new widget |
| `fix` | Bug fix |
| `refactor` | Code change that's not a fix or feature (restructuring, renaming) |
| `test` | Adding or updating tests |
| `chore` | Build config, pubspec changes, tooling |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `perf` | Performance improvement |

### Scope (use the feature or layer name)
Examples: `auth`, `image-description`, `core`, `router`, `riverpod`, `di`

### Rules
- Subject line: max 72 chars, imperative mood ("add" not "added")
- No period at end of subject line
- Body: explain *why*, not *what* (the diff already shows what)
- If there's a breaking change, add `BREAKING CHANGE:` in the footer
- If files from multiple features changed, omit scope

### Flutter-specific notes
- Adding a new package to `pubspec.yaml` → `chore(deps): add <package>`
- New provider → `feat(<feature>): add <name> provider`
- New UseCase → `feat(<feature>): add <name> use case`
- New widget in `core/components` → `feat(core): add <name> component`
- New widget inside a feature → `feat(<feature>): add <name> component`
- Moving widget between `core/components` and feature → `refactor: move <name> to <location>`

---

Output only the final commit message, ready to use. Do not explain it.
Then run `git commit -m "<message>"` using the message you generated.
