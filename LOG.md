# Log

One dated entry per working session: what changed, decisions and who made them, facts checked,
open questions. Earlier history of `init.el`: omarchy-customizations, `home/.emacs.d/init.el`.

## 2026-10-03 (16:05–17:20 CEST) — Claude Code in Emacs; init.el gets its own repository

**Claude Code in Emacs.** Request (user): Claude Code inside Emacs, aware of the open file and
the selected region, following an installation note (claude-code-ide.el with vterm).

- claude-code-ide 0.3.0 (commit 50a3d55) installed by `use-package :vc`, with its dependency
  web-server 0.1.2 from GNU ELPA. vterm was already installed, its module built.
- Corrections to the note: it repeats the MELPA and `package-initialize` lines init.el already
  has (left out); it assumes `claude` is on PATH, which is false for the daemon, whose PATH is
  `/usr/local/bin:/usr/bin` when it starts at boot (checked with `emacsclient --eval '(getenv
  "PATH")'`). `claude-code-ide-cli-path` therefore names the mise binary. After a restart the
  PATH would find Omarchy's wrapper `~/.local/bin/claude`, which runs `mise use -g claude` at every
  launch, so the mise binary comes first in both cases.
- Mistake during installation: `package-vc-install` was called with `:newest` as its revision.
  That is `use-package :vc` syntax; `package-vc-install` wants nil. The failed partial clone
  was removed before reinstalling.
- The running daemon had not read the new lines (it reads init.el only at start). Loaded live
  with `package-load-all-descriptors`, `package-activate` and the forms themselves.
- Decision (user): Claude's window below the left pane when the frame has panes side by side,
  else beside the selected window. Checked in a 200×50 terminal Emacs: one window → right of it;
  source | PDF → below the source, whichever is selected; source | PDF above a compilation
  window → below the source; source above compilation → right of the selected window; shown
  again → same window reused.
- Terminal buffers had line numbers (`global-display-line-numbers-mode`): off in vterm and
  ghostel. `display-line-numbers-exempt-modes` does not exist in Emacs 31.1.
- Decision (user): ghostel instead of vterm, as claude-code-ide recommends. ghostel
  20260930.1214 from MELPA; its native module v0.56.0 downloaded from the ghostel releases on
  GitHub. Checked in a terminal Emacs: output drawn, `TERM=xterm-ghostty`, no line numbers.
- Found: `~/.git` holds only `info/exclude`, written by Claude Code on 2026-10-02 (a list of
  its runtime files). It makes project.el treat the whole home folder as one project, so
  Claude sessions started from files outside a Git repository ran in `~`.

**Own repository.** Decision (user): each Emacs project in its own repository, so others can
pick them up separately; init.el in a new one, emacs-customizations, with
`~/.emacs.d/init.el` pointing to it. emacs-omarchy-theme and emacs-tui-default left
omarchy-customizations with their history (`git subtree split`); this repository starts from
the live init.el, without the old history, which stays in omarchy-customizations. The TEXSYNC
block now loads the theme from `~/repos/emacs-omarchy-theme`. Checked: the whole file loads in
batch with the daemon's PATH and `daemonp` forced (omarchy-follow on, from the new path;
texsync found; claude-code-ide defined, backend ghostel, CLI found).

**`~/.git` removed** (user: "do as you see fit"). Afterwards `project-current` in a
`.tex` buffer outside any Git repository is nil, and a new Claude session started from it runs
in that file's folder. Three sessions started earlier still run in `~`: if Claude Code
writes `~/.git/info/exclude` again, remove it again.

**Licence.** Decision (user): GPL-3.0-or-later for emacs-customizations, emacs-omarchy-theme
and emacs-tui-default, as texsync.

**Mistake.** The first version of the `~/.git` paragraph above named one of the user's lecture
files and its course folder. The user decided those names must not be public: this repository
was deleted on GitHub and re-created with a history that never contained them. A force push
alone would have left the old commit reachable by its hash.

**Open.**
- The orgmode.org ELPA archive no longer exists: each package refresh prints "Failed to download
  'org' archive" (it predates this session).
- Not checked: Claude Code's own shell commands with the daemon's short PATH (its shell is
  `/usr/bin/bash`, which reads `~/.bashrc`); `/voice` inside the Emacs terminal.
