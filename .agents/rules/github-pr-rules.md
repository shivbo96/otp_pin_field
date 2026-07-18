## Agent Guidelines (Antigravity Commit & PR Automation)

When the user asks you to "commit the code", "commit this", "push changes", or "create a PR", you MUST automatically follow this workflow:

1. **Analyze Workspace Changes First**:
   - Run:
     ```bash
     git status
     git diff
     ```
   - Analyze all modified, added, and deleted files.
   - Infer the following dynamically from the actual code changes:
     - Branch type
     - Branch name
     - Commit type
     - Commit message
     - PR title
     - PR description
   - Do not use generic placeholders.

2. **Verify Base Branch and Branch Checkout**:
   - Determine the current branch:
     ```bash
     git branch --show-current
     ```
   - Treat `main`, `master`, and `develop` as protected base branches.
   - If currently on a protected base branch, create a new branch first:
     ```bash
     git checkout -b <type>/<ticket-id>-short-description
     ```
   - If no ticket ID is provided, omit it:
     ```bash
     git checkout -b feature/routix-branding
     ```

3. **Protect Sensitive and Unwanted Files**:
   - Do not commit:
     - `.env`
     - `.env.*`
     - API keys
     - credentials
     - secret files
     - build folders
     - temporary files
     - IDE/system files

4. **Stage and Commit**:
   - Stage only relevant files.
   - Prefer:
     ```bash
     git add <specific-files>
     ```
   - Avoid blindly committing unrelated changes.
   - Create a Conventional Commit:
     ```bash
     git commit -m "<type>: short description" -m "Detailed explanation of changes."
     ```

5. **Generate and Raise PR**:
   - Generate the PR body using the exact `## PR Description Rule` format.
   - Fill all sections dynamically.
   - Mark relevant checkboxes using `[x]`.
   - Remove all placeholder text before finalizing.

6. **Create PR with GitHub CLI**:
   - Push the current branch:
     ```bash
     git push -u origin <current-branch>
     ```
   - Create the PR:
     ```bash
     gh pr create --title "<type>: short description" --body "<PR Description Content>"
     ```

7. **Fallback if GitHub CLI Fails**:
   - If `gh pr create` fails, print:
     - Full PR title
     - Full PR description
     - Exact commands the user can run manually

---

## PR Description Rule

Whenever generating a PR description, you **MUST** populate and use this exact markdown layout:

```markdown
## Description
<!-- Provide a clear and concise description of what this PR does -->

This PR includes <brief summary of the work completed>.

## Changes Made
<!-- List the main changes in bullet points -->
- 
- 

## Type of Change
<!-- Mark the relevant option with an 'x' -->
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Refactoring (no functional changes)
- [ ] Infrastructure/DevOps changes
- [ ] Documentation update

## Deployment Notes
<!-- Any special deployment considerations? Database migrations? Environment variables? -->
- [ ] No special deployment steps required
- [ ] Requires database migration
- [ ] Requires environment variable changes
- [ ] Requires infrastructure changes

**Details:**

## Screenshots/Logs
<!-- If applicable, add screenshots or relevant logs -->
```
