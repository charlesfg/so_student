# Operating Systems environment support

This directory supports the course Linux VM, Google Cloud Shell, and macOS for
portable exercises.

The package manifests in `packages/` are the shared package source of truth.
Run the setup script for the environment you are using, then run
`./validate.sh` from this directory. Linux setup scripts require a
Debian/Ubuntu-like environment and may ask for `sudo` privileges. The macOS
setup requires Homebrew.

Cloud Shell keeps coursework under `$HOME`; system packages may need to be
reinstalled when its temporary runtime is replaced. The Cloud Shell setup also
provides the persistent `$HOME/.customize_environment` bootstrap file.

macOS validation covers portable shell, C, and POSIX-thread exercises. Linux-
specific facilities such as `/proc`, System V IPC, and `ipcs` must be tested in
the Linux VM or Cloud Shell.
