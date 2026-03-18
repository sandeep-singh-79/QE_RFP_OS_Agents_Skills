# Stage 9 — Proposal Output Structure

> **Used by:** Conductor at Stage 9 — Output Generation.
> Load this file when generating proposal output. It defines the canonical section order and per-section content rules for all QA transformation proposal outputs.

---

## Canonical Section Order

The following is the mandatory section order for all QA transformation proposal outputs.

| # | Section | Type |
|---|---|---|
| 1 | Our Understanding | Always-on |
| 2 | Current Delivery Enablers | Conditional |
| 3 | Technology Landscape | Always-on |
| 4 | Executive Summary | Always-on |
| 5 | Key Findings & Impact | Always-on |
| 6 | Maturity Model | Always-on |
| 7 | QE Architecture / Pillars | Always-on |
| 8 | Transformation Roadmap | Always-on |
| 9 | Tooling Recommendations | Always-on |
| 10 | Benefit Realisation + "Towards Shift" Table | Always-on |
| 11 | Governance Model + RACI | Always-on |
| 12 | Team Structure / POD Model | Always-on |
| 13 | KPI / Metrics Dashboard | Always-on |
| 14 | Application Clustering Framework | Conditional |
| 15 | Transition Model | Conditional |
| 16 | TaaS Operating Model | Conditional |
| 17 | Risk Register | Always-on |
| 18 | Dependency Register | Always-on |
| 19 | Appendices (Finding Traceability, Open Conditions) | Always-on |

**Conditional section rule:** Sections marked `Conditional` are suppressed when their trigger condition is not met. Generate no empty headings or placeholder text for suppressed sections.

---

## Section Content Rules

### Section 1 — Our Understanding
First structural slot in all proposal outputs.
- Content: 2–4 sentences synthesising company context, industry, stated transformation goal, and the business pressure driving urgency — derived from Stage 1 engagement context fields.
- Source: Stage 1 findings (`Client Domain`, engagement context description, stated goals or pressure signals from artifacts).
- Failure mode: If Stage 1 engagement context is absent, write a one-sentence placeholder noting that full context will be confirmed in Phase 0. Do not fabricate company context.

### Section 2 — Current Delivery Enablers (Conditional)
Trigger: Generate if Stage 1 findings include positive evidence (existing tooling in use, functioning QA practices, institutional knowledge, prior achievements). Suppress if Stage 0 `engagement_type` = `qa_audit`.
- Default behaviour: ON unless the engagement type signal suppresses it.
- Content: Named tools confirmed as in use, described QA practices, capability signals worth preserving.
- Source: Stage 1 Capability-type findings with affirmative evidence.

### Section 3 — Technology Landscape
Two-column table: (1) Confirmed in Discovery (with Stage 1 evidence source reference) vs. (2) To be confirmed in Phase 0.
- **Source:** `## Technology Inventory` from `claude-memory/memory.md` (populated at Stage 1, Step 13). Do not re-extract tools from artifacts at Stage 9 — use the inventory exclusively.
- Classification mapping: `Confirmed` tools → Column 1 (include source reference from inventory). `Present` and `Legacy` tools → Column 2 (TBC or note migration). For `Legacy` tools in Column 2, add a note: "Previously in use — [migration note from inventory]."
- All tools appear in exactly one column — confirmed or TBC, not both.
- If the Technology Inventory is empty (flagged at Stage 1 as no tools identified), render Column 1 as empty with the note: "No tools confirmed in artifacts — all to be confirmed in Phase 0."

### Section 6 — Maturity Model
Produces a per-domain capability maturity matrix. Suppressed only when `engagement_type = qa_audit`.
- Mapping: `Absent` → Foundational; `Partial` → Transitioning; `Present (basic)` → Efficient; `Present (advanced)` → Optimized
- Matrix format: QE Domain | Current State | Target by Phase 2 | Target by Phase 4
- Source: Stage 3.5 capability coverage output — one row per QE capability domain assessed.

### Section 7 — QE Architecture / Pillars
Always-on. The primary architecture section rendering the Test Architect's Stage 4 output.

**Risk-Based Test Classification:** If a risk-tier table was produced at Stage 4 (activation condition: `application_count > 1` OR Discovery Maturity = `Deep`), Section 7 must include or reference it within the test strategy pillar. If the activation condition was not met at Stage 0, Section 7 proceeds without it — do not insert a placeholder.

Risk-tier table format (include when present):
```
| Change Type | Risk Tier (High/Medium/Low) | Required Test Depth | Automation Priority |
|---|---|---|---|
```

**Gradual Automation Suite Deployment:** For `transformation_partnership` and `managed_service` engagement types, Section 7 must include an Automation Deployment Sequence subsection with a 3-stage deployment table. For `qa_audit` and `standalone_project` engagement types, omit this subsection.

