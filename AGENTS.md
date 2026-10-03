# Working on emacs-customizations

- **Public repository** (github.com/stefanoconiglio/emacs-customizations): no secrets,
  credentials, chat links or other private details in `init.el` or anywhere else.
- **`init.el` is live:** `~/.emacs.d/init.el` is a symlink to it, so editing it edits the
  user's Emacs configuration. Commit and push only when the user asks.
- **The rest of the machine is read-only** unless the user says otherwise: inspect it, but do
  not change files, packages or services outside this repository without being asked.
- **The running Emacs is a daemon** (`emacs.service`; "Emacs (Client)" opens its frames). It read
  `init.el` when it started and does not reload it. Restarting it closes the user's frames: ask
  first, after they have saved. A package installed after it started is invisible to it until
  `package-load-all-descriptors`; evaluating a `use-package :vc` form before that would try to
  install the package again.
- **Testing:** use `/usr/bin/emacs --batch`, not `emacs`, which is the emacs-tui-default wrapper
  and opens a terminal window. To load the whole file, advise `server-start` to do nothing (the
  daemon's server is running) and force `daemonp` or `display-graphic-p` to t for the graphical
  branches. The daemon's PATH is only `/usr/local/bin:/usr/bin`: test with that PATH too.
- **Log:** `LOG.md`, one dated entry per working session.
