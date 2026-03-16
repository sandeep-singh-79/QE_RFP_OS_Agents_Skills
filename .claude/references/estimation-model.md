# QE OS — Estimation Model Reference

> **Loaded by:** `pert-estimation` skill when estimation is in scope.
> **Do not pre-load.** This file is an on-demand reference only — not a base-context file.
> **Last updated:** March 2026 (Phase 8)

---

## Estimation Mode Framework

> **Task 1.2** — declares the three operating modes that govern conditionality throughout the estimation model.

Mode must be declared **before any sizing begins**. All subsequent sections are mode-conditional — check each section's mode applicability header before applying.

| Mode | When It Applies | Scope Visibility | Multiplier Applicability |
|---|---|---|---|
| **Upfront / WBS-based** | Full scope defined before engagement starts; client provides WBS, feature list, or test repository | High — scenario baseline fixed upfront | All multipliers applicable where conditions are met |
| **Inference-based** | RFP response; no WBS or test artifacts available; scope inferred from module descriptions and domain experience | Medium — count is estimated, confidence declared (±30%) | Most multipliers applicable conditionally; normalization/parameterization require qualifying evidence |
| **Capacity-based** | Agile/sprint-embedded QA; scope emerges from backlog incrementally; no upfront scenario count possible | Low — no fixed baseline at proposal time | Multipliers largely inapplicable; estimation basis is team size × sprint velocity × automation velocity |

**Mode selection rule:** If artifacts are available → Upfront/WBS-based. If scope must be inferred from RFP/feature descriptions → Inference-based. If engagement is agile/sprint-embedded with no pre-defined scenario list → Capacity-based.

---

## Estimation Unit Derivation Paths

> **Task 2.2** — mode-conditional paths for arriving at the estimation unit count.

The estimation unit is the **automation scenario** — a single, independently automatable business validation.

| Path | Mode | How Count Is Derived | Confidence Level | Review Implications |
|---|---|---|---|---|
| **Artifact-derived** | Upfront/WBS-based | WBS Level-3 decomposition of client test repository — multi-step manual test cases decomposed into atomic scenarios; one validation step = one scenario. Net count may exceed raw file count after decomposition (expected). | High | Count is verifiable; limited contingency required |
| **Inference-based** | Inference-based | Module list × estimated scenario density per module type; or functional feature count × complexity weighting; derived from domain experience. | Medium — ±30% | Explicit confidence declaration required; higher risk contingency applies |
| **Capacity-based** | Capacity-based | No upfront scenario count. Estimation basis: team size × sprint duration × automation velocity (scenarios per sprint per engineer). Scope deferred to engagement kickoff. | Low — no fixed baseline | Scope baseline established at kickoff; estimate anchored to capacity, not scenario count |

**Halting condition:** If the declared unit type does not match the effort rate being applied (e.g., applying scenario rates to raw test case counts without decomposition), estimation must halt until the unit-rate pairing is corrected.

---

## Scope Establishment Pre-Phase

> **Tasks 3.1–3.4** — mode-conditional activities and effort for deriving the scenario count before PERT sizing begins.

This pre-phase produces the scenario count that feeds estimation. Declare which path applies before sizing begins.

### Artifact-Access Path (Upfront/WBS-based)

Six activities required before sizing baseline is locked:

1. **Artifact review** — read all test files; categorise by tier and module
2. **WBS mapping** — map files to WBS Level-3 work packages
3. **Manual-test decomposition** — decompose multi-step manual test cases into atomic automation scenarios
4. **Complexity classification** — assign Simple/Medium/Complex/HC to each scenario
5. **Priority assignment** — assign P0/P1/P2 per scenario or sub-module
6. **Cross-artifact reconciliation** — identify overlaps; run deduplication guard (see Scope Reconciliation)

**Scope establishment effort:** 2–5% of projected base total. Declare as an explicit effort line item. This effort does not appear in the PERT tier table — it is a pre-phase cost.

### Inference-Based Path (Default — applies to most RFP engagements)

