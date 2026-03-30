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

## Submission Hygiene Rules

> Apply to every client-facing output before final delivery. These rules cannot be overridden by section-level instructions.

**Output Type Declaration (mandatory — governance.md):**
The final output document must include an `Output Type:` header before any content section. Value is typically `Client Facing` for Stage 9 proposal outputs. If producing a working draft, declare `Working Draft` explicitly. The Review & Challenge Thinking skill defaults to `Client Facing` if absent, but explicit declaration is required for governance traceability.

**Staff Name Hygiene (IP-MAN-09):** All references to internal staff in client-facing sections (Open Conditions, Risk Register, Dependency Register, Team Structure, Governance Model, Delivery Risk Ownership) must use formal role designations only. Examples: "R Systems QA Practice Lead", "R Systems Presales Lead", "R Systems Programme Delivery Lead". First names, informal handles, and "Name / Role" combinations must not appear in any section read by client procurement, evaluation panel, or steering committee.

- **Pass test:** No internal staff personal first name is visible in OC, Risk Register, Dependency Register, Team Structure, or Governance sections.
- **Failure mode:** "Sandeep / Praveen (Presales Lead)" in an OC row — must be replaced with "R Systems Presales Lead".
- **Scope:** This rule applies even where an internal staff personal name appears incidentally (e.g., "Risk Owner: John") — replace with "R Systems [Role]". Client-side names referenced in dependency descriptions or governance sections are not subject to this rule.

---

## Revision History Rule

Any Stage 9 output that is revised after initial production MUST include a `## Revision History` section at the top of the document — after the Output Type declaration and before Section 1 (Our Understanding).

**When mandatory:** The Revision History section is required whenever the Stage 9 output has been modified after its initial production (e.g., new evidence integrated, scope changed, findings revised post-delivery).

**For first-time outputs:** The Revision History section contains only the `1.0` row and is not required to be present for outputs that have never been revised.

**Format:**

| Rev | Date | Trigger | Summary | Findings Δ |
|---|---|---|---|---|
| 1.0 | YYYY-MM-DD | Initial Stage 9 output | — | +N |
| 1.1 | YYYY-MM-DD | [Phase label] — [evidence type] | [sections updated, scoring changes] | +N / −N |

**Field definitions:**
- `Rev` — Sequential revision number. `1.0` is always the initial Stage 9 output.
- `Date` — Date the revision was produced (not the date evidence arrived).
- `Trigger` — The phase label and event that caused the revision (e.g., "Phase 20 — Vendor questionnaire integration").
- `Summary` — Brief description of what changed: sections updated, scoring changes, scope delta applied.
- `Findings Δ` — Net change in finding count: `+N` for new findings added, `−N` for findings removed, both if applicable.

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

**AI Execution Integration (conditional sub-section in §7, Tier 1 only — IP-MAN-01):**
Trigger: At least one Tier 1 AI capability is proposed. Suppressed when only Tier 2 capabilities or no AI capabilities are present.

When triggered, render a `### [AI Platform] — Execution Integration` subsection **immediately after** the Agentic AI Governance Model table and governing principle. This subsection must:
- Name the **delivery-stage responsibilities** of each active Tier 1 capability with its phase-activation point (e.g., "Active from Phase 1 — test case generation on spec receipt"; "Active from Phase 2 — regression suite acceleration"; "Active from Phase 2 — failure triage and defect classification"; "Active from Phase 3 — suite stability and flakiness detection").
- Frame each capability as an **execution mechanism** — not as a tooling option or optional enhancement. Each capability is operational from its activation phase and contributes to named delivery outcomes.
- Do **not** frame Tier 1 AI capabilities as "available tools", "optional accelerators", or "subject to Phase 0 assessment". AI capabilities classified as Tier 1 are available without specialist ML infrastructure and are committed delivery mechanisms. Tooling-framed AI scores in the technology catalogue; execution-mechanism framing scores in delivery confidence and commercial defensibility.

**External Integration Testing Model (conditional sub-section in §7 — IP-MAN-02):**
Trigger: `scope-completeness-validator` Category 1 (Integration Testing) resolves as `Present` — i.e., integration testing is confirmed in scope. Suppressed when integration testing is not in scope.

