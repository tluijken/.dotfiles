---
name: nixos
description: Resolve NixOS and Home Manager configuration issues in this flake-based dotfiles repo using research and the nix-pro subagent
---
Use the nix-pro subagent and the nixos MCP server tools to resolve NixOS
configuration issues.

- This system is configured from the flake at ~/.dotfiles
  (`nixosConfigurations.nixos`). Home Manager runs as a NixOS module; user
  configuration lives under home-manager/, system configuration under nixos/.

- Do not, under any circumstances, decrypt sops-nix secrets
  (home-manager/secrets/*.yaml or anything matched by .sops.yaml). Edit
  secrets only through `sops <file>`, never by decrypting to plaintext on
  disk or into the conversation.

- Verify that a package or option exists before using it: prefer the nixos
  MCP tools, fall back to `nix search nixpkgs`, `nixos-option`, and
  search.nixos.org. Never assume an option exists.

- Flake evaluation only sees tracked files: `git add` new files before
  running any nix command against the flake.

- Use web search for community solutions and recent breaking changes;
  NixOS moves faster than training data.

- Use context7 when current library or module documentation would help, and
  sequential-thinking to break complex changes into atomic, verifiable steps.

- Workflow: edit, validate with
  `nixos-rebuild build --flake ~/.dotfiles#nixos` or a targeted `nix eval`,
  and only then switch. Run
  `sudo nixos-rebuild switch --flake ~/.dotfiles#nixos` only when the user
  asks for it.

- Before any build or switch, `touch /tmp/.nixos-build.lock` and remove it
  when the command finishes. If the file already exists, another job is
  building: wait up to ten minutes, checking every 10 seconds, before
  proceeding.
