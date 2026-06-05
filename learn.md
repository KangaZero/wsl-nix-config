# NixOS Learn Notes

## `nixos-rebuild` command ladder

Mental model: recipe check → cook → serve → set-as-default.
`dry-build` only reads the recipe; `switch` cooks, serves, and makes it the default.

| Command       | Eval config | Build derivations | Activate now | Default at boot |
|---------------|:-----------:|:-----------------:|:------------:|:---------------:|
| `dry-build`   | ✓           | ✗                 | ✗            | ✗               |
| `build`       | ✓           | ✓                 | ✗            | ✗               |
| `test`        | ✓           | ✓                 | ✓            | ✗               |
| `switch`      | ✓           | ✓                 | ✓            | ✓               |
| `boot`        | ✓           | ✓                 | ✗            | ✓ (next boot)   |
| `dry-activate`| ✓           | ✓                 | shows diff   | ✗               |

**Stages:**
1. **Eval** — parse all `.nix`, resolve options, catch syntax/type errors.
2. **Build** — compile derivations into `/nix/store`.
3. **Activate** — switch the live system to the new generation (restart services, relink `/run/current-system`).
4. **Boot default** — set new generation as the boot entry.

**Usage (flake):**
```bash
sudo nixos-rebuild dry-build --flake .#nixos   # rehearsal, safe
sudo nixos-rebuild switch    --flake .#nixos   # apply now + on boot
sudo nixos-rebuild test      --flake .#nixos   # apply now, NOT on boot (revert by reboot)
sudo nixos-rebuild boot      --flake .#nixos   # apply on next boot only
```

**When to use which:**
- `dry-build` — validate before committing. Cheap safety net.
- `test` — try risky change; reboot reverts if it breaks.
- `switch` — confident, want it permanent.
- `boot` — kernel/driver change needing clean reboot.

Docs: `man nixos-rebuild`
