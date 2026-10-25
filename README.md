# System Design Concepts

A personal system design knowledge base (also an Obsidian vault), packaged as **AI agent skills**.

- Notes are in `01Foundation/` → `02BuildingBlocks/` → `03Patterns/` → `04Architectures/`. Start at [INDEX.md](INDEX.md).
- Agent instructions for working in this repo are in [AGENTS.md](AGENTS.md).

## Skills

| Skill | Use it for |
|---|---|
| [`system-design-architect`](skills/system-design-architect/SKILL.md) | Designing a new system, or reviewing and critiquing an existing architecture |
| [`system-design-tutor`](skills/system-design-tutor/SKILL.md) | Learning concepts, answering "what is / how does / X vs Y" questions, study plans, interview practice |

Both follow the open [Agent Skills](https://agentskills.io) standard: a `SKILL.md` file plus a `references/` folder. Each skill is self-contained. Its `references/` folder is a generated copy of the notes, so it works anywhere it's installed.

## Install

### Option 1: one command, any agent (recommended)

```sh
npx skills add DhruvSharma-845/System_Design_Concepts -g
```

This detects the agents installed on your machine (Claude Code, Copilot, Codex, OpenCode, Cursor, ...) and installs both skills globally. Add `--skill system-design-tutor` to install just one.

### Option 2: install script (clone + link)

```sh
curl -fsSL https://raw.githubusercontent.com/DhruvSharma-845/System_Design_Concepts/main/install.sh | bash
```

The script clones the repo to `~/.local/share/system-design-kb` and links the skills into:

| Directory | Read by |
|---|---|
| `~/.claude/skills/` | Claude Code, OpenCode |
| `~/.agents/skills/` | GitHub Copilot (CLI, VS Code, other IDEs), OpenAI Codex (CLI, IDE, ChatGPT desktop), OpenCode |

To update, re-run the script or `git -C ~/.local/share/system-design-kb pull`. Set `SDK_MODE=copy` to copy the folders instead of symlinking them.

### Option 3: Claude Code plugin marketplace

```text
/plugin marketplace add DhruvSharma-845/System_Design_Concepts
/plugin install system-design@system-design-concepts
```

### Option 4: web apps (claude.ai, etc.)

Download `system-design-architect.zip` / `system-design-tutor.zip` from the [`skills-latest` release](https://github.com/DhruvSharma-845/System_Design_Concepts/releases/tag/skills-latest) and upload them in the app's **Skills** settings. ChatGPT on the web and mobile only supports skills bundled as an OpenAI plugin. Use the ChatGPT desktop app or Codex with Option 1 or 2 instead.

### Per-project (team) install

To share the skills with everyone working in a repo, copy the skill folders into that repo's `.agents/skills/` (Copilot, Codex, OpenCode) or `.claude/skills/` (Claude Code, Copilot, OpenCode).

## Usage

You can just ask, and the agent picks the skill from its description. For example, "Design a rate limiter for 1M RPS" or "Explain quorum reads". You can also invoke a skill explicitly:

- Claude Code / Copilot CLI: `/system-design-architect`
- Codex: `$system-design-tutor`

## Maintaining

1. Edit notes as usual. Keep the frontmatter and [INDEX.md](INDEX.md) in sync (see [AGENTS.md](AGENTS.md)).
2. Push to `main`. The [`skills` workflow](.github/workflows/skills.yml) then:
   - re-syncs `skills/*/references/`
   - commits the result
   - republishes the zips to the `skills-latest` release

   To do the same locally, run `scripts/sync-skills.sh`, or `scripts/package-skills.sh` to also build `dist/*.zip`.
3. Don't edit `skills/*/references/` by hand. It's generated, and hidden from Obsidian.
