# Uninstalling Superpowers Plus

These steps assume you installed superpowers-plus via `.opencode/INSTALL.md`. This does not attempt to restore upstream superpowers.

## Remove the skills symlink or folder

```bash
rm -rf ~/.config/opencode/skills/superpowers
```
## Remove plugin from corresponding opencode folder

```bash
rm -rf ~/.config/opencode/plugins/superpowers.js
```

## Remove the superpowers-plus repo clone

```bash
rm -rf ~/.config/opencode/superpowers
```

## Remove Superpowers Plus agent files

```bash
rm -f ~/.config/opencode/agents/sp-*.md
```
