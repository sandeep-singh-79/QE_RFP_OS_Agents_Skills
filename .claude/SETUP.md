# SETUP.md — Workspace Initialization

**Load this file:** During workspace initialization only, before Stages 0–3 begin. Not required during agent execution (Stages 4+) unless file templates or initialization order need to be consulted.

Workspace initialization procedures for the QE RFP Operating System. Load this file when setting up a new engagement workspace or when file templates are needed for initialization.

---

## Workspace Initialization

If required workspace files or folders do not exist, the system may create them when first needed during workflow execution. Do not create files prematurely or speculatively.

### Initialization Order
1. Check if `claude-memory/` directory exists — create if absent
2. Check for required memory files — create with header template when first write is needed
3. `plan.md` at root — create if absent when task tracking begins
4. Never create agent or skill files during initialization — these are system-managed

### File Templates (for creation on first use)

**claude-memory/decisions.md** — Header: `# Decisions Log` + `> Tracks major decisions made during engagement analysis.`

**claude-memory/artifacts.md** — Header: `# Artifact Index` + `> Registers all knowledge source artifacts entering the system.` + table with columns: ID, Name, Type, Source, Date Received, Status

**claude-memory/improvements.md** — Header: `# QE OS Improvement Proposals` + `> Records proposed improvements to the QE RFP Operating System.` + `> Agents propose changes here. System updates require human approval.`

**plan.md** (at workspace root) — Use the following structure:

```md
# Engagement Plan

| Field | Value |
|---|---|
| Client | [client name from artifacts] |
| RFP / Document | [document name or reference] |
| Engagement Started | [date] |
| Discovery Maturity | [Constrained / Moderate / Deep] |
| Current Stage | [Stage N — Name] |

## Stage Status

| Stage | Status | Notes |
|---|---|---|
| Stage 0 — Artifact Discovery | Not Started | |
| Stage 1 — Evidence Extraction | Not Started | |
| Stage 2 — Memory Initialization | Not Started | |
| Stage 3 — Gap Coverage | Not Started | |
| Stage 3.5 — Capability Coverage | Not Started | |
| Stage 4 — Solution Design | Not Started | |
| Stage 5 — Architecture Validation | Not Started | |
| Stage 6 — Delivery Validation | Not Started | |
| Stage 7 — Client Perspective Review | Not Started | |
| Stage 8 — Governance Validation | Not Started | |
| Stage 9 — Output Generation | Not Started | |
| Stage 10 — System Learning | Not Started | |
```

Update `Current Stage` in the header and the corresponding row in Stage Status after each stage completes.
