# sourceFR

Source from Repo: Execute a script from a remote git repo in the current shell

## What's sourceFR?

In Zsh and Bash, you can read and execute commands from a file in the current shell by making use of the `source` command. For example:

```bash
source "myScript.sh"
```

This is useful if you want to load functions and instantiate variables in one script and reuse them in another.

But what if you wish to run `source` on a script that lives in a remote git repository? Introducing `sourceFR`!

## Dependencies

- Zsh or Bash as your shell
- [git](https://git-scm.com/downloads)

## Install

There's no need to download or clone this repo to install sourceFR.

In your Zsh or Bash terminal run:

```bash
eval "$(curl -fsSL "https://raw.githubusercontent.com/benchesh/sourceFR/main/install.sh")"
```

This will run the install script, which will:

- Add an invisible `.shell_sourceFR` directory to your home directory. The `sourceFR` function will then be written to `src.sh` within this directory
- Make a single line modification to your `.zshrc` and `.bashrc` files which will load the sourceFR function every time Zsh or Bash are loaded
  - These files will be created if they don't exist

## Usage

You can use the `sourceFR` command in much the same way as you'd use `source`, but two arguments must be provided. The first argument must be the URL for the git repo, and the second must be the relative path to the script within that repo.

sourceFR works by cloning its own copy of repos you request using standard git commands. Every time you run `sourceFR`, it'll run `git pull` on the repo if it's already been cloned.

### Example

Give sourceFR a go with the `test.sh` script provided by this repository!

```bash
sourceFR https://github.com/benchesh/sourceFR example/test.sh
```

### Switching branches

Only default branches on sourceFR repos are supported out of the box. If you wish to retrieve a file from a different branch, you can navigate to sourceFR's copy of the repo and manually switch branch yourself using `git checkout`. sourceFR won't switch the branch back again, so proceed with caution!

You can navigate to sourceFR's copies of repos with this command:

```bash
cd "$HOME/.shell_sourceFR/cache"
```

### Troubleshooting

- Make sure you can access the repo within your shell (ie. use `git ls-remote <repo-url-here>`), or sourceFR won't work!
- If you wish to delete sourceFR's copies of repos, you can find them at `"$HOME/.shell_sourceFR/cache"`. sourceFR will clone a fresh copy if it's been deleted.