When triggered, render a named `### External Integration Testing Model` subsection within Section 7. This subsection must not be omitted in favour of integration testing coverage appearing inside per-workstream bullets. Named sections are evaluator-visible; workstream bullets are not. The subsection must cover:
- Integration boundary inventory: list named external systems and APIs under test scope.
- Contract and API testing approach (REST/SOAP/messaging as applicable).
- Service virtualisation strategy where downstream/upstream systems are unavailable in test environments.
- Cross-system end-to-end validation: named integration flows, entry/exit points, and data validation approach.

**RBAC Validation as a Security Control (conditional sub-section in §7 — IP-MAN-03):**
Trigger: `scope-completeness-validator` Category 2 (RBAC / Access Control) resolves as `Present` — i.e., RBAC validation is confirmed in scope. Suppressed when RBAC validation is not in scope.

When triggered, render a named `### RBAC Validation as a Security Control` subsection within the Security Testing pillar in Section 7. This subsection must not be omitted in favour of RBAC coverage appearing inside per-workstream functional testing bullets. RBAC must be framed as a **security and compliance control layer**, not solely as a functional testing activity. The subsection must cover:
- Role entitlement verification: confirm authorised roles have correct access.
- Access denial validation: confirm unauthorised roles are denied access as per access matrix.
- Privilege escalation testing: verify no horizontal or vertical privilege escalation paths exist.
- Audit log verification: confirm access events are logged as required by compliance framework (e.g., MAS-TRM, SOC2).

### Section 8 — Transformation Roadmap
Phase-based delivery roadmap. Phasing driven by `engagement_type` and `application_count` from Stage 0.
- Source: Stage 6 delivery planning output + Stage 4 architecture pillars.
- Standard phases: Phase 0 (Discovery & Foundations), Phase 1 (Pilot & Enablement), Phase 2 (Expand & Automate), Phase 3 (Optimise & Scale). Phases 4+ and the "Scale & Sustain" phase are generated only when the TaaS section (Section 16) is generated.
- Each phase: named milestone list, FTE model, key deliverables.

**Phase 0 Kick-off Date Rule (IP-MAN-11):**
Phase 0 kick-off dates must never be expressed as absolute calendar dates in RFP or competitive tender submissions where award timing is unknown.

- **Correct form:** "[Award + N business days] (indicative)" — where N is the mobilisation lead time (typically 5 business days).
- **If absolute framing is required** (e.g., for a milestone table with fixed calendar columns), add the label: `[ASSUMPTION-BASED — relative to award receipt; confirmed no later than Day 3 of Phase 0]`
- All downstream milestone dates derived from Phase 0 kick-off inherit this relativity. If Phase 0 kick-off is relative, every milestone column below it is also relative — do not mix absolute and relative dates in the same table without declaring the anchor.

**Rationale:** Award timing is a client-controlled variable. An absolute kick-off date stated in a competitive submission assumes procurement cycle completion in a window the vendor cannot control — an assumption that, if wrong, collapses the entire downstream calendar chain.

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

**Environment Capacity Planning Note (conditional — IP-MAN-06):**
Trigger: Engagement has 3+ concurrent workstreams running simultaneously (e.g., Tranche-based delivery with 3+ Tier A workstreams active at the same time). Suppressed for sequential delivery or engagements with fewer than 3 concurrent workstreams.

When triggered, include an environment capacity planning note within or immediately after the Parallel Execution Assurance content in Section 8. The note must:
1. Name the assumption: concurrent test cycle execution across [N] simultaneous workstreams assumes sufficient test environment capacity.
2. Confirm validation: environment capacity is validated during Phase 0 discovery and documented in the environment readiness baseline.
3. Name the resolution mechanism: where environment contention arises, workstream test cycle sequencing is coordinated through the joint governance framework to protect tranche delivery milestones without compromising quality gates.

Do not present this as a separate major heading. A paragraph within or immediately after Parallel Execution Assurance is the correct structural placement.

**Phase 0 Exit Criteria — Pass/Fail Threshold Requirement (IP-MAN-12):**
Every Phase 0 exit criterion must specify three elements — not just one:
1. **What is measured** — the specific metric, artefact, or status dimension (per IP-MAN-07)
2. **Who confirms it** — the named role or joint sign-off required
3. **The pass condition** — the specific threshold or state that constitutes a PASS, and the consequence if not met

