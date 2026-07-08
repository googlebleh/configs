# tmux-resurrect: empty-save clobber recovery

## Symptom
After reboot, restoring tmux-resurrect instantly exits the session (tmux dies).
Running `~/.tmux/plugins/tmux-resurrect/scripts/restore.sh` by hand reproduces it.

## Cause
`~/.local/share/tmux/resurrect/last` symlinks to a **0-byte** save file. With an
empty save, `restore.sh` restores nothing, then `handle_session_0()` runs
`tmux kill-session -t 0` and kills the only session.

The empty file comes from a tmux-continuum autosave (~15 min interval) firing
while the server is mid-boot/shutdown: `save.sh` truncates the new file with `>`,
captures nothing, then repoints `last` because empty "differs" from the good
save. Only the pointer moves — prior good saves stay intact.

## Recover
```sh
DIR=~/.local/share/tmux/resurrect
# newest non-empty save:
GOOD=$(ls -t "$DIR"/tmux_resurrect_*.txt | while read f; do [ -s "$f" ] && echo "$(basename "$f")" && break; done)
echo "$GOOD"
mv "$DIR"/last "$DIR"/last.broken 2>/dev/null; ln -fs "$GOOD" "$DIR"/last  # target = basename
wc -l "$(readlink -f "$DIR"/last)"   # sanity: >0
```
Then start tmux and restore **within ~15 min** (before the next autosave):
`prefix + Ctrl-r` (or run `restore.sh` inside tmux). Pane contents restore too if
`pane_contents.tar.gz` still matches the good save.

## Prevent
Guard `save.sh` `save_all()` — right before the `if files_differ ...` line, skip
repointing `last` on a paneless dump:
```sh
grep -q '^pane' "$resurrect_file_path" || { rm -f "$resurrect_file_path"; return; }
```
(Lives in a TPM-managed plugin dir; a plugin update can overwrite it.) Also fine:
keep `@continuum-restore` off and restore manually / promptly after boot.
