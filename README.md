# Git Workflow Guidelines for Event Management Repository

## Repository URL
`git clone https://github.com/lalisabl/eventManagement`

## General Rules
1. **Pull from Main Before Starting Work**
   - Before starting any new task, ensure you pull the latest changes from the main branch to stay up-to-date:
     ```sh
     git checkout main
     git pull origin main
     ```

2. **Create a New Branch for Each Task**
   - Always create your own branch before making any changes:
     ```sh
     git checkout -b your-branch-name
     ```
   - Name your branches descriptively, ideally including the task or feature name, e.g., `feature/user-authentication`.

3. **Commit Regularly and Push to Your Branch Only**
   - Make frequent, meaningful commits to your branch.
   - Push your changes to your branch only:
     ```sh
     git push origin your-branch-name
     ```

4. **Never Push Directly to Main**
   - Do not push changes directly to the main branch. This helps prevent breaking the main branch inadvertently.

5. **Periodic Merging by Designated Person**
   - A designated person will be responsible for merging branches into the main branch periodically.
   - They will review the pull requests, resolve conflicts, and ensure the main branch remains stable.

6. **Handling Conflicts**
   - If you encounter conflicts, attempt to resolve them by reverting to your last stable code and incorporating your changes again:
     ```sh
     git stash
     git pull origin main
     git stash pop
     ```
   - If conflicts affect your code, do not leave them unresolved. Seek help from your teammates.

7. **Avoid Force Pushing**
   - Never use `git push --force` as it can overwrite commits and cause loss of work.

## Branch Naming Conventions
- Use descriptive names for branches. Examples:
  - `your_name/feature_you_are_doing` this is good i guess
  - `feature/login-page`
  - `bugfix/navbar-issue`
  - `hotfix/critical-bug`

## Production and Main Branch
- The `main` branch is our main provider and the production branch we will use later.
- Ensure the `main` branch is always stable and deployable.

## Summary
1. **Always pull from main before starting work.**
2. **Create your own branch for any new task.**
3. **Commit and push to your branch only.**
4. **Never push directly to main.**
5. **A designated person will handle merging into the main branch.**
6. **Resolve conflicts with help if needed and never use force push.**

By following these guidelines, we ensure a smooth workflow, minimize conflicts, and maintain a stable main branch.