No test artifacts available. Derivation basis must be declared:

- State the derivation basis: module list, functional feature descriptions, RFP section headings, epic/story counts, or domain density assumptions
- Declare confidence explicitly: **"Estimated ± 30% — no artifact verification"**
- Apply higher risk contingency (upper end of 3–7% range) to compensate for scope uncertainty
- Flag for client review: scenario count is an estimate, not a verified baseline

Scope establishment effort: minimal (analyst reasoning time only) — do not price as a separate line item.

### Capacity-Based Path (Agile/Sprint-Embedded)

No upfront scenario baseline. Estimation basis:

- **Test effort ratio:** dev effort × **0.35–0.45** (derived from senior delivery leadership experience across agile engagements with parallel development)
- For **hybrid engagements** (fixed scope → sprint-embedded transition): apply the 0.35–0.45 ratio to the agile portion only; price the fixed-scope portion using the appropriate artifact or inference path
- Scope establishment deferred to engagement kickoff; backlog grooming and sprint planning establish working scope incrementally
- Estimation output is a capacity-based envelope, not a scenario-count-driven PERT estimate

Declare which ratio value is used (0.35–0.45) and the justification (e.g., "medium-complexity agile domain, moderate automation target").

---

## Multiplier Chain

> **Tasks 4.2–4.6** — mode applicability: **Upfront and Inference modes only.** Capacity-based mode: N/A.

### Reusability Factor (Four-Case Model)

**Pre-estimation gating query — ask before applying any reuse factor:**
> *"Is the client environment open to onboarding a pre-built automation accelerator, or do regulatory/security/procurement constraints require building within the client's approved toolchain?"*

If unknown, default to Case D (greenfield) and flag `[CLIENT CONFIRMATION REQUIRED]`.

| Case | Scenario | Reduction Factor | Notes |
|---|---|---|---|
| **A — Existing client framework** | Client already has an active automation framework (e.g., Cypress suite on a related project); shared components, page objects, and utilities available | ×0.55–0.85 (15–45% savings) | Factor depends on depth of shared component coverage. Declare which components are reusable and estimated reuse %. |
| **B — Accelerator permitted** | Pre-built automation framework (e.g., Playwright, Cypress, Selenium with reporting + observability pre-configured) onboarded as accelerator | Framework Establishment reduced to 60–75% of greenfield; scenario scripting rate unchanged | Requires client confirmation that regulatory/procurement constraints do not block external codebases. **Pre-condition:** client explicitly confirms accelerator is permitted. |
| **C — Accelerator blocked** | Regulatory (Banking/SOC2, Government/FedRAMP, Healthcare/HIPAA) or procurement constraints prevent accelerator use; full greenfield framework required | No reduction to Framework Establishment; full build | Mark as `[CLIENT CONFIRMATION REQUIRED — accelerator eligibility]` if not yet confirmed. Regulatory domains: Banking, Government, Healthcare by default. |
| **D — Greenfield, no accelerator** | No prior framework; full build from scratch | ×1.0 (no reduction) | Default when no information is available. Always declare even when factor = 1.0 (state reason). |

**Cross-browser scripting guardrail:** Scripting effort is counted once per test case regardless of target browser/device count. Do not multiply Script Development hours by browser count unless cross-browser scripting divergence is explicitly evidenced.

**Application base:** Reusability factor applies as a post-summation multiplier on the gross base effort total — not as a per-scenario rate reduction.

### Scenario Normalization Factor

**Mode:** Upfront only. Conditional — apply only when parameterizable scenario groups are evidenced.

Reference range: **×0.85–0.95 (conservative)**

- **Form-heavy domains** (insurance onboarding, banking account setup): trend ×0.85
- **Integration-heavy domains** (supply chain, ERP, reconciliation): trend ×0.95
- Values below ×0.80: explicit derivation required — declare qualifying proportion × per-group reduction rate
- Factor = 1.0 when not applicable (declare reason). Do not apply when no parameterizable patterns exist.

