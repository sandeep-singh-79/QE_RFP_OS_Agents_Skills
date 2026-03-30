# QE OS Improvement Proposals

> Records proposed improvements to the QE RFP Operating System.
> Agents propose changes here. System updates require human approval.

---

## Active Proposals

### Improvement Proposal: IP-LBMX-01
- **Observation:** The `pert-estimation` skill has no deduplication guard. When a test library contains files labelled "Regression" (or similar), those files typically contain test cases that also appear in Functional, E2E, or Integration categories. Without an explicit deduplication step before sizing, the gross file/test count inflates the estimate — and every subsequent multiplier compounds the error.
- **Root Cause:** The skill operates on raw test counts provided to it. It has no instruction to detect or handle known overlap patterns (e.g., Regression-labelled files containing a subset of tests from other tiers).
- **Suggested Change:** Add a mandatory **Test Deduplication Step** to `pert-estimation` before the Test Case Categorisation Tiers table is applied. The step must: (1) identify any tier groupings likely to contain overlapping test cases (e.g., Regression files vs. Functional/E2E), (2) instruct the system to deduplicate by unique test case identity before establishing the sizing baseline, (3) declare the deduplication method and net counts as an explicit assumption in the Assumptions Block. The gross count and net deduplicated count must both be reported.
- **Impact:** High — inflated gross counts directly inflate all downstream effort figures
- **Status:** Consolidated → merged with IP-LBMX-14 into `## Scope Reconciliation` in `references/estimation-model.md` (Phase 8, Task 6). Path-conditional deduplication guard: inference path (module boundary overlap check) + artifact-access path (bidirectional removal + decomposition expansion).
- **Priority:** High

---

### Improvement Proposal: IP-LBMX-02
- **Observation:** The `pert-estimation` skill does not declare a reusability reduction factor for engagements where an existing automation framework is already in place. When a client has an active Cypress (or equivalent) framework on a related project, shared components, page objects, and common workflows can be reused — materially reducing Script Development effort. Without a declared factor, estimates default to greenfield effort, overstating cost.
- **Root Cause:** The Effort Multipliers table covers complexity-based per-test-case effort but has no mechanism to express downward effort adjustment from reusability. The skill assumes net-new scripting effort unless told otherwise.
- **Suggested Change:** Add a **Reusability Factor** to the Effort Multipliers section of `pert-estimation`. The factor should: (1) be declared only when an existing framework is confirmed (do not infer or assume), (2) apply as a **post-summation multiplier** on the base effort total (e.g., Total × 0.60 for 40% reuse) — *not* as a per-scenario rate reduction; this distinction matters because applying the factor post-summation keeps per-scenario rates calibrated and separates the reuse adjustment from complexity-based sizing, (3) specify the application base clearly: the reusability multiplier is applied to the sum of all scenario efforts at the total level, (4) appear as a named, valued line item in the Assumptions Block and the multiplier summary table. The factor must be declared even when it is 0% (i.e., no reuse possible — state why). Typical range: 0.55–0.85 (15–45% savings depending on shared component depth).
- **Impact:** Medium — materially affects total engagement cost for existing-framework engagements; applying factor at wrong level (per-row vs. post-summation) produces structurally different and less defensible results
- **Status:** Implemented — `.claude/references/estimation-model.md` § Reusability Factor (Four-Case Model)
- **Priority:** Medium

---

### Improvement Proposal: IP-LBMX-03
- **Observation:** The `pert-estimation` skill has no cross-browser/device efficiency declaration. When automation scripts are written to be browser-agnostic (as is standard in Cypress/Playwright/Selenium), a single script executes across multiple browsers and devices without re-scripting. Without an explicit guard, a system could mistakenly multiply Script Development effort by the number of target browsers or devices — significantly overstating cost.
- **Root Cause:** The skill defines effort per test case but does not distinguish between scripting effort (once per test) and execution effort (once per browser per test). The distinction is not enforced.
- **Suggested Change:** Add a **Cross-Browser/Device Efficiency** rule to the Effort Multipliers section: scripting effort is counted once per test case regardless of target browser/device count. Execution cycle effort (in the Execution & Reporting phase) may be multiplied by browser/device count where parallel execution infrastructure is not available. Both values must be declared separately in the estimate. Add a guardrail: do not multiply Script Development hours by browser count unless cross-browser scripting divergence is explicitly evidenced.
- **Impact:** Medium — prevents a significant overestimate in multi-browser/mobile-enabled engagements
- **Status:** Consolidated → collapsed into IP-LBMX-02 as a one-line cross-browser guardrail within the Reusability Factor section of `references/estimation-model.md` (Phase 8, Task 4.2). Removed as standalone proposal.
- **Priority:** Medium

---

### Improvement Proposal: IP-LBMX-04
- **Observation:** The `pert-estimation` and `estimation-sizing-thinking` skills have no mechanism for two related effort-reduction factors — and more critically, no rule that **scenario count is immutable once established**. The two factors are: (a) **Scenario Normalization** — a parameterized groups of scenarios (wizard-based flows, multi-tenant variants, data-driven paths) require less scripting effort per scenario because they share infrastructure, page objects, and data-driver setup. All scenarios are still automated; the factor reduces the *effort* per parameterizable group, not the scenario count. (b) **Parameterized Consolidation** — execution efficiency gain from parameterized test design, applied as a further effort reduction on the normalization-adjusted total.
- **Root Cause:** Both skills treat complexity and count as the only effort drivers. They have no post-summation reduction mechanism, and — absent an explicit rule — a system could interpret normalization as reducing the scenario count (e.g., "50 wizard variants → 1 parameterized script") rather than reducing the effort multiplier on a fixed scenario count. This is the wrong model. If variant A and variant B are separate business validations, both must be automated. Parameterization reduces scripting effort for the pair; it does not eliminate either scenario from scope.
- **Suggested Change:** Add three things to `pert-estimation`: (1) **Immutable Baseline Rule** (placed immediately after the Scope Establishment Pre-Phase): "The WBS scenario count established in scope establishment is fixed for the duration of estimation. Efficiency multipliers reduce effort required to automate those scenarios — they do not eliminate scenarios from scope. Do not adjust scenario count when applying normalization or parameterization factors."; (2) **Scenario Normalization factor** — a named post-summation multiplier applied to the reuse-adjusted effort total, reflecting that parameterizable scenario groups cost less to script than independently scripted equivalents; declare factor value and which module groups qualify; (3) **Parameterized Consolidation factor** — applied to normalization-adjusted total, reflecting execution efficiency (reference value: ×0.95). The application chain must be explicit: *Raw Effort → ×Reuse → ×Normalization → ×Parameterization → Adjusted Total*. Remove the companion note to `estimation-sizing-thinking` Step 2 about "counting unique scenarios not data permutations" — that logic belongs in Scope Establishment (IP-LBMX-13), not in the estimation multiplier step.
- **Impact:** High — confusing scenario count reduction with effort reduction produces structurally invalid estimates; all scenarios must appear in the delivery baseline regardless of parameterization efficiency gains
- **Status:** Implemented — `.claude/references/estimation-model.md` § Multiplier Chain (Normalization, Parameterization, Immutable Baseline)
- **Priority:** High

---

### Improvement Proposal: IP-LBMX-05
- **Observation:** The skills do not declare a **WBS alignment note** for engagements where client-side estimates were built using a Work Breakdown Structure (WBS) approach with direct hour assignments per work package. The PERT-based system produces effort ranges (O/ML/P) that are compatible with WBS direct assignments — where the client's direct hours map naturally to the Most Likely (M) input — but this mapping is not documented. Without it, post-run comparison between QE OS PERT output and WBS-based reference estimates is harder to interpret.
- **Root Cause:** PERT and WBS are complementary approaches but the skill does not call this out, leaving the relationship implicit.
- **Suggested Change:** Add a short **WBS Compatibility Note** to the PERT Formula section of `pert-estimation`: "When a reference estimate is built using WBS direct hour assignments per work package, those assignments map to the Most Likely (M) input in the PERT formula. O and P are then derived by applying optimistic/pessimistic variance to each work package. This allows PERT ranges to be layered over an existing WBS baseline without re-deriving M from scratch." This is documentation only — no workflow change required.
- **Impact:** Low — clarity and post-run comparison quality improvement only
- **Status:** Consolidated → downgraded to a conditional one-line footnote within the PERT Formula section of `pert-estimation/SKILL.md` (Phase 8, Task 4.7). Applies only when a client-provided WBS reference estimate exists. Removed as standalone proposal.
- **Priority:** Low

---

### Improvement Proposal: IP-LBMX-06
- **Observation:** The `pert-estimation` skill has no criticality priority classification (P0/P1/P2). The reference estimation workbook uses a separate priority dimension — P0 (mission critical), P1 (important), P2 (lower priority) — applied per sub-module row, independent of complexity (Simple/Medium/Complex/HC). Priority drives phasing decisions and risk-based sequencing: P0 items are automated first, P2 last. Without this, the skill produces effort totals but no criticality-driven ordering mechanism — making it impossible to produce a defensible "automate this first" phasing recommendation.
- **Root Cause:** The skill's tier system (Smoke/Sanity/Regression/Functional/Integration/E2E) addresses *test type* coverage, not *business criticality*. These are orthogonal dimensions: a Functional test can be P0 or P2 depending on the sub-module it covers. The skill has no construct for criticality.
- **Suggested Change:** Add a **Criticality Priority Classification** step to `pert-estimation`, applied per test group or sub-module before phasing recommendations are made. The step must: (1) define P0/P1/P2 levels (P0 = mission-critical, financially gated, or compliance-relevant; P1 = operationally important; P2 = lower priority / edge cases / language variants), (2) produce a priority distribution by sub-module or tier, (3) feed directly into the phase effort breakdown — Phase 1 / pilot scope targets P0 items, Phase 2 targets P1, Phase 3 targets P2. The priority classification must be declared as an assumption with rationale — do not assign priorities without evidence.
- **Impact:** High — without criticality ordering, phasing recommendations default to arbitrary sequencing rather than risk-based prioritization, which weakens the proposal's defensibility
- **Status:** Implemented — `.claude/references/estimation-model.md` § Criticality Priority Classification
- **Priority:** High

