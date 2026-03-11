# QE OS Improvement Proposals

> Records proposed improvements to the QE RFP Operating System.
> Agents propose changes here. System updates require human approval.

---

## Active Proposals

### Improvement Proposal: IP-P3-01
- **Observation:** After Phase 3 implementation, `AGENTS.md` is 816 lines. The practical single-load warning threshold is ~400–500 lines. AGENTS.md is significantly above this, though as a system harness file (rules + workflow, not growing data) this is more tolerable than data files.
- **Root Cause:** AGENTS.md accumulates all workflow rules, governance layers, stage definitions, skill rosters, HITL rules, and conflict resolution protocols in a single file. Each phase of improvements adds to it.
- **Suggested Change:** For Phase 4, evaluate whether AGENTS.md can be split into: (1) a lean orchestration harness (stage definitions, checkpoint rules, executor table) and (2) a separate governance rulebook (HITL, gap coverage, evidence-first, regulatory context). The harness remains always-loaded; the governance rulebook is loaded selectively by relevant stages.
- **Impact:** Medium
- **Status:** Proposed
- **Priority:** Medium

---

### Improvement Proposal: IP-P3-03
- **Observation:** `evidence-extraction/SKILL.md` is 301 lines — the largest skill file in the system. It is loaded in full at Stage 1 and carries significant structural detail: finding formats, RFP question extraction rules, missing evidence format, Value Claim Trace block, contradiction handling, guardrails, and handoff.
- **Root Cause:** Evidence extraction is a multi-responsibility task by nature — it must handle multiple artifact types, multiple finding categories, and multiple output formats. However, the file is approaching a size where further additions would meaningfully inflate Stage 1 context loading.
- **Suggested Change:** No action now. Flag for Phase 4 review. If any further schema additions are proposed (e.g., new finding types, additional extraction rules), evaluate whether a dedicated `evidence-extraction-formats.md` reference file can hold schema definitions (finding structure, block formats) separately from the skill logic (responsibilities, guardrails, handoff).
- **Impact:** Low
- **Status:** Proposed
- **Priority:** Low

---

## Archive

### Improvement Proposal: IP-P3-02
- **Observation:** The Value Claim Trace block (Task 3) adds ~5 lines per quantified claim in `memory.md`. A claim-heavy RFP (15–20 quantified benefit claims) could add 75–100 lines to `memory.md`, accelerating how quickly the 250-line summarisation threshold is reached and potentially triggering premature summarisation before all agents have used the full findings.
- **Root Cause:** Value Claim Trace blocks are appended inline with findings rather than in a separate section of `memory.md`. High-claim engagements will inflate the primary findings section of memory.md disproportionately.
- **Suggested Change:** Consider adding a dedicated `## Value Claim Traces` section to the `memory.md` schema, so that quantified claim validation blocks are stored separately from the primary finding list. This keeps the primary findings section compact while preserving full traceability. Evaluate in the first live engagement where Value Claim Trace is triggered.
- **Impact:** Medium
- **Status:** Implemented
- **Priority:** Medium

---

### Improvement Proposal: IP-P3-04
- **Observation:** AGENTS.md has three functionally distinct zones — conductor-only (Stages 0–3, ~120 lines), agent-facing routing and skill roster (~80 lines), and governance rules (HITL, evidence-first, conflict resolution, gap coverage, ~350 lines) — but is loaded in full by all agents at all stages.
- **Root Cause:** No split between always-needed orchestration content and stage-specific governance rules. Agents in Stages 4–7 load ~350 lines of governance content they do not need.
- **Suggested Change:** Split AGENTS.md into three files: (1) `AGENTS.md` — lean harness (~250 lines): stage summary, conductor responsibilities, agent/skill roster, routing guide, agent context scope, memory rules; (2) `governance.md` (~350 lines): HITL model, evidence-first rule, gap coverage rules, proposal quality rules, output type classification, conflict resolution; (3) `SETUP.md` (~55 lines): workspace initialization + file templates. Governance.md loaded on-demand at Stage 8 only.
- **Impact:** High
- **Status:** Implemented
- **Priority:** High