**Application base:** Reuse-adjusted total (output of Reusability Factor step).

Normalization reduces *effort* per parameterizable scenario group — it does **not** reduce scenario count. All scenarios remain in the delivery baseline.

### Parameterized Consolidation Factor

**Mode:** Upfront only. Conditional — apply only when data-driven execution patterns are confirmed.

Reference value: **×0.95**

Reflects execution efficiency gain from parameterized test design. Apply to normalization-adjusted total.

**Application base:** Normalization-adjusted total (output of Normalization step).

### Multi-Factor Reduction Declaration

**Required when two or more reduction factors are applied.** Each multiplier must declare:

1. **Application base** — which total it multiplies from (not the raw base, unless it's the first factor)
2. **Application order** — position in the chain
3. **Coverage** — what the factor covers and explicitly what it does not cover

**Required stacking summary table** (include in Assumptions Block):

| Step | Factor | Application Base | Result |
|---|---|---|---|
| Gross base | — | Sum of all tier × complexity effort | [total] hrs |
| Reusability | ×[value] | Gross base | [result] hrs |
| Normalization | ×[value] | Reuse-adjusted total | [result] hrs |
| Parameterization | ×[value] | Norm-adjusted total | [result] hrs |
| **Adjusted Total** | — | — | **[total] hrs** |

**Prohibition:** Do not compute a combined multiplier and apply in a single step. The chain must be shown step by step. A combined multiplier cannot be reviewed, challenged, or audited.

### Factor Declaration Completeness Rule

Each percentage label on a multiplier row must correspond to the actual sequential factor applied. If a label reads "Normalization 25%" but the factor applied is ×0.45, the row must either:

- (a) Explain the derivation (e.g., "25% of scenarios eligible × 40% sub-reduction on qualifying group = ×0.85 on total"), OR
- (b) Relabel as the actual factor applied (e.g., "Normalization ×0.45")

Opaque labels that do not match their numeric effect are a transparency and audit risk. Any manual recreation of the estimate from the label alone will produce a structurally different number.

---

## Rate Calibration Override

> **Task 4.8** — engagement-specific rate source declaration.

**Default source:** Tier × complexity range table in `pert-estimation/SKILL.md`. Use when no engagement-specific guidance is provided.

**Override:** Engagement-specific rates provided by project head, vertical head, or delivery leadership. Override replaces the default table for the engagement. Common forms:
- Flat per-complexity rates (e.g., Simple = 2.5h, Medium = 4.5h, Complex = 9h, HC = 14h)
- Custom tier × complexity values calibrated to a reference engagement

**Declaration required:** State the rate source in the Assumptions Block:
- Default: `"Effort rates: Default ranges from pert-estimation/SKILL.md"`
- Override: `"Effort rates: Calibrated rates (source: [name/role], [reference engagement if applicable])"`

**Rates below the default lower bound:** Flag with rationale. Do not reject — engagement context (e.g., highly parameterized domain, experienced team, simplified scope) may justify lower rates. Document the justification.

---

## Criticality Priority Classification

> **Tasks 5.1–5.3** — always declared; confidence qualified by evidence depth. Mode: Upfront and Inference.

### Priority Levels

| Priority | Definition | Typical Examples |
|---|---|---|
| **P0 — Mission Critical** | Financially gated, compliance-relevant, or system-failure-risk scenarios. Failure to automate or defect escape carries business-critical consequence. | Payment processing, audit trails, regulatory reporting, authentication enforcement |
| **P1 — Operationally Important** | Core functional flows; important but not immediately business-critical if missed in a given sprint | Standard user workflows, core CRUD operations, primary reporting paths |
| **P2 — Lower Priority** | Edge cases, language/locale variants, low-frequency paths, cosmetic validations | Multi-language variants, low-traffic edge cases, UI polish checks |

Produce a priority distribution by sub-module or tier before phasing recommendations are made.

### Dual Phasing Strategy

Declare one strategy per engagement. The choice must be stated as an assumption with rationale.

| Strategy | Default Applicability | Phase Ordering | Rationale |
|---|---|---|---|
| **Confidence-first** | **Default** — transformation/greenfield/multi-phase engagements | P2 items in early phases → P0 items in later phases | Builds team capability and proves automation patterns on lower-risk items first; team is confident and framework is mature when tackling the highest-risk and most complex items |
| **Risk-first** | Fixed-scope, deadline-driven, high-governance engagements | P0 items first → P2 items last | Retires highest-risk unknowns early; acceptable when team is already experienced and framework risk is low |

**Declaration format (Assumptions Block):**
> `"Phasing strategy: Confidence-first (default) — P2 items in early phases to build framework maturity; P0 items in Phases 2+ once automation patterns are proven."`

### Confidence Declaration

| Evidence Basis | Declaration |
|---|---|
| Classification derived from artifacts (WBS, test repository, functional spec) | `Evidenced — artifact-derived` |
| Classification inferred from business risk analysis without artifacts | `Inferred — subject to client confirmation` |

Never assign P0 without rationale. If in doubt, declare as P1 and flag for client confirmation.

---

## Scope Reconciliation

> **Tasks 6.1–6.3** — mode-conditional deduplication/overlap guard. Mode: **Upfront and Inference only.** Capacity-based: N/A.

Run scope reconciliation after scope establishment and before the scenario baseline is locked for PERT sizing.

### Inference-Based Path (Default)

When scenario counts are estimated per module independently, cross-module overlap risk exists — the same functional area may be sized from both sides of a boundary (e.g., an integration boundary counted in both Module A and Module B).

Overlap check steps:
1. List all module-boundary areas where cross-cutting scope was estimated
2. For each boundary: confirm whether the scenario count was claimed once (from one side) or twice (from both sides)
3. Flag any double-claimed boundaries with the estimated overlap volume
4. Adjust scenario baseline before locking. Declare: "Cross-module overlap check performed — [n] boundary areas reviewed, [n] adjustments made."

### Artifact-Access Path (Upfront/WBS-based)

Model bidirectionally — scope establishment both removes overlaps and expands count via decomposition:

| Metric | Definition |
|---|---|
| **Raw artifact count** | Total scenarios/test cases from raw files before any processing |
| **Removed** | Overlapping/duplicate test cases identified and removed |
| **Added** | New atomic scenarios created by decomposing multi-step manual test cases |
| **Net count** | Raw − Removed + Added |

> **Note:** Net scenario count may exceed raw artifact count after decomposition. This is expected when complex manual test cases are decomposed into atomic automation scenarios.

Output all four metrics. The net count is the locked baseline. Declare: "Scope reconciliation complete — bidirectional model applied."

The Scope Baseline Declaration (Assumptions Block) must reference the **post-reconciliation net count** with its derivation path labelled.

---

## Phase-Allocated Delivery Overheads

> **Tasks 7.1–7.6** — overhead categories distributed into engagement delivery phases, not stacked as a flat additive percentage.

Overheads are **phase-allocated** — each category belongs to the engagement phase(s) where it naturally occurs. The Phase Effort Breakdown (in `pert-estimation` output) is the phase-allocation model. Do not add overheads on top of the adjusted base as a separate additive layer.

### Phase 0 / Phase 1 Overheads (Front-Loaded)

These are enablement costs allocated to early engagement phases:

| Overhead | Phase | Reference % of Adjusted Base | Notes |
|---|---|---|---|
| **Discovery / KT** | Phase 0 | 5–10% | Artifact review, environment assessment, domain onboarding, knowledge transfer from incumbent/client team |
| **Framework Establishment** | Phase 0–1 | 15–25% | Test framework setup, CI/CD integration, reporting configuration, test data strategy. See Enablement MIN-Cap Formulas for sizing. Never fold into Script Development. |
| **PoC (Proof of Concept)** | Phase 0–1 | Included in Framework Establishment | PoC effort is part of Framework Establishment; declare separately if client requires explicit PoC milestone |

### Distributed Overheads (Spread Across Phases)

Allocated incrementally as the framework and automation suite matures:

| Overhead | Phase Allocation | Reference % | Trigger |
|---|---|---|---|
| **Governance & Reporting** | Phases 1 onwards, incremental | 1–3% of adjusted base per active delivery phase | Applies when formal governance is present (steering committee, status reporting, metrics dashboards). Conditional for informal engagements. |
| **Observability** | Phases 1 onwards, incremental | Included in Framework Establishment and Script Development | Observability setup (dashboards, alerting, test execution reporting) matures alongside automation suite; cost is embedded, not a separate overhead line |

### Late-Phase Overheads

Allocated to later phases as automation matures:

| Overhead | Phase | Reference % | Notes |
|---|---|---|---|
| **Stabilization** | Phase 2+ (post-first execution cycle) | 5–6% of adjusted base | Post-deployment defect findings, retesting, framework stability work. Universal — present in all engagements. |
| **Risk Contingency** | Spread, crystallises late | 3–7% of adjusted base | Buffer for scope uncertainty, integration surprises, access delays. Universal. Use upper bound for Inference-based mode or high-complexity engagements. |

### Conditional Overheads

| Overhead | Trigger | Reference % | Notes |
|---|---|---|---|
| **Build Phase Maintenance** | Agile/ongoing delivery model — active development sprints overlapping automation delivery | 4–6% of adjusted base | Ongoing test maintenance during active sprints while build is in motion. Not applicable to fixed-scope waterfall engagements. |
| **Test Data Creation** | Domain complexity — reconciliation, financial processing, multi-entity data (e.g., EFT, GL, multi-tenant) | Declare as a separate effort line; no universal % | Effort is domain- and complexity-dependent. Declare trigger condition and sizing basis as an assumption. |

### Overhead Declaration Rule

All overhead percentages are declared as **assumptions, not hardcoded values**. Reference ranges above are guidance for sizing. Engagements with fixed scope, clean environments, or low governance requirements may reduce or waive specific conditional categories. Each declared overhead must state:
- Category name
- Phase allocation (which phase it falls in)
- Percentage applied and reference range
- Whether it is universal or conditional (and the trigger condition if conditional)

---

## Enablement MIN-Cap Formulas (Within-Phase Sizing)

> **Tasks 8.1–8.2** — sizes enablement activities *within* their allocated engagement phases. Not an overhead stacked above the adjusted base.

MIN-cap formulas constrain within-phase effort growth on large engagements where infrastructure does not scale linearly with scenario count.

| Activity | Formula | Reference Values | Phase |
|---|---|---|---|
| **Framework Alignment** | `MIN(cap, adjusted_base × 3%)` | Cap: 200h | Phase 0–1 |
| **Data Utilities** | `MIN(cap, adjusted_base × 1.5%)` | Cap: 350h | Phase 0–1 |
| **KT / Handover** | `MIN(cap, adjusted_base × 1%)` | Cap: 250h | Phase 0 |
| **CI/CD Integration** | Fixed hours (declare per engagement) | Not percentage-based | Phase 0–1 |

**Activation threshold:** The Framework Alignment cap binds when the adjusted base exceeds approximately **6,700h** (200h ÷ 3% = 6,667h). Data Utilities cap binds above ~23,333h; KT/Handover cap binds above ~25,000h — both are unlikely to activate at typical engagement sizes. In practice, only the Framework Alignment cap requires active monitoring. Declare which caps are active in the Assumptions Block.

**Cap value declaration:** Reference cap values above are assumptions. Different environments or team sizes may warrant adjustment. Declare the cap value used and its basis.

**Cap activation — itemisation required:** When any cap activates (i.e., the formula result equals the cap, not the percentage), the Assumptions Block **must** itemise the sub-activities that make up the capped effort. A bare number is not defensible under client or governance scrutiny.

Required format when cap activates:
```
[Activity] cap active — capped at [N]h (flat % would be [M]h).
Sub-activities:
  - [Sub-activity 1]: [hours]h
  - [Sub-activity 2]: [hours]h
  - [Sub-activity 3]: [hours]h
  Total: [N]h
```

Reference sub-activity breakdown for **Framework Alignment** (200h cap):
- CI/CD pipeline integration and test trigger configuration: ~60h
- Test harness configuration (framework setup, base classes, shared utilities): ~80h
- Reporting dashboard setup and test execution alerting: ~40h
- Framework stability testing and smoke validation: ~20h

These are reference values — adjust to engagement context and declare actuals. The obligation is itemisation, not conformity to these specific allocations.

**Relationship to Phase-Allocated Overheads:** These formulas size effort *within* Phase 0/1 — they are the detail behind the 15–25% Framework Establishment overhead range. Do not add them on top of the Phase Effort Breakdown column — they are the sizing method for that phase's effort.

---

## Automation Layer Declaration

> **Task 9.1** — conditional on scope: activates when integration/backend/API validation is in scope alongside UI automation.

If non-UI validation is in scope:

1. Declare whether per-scenario effort rates include non-UI effort or are UI-only
2. For test groups with known non-UI components (API assertions, DB validation, integration checks, document output verification, EFT/GL processing):
   - Declare a separate effort line for non-UI work, OR
   - Declare an additive percentage for non-UI effort on the applicable tier

**Guardrail:** Do not assume UI-only effort when the test scope includes external integrations, document generation, or data pipeline validation.

If scope is UI-only: declaration is silent. No additional action required.

---

## Assumptions Block Enhancements

> **Tasks 10.1–10.4** — required output format additions.

### Client Confirmation Required (CCR) Flag

Mark any assumption that is client-controlled with `[CLIENT CONFIRMATION REQUIRED]`:

- Accelerator eligibility (regulatory/procurement check)
- Environment readiness and access
- Test data availability
- SME availability and response time
- Scope stability (no known pending RFP amendments)

**Validity statement** (required in the Assumptions Block):
> *"This estimate remains valid subject to fulfillment of assumptions [list CCR assumption IDs]. Deviations exceeding 15% from declared assumptions trigger formal change control."*

Flagged CCR assumption IDs must also be surfaced in the executive summary.

### Scope Baseline Declaration

Required output element alongside the Assumptions Block (mode-conditional):

| Mode | Baseline Anchor | Change Control Trigger |
|---|---|---|
| **Upfront / WBS-based** | Net deduplicated scenario count (post-reconciliation) | ≥15% increase in scenario count without corresponding estimate recalibration |
| **Inference-based** | Estimated scenario count with stated confidence level (±30%) | ≥15% variance from declared count at project kickoff |
| **Capacity-based** | Team size × sprint duration (no fixed scenario baseline) | ≥15% change in team size or sprint duration without recalibration |

**Declaration format:**
> *"Scope baseline: [N] scenarios ([path: artifact-derived / inferred / capacity-based]). Formal change control applies to scope changes ≥15% of this baseline."*

### Minimum Viable Risk Register

Standard section in estimation output (not optional). Tiered depth:

| Engagement Type | Minimum Depth |
|---|---|
| Estimates ≤500h / informal sizing | Lightweight: 3–5 risks |
| RFP submissions / governance submissions | Full register: cover all CCR assumptions + top engagement risks |

**Minimum structure per risk entry:**

| Risk ID | Description | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R-[n] | [Risk] | Low/Medium/High | Low/Medium/High | [Mitigation action] |

**Linkage rule:** Each assumption marked `[CLIENT CONFIRMATION REQUIRED]` must have at least one corresponding risk entry covering the "assumption proves false" scenario.

### Cross-Skill Note

> *"For engagements requiring a full risk register beyond the minimum viable scope, invoke `assumption-dependency-management` — that skill produces a comprehensive dependency-mapped register. The minimum viable register above is sufficient for estimation output only."*