---

### Improvement Proposal: IP-LBMX-07
- **Observation:** The `pert-estimation` skill estimates total effort per test case but does not split UI automation effort from non-UI effort (API validation, data verification, backend assertions). The reference estimation workbook explicitly separates "UI base (hrs)" columns from total effort columns, implying non-UI effort is costed on top of the UI base. Without this split, automation proposals either silently undercount non-UI effort (if total = UI only) or cannot defend how non-UI work was accounted for.
- **Root Cause:** The Effort Multipliers table (Tier × Complexity) produces a per-test-case total without distinguishing automation layer. For test cases that involve API responses, database validation, document output verification, or EFT/GL integration checks, the UI-only base significantly understates total script development effort.
- **Suggested Change:** Add a **UI vs Non-UI effort declaration** to the `pert-estimation` output format. At a minimum: (1) the estimate must declare whether the per-test-case effort figures include non-UI verification or are UI-only, (2) for test groups with known non-UI components (API assertions, DB validation, integration checks), declare a separate effort line or an additive percentage for non-UI work, (3) add a guardrail: do not assume UI-only effort when the test scope includes external integrations, document generation, or data pipeline validation. This does not require a full separate effort table — a declared split and rationale is sufficient.
- **Impact:** Medium — most significant for complex integration-heavy engagements (Reconcile Management, GL XML, EFT processing, Document Manager)
- **Status:** Implemented — `.claude/references/estimation-model.md` § Automation Layer Declaration
- **Priority:** Medium

---

### Improvement Proposal: IP-LBMX-08
- **Observation:** The `pert-estimation` skill has no double-counting guard when multiple effort reduction factors are applied in sequence. The reference estimation workbook explicitly declares (A13): "The 40% reuse factor applies to shared code, utilities, and components, *not* additional scenario consolidation." The workbook resolves this by applying Reuse and Normalization as separate named multiplier rows each anchored to a declared base — Reuse at post-summation base, Normalization on top of reuse-adjusted total, Parameterization on normalization-adjusted total. Without an equivalent declaration structure, a system applying these factors could anchor multiple reductions to the wrong base or apply overlapping factors to the same effort component.
- **Root Cause:** The three reduction factors target different things: Reusability = fewer scripts to write (shared components); Scenario Normalization = fewer unique scripts via parameterization; Parameterized Consolidation = execution cycle efficiency. They are applied **sequentially to different bases** — the output of each step becomes the input of the next. Without explicit sequencing and base declarations, the same reduction can be double-applied, or the chain can be applied out of order.
- **Suggested Change:** Add a **Multi-Factor Reduction Declaration** requirement to the Effort Multipliers section of `pert-estimation`. Each declared multiplier must state: (1) its **application base** — which total it multiplies from (e.g., "Normalization applies to the Reuse-adjusted total, not to the raw base"); (2) its **application order** in the chain; (3) what it covers and explicitly what it does not cover (citing A13 pattern). Produce a stacking summary table: `Raw Base → × Reuse [factor, base=Raw] → × Normalization [factor, base=Reuse-adjusted] → × Parameterization [factor, base=Norm-adjusted] → Adjusted Total`. This must appear in the Assumptions Block. Prohibit computing a combined multiplier and applying it in a single step — the chain must be shown step-by-step.
- **Impact:** High — without this, factors can be incorrectly chained (e.g., Normalization anchored back to raw base instead of reuse-adjusted), or combined into a single opaque multiplier that cannot be reviewed or challenged
- **Status:** Consolidated → merged into IP-LBMX-04 as the Multi-Factor Reduction Declaration requirement in `references/estimation-model.md` § Multiplier Chain (Phase 8, Task 4.5). Chain declaration is a sub-requirement of IP-LBMX-04. Removed as standalone proposal.
- **Priority:** High

---

### Improvement Proposal: IP-LBMX-09
- **Observation:** The `pert-estimation` skill's Assumptions Block has no mechanism to flag specific assumptions as requiring client confirmation before the estimate is locked. The reference estimation workbook explicitly marks A1b, A4, A7, A12, A13 as "Client Confirmation Required" and includes a formal validity note: "This estimate remains valid subject to fulfillment of Assumptions A1b, A4, A7, A12, and A13. Deviations may require effort recalibration through formal change control." Without this mechanism, all assumptions are implicitly treated as provisionally accepted, which understates the governance risk and leaves the vendor exposed if unconfirmed assumptions prove wrong post-award.
- **Root Cause:** The Assumptions Block format in `pert-estimation` uses a flat "Assumption N: [what] — if incorrect: [impact]" structure with no differentiation between internally-held assumptions and externally-dependent ones that require client confirmation.
- **Suggested Change:** Add a **Client Confirmation Required** tag to the Assumptions Block format. Mark assumptions that are client-controlled (access, environment readiness, data availability, scope stability, SME availability) with a `[CLIENT CONFIRMATION REQUIRED]` flag. Add a mandatory validity statement to the assumptions section: "This estimate remains valid subject to fulfillment of [list flagged assumption IDs]. Deviations exceeding 15% from declared assumptions trigger formal change control." The flagged assumption IDs should also be surfaced in the final output's executive summary.
- **Impact:** Medium — governance and defensibility quality; directly reduces post-award credibility risk when confirmed assumptions prove false
- **Status:** Implemented — `.claude/references/estimation-model.md` § Assumptions Block Enhancements (CCR Flag)
- **Priority:** Medium

---

### Improvement Proposal: IP-LBMX-10
- **Observation:** The `pert-estimation` skill produces scenario/test counts as sizing inputs but never declares the final net count as a formal **change control baseline**. The reference estimation workbook explicitly uses the deduplicated scenario count ("8,916-scenario baseline" in A9) as the trigger for formal change control: "Functional scope changes will follow formal change control using the 8,916-scenario baseline as reference." Without this, estimates have no anchor against which scope growth can be measured — making the estimate defensible at submission but unenforceable post-award.
- **Root Cause:** The skill is scoped to produce effort figures, not delivery governance controls. The scenario count is used internally for sizing but is not surfaced as a lockable reference point in the output.
- **Suggested Change:** Add a **Scope Baseline Declaration** to the `pert-estimation` Output Format, as a required element alongside the Assumptions Block. The declaration must: (1) state the net deduplicated scenario count used as the sizing basis, (2) note that this count constitutes the scope baseline for change control, (3) declare the variance threshold that triggers formal change control (recommend ≥15% increase in scope without corresponding estimate recalibration). This is a documentation-only addition — no workflow change required.
- **Impact:** Medium — directly improves post-award scope management and prevents uncontrolled scope growth from eroding engagement profitability
- **Status:** Implemented — `.claude/references/estimation-model.md` § Assumptions Block Enhancements (Scope Baseline Declaration)
- **Priority:** Medium

---

### Improvement Proposal: IP-LBMX-11
- **Observation:** The `pert-estimation` skill output does not include a Risk Register alongside the Assumptions Block. The reference estimation workbook pairs 14 named risks (R1–R14) with Likelihood, Impact, and Mitigation columns directly adjacent to the assumptions. Producing assumptions without paired risks creates an incomplete governance picture — assumptions declare what is relied upon, but risks declare what happens when those reliances fail under real-world conditions. Without a risk register, the estimate appears optimistically framed and may not survive scrutiny from an experienced procurement evaluator.
- **Root Cause:** The skill's output format was designed around a simplified assumption-confidence model. Risk register production was implicitly assumed to be the responsibility of `assumption-dependency-management` — but that skill is not always invoked alongside `pert-estimation`, and the two outputs are not formally linked in the workflow.
- **Suggested Change:** Add a lightweight **Risk Register** to the `pert-estimation` Output Format as a standard section (not optional). Minimum structure: Risk ID, Risk description, Likelihood (Low/Medium/High), Impact (Low/Medium/High), Mitigation strategy. Each assumption flagged as Client Confirmation Required (IP-LBMX-09) should have at least one corresponding risk entry covering the "assumption proves false" scenario. Note in the skill: "For engagements requiring a full risk register, invoke `assumption-dependency-management` — this skill produces a minimum viable risk register sufficient for estimation output only."
- **Impact:** Medium — strengthens defensibility and completeness of client-facing estimation output; closes the gap between assumption declaration and risk disclosure
- **Status:** Implemented — `.claude/references/estimation-model.md` § Minimum Viable Risk Register
- **Priority:** Medium

---

### Improvement Proposal: IP-LBMX-12
- **Observation:** The `pert-estimation` skill does not declare its **estimation unit** — the fundamental object being sized. This matters differently depending on engagement type. When client test artifacts are available (uncommon — LBMX was an exception), the estimation unit is the **WBS Level-3 automation scenario**: a single, independently automatable business validation derived by decomposing multi-step manual test cases. Each validation step becomes its own scenario, so scenario count can exceed raw manual test case count. In the more common case — where no test artifacts are available — the estimation unit must be inferred from functional scope (module list, RFP feature descriptions, functional spec), and scenarios are estimated rather than counted. The base effort rates are calibrated per unit (ML: Simple=2.5h, Medium=4.5h, Complex=9h, HC=14h per scenario). Applying test case rates to a scenario count, or treating inferred scenario counts as if they were artifact-derived, produces wrong totals with no error signal.
- **Root Cause:** The skill defines effort rates per "test case" without declaring (a) what unit those rates apply to, or (b) which input path was used to arrive at the count — artifact-derived vs. inference-based. These are structurally different inputs with different confidence levels and different review processes.
- **Suggested Change:** Add an **Estimation Unit Declaration** as the first required output element of `pert-estimation`, with two declared fields: (1) **Unit type**: "Automation Scenarios (WBS Level-3, artifact-derived)" or "Automation Scenarios (inferred from functional scope)"; (2) **Derivation path**: how the count was reached. When artifact-derived: note that multi-step manual test cases were decomposed into atomic scenarios — one validation step = one scenario. When inference-based (the default for most RFP engagements): declare the assumption basis (e.g., module count × estimated scenario density, or functional feature count × complexity weighting) and flag the count as an estimate with stated confidence. Incorrect unit-rate pairing must be treated as a halting condition regardless of derivation path.
- **Impact:** High — the distinction between artifact-derived and inferred scenario counts affects the confidence level, the review process, and the appropriate contingency buffer; treating an inferred count as if it were artifact-verified overstates precision
- **Status:** Implemented — `.claude/references/estimation-model.md` § Estimation Unit Derivation Paths
- **Priority:** High