Deployment table format:
```
| Stage | Suite | Phase | Runtime Target | Coverage Scope | Trigger |
|---|---|---|---|---|---|
| 1 | Smoke Suite | Phase 1 | < 15 min | Critical paths only | Every commit / merge |
| 2 | Sanity Suite | Phase 2 | < 45 min | Regression-prone modules | Sprint close |
| 3 | Full Regression Suite | Phase 2–3 | Nightly target (coverage % declared) | Full in-scope module set | Nightly / pre-release |
```

- Runtime targets and coverage % are "proposed — to be baselined in Phase 0" unless client evidence specifies existing targets. Do not fabricate baselines.
- Deployment stages must reference Section 8 roadmap phase dates — Smoke Suite must align with Phase 1 dates; Full Regression Suite with Phase 2–3 dates.
- If a risk-tier table was produced at Stage 4, the Automation Priority column in that table informs which application sets are prioritised for each suite. Surface this linkage in the subsection narrative.

**Agentic AI Governance Model (conditional sub-section in §7):**
Trigger: AI accelerators or AI-assisted QE capabilities are proposed in the QE Architecture (Pillar 8 / AI-Assisted QE) — any Tier 1 or Tier 2 capability. Suppressed when no AI capabilities are proposed.

When triggered, render a mandatory "Agentic AI Governance Model" sub-section **immediately after** the AI accelerator deployment or capability table. Format as a 5-column lifecycle table:

| SDLC Phase | Agentic Workflow Activities | Human-in-the-Loop Gates | Escalation Triggers | Named Human Roles |
|---|---|---|---|---|

- **SDLC Phase:** Minimum 5 phases (e.g., Requirements, Design, Build, Test Execution, Release).
- **Agentic Workflow Activities:** What the AI performs autonomously (e.g., test case generation, defect triage, risk scoring).
- **Human-in-the-Loop Gates:** What requires explicit human validation before the AI output is accepted or acted on.
- **Escalation Triggers:** When the AI agent must be overridden — e.g., confidence below threshold, policy boundary breached, conflicting outputs from multi-agent flows.
- **Named Human Roles:** The specific named role (e.g., QE Lead, Test Architect, Release Manager) accountable for each HITL gate.

State the governing principle explicitly beneath the table:
> "AI Recommends → SMEs Validate / Refine → Leadership Approves"

This principle must appear verbatim. It applies to all Tier 1 and Tier 2 AI capabilities — HITL governance is not restricted to Tier 2 ML models.

### Section 8 — Transformation Roadmap
Phase-based delivery roadmap. Phasing driven by `engagement_type` and `application_count` from Stage 0.
- Source: Stage 6 delivery planning output + Stage 4 architecture pillars.
- Standard phases: Phase 0 (Discovery & Foundations), Phase 1 (Pilot & Enablement), Phase 2 (Expand & Automate), Phase 3 (Optimise & Scale). Phases 4+ and the "Scale & Sustain" phase are generated only when the TaaS section (Section 16) is generated.
- Each phase: named milestone list, FTE model, key deliverables.

**In-Sprint Automation Definition of Done milestone — mandatory in Phase 1:**
For `transformation_partnership`, `managed_service`, and `retained_qe_delivery` engagement types, Phase 1 must include the following named milestone:
> "DoD update — in-sprint automation criteria approved and embedded in team working agreements."
This milestone must appear **before** any automation coverage milestone in later phases. Do not omit it for these engagement types. Suppressed for `qa_audit` and `standalone_project`.

**Sprint-Lifecycle QE Integration model (recommended sub-section in §8):**
Trigger: `engagement_type = transformation_partnership` AND sprint-based Agile delivery is confirmed in Stage 1 findings or Stage 0 signals. Recommended — not mandatory. Suppressed for `qa_audit`, `standalone_project`, or when waterfall delivery is confirmed.

When triggered, render a "Sprint-Lifecycle QE Integration" sub-section within §8, after the roadmap phase table and before any appendix references. Format as a sprint progression model with 4 columns:

| Sprint N | QE Practice Introduced | Team Impact | Definition of Done Change |
|---|---|---|---|

- Minimum 4 sprints. Maximum 6 for engagements with longer ramp periods; compress to 2 sprints only if total engagement window is fewer than 3 sprints.
- **Sprint N:** Sprint number or range (e.g., Sprint 1, Sprint 2–3).
- **QE Practice Introduced:** The specific QE change introduced in that sprint (e.g., "API regression harness activated", "smoke suite added to PR gates").
- **Team Impact:** What changes for the development or QA team in their sprint activities (e.g., "QA joins sprint planning to review test coverage", "No-code defect triage via AI assistant").
- **Definition of Done Change:** What new or modified DoD criterion applies from this sprint onward.
- This model bridges the macro phase roadmap (executive audience) with micro sprint integration (delivery teams) — it answers "what changes in my sprint next month?"
- Source: Stage 4 automation deployment sequence + Stage 6 delivery planning phase milestones. Do not fabricate sprint activities without a corresponding Stage 4/6 output.