A condition that states only what will be documented (e.g., "automation coverage % documented") is a reporting criterion, not a gate criterion. A gate criterion states the threshold — e.g., "Phase 0 cannot exit if any Tier A workstream records 'not ready' on regression suite readiness without a client-approved recovery plan."

**Minimum required Phase 0 exit conditions** (adapt per engagement):
- Test strategies approved by named stakeholders (pass: signed-off artefact confirmed in shared repository)
- Integration dependencies confirmed (pass: all Open items in Dependency Register with "Phase 0" resolution date are Confirmed or have a documented exception)
- Environment readiness validated (pass: all Tier A workstream environments confirmed accessible and stable per environment readiness baseline)
- Automation coverage baseline established — documenting coverage % per workstream, critical path completeness (pass/fail), and regression suite readiness (ready / conditional / not ready). **Pass threshold:** No Tier A workstream may record "not ready" without a client-approved recovery plan; no critical path completeness may be "fail" without an agreed remediation path.
- Test data availability confirmed (pass: named data sets available in SIT environment for all Tier A workstreams)
- Refined estimates approved (pass: effort range acknowledged by client delivery lead in writing)

Do not use Phase 0 exit criteria as reporting checkpoints. Each criterion is a gate — Phase 1 does not begin if any criterion does not pass.

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

**Delivery Risk Ownership subsection (conditional — IP-MAN-05):**
Trigger: `engagement_type` ∈ {`transformation_partnership`, `managed_service`} AND `application_count` >= 3 (i.e., 3+ concurrent workstreams).

When triggered, produce a `### Delivery Risk Ownership` subsection immediately after the RACI table. This subsection must:
- Name the **QA Lead** explicitly as the single accountable owner for delivery risk visibility.
- List the 4 monitoring responsibilities: (1) continuous monitoring of workstream readiness signals against tranche milestones; (2) early identification of schedule deviations or dependency risks before they breach milestone boundaries; (3) escalation of cross-workstream delivery risks through the joint escalation framework; (4) reporting of release readiness status to the joint steering committee.
- State that this model ensures delivery risk is actively monitored and escalated — not reactively discovered at milestone reviews.
- Do **not** duplicate TaaS Governance & Ownership row text (Section 16). The TaaS row covers operational framework; the Delivery Risk Ownership subsection answers the procurement single-owner accountability expectation. Both are required.
- **Co-location disclosure (IP-MAN-10):** If OC-002 (or equivalent open condition for the named QA Lead) is active at output time, include a parenthetical immediately following the QA Lead ownership statement: *(QA Lead to be confirmed within [N] business days of award — see OC-[n]; interim pre-kick-off accountability: R Systems Programme Delivery Lead.)* This caveat must appear in the Delivery Risk Ownership subsection itself — not only in the Risk Register or Open Conditions appendix. Distance between an accountability claim and its caveat is functionally equivalent to silence.
- **Governance Forum participant (IP-MAN-14):** If the Delivery Risk Ownership subsection references a Programme Governance Forum or equivalent joint review cadence, the client-side participant must be named by role — e.g., "specifically, the R Systems QA Lead and the [Client] Test Manager or nominated Delivery Lead." Generic descriptions ("leads from both organisations") do not satisfy joint governance accountability. Before rendering Section 18, verify a governance forum participation dependency entry has been logged to `claude-memory/notes.md` during Stages 4–6; if absent, flag `⚠ MISSING DEPENDENCY — client governance forum participation not tracked in Dependency Register` at the Section 18 rendering step.

Suppression: Suppress for `standalone_project` and `qa_audit` engagement types, or where `application_count` < 3.

### Section 12 — Team Structure / POD Model
Invokes `estimation-sizing-thinking` for team POD sizing.
- Inputs: `engagement_type` and `application_count` (from Stage 0 `plan.md`), automation maturity (Stage 3.5), delivery model scope.
- Output format: Named POD with role title, FTE count, and brief responsibility per role. Differentiate by phase if scope varies materially.

**Cross-Section Headcount Coherence (IP-MAN-13):**
Before finalising the Team Structure headcount summary, scan all Risk Register entries (Section 17) for dedications, pools, or workstream-specific resource commitments. If any risk mitigation names a dedicated sub-team separate from the primary pool (e.g., "dedicated SDET pool for WS-7 from Phase 1, separate from primary resourcing"), that sub-pool must appear as a named allocation in Section 12.