---

### Improvement Proposal: IP-LBMX-13
- **Observation:** The `pert-estimation` skill receives a scenario count as input but has no declared **Scope Establishment Pre-Phase** — the work required to arrive at that count from raw inputs. This phase exists in two distinct forms depending on engagement type, and the skill handles neither explicitly: (a) **Artifact-access path** (rare — LBMX was an exception): client provides their full test repository; team must review each file, map to WBS modules, decompose multi-step manual test cases into atomic automation scenarios, classify complexity, assign priority, and reconcile overlaps. For 272 files this is a multi-week effort. (b) **Inference-based path** (the default for most RFP engagements): no test artifacts are available; the team derives scenario counts from functional scope — module lists, RFP feature descriptions, epic/story counts, or functional spec coverage areas — combined with experience-based scenario density estimates per module type. Both paths produce a scenario count that feeds estimation, but with different effort costs, different confidence levels, and different validity conditions. Neither is currently declared in the skill.
- **Root Cause:** `pert-estimation` begins at the point where a scenario count exists. It has no concept of the upstream work that produced that count or the confidence level it carries, which means (a) the effort to produce it is unpriced, and (b) the downstream estimate carries implied precision it doesn't have.
- **Suggested Change:** Add a **Scope Establishment Pre-Phase** declaration to `pert-estimation` before sizing begins. The declaration must: (1) state which path applies: artifact-access or inference-based; (2) for artifact-access: declare the five activities (artifact review, WBS mapping, manual-test decomposition, complexity classification, priority assignment, cross-artifact reconciliation) and estimate effort at 2–5% of projected base total; (3) for inference-based (default): declare the derivation basis (module list, feature count, domain density assumptions), state the confidence level explicitly ("Estimated ± 30% — no artifact verification"), and increase the risk contingency overhead accordingly; (4) in both cases: output an explicit scenario count with derivation path label before PERT sizing begins. The inference-based path is the skill's normal operating mode — artifact access is a premium engagement condition, not the default.
- **Impact:** High — unpriced scope establishment effort and undeclared count confidence are the two most consistent sources of post-award estimation disputes; surfacing both at the output level prevents them
- **Status:** Implemented — `.claude/references/estimation-model.md` § Scope Establishment Pre-Phase
- **Priority:** High

---