### Section 9 — Tooling Recommendations
All tooling must use the three-tier framing defined at Stage 4 (Confirmed / Suggested / Proposed — Vendor Platform). Table columns: Tool | Tier | Capability Layer | AI Tier (if applicable) | Rationale.

**Named tool completeness check:** For each tooling capability category proposed in the solution (e.g., test management, service virtualisation, test data management, security testing, CI/CD integration, dashboarding / reporting), confirm a specific named tool is referenced — not just a category label. If only a generic category is stated with no named tool, either:
- Name a candidate tool using `Suggested` tier framing (e.g., "WireMock — Suggested — subject to Phase 0 confirmation"), or
- Declare an Open Condition: `OC-[n]: [Category] tool not named — specific tooling to be confirmed during Phase 0 discovery.`
Unresolved unnamed capability category slots must not pass Stage 8 governance clearance without an OC declared. This check cross-references the Stage 1 `## Technology Inventory` to promote any `Confirmed` tools to the appropriate capability category.

### Section 10 — Benefit Realisation + "Towards Shift" Table
The Benefit Realisation table is followed immediately by the "Towards Shift" operational before/after table.

**Benefit Realisation table — Stage 4 classification required:**
The Benefit Realisation table must reference the Stage 4 Benefit Claim Classification (written to `claude-memory/notes.md` under `## Benefit Claim Classification`). Each benefit claim must be displayed with its category:
- `Conditional` claims must display their dependency and earliest-phase qualifier
- `Unconditional` claims may display without caveat
- Do not present any benefit claim without its realisability category — unarticulated claims are not permitted.

**“Towards Shift” table:**
- Format: Theme | Current State | Target State | Shift Enabled By (pillar + phase)
- **Minimum 5 operational themes required.** Themes must be sourced from Stage 1 gap findings. Do not generate a theme without a corresponding F[n] reference in the Current State column.
- If fewer than 5 themes with F[n] references can be produced (e.g., Stage 1 yielded fewer than 5 operational gap findings), declare the shortfall explicitly: "Fewer than 5 operational themes identified — remaining themes to be confirmed in Phase 0." Do not fabricate themes to meet the minimum.
- Themes to include where evidence supports: Regression, Test Management, Defect Triage, Release Readiness, Environment Management — and any additional themes evidenced by Stage 1 findings.
- Disclosure rule: Where current-state evidence is unavailable for a theme, write "Current baseline to be confirmed in Phase 0" — do not fabricate a before-state without evidence.

### Section 11 — Governance Model + RACI
Derive RACI from: (1) Stage 4 pillar ownership declarations; (2) Stage 6 governance tier output (strategic/tactical/operational); (3) Stage 1 ownership findings.
- RACI format: rows = activity areas (Test Planning, Automation Framework, Defect Triage, Release Sign-off, KPI Reporting, Environment Management, Defect Management, Onboarding / Ramp); columns = **Client | R Systems | Joint**; cells = R / A / C / I per stakeholder group.
- Specific role names do NOT appear in the RACI — role names belong in the POD model (Section 12).
- RACI assignments are engagement-specific — derive from RFP context. Do not hardcode default assignments across engagements.
- Placement: Governance section body, or Appendix C if sectioning requires it.

### Section 12 — Team Structure / POD Model
Invokes `estimation-sizing-thinking` for team POD sizing.
- Inputs: `engagement_type` and `application_count` (from Stage 0 `plan.md`), automation maturity (Stage 3.5), delivery model scope.
- Output format: Named POD with role title, FTE count, and brief responsibility per role. Differentiate by phase if scope varies materially.

### Section 13 — KPI / Metrics Dashboard
Invoke `kpi-baseline` directly with task "produce client-facing delivery KPI framework".
- Inputs: pillars (Stage 4), gap findings (Stage 3), client-stated KPI targets (Stage 1 `kpi-baseline` run in `memory.md`).
- Table format: Metric Name | Current Baseline | Target by Phase | Measurement Mechanism
- Baseline: use Stage 1 evidence where available; "To be baselined in Phase 0" where not.
- Standard metrics to include: DRE, defect leakage, cycle time, automation coverage, Release Confidence Index.

