# Kilo Tool Mapping

Skills speak in actions ("dispatch a subagent", "create a todo", "read a file").
On Kilo these resolve to the tools below.

| Action skills request | Kilo tool |
| --- | --- |
| Read a file | `read` |
| Create a file | `write` |
| Edit a file | `edit` |
| Run a shell command | `bash` |
| Search file contents | `grep` |
| Find files by name | `glob` |
| List a directory | `list` |
| Fetch a URL | `webfetch` |
| Web search | `websearch` |
| Create / update todos ("create a todo", "mark complete"; older `TodoWrite` refs) | `todowrite` |
| Dispatch a subagent (`Subagent (general-purpose):` template) | `task` with `subagent_type: "general"` (use `"explore"` for read-only codebase exploration) |
| Invoke a skill | Kilo's native `skill` tool |
| Ask the human a question | `question` |
| Start a long-lived process | `background_process` |
| Render a chart | `chart` |

Kilo ships a native `skill` tool: list and load skills with it. Do **not** read
`SKILL.md` files with `read` — that bypasses the skill mechanism. (Reading a
`SKILL.md` directly is only the sanctioned fallback on harnesses with no skill
tool; Kilo is not one of those.)

The local installer targets Kilo-supported legacy locations: skills under
`~/.kilocode/skills/`, the always-on bootstrap at
`~/.kilocode/rules/superpowers.md`, and the `/superpowers` command under the
singular `~/.config/kilo/command/` directory.

Current Kilo documentation recommends `~/.kilo/skills/` for global skills,
global instructions through `~/.config/kilo/AGENTS.md` or the `instructions`
setting in `~/.config/kilo/kilo.jsonc`, and `~/.config/kilo/commands/` for
global commands. Kilo still supports the legacy skill and rules paths, and its
configuration reference accepts both `command/` and `commands/`. The installer
does not migrate these files or edit the global Kilo configuration.