### Improvement Proposal: IP-LBMX-14
- **Observation:** IP-LBMX-01 (Test Deduplication Guard) was written with the implicit assumption that reconciliation always *reduces* the test count. In practice, when artifact access is available, scope establishment is **bidirectional**: it removes overlaps AND structurally expands count through decomposition of multi-step manual test cases into atomic automation scenarios. The LBMX engagement — where full test artifact access was available — confirms this: raw count from ~272 manual test files ≈ 8,900, but WBS-mapped automation scenario count = 8,916 (net *increase* of +0.2%). The expansion was concentrated in rule-heavy areas: Rebate Categorization, GL Coding, Auto Reconcile, Rebate Genius, and Exports. However: **this bidirectional behaviour only applies when artifact access exists**. In the inference-based path (the default for most RFP engagements), there are no raw test files to decompose, so the deduplication guard is relevant in a different form — preventing double-counting of scenarios estimated across overlapping functional areas (e.g., the same integration boundary estimated once in Module A and again in Module B's cross-cutting scope).
- **Root Cause:** IP-LBMX-01 was written for artifact-access engagements. Its deduplication model has two blind spots: (a) it doesn't model the expansion direction (decomposition adds scenarios); (b) it doesn't define the equivalent guard for inference-based engagements (where the overlap risk is double-counting estimated scope, not duplicate test files).
- **Suggested Change:** Amend the **Test Deduplication Step** from IP-LBMX-01 to be path-conditional: *Artifact-access path*: model bidirectionally — removal (overlapping test files) and expansion (decomposed sub-scenarios); output four metrics: raw artifact count, removed, added, net; include the warning "Net scenario count may exceed raw file count after decomposition. This is expected.". *Inference-based path (default)*: deduplication guard applies to scope overlap — when scenario counts are estimated per module independently, flag any module boundaries where the same functional area may have been estimated twice (e.g., integrations claimed from both sides); require a cross-module overlap check before the scenario baseline is locked. In both cases: the Scope Baseline Declaration (IP-LBMX-10) must reference the post-reconciliation net count with its derivation path labelled.
- **Impact:** Medium — the deduplication guard is relevant in both paths but for structurally different reasons; a single undifferentiated rule will be incorrectly applied in one or the other
- **Status:** Consolidated → merged with IP-LBMX-01 into `## Scope Reconciliation` in `references/estimation-model.md` (Phase 8, Task 6). IP-14 provides the bidirectionality model (artifact path); IP-01 provides the inference-path overlap guard. LBMX-14 leads as the more complete model.
- **Priority:** Medium

---

### Improvement Proposal: IP-LBMX-15
- **Observation:** The `pert-estimation` skill's PERT Formula and Output Format sections cover only the core script development effort and a limited set of enablement overheads (Framework Establishment, CI/CD Integration, Data Utilities). They do not include four significant overhead categories present in the reference estimation workbook: (1) **Stabilization** (5.5% of adjusted base) — post-deployment defect findings, retesting, and framework stability work; (2) **Build Phase Maintenance** (5%) — ongoing test maintenance during active sprints while the build is in motion; (3) **Risk Contingency** (5%) — buffer for scope uncertainty, integration surprises, access delays; (4) **Governance and Reporting** (2%) — status reporting, review sessions, metrics dashboards, steering committee artifacts. Combined, these four categories add 17.5% to the post-multiplier adjusted base effort. Omitting them produces a structurally incomplete estimate that will be challenged as unrealistic by any experienced QA delivery manager.
- **Root Cause:** The skill was designed to size the core automation development work. Overhead categories were treated as delivery concerns outside the estimation scope. In practice, RFP-grade estimates are expected to include these categories — their absence signals an inexperienced costing model.
- **Suggested Change:** Add a **Delivery Overhead Categories** section to `pert-estimation` Output Format, applied as percentage additions to the post-multiplier adjusted base (the figure after all reduction factors are applied). Four required categories with reference percentages (to be declared as assumptions, adjustable by engagement): Stabilization (reference: 5–6%), Build Phase Maintenance (reference: 4–6%), Risk Contingency (reference: 3–7%), Governance and Reporting (reference: 1–3%). Each category percentage applies to the same adjusted base (post-Parameterization total). Produce a subtotal for overheads and add to adjusted base to reach the **Delivery-Ready Total**. Note: overhead percentages must be declared as assumptions, not hardcoded — engagements with fixed scope, clean environments, or low governance requirements may reduce or waive specific categories.
- **Impact:** High — a proposal that omits these categories will be immediately identified as incomplete by client QA Managers; the gap between adjusted base and delivery-ready total is typically 15–20%, which is material to commercial viability
- **Status:** Implemented — `.claude/references/estimation-model.md` § Phase-Allocated Delivery Overheads
- **Priority:** High

---

### Improvement Proposal: IP-LBMX-16
- **Observation:** The `pert-estimation` skill calculates enablement overheads (Framework Alignment, Data Utilities, KT and Handover) as flat percentages of the base effort. The reference estimation workbook uses **MIN-capped formulas** for these same categories: `MIN(cap, base × %)`. For example: Framework Alignment = `MIN(200h, base × 3%)` — on a 9,145h adjusted base, 3% = 274h but is capped at 200h. Without this cap, flat percentage calculations overstate enablement costs as engagement size grows, because infrastructure effort does not scale linearly with scenario count beyond a threshold. On large engagements, the uncapped flat % approach can overstate Framework Alignment effort alone by 30–40%.
- **Root Cause:** The skill uses percentages for computational simplicity. The implicit model is that enablement scales proportionally with engagement size. This is only valid up to a scale threshold — above ~6,000–8,000 hrs, a single framework alignment effort does not keep growing proportionally; it hits an infrastructure ceiling.
- **Suggested Change:** Replace flat percentage calculations for enablement overheads in `pert-estimation` with **MIN-capped formulas**. Recommended structure: `MIN(cap_hours, adjusted_base × rate%)`. Reference values from LBMX workbook: Framework Alignment `MIN(200h, base×3%)`, Data Utilities `MIN(350h, base×1.5%)`, KT and Handover `MIN(250h, base×1%)`. CI/CD Integration: retain as fixed hours (independent of scenario count). Caps must be declared as assumptions — different environments or complexity levels may warrant adjustment. Add a note: "On engagements where adjusted base exceeds ~6,700h, MIN caps will activate and limit enablement overhead growth. Declare which caps are active in the Assumptions Block."
- **Impact:** Medium — most impactful on large-scale engagements (>400 scenarios, adjusted base >6,000h); prevents systematic overcharging of enablement overhead; improves commercial accuracy and defensibility under client scrutiny
- **Status:** Implemented — `.claude/references/estimation-model.md` § Enablement MIN-Cap Formulas
- **Priority:** Medium

---

### Improvement Proposal: IP-LBMX-17
- **Observation:** The reference estimation workbook labels Row 301 as "Scenario Normalization 25%" but the actual sequential factor applied is ×0.45 (not ×0.75). Verification: Row 300 ML = 21,392; Row 301 ML = 9,627; 9,627 / 21,392 = 0.450 exactly — confirmed across all three effort columns (P, ML, O). The factor ×0.75 (a 25% reduction) would produce Row 301 ML = 16,044, which is 66% higher than the workbook value. This discrepancy exists between the row label and the computed factor in the workbook. Without resolution, any system following the label (×0.75) will produce an adjusted base of ~15,242 ML hrs rather than the workbook's 9,145 ML hrs — a 67% overstatement of post-normalization effort.
- **Root Cause:** The label "25%" may describe the proportion of scenarios eligible for normalization (25% of scenarios qualify), with the full effort impact being a deeper cut on those qualifying scenarios — but neither the eligible proportion nor the per-group reduction rate is declared in the workbook row. The discrepancy is also consistent with an unlabelled second factor being applied without a dedicated row.
- **Suggested Change:** Add a **Factor Declaration Completeness Rule** to the estimation multiplier chain: each percentage label on a multiplier row must correspond to the actual sequential factor applied. If a label reads "Normalization 25%" but the factor applied is ×0.45, the row must either: (a) explain the derivation (e.g., "25% of scenarios eligible × 40% sub-reduction on qualifying group = combined ×0.85 on total" — or whatever the correct derivation is), OR (b) relabel as the actual factor applied. Opaque labels that do not match their numeric effect are a transparency and audit risk. This is a labelling and governance standard for estimation workbooks, not a model change. LBMX workbook discrepancy (label "25%", actual factor ×0.45) is the motivating example — retained as reference case; no LBMX-specific numbers hardcoded into the principle.
- **Impact:** High — a large variance between declared label and applied factor cannot be explained away under client scrutiny; any manual recreation of the estimate from the label alone will produce a structurally different number
- **Status:** Implemented — `.claude/references/estimation-model.md` § Factor Declaration Completeness Rule (Phase 9, L-3)
- **Priority:** High

---

### Improvement Proposal: IP-P3-03
- **Observation:** `evidence-extraction/SKILL.md` is 301 lines — the largest skill file in the system. It is loaded in full at Stage 1 and carries significant structural detail: finding formats, RFP question extraction rules, missing evidence format, Value Claim Trace block, contradiction handling, guardrails, and handoff.
- **Root Cause:** Evidence extraction is a multi-responsibility task by nature — it must handle multiple artifact types, multiple finding categories, and multiple output formats. However, the file is approaching a size where further additions would meaningfully inflate Stage 1 context loading.
- **Suggested Change:** No action now. Flag for Phase 5 review — Phase 4 made no structural changes to evidence-extraction SKILL.md. If any further schema additions are proposed (e.g., new finding types, additional extraction rules), evaluate whether a dedicated `evidence-extraction-formats.md` reference file can hold schema definitions (finding structure, block formats) separately from the skill logic (responsibilities, guardrails, handoff).
- **Impact:** Low
- **Status:** Proposed
- **Priority:** Low

---

### Improvement Proposal: IP-CX-01
- **Observation:** The Agent Context Scope table lists only `plan.md` as Required Context for `Conductor (Stage 9)`. However, Stage 9 requires the Conductor to run a self-validation completeness check against each major output section and — conditionally — a cross-document duration consistency check if `outputs/estimation-proposal.md` exists. Both checks are impossible without loading the output files they operate on.
- **Root Cause:** The scope row was set conservatively when Stage 9 was defined, before the self-validation loop and duration consistency check were added as mandatory Conductor obligations.
- **Suggested Change:** Update the `Conductor (Stage 9)` row in the Agent Context Scope table to add `outputs/staged-proposal.md` (required) and `outputs/estimation-proposal.md` (conditional — load only if the file exists) to the Required Context column.
- **Impact:** High — without these files in scope, the Conductor cannot legally execute mandatory Stage 9 gates; validations are either skipped or performed without their required evidence source.
- **Status:** Implemented
- **Priority:** High

---

### Improvement Proposal: IP-CX-02
- **Observation:** Two rules in AGENTS.md govern checkpoint enforcement and directly contradict each other. The Conductor Responsibilities summary states "do not advance if the checkpoint condition is not met" (hard block). But the summary note at the bottom of the Review Checkpoints table states "violations are flagged but do not hard-block unless a skill-level HALT applies." These are opposite behaviours for the same event.
- **Root Cause:** The note at the bottom of the Review Checkpoints table was not aligned with the Conductor's HITL Escalation Protocol (defined in `conductor.md`), which classifies unmet checkpoint conditions as Blocking HITL — requiring halt and human resolution before advancement.
- **Suggested Change:** Replace the contradicting note at the bottom of the Review Checkpoints table with a statement that aligns with the HITL protocol: unmet checkpoint conditions trigger Blocking HITL and must be resolved before advancement. Add a pointer to `agents/conductor.md — HITL Escalation Protocol`.
- **Impact:** High — the conflicting statement creates opposite advancement decisions for the same failed checkpoint depending on which rule an agent reads first, directly undermining governance predictability.
- **Status:** Implemented
- **Priority:** High

---

### Improvement Proposal: IP-CX-03
- **Observation:** Stage 7 declares `Outcome & Risk Framing → Structuring & Consulting Thinking` as the required skill chain for pre-processing. But the two-step Execution Sequence assigns only Structuring to the Conductor (Step 1) and the Client/RFP Evaluator (Step 2). Outcome & Risk Framing is declared as required but has no designated owner, no assigned execution step, and is absent from the Conductor (Stage 7 pre-processing) context scope.
- **Root Cause:** The Execution Sequence was written when Stage 7 pre-processing was single-skill (Structuring only). Outcome & Risk Framing was added to the Skills field without updating the Execution Sequence or the Agent Context Scope table.
- **Suggested Change:** Expand Stage 7 Execution Sequence from two steps to three: Step 1 — Conductor applies `outcome-risk-framing` to frame findings in business impact and scoring consequence terms; Step 2 — Conductor applies `structuring-consulting-thinking` to pre-process the framed output; Step 3 — Client/RFP Evaluator reviews the structured, consequence-framed output. Update Agent Context Scope `Conductor (Stage 7 pre-processing)` to add `outcome-risk-framing` to the skill column. Update conductor.md Stage 7 governance to reference both skills.
- **Impact:** High — without an explicit owner, Stage 7 can proceed without the consequence-framing step, producing outputs that have structure but lack the business-impact framing required for defensibility scoring.
- **Status:** Implemented
- **Priority:** High

---

## Design Review — Conditionality & Engagement-Model Analysis

> Recorded: March 2026 — LBMX estimation deep-dive session.
> Purpose: Captures analysis of which proposals are universal vs. conditional, and user observations that refine scope before implementation.

### User Observations Analysis

| ID | User Observation | Assessment | Implementation Implication |
|---|---|---|---|
| **General** | Multipliers are proposal-dependent; agile/sprint-embedded QA means per-phase scope isn't possible without backlog or WBS visibility | Valid structural constraint — not just a caveat. Scope visibility varies by engagement model. | Skill must declare three operating modes: Upfront/WBS-based, Inference-based, Capacity-based (agile). Multipliers only apply in Upfront mode. |
| **IP-LBMX-02** | Not all proposals have existing frameworks; some require discovery + framework creation using accelerators that need modification | Agreed — reality is a spectrum: greenfield, partial reuse, existing framework. Accelerator onboarding effort is currently absent from skill entirely. | Model three cases explicitly. Add accelerator adoption + modification as a named effort item in greenfield/partial scenarios. Not just a reduction factor. |
| **IP-LBMX-04** | Scenario normalization factor may not apply to all proposals | Agreed — normalization is conditional on parameterizable scenario patterns existing in scope. | Immutable baseline rule stays universal. Normalization and parameterization factors declared as conditional additions — applied only when qualifying patterns are evidenced; skipped and noted otherwise. |
| **IP-LBMX-05** | WBS compatibility note is proposal-dependent — only relevant when client shares a WBS | Agreed. No WBS to compare against in inference-based or capacity-based engagements. | Implement as conditional footnote only. Not a structural skill addition. |
| **IP-LBMX-06** | Criticality classification only applies if WBS or test cases are present | Partially agreed. Artifact presence improves precision but P0/P1/P2 can be assigned at module/feature level from business risk analysis alone — no artifacts required. | Apply when evidence exists; flag as assumed/inferred otherwise. Making it fully conditional on artifacts would remove it from most RFP proposals where it's most needed. |
| **IP-LBMX-15** | Choose only the most important and relevant delivery overhead categories | Agreed. Four categories have different universality. | Mandate: Risk Contingency + Stabilization (universal). Conditional: Build Phase Maintenance (agile/ongoing delivery only), Governance and Reporting (steering committee / formal governance present). |

### Full Proposal Conditionality Review

| ID | Conditional or Universal | Engagement-Model Dependency | Revised Disposition |
|---|---|---|---|
| **IP-LBMX-01** | Conditional on input type | Artifact-access: deduplication of test files. Inference-based: overlap guard across estimated modules. Capacity-based: N/A. | Consolidate with IP-LBMX-14 — same concern at different stages of the same workflow. |
| **IP-LBMX-02** | Conditional on framework status | Greenfield needs accelerator onboarding cost. Partial reuse needs adaptation effort. Existing framework needs reduction factor. | Expand to three-case model. Add accelerator effort as a missing item (not covered by any current proposal). |
| **IP-LBMX-03** | Conditional on browser scope | Only relevant when multi-browser coverage is in scope. Modern frameworks abstract this natively. | Collapse into IP-LBMX-02 as a one-line guardrail. Remove as standalone proposal. |
| **IP-LBMX-04** | Mixed — baseline rule is universal; multipliers are conditional | Normalization and parameterization only applicable in Upfront/WBS mode with qualifying scenario patterns. | Baseline rule: universal. Factors: conditional. Merge IP-LBMX-08 chain declaration into this proposal. |
| **IP-LBMX-05** | Conditional — client WBS must exist | Only relevant in Upfront/WBS mode when a client reference estimate is available. | One-line conditional footnote only. Do not implement as structural addition. |
| **IP-LBMX-06** | Conditional on scope visibility | Full classification requires WBS or test artifacts. Module-level assignment from business risk is always possible. | Always declare; qualify confidence level based on evidence depth. Not gated on artifacts. |
| **IP-LBMX-07** | Conditional on automation scope | Only applies when integration/backend/API validation is in scope alongside UI. | Trigger on scope: if non-UI validation is in scope, declaration required; otherwise silent. |
| **IP-LBMX-08** | Conditional on number of multipliers | Chain declaration only relevant when two or more reduction factors are applied. | Merge into IP-LBMX-04. Remove as standalone. |
| **IP-LBMX-09** | Universal | Client-controlled dependencies exist in every engagement regardless of model. | Implement as-is. No conditionality needed. |
| **IP-LBMX-10** | Conditional on estimation mode | In Upfront mode: scenario count is the anchor. In Capacity-based mode: team size × duration is the anchor; no fixed scenario baseline exists. | Make mode-conditional. Declare appropriate baseline type per mode. |
| **IP-LBMX-11** | Universal in intent; depth is engagement-dependent | Risk register always useful. Depth scales with submission type and commercial exposure. | Tiered trigger: lightweight (3–5 risks) for estimates ≤500h; full register for RFP/governance submissions. |
| **IP-LBMX-12** | Universal — two-path model already handles conditionality | Artifact-derived vs inference-based already declared. | Implement as-is. Add capacity-based as a third path declaration. |
| **IP-LBMX-13** | Needs third mode | Current two paths (artifact-access, inference-based) miss capacity-based agile mode where scope establishment is ongoing, not front-loaded. | Add capacity-based mode: no upfront scenario baseline; scope establishment deferred to kickoff; estimation basis is team capacity × sprint velocity. |
| **IP-LBMX-14** | Conditional on input type | Artifact-access: bidirectional (removal + decomposition expansion). Inference-based: module boundary double-counting guard. | Consolidate with IP-LBMX-01. Lead with inference path as the default case. |
| **IP-LBMX-15** | Mixed — two categories universal, two conditional | Risk Contingency + Stabilization: universal. Build Phase Maintenance: agile/ongoing only. Governance and Reporting: formal governance engagements only. | Implement two-tier model. Universal categories always present. Conditional categories declared with trigger conditions. |
| **IP-LBMX-16** | Universal formula; scale-dependent activation | MIN-cap activates above ~6,000h. Below that, produces identical result to flat %. | Implement universally — it's simply more accurate at all scales. Cap threshold noted as assumption. |
| **IP-LBMX-17** | Universal governance rule | Applies to any multiplier row in any engagement — labels must match applied factors. | Implement principle universally. Strip LBMX-specific numbers. Reference the workbook discrepancy as the motivating example only. |

### Cross-Cutting: Estimation Mode Framework

> This is the structural pattern underlying most conditionality issues identified above. Skills should declare which mode is in use before any sizing begins.

| Mode | When It Applies | Scope Visibility | Multiplier Applicability |
|---|---|---|---|
| **Upfront / WBS-based** | Full scope defined before engagement starts; client provides WBS, feature list, or test repository | High — scenario baseline fixed upfront | All multipliers applicable where conditions are met |
| **Inference-based** | RFP response; no WBS or test artifacts available; scope inferred from module descriptions and domain experience | Medium — count is estimated, confidence declared (±30%) | Most multipliers applicable conditionally; normalization/parameterization require qualifying evidence |
| **Capacity-based** | Agile/sprint-embedded QA; scope emerges from backlog incrementally; no upfront scenario count possible | Low — no fixed baseline at proposal time | Multipliers largely inapplicable; estimation basis is team size × sprint velocity × automation velocity |

**Required action:** IP-LBMX-04, IP-LBMX-10, IP-LBMX-13 must each declare which mode(s) they apply to before the proposed skill changes are drafted. Mode declaration should be the first step in the Scope Establishment Pre-Phase (IP-LBMX-13).

---

## Archive

### Improvement Proposal: IP-P3-01
- **Observation:** After Phase 3 implementation, `AGENTS.md` is 816 lines. The practical single-load warning threshold is ~400–500 lines. AGENTS.md is significantly above this, though as a system harness file (rules + workflow, not growing data) this is more tolerable than data files.
- **Root Cause:** AGENTS.md accumulates all workflow rules, governance layers, stage definitions, skill rosters, HITL rules, and conflict resolution protocols in a single file. Each phase of improvements adds to it.
- **Suggested Change:** Split AGENTS.md into a lean orchestration harness and a separate governance rulebook loaded selectively by relevant stages.
- **Impact:** Medium
- **Status:** Implemented (Phase 4 — governance.md and SETUP.md extracted; AGENTS.md reduced to lean harness)
- **Priority:** Medium

---

### Improvement Proposal: IP-P3-02
- **Observation:** The Value Claim Trace block (Task 3) adds ~5 lines per quantified claim in `claude-memory/memory.md`. A claim-heavy RFP (15–20 quantified benefit claims) could add 75–100 lines to `claude-memory/memory.md`, accelerating how quickly the 250-line summarisation threshold is reached and potentially triggering premature summarisation before all agents have used the full findings.
- **Root Cause:** Value Claim Trace blocks are appended inline with findings rather than in a separate section of `claude-memory/memory.md`. High-claim engagements will inflate the primary findings section of claude-memory/memory.md disproportionately.
- **Suggested Change:** Consider adding a dedicated `## Value Claim Traces` section to the `claude-memory/memory.md` schema, so that quantified claim validation blocks are stored separately from the primary finding list. This keeps the primary findings section compact while preserving full traceability. Evaluate in the first live engagement where Value Claim Trace is triggered.
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
- **Observation:** Phase 3 introduced three constructs that write to `claude-memory/memory.md` beyond simple findings: (a) Value Claim Trace blocks (~5 lines/claim), (b) Extraction Completeness Declaration appended at Stage 2 handoff (will accumulate on re-runs), (c) Gap Coverage report written to claude-memory/memory.md at Stage 3 (one row per finding — 50+ lines on large RFPs).
- **Root Cause:** All three write to claude-memory/memory.md without containment rules. The 250-line summarisation threshold can be hit before Stage 4 agents begin analysis on claim-heavy or high-finding engagements.
- **Suggested Change:** Three targeted fixes: (a) Implement IP-P3-02 — separate `## Value Claim Traces` section in claude-memory/memory.md schema; (b) Add overwrite-not-append rule to evidence-extraction/SKILL.md Handoff — the Extraction Completeness Declaration is an operational status block, not a finding; (c) Route Gap Coverage report to `claude-memory/notes.md` instead of claude-memory/memory.md — it is a stage output, not a persistent finding.
- **Impact:** Medium
- **Status:** Implemented
- **Priority:** Medium

---

### Improvement Proposal: IP-P3-07
- **Observation:** The claude-memory/memory.md summarisation threshold is 250 lines. With Value Claim Trace blocks, the Extraction Completeness Declaration, and the Gap Coverage report all writing to claude-memory/memory.md, a medium-complexity RFP (20+ findings, 10+ quantified claims) will reach the 250-line threshold by end of Stage 3 — before any agent analysis begins at Stage 4.
- **Root Cause:** Threshold was set before Phase 3 additions. Phase 3 materially increased the per-engagement write volume to claude-memory/memory.md.
- **Suggested Change:** Lower threshold to 200 lines, or implement IP-P3-02 + IP-P3-06(c) first (separating Value Claim Traces and routing Gap Coverage to claude-memory/notes.md), which effectively raises the functional headroom without changing the threshold. The two approaches are complementary — implement structural separation first, then reassess whether threshold adjustment is still needed.
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

---

### Improvement Proposal: IP-MAN-01
- **Observation:** AGENTS.md Stage 4 (Test Architect) has AI Capability Tier Classification (Tier 1/Tier 2) governing phasing and OC-1 guard, but contains no instruction to frame Tier 1 AI capabilities as *embedded execution accelerators with named delivery responsibilities per phase*. The output produced is a tier table and tooling rationale — not an execution integration narrative. AI capabilities consistently land in Stage 9 as tooling additions or optional enhancements rather than as delivery mechanisms, reducing proposal credibility under governance and procurement scrutiny.
- **Root Cause:** Stage 4 AI classification governs what to include and under what conditions — it does not govern how to position AI in the narrative. Stage 9 output structure has no explicit instruction to produce an execution integration section for Tier 1 AI capabilities.
- **Suggested Change:** Add a rule to Stage 9 output structure (AGENTS.md Stage 9 / Test Architect section): "After the AI Capability Tier table and Agentic AI Governance Model, produce a `### [AI Platform] — Execution Integration` subsection that names the delivery-stage responsibilities of each active Tier 1 capability (test generation on spec receipt, regression acceleration, failure triage, suite stability). Frame capabilities as execution mechanisms with phase-activation points — not as tooling options."
- **Impact:** High — AI framing directly affects delivery credibility scoring. Tooling framing scores in the tech section; execution mechanism framing scores in delivery confidence and commercial defensibility.
- **Derived from:** Manulife 7-workstream proposal — ChatGPT 5.4 review, March 23, 2026
- **Status:** Implemented
- **Priority:** High

---

### Improvement Proposal: IP-MAN-02
- **Observation:** `scope-completeness-validator` Category 1 (Integration Testing) correctly flags when integration testing is absent from scope estimates. However, Stage 9 has no instruction to produce integration testing as a *named architecture section* in the proposal output. Flagging at estimation time does not produce named framing in the final proposal narrative — the two actions are independent. Integration testing remains embedded inside per-workstream bullets rather than appearing as a named, evaluator-visible discipline.
- **Root Cause:** The scope validator operates on the estimation layer; Stage 9 output structure operates on the narrative layer. There is no wiring between them — a Category 1 `Present` result does not trigger a named section in Section 7.
- **Suggested Change:** Add a rule to Stage 9 output structure: "If integration testing is in scope (scope validator Category 1 = `Present`), produce a named `### External Integration Testing Model` subsection within the QE Architecture section. Do not rely on integration testing being visible inside per-workstream bullets. The subsection must cover: integration boundary inventory, contract/API testing approach, service virtualisation where applicable, and cross-system E2E validation."
- **Impact:** Medium — evaluators scanning for a named integration testing layer will not find it in workstream bullets. Named sections score; buried bullets do not.
- **Derived from:** Manulife 7-workstream proposal — ChatGPT 5.4 review, March 23, 2026
- **Status:** Implemented
- **Priority:** Medium

---

### Improvement Proposal: IP-MAN-03
- **Observation:** `scope-completeness-validator` Category 2 (RBAC) correctly flags when RBAC validation is absent from scope estimates. However, Stage 9 has no instruction to produce RBAC validation as a *named security control section* in the proposal output. RBAC work remains buried in workstream functional testing bullets rather than appearing as a named compliance and governance control layer — invisible to MAS-TRM or equivalent regulatory scrutiny.
- **Root Cause:** The scope validator operates on the estimation layer; Stage 9 Security Testing pillar has no conditional rule to produce a named RBAC subsection. RBAC is treated as a functional testing concern rather than a security and compliance control layer.
- **Suggested Change:** Add a rule to Stage 9 output structure: "If RBAC validation is in scope (scope validator Category 2 = `Present`), produce a named `### RBAC Validation as a Security Control` subsection within the Security Testing pillar. Frame RBAC as a security and compliance control layer — not solely as a functional testing activity. The subsection must cover: role entitlement verification, access denial validation for unauthorised roles, privilege escalation testing, and audit log verification."
- **Impact:** Medium — RBAC as a security control layer is scored differently from RBAC as a functional check. Governance and compliance evaluators expect to see it as a named security pillar element.
- **Derived from:** Manulife 7-workstream proposal — ChatGPT 5.4 review, March 23, 2026
- **Status:** Implemented
- **Priority:** Medium

---

### Improvement Proposal: IP-MAN-04
- **Observation:** AGENTS.md Stage 6 (Project Manager) instructs production of a Phase Model with deliverables and milestones. No instruction exists to produce explicit, enumerable Phase 0 exit criteria — the named conditions that must be satisfied before Phase 1 can begin. Every Stage 9 output will have a Phase 0 deliverable list and a gate statement but no table of verifiable exit conditions with named blockers and escalation paths.
- **Root Cause:** Phase model instructions specify what happens during each phase and what the milestone is, but not what conditions must simultaneously be true for the phase to be declared complete. A deliverable list is an activity checklist; exit criteria are a readiness gate — these are different.
- **Suggested Change:** Add a rule to Stage 6 Project Manager instructions: "After the Phase 0 deliverable triage block, produce a `### Phase 0 Exit Criteria` subsection. Enumerate named, verifiable conditions (not deliverable lists) that must all be satisfied before Phase 1 begins. Include a verification column. State that any unsatisfied condition at Phase 0 close is escalated to joint steering — Phase 0 does not close with outstanding blockers silently carried forward." Minimum required conditions: test strategies approved, integration dependencies confirmed, environment readiness validated, automation coverage baseline established, test data availability confirmed, refined estimates approved.
- **Impact:** High — absence of explicit exit criteria implies Phase 1 start is schedule-driven, not quality-gate-driven — a red flag for governance-oriented reviewers.
- **Derived from:** Manulife 7-workstream proposal — ChatGPT 5.4 review, March 23, 2026
- **Status:** Implemented
- **Priority:** High

---

### Improvement Proposal: IP-MAN-05
- **Observation:** Section 11 (Governance Model + RACI) rule requires a RACI table and governance tier derivation, but has no instruction to produce a named delivery risk ownership statement. In multi-workstream concurrent engagements, the RACI shows who is Accountable per activity but no section consolidates delivery risk monitoring into a single named function — creating a gap against procurement governance rubrics that expect a single accountable risk owner.
- **Root Cause:** Section 11 rule focuses on RACI activity coverage. It does not have a conditional rule for a named accountability paragraph for delivery risk visibility when the engagement involves multiple concurrent workstreams.
- **Suggested Change:** Add a conditional rule to Section 11: "For `transformation_partnership` and `managed_service` engagement types with `application_count > 3`, produce a `### Delivery Risk Ownership` subsection after the RACI table. Name the QA Lead as the single delivery risk visibility owner. List 4 monitoring responsibilities: (1) continuous monitoring of workstream readiness signals; (2) early identification of schedule or dependency risks; (3) escalation of cross-workstream delivery risks; (4) reporting of release readiness status to the steering committee."
- **Impact:** Medium — addresses a specific procurement governance expectation. Low effort, high signal for evaluators applying a single-point accountability rubric.
- **Derived from:** Manulife 7-workstream proposal — ChatGPT 5.4 third-pass review, March 23, 2026
- **Status:** Pending
- **Priority:** Medium

---

### Improvement Proposal: IP-MAN-06
- **Observation:** Section 8 Parallel Execution Assurance rule captures what enables concurrent execution but has no instruction to explicitly name environment capacity contention risk for engagements with 3+ simultaneous Tier A workstreams sharing test environments. With multiple concurrent workstreams active, environment capacity may become the binding constraint — but this is not named in the governance narrative.
- **Root Cause:** Parallel Execution Assurance covers enabling mechanisms (dedicated ownership, milestone coordination). Section 6 covers environment stability and readiness. Neither covers the specific risk that available environment slots may be insufficient for concurrent test cycles across 3+ workstreams.
- **Suggested Change:** To the Parallel Execution Assurance sub-section rule in `stage-9-output-structure.md` §8, add: "When engagement has 3+ concurrent workstreams (Tranche-based or simultaneous Tier A workstreams), include an environment capacity planning note: (1) concurrent test cycle execution assumes sufficient environment capacity; (2) environment capacity validated during Phase 0; (3) where contention occurs, sequencing coordinated through governance framework to protect tranche milestones."
- **Impact:** Low-Medium — genuine multi-workstream constraint; currently partially covered by Phase 0 exit criteria but not named as a capacity constraint pattern.
- **Derived from:** Manulife 7-workstream proposal — ChatGPT 5.4 third-pass review, March 23, 2026
- **Status:** Pending
- **Priority:** Low

---

### Improvement Proposal: IP-MAN-07
- **Observation:** Phase 0 Exit Criteria condition "Automation coverage baseline established" (added by IP-MAN-04) is stated without specifying what constitutes a baseline. The condition is verifiable in principle but not in practice — without a shared definition of what the baseline documents, delivery teams and evaluators cannot confirm it has been met.
- **Root Cause:** IP-MAN-04 correctly mandated the Exit Criteria table, but the coverage baseline condition is generic. A verifiable condition must state exactly what will be measured and reported.
- **Suggested Change:** Refine the Phase 0 exit criteria coverage baseline condition (in `stage-9-output-structure.md` and `AGENTS.md` Stage 6) from: "Automation coverage baseline established" to: "Automation coverage baseline established — documenting automation coverage % per workstream, critical path coverage completeness (pass/fail), and regression suite readiness level (ready / conditional / not ready)."
- **Impact:** Low — the substance is already present; this is a precision improvement that makes condition 4 verifiable rather than aspirational.
- **Derived from:** Manulife 7-workstream proposal — ChatGPT 5.4 third-pass review, March 23, 2026
- **Status:** Pending
- **Priority:** Low

---

### Design Decision: IP-MAN-08 (Gap 4 — Dependency Failure Handling — NOT IMPLEMENTING)
- **Gap identified by:** ChatGPT 5.4 third-pass review, March 23, 2026
- **Proposed:** Add a `## Dependency Failure Handling` generic narrative paragraph describing the protocol when dependencies fail.
- **Assessment:** Negative ROI. The Section 18 Dependency Register with its "Impact if Missed" column already provides per-dependency, specific failure consequence statements for every dependency. A generic narrative paragraph replaces specific, per-dependency clarity with abstracted governance language. Specificity is more valuable than abstraction in dependency risk communication — evaluators reviewing a dependency register assess each dependency against its consequence, not against a generic protocol statement.
- **Decision:** Do NOT add a generic dependency failure narrative section. The existing per-dependency "Impact if Missed" column is the correct mechanism. If escalation is insufficiently visible, strengthen the cross-reference from Section 18 to Section 11 (escalation path) rather than adding abstraction.
- **Status:** Closed — design decision (no OS implementation)
- **Priority:** N/A

---

## Phase 17 Improvements — March 24, 2026

Derived from: Post-Phase 16 critical re-evaluation of Manulife 7-workstream proposal (4-lens: Review & Challenge Thinking). Seven new OS-layer gaps identified — 5 pure gaps (no rule exists), 2 partial gaps (prior IP partially addressed but incomplete).

---

### Improvement Proposal: IP-MAN-09
- **Observation:** The Stage 9 output rules have no guardrail preventing internal staff first names from appearing in client-facing submission sections. In the Manulife proposal, OC-001 contained "Sandeep / Praveen (Presales Lead)" and R-009 contained "Presales Lead (Praveen)" — both referencing internal R Systems staff by first name. Enterprise procurement panels treat this as unprofessional and it exposes internal org structure unnecessarily.
- **Root Cause:** No output hygiene rule exists for role designation vs. personal names. The OS produces output that names whoever is contextually referenced without sanitizing for client-facing submission context.
- **Suggested Change:** Add a **Submission Hygiene Rule** to `stage-9-output-structure.md` (and to `review-challenge-thinking/SKILL.md` as a review check): "All internal staff references in client-facing sections (OC, Risk Register, Team Structure, Governance Model) must use role designations only — e.g., 'R Systems QA Practice Lead', 'R Systems Presales Lead', 'R Systems Programme Delivery Lead'. First names and informal staff references must not appear in any section that will be read by client procurement, evaluation panel, or steering committee."
- **Impact:** Medium — credibility and professionalism risk; straightforward to enforce as a final-pass rule
- **Derived from:** Manulife 7-workstream proposal Phase 17 review, March 24, 2026 (RC-01)
- **Status:** Implemented — `stage-9-output-structure.md` § Submission Hygiene Rules; `review-challenge-thinking/SKILL.md` Completeness Checklist (Phase 17, Task A1)
- **Priority:** Medium

---

### Improvement Proposal: IP-MAN-10
- **Observation:** IP-MAN-05 added a Delivery Risk Ownership subsection naming the QA Lead as the single accountable owner. However, the proposal also has OC-002, R-007, and D-10 disclosing that the QA Lead is not yet confirmed. These disclosures appear in Sections 17, 19, and 18 respectively — 12+ sections after the ownership claim in Section 11. An evaluator reading Section 11 will not cross-reference to Section 17. The accountability claim contradicts its own disclosed risk without a co-located caveat.
- **Root Cause:** IP-MAN-05 specified producing the ownership statement and listing 4 monitoring responsibilities, but did not require a co-located parenthetical linking the ownership claim to the unconfirmed-role disclosure. These are independent pieces of content produced at different sections of the output, with no wiring between them.
- **Suggested Change:** Add to the IP-MAN-05 rule in `stage-9-output-structure.md`: "If OC-002 (or equivalent open condition for named QA Lead) is active at output time, include a parenthetical immediately following the QA Lead ownership statement: '*(QA Lead to be confirmed within 5 business days of award — see OC-002; interim pre-kick-off accountability: R Systems Programme Delivery Lead.)*' This disclosure must be co-located with the ownership claim — not separated by more than one section."
- **Impact:** High — an accountability claim that contradicts an undisclosed risk is a credibility landmine for evaluators. Co-location is the minimum required fix; downstream disclosure is insufficient.
- **Derived from:** Manulife 7-workstream proposal Phase 17 review, March 24, 2026 (RC-02)
- **Status:** Implemented — `stage-9-output-structure.md` § Section 11 Delivery Risk Ownership, Co-location Disclosure rule (Phase 17, Task A2)
- **Priority:** High

---

### Improvement Proposal: IP-MAN-11
- **Observation:** Section 8 of the Manulife proposal stated "Phase 0 kick-off: Week of March 30, 2026 (indicative)" — a hard calendar date when the proposal submission was March 23. This assumes a 7-day procurement cycle including evaluation, selection, negotiation, and contract execution. If award arrives in April (realistic), the entire WS-4 milestone chain collapses, yet the absolute date carries no assumption label declaring it is relative to award.
- **Root Cause:** The Stage 6 (Project Manager) and Stage 9 roadmap rules do not prohibit absolute calendar dates for Phase 0 kick-off. The OS has no rule requiring that Phase 0 start dates be expressed as relative to award date. When an agent populates a date, it anchors to the current date — which is always wrong for a competitive proposal because award timing is unknown.
- **Suggested Change:** Add a rule to Stage 6 Project Manager and Stage 9 Transformation Roadmap output rules in `stage-9-output-structure.md`: "Phase 0 kick-off dates must never be expressed as absolute calendar dates in RFP submissions. Use relative form: '[Award + N business days] (indicative)'. If absolute framing is required for a milestone table, add an explicit assumption label: '[ASSUMPTION-BASED — relative to award receipt; confirmed no later than Day 3 of Phase 0]'. All downstream milestone dates that are derived from Phase 0 kick-off inherit this relativity."
- **Impact:** High — absolute kick-off dates in competitive proposals are always wrong and can undermine every calendar-dependent commitment downstream
- **Derived from:** Manulife 7-workstream proposal Phase 17 review, March 24, 2026 (RC-03)
- **Status:** Implemented — `stage-9-output-structure.md` § Section 8 Phase 0 Kick-off Date Rule (Phase 17, Task A3)
- **Priority:** High

---

### Improvement Proposal: IP-MAN-12
- **Observation:** IP-MAN-07 correctly refined Phase 0 Exit Criterion Condition 4 to specify measurable dimensions: "automation coverage % per workstream, critical path coverage completeness (pass/fail), and regression suite readiness level (ready / conditional / not ready)." However, the condition still has no pass threshold — Phase 0 can technically exit with 0% automation coverage and 'not ready' regression status as long as these are documented. Documenting a failing state is not the same as passing a gate.
- **Root Cause:** IP-MAN-07 (Insight 12) addressed the "what is measured" question but not the "what constitutes a PASS" question. These are two distinct requirements for a verifiable gate: a measurement definition and a pass/fail threshold. Specifying only the measurement produces a reporting condition, not a gate condition.
- **Suggested Change:** Extend IP-MAN-07's rule to require both (a) measurement specification AND (b) pass/fail threshold for every Phase 0 exit criterion. For the coverage condition specifically: "Phase 0 cannot exit if any Tier A workstream records 'not ready' on regression suite readiness without a client-approved recovery plan, or if critical path coverage completeness is 'fail' without an agreed remediation path." Apply the principle universally: all Phase 0 exit criteria must specify the condition under which the criterion passes — not only what is measured.
- **Impact:** High — an exit criterion without a threshold is a reporting activity, not a governance gate. Any governance-oriented evaluator will recognise this immediately.
- **Derived from:** Manulife 7-workstream proposal Phase 17 review, March 24, 2026 (RC-04); extends IP-MAN-07
- **Status:** Implemented — `stage-9-output-structure.md` § Section 8 Phase 0 Exit Criteria Pass/Fail Threshold Requirement (Phase 17, Task A4)
- **Priority:** High

---

### Improvement Proposal: IP-MAN-13
- **Observation:** When the Risk Register names a workstream-specific dedicated sub-team (e.g., "dedicated SDET team for WS-7 from Phase 1; separate from WS-5/WS-6 resourcing"), Section 12 (Team Structure) does not automatically reflect this as a separate pool in the headcount summary. The Manulife proposal's Section 12 stated "4–6 SDETs" without disclosing the additional 2–3 dedicated WS-7 SDETs — understating real team commitment by up to 40%.
- **Root Cause:** The Team Structure section production rule and the Risk Register production rule operate independently. There is no cross-section coherence rule requiring that risk mitigations involving dedicated resource sub-pools be reflected as explicit allocations in the Team Structure section. When a risk register entry says "dedicated team," the System produces it in isolation without checking whether Section 12 accounts for it.
- **Suggested Change:** Add a cross-section coherence rule to the Stage 9 Team Structure section production logic in `stage-9-output-structure.md`: "Before finalizing the Team Structure section headcount summary, scan all Risk Register entries for dedications, pools, or workstream-specific resource commitments. If any risk mitigation names a dedicated sub-team separate from the primary pool, that sub-pool must appear as a named allocation in Section 12. Produce the full headcount as a sum: primary pool + all named sub-pools. If Tranche 1 and Tranche 2 have separate pools, show the rollup and the per-tranche split."
- **Impact:** High — understating team size in the Team Structure section while citing dedicated pools in the Risk Register is an internal contradiction that evaluators will catch; it also weakens the proposal's delivery credibility
- **Derived from:** Manulife 7-workstream proposal Phase 17 review, March 24, 2026 (RC-05)
- **Status:** Implemented — `stage-9-output-structure.md` § Section 12 Cross-Section Headcount Coherence (Phase 17, Task A5)
- **Priority:** High

---

### Improvement Proposal: IP-MAN-14
- **Observation:** IP-MAN-05 added the Programme Governance Forum sentence (weekly meeting during active execution phases, comprising QA and Delivery Leads from both organisations). However, no Manulife role was named in the forum description, and no dependency was added to the Dependency Register covering Manulife's participation commitment. Without a named Manulife participant or a dependency entry, the governance forum is a unilateral vendor commitment — it cannot function as a joint forum if the client hasn't committed to attending.
- **Root Cause:** IP-MAN-05 specified the forum's membership in abstract terms ("QA leads and Delivery Leads from both organisations") without requiring a named Manulife role or a corresponding dependency. The forum exists in narrative text only — there is no governance mechanism ensuring Manulife's participation is a tracked and mutual commitment.
- **Suggested Change:** Extend IP-MAN-05's Delivery Risk Ownership rule to require two additions: (1) Name the client-side participant by role in the forum description — e.g., "specifically, the R Systems QA Lead and the [Client] Test Manager or nominated Delivery Lead." If the client role is not yet confirmed, use "[Client]-nominated Delivery Lead." (2) Add a corresponding dependency entry via the Stage 4 dependency logging rule, and require Stage 9 Section 18 to verify its presence and flag if missing: "D-[n]: [Client] Governance Forum participant nominated — Owner: [Client] — Status: Open — Phase 0 Day 1 confirmation required — Impact if missed: Weekly forum cannot convene with joint authority; governance escalation path is weakened."
- **Impact:** Medium — joint governance without a named client-side participant is a structural gap; adding the dependency makes it a trackable commitment rather than an assumed one
- **Derived from:** Manulife 7-workstream proposal Phase 17 review, March 24, 2026 (RC-07); extends IP-MAN-05
- **Status:** Implemented — `stage-9-output-structure.md` § Section 11 Delivery Risk Ownership, Governance Forum Participant rule + Dependency Register entry (Phase 17, Task A2)
- **Priority:** Medium

---

### Improvement Proposal: IP-MAN-15
- **Observation:** The Application Clustering Framework (Section 14) presents a per-workstream component breakdown table. In the Manulife proposal, the component sum (199) was materially larger than the application count used for estimation (41) — a 4.85× difference. No sentence in Section 14 explained the relationship between the two figures. An evaluator reading Section 4 (effort based on 41 applications) and then Section 14 (199 components with the same scope label) will legitimately challenge the estimation basis.
- **Root Cause:** The Section 14 production rule has no requirement to reconcile the component-level view with the application-level view used for estimation. The two figures are produced independently by different agents (Estimation sizing produces the application count; Application Clustering produces the component breakdown) with no cross-reference rule.
- **Suggested Change:** Add a rule to the Application Clustering Framework section production in `stage-9-output-structure.md`: "If the per-workstream component sum in the clustering table differs from the application count stated in Section 4, include a reconciliation sentence immediately after the scope header: '[Component count] components above represent the full microservice and application decomposition of the [application count] named in-scope applications. Effort estimates were sized at workstream level against this component surface; the [application count]-application figure reflects the application-ownership layer, not the component count.' This prevents evaluators from treating the component count as the estimation basis."
- **Impact:** Medium — without reconciliation, the proposal creates an exploitable ambiguity about what the estimate was actually based on; a two-sentence addition eliminates this risk entirely
- **Derived from:** Manulife 7-workstream proposal Phase 17 review, March 24, 2026 (RC-09)
- **Status:** Implemented — `stage-9-output-structure.md` § Section 14 Component-to-Application Reconciliation (Phase 17, Task A6)
- **Priority:** Medium

---

## Phase 21 Deferred Items — March 30, 2026

Gaps GAP-8 through GAP-12, identified during Phase 20 (Manulife vendor questionnaire integration). Deferred from Phase 21 scope as MEDIUM severity. CRITICAL and HIGH gaps (GAP-1 through GAP-7) were implemented in Phase 21 Commits A and B.

### Improvement Proposal: IP-MAN-16
- **Observation:** No rule requires confirmation of current automation coverage percentages before citing them in proposals. During Phase 20, the automation coverage baseline (0% for Angular upgrade apps) was inferred from the absence of evidence rather than confirmed from a client-supplied artefact.
- **Root Cause:** GAP-8 — No automation baseline confirmation protocol in the OS extraction or Stage 0 discovery rules.
- **Suggested Change:** Add a rule to Stage 0 or Stage 1 extraction: "If the proposal will cite automation coverage as a baseline figure, the figure must be sourced from a confirmed artefact (test management report, CI dashboard export, client declaration). If no artefact is available, the coverage baseline must be declared as `[UNCONFIRMED — to be validated in Phase 0]` and must not be cited as a known figure in the proposal body."
- **Impact:** Low frequency — only affects initial engagement scoping where baseline data is absent; partially mitigated by `[INFERENCE-BASED]` annotation rule (GAP-3, Phase 21 Commit B)
- **Derived from:** Phase 20 vendor questionnaire integration, March 30, 2026
- **Status:** Deferred
- **Priority:** Medium

### Improvement Proposal: IP-MAN-17
- **Observation:** Environment count (e.g., DEV, SIT, UAT, UAT-DR) is not tracked as a proposal-wide constant. During Phase 20, the environment count was mentioned inconsistently across sections — NFR testing referenced 4 environments while other sections implied 3.
- **Root Cause:** GAP-9 — No OS rule establishing environment count as a tracked, proposal-wide variable checked for consistency.
- **Suggested Change:** Add environment count to the list of proposal-wide constants tracked in `claude-memory/notes.md` at Stage 1 (alongside application count, component count). Add a cross-section consistency check to Stage 7 Pre-Processing: "Verify environment count is consistent across Sections 7 (NFR), 8 (Roadmap), and 13 (KPIs). Flag any discrepancy as a Stale Reference Sweep finding."
- **Impact:** Medium — partially mitigated by the Stale Reference Sweep lens (GAP-5, Phase 21 Commit B), which will catch numeric constant inconsistencies during post-edit review
- **Derived from:** Phase 20 vendor questionnaire integration, March 30, 2026
- **Status:** Deferred
- **Priority:** Medium

### Improvement Proposal: IP-MAN-18
- **Observation:** No rule defines how quickly new client artefacts must be integrated once received. During Phase 20, vendor questionnaire responses arrived mid-engagement and were integrated on the same day, but there is no OS-enforced deadline or integration SLA.
- **Root Cause:** GAP-10 — No client-response integration deadline rule in the OS. This is a process discipline gap rather than a system rule gap.
- **Suggested Change:** Add a note to Stage 0 Artifact Discovery (or a client engagement checklist): "When new client artefacts arrive after Stage 0 closes, the operator must register them in `claude-memory/artifacts.md` within the same working session and trigger the re-entry protocol (see `AGENTS.md` — Evidence Re-Entry Protocol) within one session of receipt. Artefacts not integrated within one session must be flagged in `claude-memory/notes.md` as `[PENDING INTEGRATION — received YYYY-MM-DD]`."
- **Impact:** Low — process discipline issue; the Evidence Re-Entry Protocol (GAP-1, Phase 21 Commit A) addresses the integration mechanics; this adds a timeliness expectation
- **Derived from:** Phase 20 vendor questionnaire integration, March 30, 2026
- **Status:** Deferred
- **Priority:** Medium

### Improvement Proposal: IP-MAN-19
- **Observation:** Section 7 (Risks & Assumptions) lacks a formal escalation pattern for dependencies that block multiple workstreams simultaneously. During Phase 20, the Syncsort/Kafka decommission dependency blocked 4 workstreams but was only recorded as a single dependency entry with no cross-workstream impact signal.
- **Root Cause:** GAP-11 — No blocker dependency escalation pattern in Section 7 or the Dependency Register rules. Single-entry dependencies with multi-workstream impact are indistinguishable from single-workstream dependencies.
- **Suggested Change:** Add a rule to Section 18 (Dependency Register) production: "If a dependency impacts 2 or more workstreams, annotate it with `[CROSS-WORKSTREAM BLOCKER — N workstreams affected]` and add a corresponding risk entry to Section 17 (Risk Register) with Impact = High. The risk entry must name the affected workstreams explicitly." This can be folded into the next Section 7/18 rules revision.
- **Impact:** Medium — cross-workstream blocker dependencies are high-visibility risks for client evaluation panels; making them structurally distinct from single-workstream dependencies improves proposal defensibility
- **Derived from:** Phase 20 vendor questionnaire integration, March 30, 2026
- **Status:** Deferred
- **Priority:** Medium

### Improvement Proposal: IP-MAN-20
- **Observation:** No rule requires explicit declaration of mobile testing scope (in-scope, out-of-scope, or deferred to Phase 0) when mobile apps or mobile channels are mentioned in RFP artefacts. During Phase 20, the Manulife recruitment platform RFP mentioned candidate-facing portal access but did not specify whether a mobile app existed — this was left unaddressed.
- **Root Cause:** GAP-12 — No mobile testing scope declaration rule in the OS. Mobile scope is a common Unresolved Condition that evaluators expect to see addressed.
- **Suggested Change:** Add a check to `scope-completeness-validator/SKILL.md`: "If RFP artefacts mention a candidate-facing, customer-facing, or employee-facing portal or application, verify whether mobile access is in scope. If no explicit mobile scope declaration is found, add an Open Condition: `OC-[n]: Mobile testing scope not declared — to be confirmed during Phase 0 discovery. In-scope mobile testing will be accommodated within the existing team structure; out-of-scope mobile testing will be scoped separately if required.`"
- **Impact:** Low-Medium — absence of mobile scope declaration is a common evaluator flag; one-line OC eliminates the ambiguity without over-committing
- **Derived from:** Phase 20 vendor questionnaire integration, March 30, 2026
- **Status:** Deferred
- **Priority:** Medium

### Improvement Proposal: IP-MAN-21
- **Observation:** The Cross-Reference Update Rule in `AGENTS.md` (Post-Output Evidence Re-Entry Protocol) mandates "All cross-references in `claude-memory/notes.md` that cite superseded findings MUST be updated" but provides no search strategy. For a 150+ finding engagement, this is operationally intractable without a defined approach — practitioners have no guidance on how to discover all affected references.
- **Root Cause:** Phase 21 Commit A added the Cross-Reference Update Rule but focused on what must be done, not how to discover affected references at scale. Discovery mechanism was implicit.
- **Suggested Change:** Add an operational note to the Cross-Reference Update Rule: "To identify all cross-references to a superseded finding, search `claude-memory/notes.md` for the superseded Finding ID (e.g., `F-12`). If more than 20 references are found, raise a HITL checkpoint before bulk-updating — confirm scope of change with user before proceeding. Document all updated references in the Re-Entry Impact Assessment."
- **Impact:** Medium — without a search strategy, operators may miss references, leaving stale Finding IDs in notes.md that mispoint to superseded findings
- **Derived from:** Phase 21 R&C quality gate review, March 30, 2026
- **Status:** Deferred
- **Priority:** Medium

### Improvement Proposal: IP-MAN-22
- **Observation:** The `## Phased Finding Sets` section in `evidence-reconciliation/SKILL.md` blocks Stage 8 clearance when an unresolved `CONTRADICTED` relationship exists, but does not define what constitutes "resolved". Practitioners cannot consistently determine when a contradiction has been sufficiently addressed to clear the block.
- **Root Cause:** Phase 21 Commit A defined the blocking rule but omitted resolution criteria. The three acceptable resolution paths (supersede one finding, reclassify confidence, or accept both with explicit acknowledgement in an Open Condition) were not codified.
- **Suggested Change:** Add a resolution definition to the blocking rule in `evidence-reconciliation/SKILL.md`: "A `CONTRADICTED` relationship is resolved when: (a) one finding is marked `Status: SUPERSEDED — see [new Finding ID]`, or (b) both findings are re-examined and one is reclassified (e.g., downgraded from HIGH to LOW confidence with documented rationale), or (c) the conductor explicitly acknowledges the unresolved contradiction in the proposal's Appendix as an Open Condition before Stage 8 clears."
- **Impact:** Medium — without resolution criteria, Stage 8 blocks can become permanent, stalling engagement; the three-path resolution rule provides deterministic exit
- **Derived from:** Phase 21 R&C quality gate review, March 30, 2026
- **Status:** Deferred
- **Priority:** Medium