### Section 14 — Application Clustering Framework (Conditional)
Trigger: Stage 0 `application_count` > 1.
- **Source:** This section confirms the Application Clustering Draft produced at Stage 4 (written to `claude-memory/notes.md` under `## Application Clustering Draft`). Stage 9 may refine tier assignments based on Stage 5–8 findings but does not build the clustering from scratch.
- If no Stage 4 draft is present (e.g., Discovery Maturity = Constrained and insufficient application evidence), produce clustering with evidence from Stage 1 technology landscape and declare: "Tier assignments are preliminary — to be confirmed during Phase 0 discovery."
- Clustering criteria per application: risk level, automation maturity, integration complexity, business criticality — rated High / Med / Low.
- Tier model: Tier A = complex/high-risk (later waves); Tier B = mid-complexity; Tier C = stable/low-risk (first waves, quick-win candidates).
- Population: Named apps from Stage 1 findings (via technology landscape, Section 3) populate tier assignments where possible. Unknowns: "Phase 0 — to be confirmed during discovery".

### Section 15 — Transition Model (Conditional)
Trigger: Stage 0 `Engagement Signals` include any of: `incumbent_vendor_present`, `distributed_delivery_consolidation`, `vendor_transition`.
- **Source:** Stage 4 Transition Planning Stub (written to `claude-memory/notes.md` under `## Transition Planning Stub`). If a stub was produced at Stage 4, Section 15 expands it — do not reconstruct the transition model from scratch. If no stub was produced (incumbent was not confirmed at Stage 0), declare: *"Transition planning to be scoped in Phase 0 once incumbent confirmation is obtained."*
- Content: (1) Handover sequence — current-state vs. R Systems-led delivery boundary by phase; (2) Parallel-run period with named entry/exit criteria (entry/exit criteria drawn from stub's `Preliminary Parallel Run` field where available); (3) Wave sequencing using Section 14 Application Clustering tier assignments; (4) Change management and team onboarding framing.
- Suppression: Not generated for `greenfield_delivery` signal or `standalone_project` engagement type.

### Section 16 — TaaS Operating Model (Conditional)
Trigger: Stage 0 `engagement_type` ∈ {`managed_service`, `transformation_partnership`, `retained_qe_delivery`}.
- Content: (1) Four-capability framework (Governance & Ownership, Quality Intelligence & Release Readiness, Service-based Delivery, Automation & Continuous Validation); (2) R Systems vs. client ownership model; (3) Relationship scorecard linked to Section 13 KPI framework.
- 6th phase rule: "Scale & Sustain" roadmap phase is generated **only** when this section is generated. Do not add a 6th phase to `standalone_project` or `qa_audit` outputs.

### Section 17 — Risk Register
Always-on. Renders all risks surfaced across Stages 4–6.
- Source: Stage 4 architecture risks, Stage 5 adoption risks (including any HIGH SME Demand Impact finding), Stage 6 sequencing and delivery risks.
- Format: `Risk ID | Risk Description | Stage Identified | Likelihood (H/M/L) | Impact (H/M/L) | Mitigation | Owner`
- Do not fabricate risks. Every row must trace to a named Stage finding or a declared assumption.
- Risks marked HIGH likelihood + HIGH impact must carry a named mitigation and owner. Rows without mitigation for HIGH/HIGH are flagged `⚠ MITIGATION REQUIRED` at Stage 8.

### Section 18 — Dependency Register
Always-on. Renders the `## Dependency Register` progressively built at Stages 4, 5, and 6 (written to `claude-memory/notes.md`).
- **Source:** Read `## Dependency Register` from `claude-memory/notes.md`. Do not rebuild the register from scratch at Stage 9 — render what was progressively collected.
- If the dependency register is empty (no entries logged at Stages 4–6), render the section with a single row: "No unconfirmed dependencies identified — review in Phase 0."
- Format: `D-[n] | Stage Identified | Description | Owner (Client/Vendor/Joint) | Status (Open/Confirmed/Mitigated)`
- All Open entries must be cross-referenced in Section 19 Appendix Open Conditions where they represent unresolved pre-award risks.

### Section 19 — Appendices
Always-on. Two mandatory appendices.

**Appendix A — Finding Traceability Table:**
- Renders all High-confidence findings from `claude-memory/memory.md` with their resolution status from the Stage 8 gap coverage check.
- Format: `Finding ID | Confidence | Evidence Type | Resolution in Output (Section reference) | Status`
- All findings with Status = `Unresolved` must be visible — do not suppress.

**Appendix B — Open Conditions:**
- Lists all Open Conditions raised across Stages 0–8, including OCs raised at Stage 0 for regulatory context and incumbent vendor status.
- Format: `OC-[n] | Stage Raised | Condition Description | Resolution Required By | Owner`
- Open Conditions that affect the validity of a section output must carry a cross-reference to that section.