Produce the full team headcount as an explicit sum:
- Primary pool: [role composition by phase]
- Named sub-pools: [workstream] dedicated pool (Phase [n] through [milestone]): [N]–[M] [roles]
- **Total:** [sum of primary + all sub-pools]

If Tranche 1 and Tranche 2 have materially different allocations, show the rollup and the per-tranche split.

**Failure mode to avoid:** A Section 12 that shows only the primary pool while the Risk Register declares a dedicated workstream-specific pool understates the real team commitment — creating an internal contradiction evaluators will identify and probe.

### Section 13 — KPI / Metrics Dashboard
Invoke `kpi-baseline` directly with task "produce client-facing delivery KPI framework".
- Inputs: pillars (Stage 4), gap findings (Stage 3), client-stated KPI targets (Stage 1 `kpi-baseline` run in `claude-memory/memory.md`).
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

**Component-to-Application Reconciliation (IP-MAN-15):**
If the per-workstream component sum in the clustering table differs by more than 2× from the application count stated in Section 4 (Executive Summary or scope declaration), include a reconciliation sentence immediately after the section scope header and before the tier table:

> *"The [N] components above represent the full microservice and application decomposition of the [M] named in-scope applications. Effort estimates were sized at workstream level against this component surface; the [M]-application figure reflects the application-ownership layer, not the component count."*

This sentence is mandatory when component count ≠ application count by more than 2×. It prevents evaluators from treating the component total as the estimation basis and challenging whether estimates were based on [M] things or [N] things.

**Per-App Inference Flagging Rule:**
When a per-app score or tier assignment in the clustering table (or any per-app scoring section of the proposal) is derived from portfolio-level evidence rather than per-app assessment data, the value MUST be annotated with `[INFERENCE-BASED]`. This annotation indicates the score is directional but not confirmed for that specific application.

- **When to label:** Annotate any cell where the score was derived by applying a portfolio-level finding, portfolio-level average, or cross-portfolio inference to a specific application for which no per-app primary evidence exists.
- **When to remove:** When per-app data becomes available (e.g., from a subsequent evidence phase), replace the annotated value with the confirmed score and remove the `[INFERENCE-BASED]` tag.
- **Example:**

  | App | Automation Coverage | Test Maturity |
  |---|---|---|
  | APP-001 | 45% | Level 2 |
  | APP-007 | 30% `[INFERENCE-BASED]` | Level 1 `[INFERENCE-BASED]` |

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
Always-on. Mandatory appendices (Appendix C included when unverified findings exist; Appendix D included when regulatory control mapping is triggered).

**Appendix A — Finding Traceability Table:**
- Renders all High-confidence findings from `claude-memory/memory.md` with their resolution status from the Stage 8 gap coverage check.
- Format: `Finding ID | Confidence | Evidence Type | Resolution in Output (Section reference) | Status`
- All findings with Status = `Unresolved` must be visible — do not suppress.

**Appendix B — Open Conditions:**
- Lists all Open Conditions raised across Stages 0–8, including OCs raised at Stage 0 for regulatory context and incumbent vendor status.
- Format: `OC-[n] | Stage Raised | Condition Description | Resolution Required By | Owner`
- Open Conditions that affect the validity of a section output must carry a cross-reference to that section.

**Appendix C — Unresolved or Unverified Findings (conditional):**
- Renders all Medium-confidence findings from `claude-memory/memory.md` that were not fully resolved during Stages 4–8.
- Purpose: Governance requires medium-confidence findings to remain visible in client-facing outputs — they must not be silently dropped.
- Format: `Finding ID | Confidence | Description | Why Unverified | Recommended Phase 0 Action`
- Suppression: If zero medium-confidence findings remain unresolved after Stage 8, omit this appendix and note in Appendix A: "No unverified findings — all medium-confidence findings resolved during analysis."

**Appendix D — Regulatory Control Mapping (conditional):**
- Trigger: Produced only when Stage 8 Regulatory Control Mapping sub-check fires (any finding with Evidence Type = `Compliance Requirement` AND Regulatory Context = `Explicit`).
- Source: Control Mapping Table produced at Stage 8 governance validation.
- Format: `Regulation / Framework | Control Objective | Proposal Mechanism | Evidence Source | Gap / Confirmed`
- Suppression: Omit entirely when Regulatory Context ≠ `Explicit` or no Compliance Requirement findings exist.
