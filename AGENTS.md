# AGENTS.md

Instructions for AI agents (Claude, Copilot, Codex, Cursor, etc.) using this repository.

## What this repo is

A personal **system design knowledge base**, written as markdown notes (also an Obsidian vault).
Use it as the reference source when asked to **design, review, or reason about the architecture of a system**.
Prefer the concepts, trade-offs, and terminology in these notes over generic knowledge; when you rely on a note, cite its path.

## Layout

Notes are layered from fundamentals up to whole-system architectures:

| Folder | `type` | Contains |
|---|---|---|
| `01Foundation/` | `concept` | Core distributed-systems and database theory (scalability, caching, replication, sharding, consistency, consensus, transactions, ...) |
| `02BuildingBlocks/` | `building_block` | Reusable components (load balancer, auth, ID generation, batch and stream processing, ...) |
| `03Patterns/` | `pattern` | Design patterns composed from building blocks (event sourcing/CQRS, IAM, workflow engines, ...) |
| `04Architectures/` | `architecture` | Whole-system styles (monolith/three-tier, microservices, event-driven, multitenancy, security architectures, ...) |
| `assets/` | — | Images referenced by notes (agents: rely on the surrounding text, not the image) |
| `skills/` | — | Agent skills built from this repo (`system-design-architect`, `system-design-tutor`). Their `references/` folders are **generated**; never edit or search them, use the originals. |
| `scripts/`, `install.sh` | — | Sync, packaging, and install tooling for the skills (see [README.md](README.md)) |

**Start with [INDEX.md](INDEX.md)**. It lists every note with a one-line summary and when to use it.

## Workflow for a system design task

1. **Read `INDEX.md`**. Pick candidate notes by matching the problem's requirements against each note's summary and `use_when`.
2. **Clarify requirements.** Cover functional needs, scale (users, QPS, data size), latency, availability, and consistency needs.
3. **Pick an architecture.** If a note in `04Architectures/` matches, read it first.
4. **Pick patterns and building blocks.** Read the relevant notes in `03Patterns/` and `02BuildingBlocks/`.
5. **Ground the trade-offs in foundations.** For each key decision (replication mode, sharding key, consistency model, transaction strategy), read the matching `01Foundation/` note.
6. **Follow `related` links** in the frontmatter, but only when they're relevant. Don't read the whole repo.
7. **Produce the design.** Cover requirements, estimates, API, data model, components (Mermaid diagram preferred), and how data flows. Then cover bottlenecks, failure modes, and trade-offs. Reference the notes you used.
8. **Check `status`.** Treat `stub` and `partial` notes as incomplete. Fill gaps from general knowledge and say so.

Fast lookup: notes are small and single-topic, so grep the frontmatter.

```sh
grep -rl "tags:.*quorum" 0*/          # by tag
grep -rl "type: pattern" 0*/          # by type
grep -rn "^summary:" 0*/              # all summaries
```

## Note frontmatter schema

Every note in `0*/` starts with this YAML frontmatter, using these keys in this order:

```yaml
---
title: "Replication"                       # human-readable name
type: concept                              # concept | building_block | pattern | architecture (matches folder)
domain: [databases, distributed-systems]   # one or more from the controlled list below
tags: [single-leader, quorum, failover]    # free-form, kebab-case keywords for grep
summary: "One sentence on what the note covers."
use_when:                                  # design situations where this note applies
  - "High availability or failover"
related:                                   # repo-root-relative paths to other notes
  - "01Foundation/Sharding.md"
status: solid                              # stub | partial | solid
---
```

- **domain** must come from this controlled list: `distributed-systems`, `databases`, `networking`, `security`, `data-processing`, `event-driven`, `multitenancy`.
- **status** is one of:
  - `stub`: empty or headings only
  - `partial`: covers the topic but has gaps
  - `solid`: covers the main topic well
- **related** paths are relative to the repo root, not to the note.

## Conventions when editing or adding notes

- Keep each note to **one topic**. Split a note when it grows past one concept.
- Put a new note in the folder that matches its `type`, and give it the full frontmatter above.
- **Add a row to `INDEX.md`** in the same change. Keep the index and the notes in sync.
- Then run `scripts/sync-skills.sh` so the skills' `references/` folders match. CI also does this on every push to `main`.
- When editing a skill's `SKILL.md` or templates, keep the `name` matching its folder and the `description` under 1024 characters. Update `README.md` if install or usage changes.
- In the body, use **standard relative markdown links** (`[Sharding](../01Foundation/Sharding.md)`). Don't use `[[wikilinks]]`, and always include the `.md` extension.
- Prefer **Mermaid or text diagrams**. If you add an image, describe what it shows in text next to it.
- Suggested body sections for building blocks and patterns: *What it is*, *When to use*, *How it works*, *Trade-offs*, *Failure modes*, *Alternatives*.
