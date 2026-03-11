# SETUP.md — Workspace Initialization

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

**decisions.md** — Header: `# Decisions Log` + `> Tracks major decisions made during engagement analysis.`

**artifacts.md** — Header: `# Artifact Index` + `> Registers all knowledge source artifacts entering the system.` + table with columns: ID, Name, Type, Source, Date Received, Status

**improvements.md** — Header: `# QE OS Improvement Proposals` + `> Records proposed improvements to the QE RFP Operating System.` + `> Agents propose changes here. System updates require human approval.`