---

### Improvement Proposal: IP-P3-05
- **Observation:** The Agent Context Scope table governs which memory files each agent loads, but has no equivalent rule for skill files. `pert-estimation` (193 lines) and `kpi-baseline` (169 lines) could be loaded in any stage where estimation is invoked — including stages where sizing is not in scope. `evidence-reconciliation` (219 lines) is Stage 8 only but has no constraint preventing earlier loading.
- **Root Cause:** Skill loading is governed by invocation rules inside each skill, not by a scope table enforced at the conductor level. There is no "skill context scope" equivalent to the memory context scope table.
- **Suggested Change:** Add a "Skill Files" column to the Agent Context Scope table in AGENTS.md. Specify which skill files each agent loads as baseline context vs. on-demand. Add one-line note to `pert-estimation` and `kpi-baseline` Skill Roster entries: "Load skill file only when estimation is in scope — do not pre-load as baseline context."
- **Impact:** High
- **Status:** Implemented
- **Priority:** High

---

### Improvement Proposal: IP-P3-06
- **Observation:** Phase 3 introduced three constructs that write to `memory.md` beyond simple findings: (a) Value Claim Trace blocks (~5 lines/claim), (b) Extraction Completeness Declaration appended at Stage 2 handoff (will accumulate on re-runs), (c) Gap Coverage report written to memory.md at Stage 3 (one row per finding — 50+ lines on large RFPs).
- **Root Cause:** All three write to memory.md without containment rules. The 250-line summarisation threshold can be hit before Stage 4 agents begin analysis on claim-heavy or high-finding engagements.
- **Suggested Change:** Three targeted fixes: (a) Implement IP-P3-02 — separate `## Value Claim Traces` section in memory.md schema; (b) Add overwrite-not-append rule to evidence-extraction/SKILL.md Handoff — the Extraction Completeness Declaration is an operational status block, not a finding; (c) Route Gap Coverage report to `notes.md` instead of memory.md — it is a stage output, not a persistent finding.
- **Impact:** Medium
- **Status:** Implemented
- **Priority:** Medium

---

### Improvement Proposal: IP-P3-07
- **Observation:** The memory.md summarisation threshold is 250 lines. With Value Claim Trace blocks, the Extraction Completeness Declaration, and the Gap Coverage report all writing to memory.md, a medium-complexity RFP (20+ findings, 10+ quantified claims) will reach the 250-line threshold by end of Stage 3 — before any agent analysis begins at Stage 4.
- **Root Cause:** Threshold was set before Phase 3 additions. Phase 3 materially increased the per-engagement write volume to memory.md.
- **Suggested Change:** Lower threshold to 200 lines, or implement IP-P3-02 + IP-P3-06(c) first (separating Value Claim Traces and routing Gap Coverage to notes.md), which effectively raises the functional headroom without changing the threshold. The two approaches are complementary — implement structural separation first, then reassess whether threshold adjustment is still needed.
- **Impact:** Medium
- **Status:** Implemented
- **Priority:** Medium

---

### Improvement Proposal: IP-P3-08
- **Observation:** The Stage 9 completeness checklist exists in two places: AGENTS.md Stage 9 self-validation loop and `review-challenge-thinking/SKILL.md` Completeness Checklist section. If criteria are updated in one file, the other may drift — producing inconsistent enforcement between conductor-level and skill-level checks.
- **Root Cause:** No designation of which file is the source of truth for the checklist criteria. Both files treat themselves as authoritative.
- **Suggested Change:** Designate `review-challenge-thinking/SKILL.md` as the source of truth for checklist criteria. In AGENTS.md Stage 9, replace the inline criteria table with a pointer: "Run the completeness checklist defined in `review-challenge-thinking/SKILL.md` — criteria are authoritative there." This reduces AGENTS.md by ~10 lines and removes the maintenance liability.
- **Impact:** Low
- **Status:** Implemented
- **Priority:** Low
