# dotfiles-linux

Personal dotfiles for Linux (Ubuntu / WSL), with zsh as the shell.

## Install

```sh
git clone <this-repo> ~/dotfiles-linux
cd ~/dotfiles-linux
./bootstrap.sh --all        # install packages, link dotfiles, chsh to zsh
```

Then open a new terminal (on WSL: close and reopen the distro).

Options:

| Flag | What it does |
| --- | --- |
| `-n`, `--dry-run` | Print what would happen without changing anything |
| `-p`, `--packages` | `apt install` zsh, plugins, and common CLI tools |
| `-s`, `--shell` | Change your login shell to zsh |
| `-a`, `--all` | All of the above (plus linking) |

With no flags it only creates the symlinks. It's idempotent, and any existing file it would replace is moved to `~/.dotfiles-backup/<timestamp>/` first.

## Layout

Everything under `home/` is symlinked to the same relative path under `$HOME`. To add a dotfile, drop it in `home/` and rerun `./bootstrap.sh`.

```
home/
├── .zshenv                  env vars, PATH, XDG dirs (all zsh instances)
├── .zprofile                login shell setup
├── .zshrc                   interactive shell: history, completion, prompt, plugins
├── .config/zsh/
│   ├── aliases.zsh
│   └── functions.zsh        any *.zsh here is sourced by .zshrc
├── .gitconfig
├── .config/git/ignore       global gitignore
├── .vimrc
├── .tmux.conf               prefix is C-a
├── .inputrc                 readline (bash, REPLs)
└── .editorconfig
```

## Machine-local overrides

These are sourced if present and are not tracked:

- `~/.zshrc.local`, `~/.zprofile.local`
- `~/.gitconfig.local` — git `user.name` / `user.email` (bootstrap prompts for these)
- `~/.tmux.conf.local`
