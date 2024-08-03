# HOWTO: Writing and Using lefthook.yml Files

> https://claude.ai/chat/a5311265-9f31-4da3-8e9c-37e382f24c93

## What is Lefthook?

Lefthook is a fast and powerful Git hooks manager that works with multiple programming languages. It allows you to
easily manage, configure, and run scripts or commands at various stages of the Git workflow, such as pre-commit or
pre-push. Lefthook helps maintain code quality and consistency across your team by automating checks and tasks.

## Installing Lefthook

To install Lefthook and set up the Git hooks:

1. Install Lefthook (e.g., `npm install lefthook --save-dev` for Node.js projects)
2. Create a `lefthook.yml` file in your project root
3. Run `lefthook install` to set up the Git hooks

This will create the necessary hook files in your `.git/hooks` directory, linking them to Lefthook.

## Running Lefthook

Lefthook runs automatically when you perform Git actions (e.g., commit, push) based on your configuration. You can also
run hooks manually:

- Run all commands for a specific hook: `lefthook run pre-commit`
- Run a specific command: `lefthook run pre-commit --commands lint`
- Run a custom task: `lefthook run lint-fix`

## Basic Structure

```yaml
<hook-name>:
  commands:
    <command-name>:
      run: <command to execute>
```

Example:
```yaml
pre-commit:
  commands:
    lint:
      run: npm run lint
```

## Parallel Execution

Enable parallel execution of commands:

```yaml
<hook-name>:
  parallel: true
  commands:
    # ...
```

## File Filtering

Filter files using glob patterns:

```yaml
commands:
  lint-js:
    glob: "*.js"
    run: eslint {staged_files}
```

Exclude files using regex:

```yaml
commands:
  lint-rb:
    glob: "*.rb"
    exclude: '(^|/)application\.rb$'
    run: rubocop {all_files}
```

## Custom File Lists

Specify custom file lists:

```yaml
commands:
  lint:
    files: git diff --name-only HEAD @{push}
    run: eslint {files}
```

## Environment Variables

Set environment variables for commands:

```yaml
commands:
  test:
    env:
      NODE_ENV: test
    run: npm test
```

## Working Directory

Change the working directory for a command:

```yaml
commands:
  build:
    root: "frontend/"
    run: npm run build
```

## Skipping Execution

Skip commands based on conditions:

```yaml
commands:
  test:
    skip:
      - merge
      - rebase
    run: npm test
```

## Tagging Commands

Add tags to group commands:

```yaml
commands:
  lint-js:
    tags: [frontend, style]
    run: eslint {staged_files}
```

## Scripts

Run scripts instead of inline commands:

```yaml
scripts:
  "check-commit-msg.sh":
    runner: bash
```

## Remote Configurations

Use remote configurations:

```yaml
remotes:
  - git_url: https://github.com/org/repo
    ref: main
    configs:
      - lefthook/base.yml
```

## Local Overrides

Create a `lefthook-local.yml` for local overrides:

```yaml
pre-commit:
  commands:
    lint:
      skip: true
```

## Custom Tasks

Define custom tasks:

```yaml
lint-fix:
  commands:
    js-fix:
      run: eslint --fix {staged_files}
    ruby-fix:
      run: rubocop -a {staged_files}
```

## Output Control

Manage verbosity:

```yaml
output:
  - meta
  - summary
  - execution
```
