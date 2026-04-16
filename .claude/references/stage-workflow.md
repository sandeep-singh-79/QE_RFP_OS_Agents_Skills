# Stage Workflow Reference

> **Used by:** Conductor. Load at Stage 0 before beginning workflow execution.
> **Specialist agents** (Test Architect, QA Manager, Project Manager, Client Evaluator) do not need to load this file — their scope is defined in the Agent Context Scope table in `AGENTS.md` and their own agent files.
> **Do not pre-load.** This file is explicitly loaded by the Conductor at Stage 0.

This file is the authoritative procedure reference for the QE OS canonical workflow (Stages 0–10), stage re-entry, and post-output evidence re-entry.

---

## System Stage Executors

Stages 0–3 are conductor-managed. Agent analysis begins at Stage 4.

| Stage | Executor |
|---|---|
| Stage 0 — Artifact Discovery | Conductor |
| Stage 1 — Evidence Extraction | Conductor (using `evidence-extraction` skill) |
| Stage 2 — Memory Initialization | Conductor |
| Stage 3 — Gap Coverage Enforcement | Conductor |
| Stage 3.5 — Capability Coverage Check | Test Architect (Capability Coverage skill) |
| Stage 4 — Solution Design | Test Architect |
| Stage 5 — Architecture Validation | QA Manager |
| Stage 6 — Delivery Validation | Project Manager |
| Stage 7 — Client Perspective Review | Client / RFP Evaluator (Conductor pre-processing) |
| Stage 8 — Governance Validation | Conductor (Evidence Reconciliation skill) |
| Stage 9 — Output Generation | Conductor (Review & Challenge quality gate) |
| Stage 10 — System Learning | Conductor |

---

## Conductor Responsibilities

The conductor manages Stages 0–3 and oversees Stage 7 pre-processing, Stage 8 coordination, and Stage 9 quality gate sequencing. Full governance enforcement obligations, HITL escalation, plan.md update discipline, context compaction procedures, and stage failure recovery are defined in `agents/conductor.md`.

Summary:
1. **Update `plan.md` after each stage** — set stage status to `Complete`; set to `In Progress` during a stage.
2. **Enforce checkpoint conditions** — do not advance if the checkpoint condition is not met.
3. **Surface Blocking HITL conditions** — halt stage advancement and surface the decision requirement to the user.

---

## Stage 0 — Artifact Discovery
  Purpose:    Identify and index all available knowledge sources
  Action:     Register artifacts in `claude-memory/artifacts.md` with type classification. Identify missing artifact categories (e.g., architecture diagrams, CI/CD pipeline description, test inventory) and record them in `claude-memory/notes.md` under "Missing Artifacts".
  Checkpoint: Confirm artifact inventory is complete before proceeding
  Output:     Populated `claude-memory/artifacts.md`

  **Engagement Details — populate `plan.md` at Stage 0:**
  Complete the Engagement Details block in `plan.md` before advancing to Stage 1:
  - Client: [client name from artifacts]
  - RFP / Document: [document name or reference]
  - Engagement Started: [date]
  - Discovery Maturity: [Constrained / Moderate / Deep — see below]
  - Engagement Type: [managed_service / transformation_partnership / retained_qe_delivery / standalone_project / qa_audit — see Engagement Type Classification below]
  - Application Count: [integer — number of in-scope applications; use 1 if not specified or not determinable from artifacts]
  - Engagement Signals: [comma-separated list of applicable signals — see Engagement Signal Classification below; use `none` if no signals detected]
  - Regulatory Context: [Explicit / Inferred ([framework], confidence [score]) / Unknown — see Regulatory Context Classification below]
  - Current Stage: Stage 0 — Artifact Discovery

  **Classification reference:** Load `.claude/references/stage-0-inputs.md` to determine valid values for Discovery Maturity, Engagement Type, Engagement Signals, Regulatory Context, and the Vendor Capability Manifest schema. This file also defines determination criteria, detection indicators, and downstream behaviour rules for each field.

  **Regulatory Context Classification — mandatory at Stage 0:**
  Infer applicable regulatory framework using domain × geography lookup in `.claude/references/domain-regulatory-map.md`. Write result to `plan.md` Engagement Details under `Regulatory Context`. If confidence < 1.0, raise Open Condition: "OC — Regulatory context inferred (confidence [score]). Confirm applicable frameworks before submission." If no match and no artefact reference, set `Unknown`.
  Classification values, determination procedure, and downstream behaviour: see `Regulatory Context Classification` in `.claude/references/stage-0-inputs.md`.

  **Incumbent Vendor Confirmation — mandatory at Stage 0:**
  Perform dual-path incumbent vendor detection before Stage 0 closes. Record confirmed signal in `plan.md` Engagement Signals as `incumbent_vendor_present ([vendor name])`. If confirmed no, leave signal absent. If unanswerable, raise Open Condition: "OC — Incumbent vendor status unconfirmed. Section 15 may be suppressed. Confirm before submission." Write to `claude-memory/notes.md`.
  Full detection procedure, named vendor list, and confirmation prompt wording: see `Incumbent vendor — dual-path detection` in `.claude/references/stage-0-inputs.md`.

  **Dependency Register Initialisation — mandatory at Stage 0:**
  Append the `## Dependency Register` section to `claude-memory/notes.md` using the template defined in `.claude/SETUP.md` (notes.md initial sections). This register is progressively populated at Stages 4, 5, and 6. Stage 9 Section 18 renders it — it does not rebuild it from scratch.

  **Manifest loading rule:** If a Vendor Capability Manifest is provided, the conductor writes vendor capability data to `claude-memory/memory.md` under `## Vendor Capability Manifest`:
  ```
  ## Vendor Capability Manifest
  Vendor: [vendor_name]
  Platform: [ai_platform_name]
  | Accelerator | Description | Effort Saving Claim | Tier | Phase Viable From |
  |---|---|---|---|---|
  | [name] | [description] | [claim] | [1/2] | [phase] |
  ```
  If no manifest is provided, skip this step — absence of a manifest does not block workflow progress.

  **Client Q&A responses:** If Q&A responses arrive after Stage 0 closes, they are registered as new artifacts and processed via the Stage Re-Entry — New Evidence Integration procedure. Q&A responses do not require re-running Stage 0 — they are appended to `claude-memory/artifacts.md` and processed through Stage 1 re-entry.

## Stage 1 — Evidence Extraction
  Purpose:    Extract structured findings from all registered artifacts
  Actions:    (1) Scan artifacts, classify findings, populate `claude-memory/memory.md`. (2) Read `Regulatory Context` from `plan.md` Engagement Details — set at Stage 0. Use the inferred frameworks to classify compliance-related findings during extraction (e.g., tag findings as `Evidence Type: Compliance Requirement` where applicable). Do not re-run domain × geography inference — it was completed at Stage 0. See `evidence-extraction` skill for full extraction instructions.
  Checkpoint: Confirm all artifacts have status = Evidence Extracted or Not Applicable
  Output:     Populated `claude-memory/memory.md` with sourced, timestamped, confidence-rated findings; compliance-related findings tagged where regulatory context applies; `## Technology Inventory` table populated (all named tools, platforms, and frameworks classified as Confirmed / Present / Legacy)

## Stage 2 — Memory Initialization
  Purpose:    Confirm workspace memory is ready for agent-level analysis
  Action:     Verify `claude-memory/memory.md` findings are sufficient. Populate `claude-memory/notes.md` with engagement context. Load `claude-memory/insights.md` for relevant prior patterns. **Verify the `## Extraction Completeness` block written by Stage 1 in `claude-memory/memory.md`.** If `Extraction status = Partial`, note which artifacts were not processed and record whether the missing context blocks downstream analysis in `claude-memory/notes.md`. Do not advance to Stage 3 if critical artifacts (e.g., the RFP itself) are unprocessed.
  Checkpoint: Confirm minimum context is available for downstream agents; Extraction status is `Complete` or declared `Partial` with rationale
  Output:     Workspace memory files ready

  **Regulatory Context Handoff:**
  During Stage 2, confirm the `Regulatory Context` field is populated in `plan.md` Engagement Details (set by Stage 0). Note the inferred or explicit frameworks in `claude-memory/notes.md` for the Test Architect:
  Format: `Regulatory Context (Stage 0): [value from plan.md — Explicit / Inferred ([framework], confidence [score]) / Unknown]`
  The Test Architect reads this at Stage 4 to align architecture pillars with applicable compliance requirements. If `Regulatory Context = Unknown`, note this explicitly so Stage 4 does not assume a regulatory framework.

## Stage 3 — Gap Coverage Enforcement
  Purpose:    Ensure all High-confidence findings have been accounted for
  Action:     Cross-reference `claude-memory/memory.md` against known requirements from artifacts. **Scope: All High-confidence findings must be accounted for — none may be omitted. Medium-confidence findings should be included and are required to remain visible but do not block Stage 3 closure if unresolved.**
  Checkpoint: Every High-confidence finding is either addressed, explicitly acknowledged as out of scope, or formally deferred with all required fields declared. No known gap may disappear silently.
  Output:     Gap coverage report — addressed / out-of-scope / unresolved / deferred
  Storage:    Write gap coverage report to `claude-memory/notes.md` under heading `## Gap Coverage`
              Begin the section with: `Discovery Maturity: [value from plan.md]` — this allows Stage 8 to access Discovery Maturity without loading plan.md.
              Format: | Finding ID | Confidence | Status | Resolution |
              Valid Status values:
              - `Addressed` — finding is covered in the solution output
              - `Out-of-Scope` — finding is explicitly acknowledged as out of scope with stated rationale
              - `Unresolved` — finding has no resolution; requires escalation or HITL
              - `Deferred to Transition — Explicitly Declared` — finding cannot be validated pre-award; valid only when all three required fields are declared (see below)
              Example row: `| F12 | High | Unresolved | CI/CD integration undefined |`

  **Deferred to Transition — Required Fields:**
  A finding may use `Deferred to Transition — Explicitly Declared` status only when all three of the following are declared in the Resolution column in `claude-memory/notes.md` (`## Gap Coverage`):
  1. `Discovery Limitation` — what access or evidence was not available pre-award
  2. `Pre-award constraint rationale` — why validation was not possible before award
  3. `Transition validation deliverable` — what will be produced post-award to close this gap

  If any field is missing, status must revert to `Unresolved`. The evidence-reconciliation skill enforces this at Stage 8 with marker `⚠ INCOMPLETE DEFERRAL`.

  **Constrained Discovery note:** When Discovery Maturity = `Constrained` (set at Stage 0), expected gaps may use `Deferred to Transition — Explicitly Declared` where the missing evidence is a direct consequence of the constrained access model, provided all three required fields are declared.

## Stage 3.5 — Capability Coverage Check
  Skill:      Capability Coverage Thinking (mandatory)
  Purpose:    Evaluate QE capability coverage against the baseline — independent of what was raised in artifacts
  Action:     Compare `claude-memory/memory.md` findings against all nine QE capability domains in `qe-capability-map.md`
  Checkpoint: All nine domains assessed; Missing and Partial domains documented; no `Missing` domain without a declared remediation path advances without HITL
  Output:     Capability coverage table — Capability / Status / Evidence / Recommendation / Expected Benefit

  **Blocking HITL condition — Stage 3.5:**
  After producing the capability coverage table, the capability-coverage skill applies its HALT Protocol (see `.claude/skills/capability-coverage/SKILL.md` — `## HALT Protocol` for the authoritative procedure, response options, and gate logic). Stage 4 may not begin until every `Missing` domain has a declared remediation or human HITL confirmation. The absence of evidence is acceptable; the absence of acknowledgement is not.

> **Optional — Question → Capability Mapping:** If RFP questions exist in artifacts and Stage 3.5 is complete, the Test Architect may invoke the `question-capability-mapping` skill before Stage 4. Activation requires: (1) RFP questions present in artifacts, (2) Stage 4 not yet started, (3) Stage 3.5 complete. The skill maps question wording to underlying capability expectations and writes results to `claude-memory/notes.md`. See `.claude/skills/question-capability-mapping/SKILL.md` for HALT conditions.

## Stage 4 — Solution Design (Architecture Review)
  Agent:      Test Architect
  Skill:      QE Architect Thinking (mandatory first)
  Input:      `claude-memory/memory.md` findings (including `## Vendor Capability Manifest` if present) + gap coverage report (from `claude-memory/notes.md` — `## Gap Coverage`) + regulatory context (from `claude-memory/notes.md` — `Regulatory Context (Stage 0)`, set at Stage 2) + capability coverage output (Stage 3.5) + question capability mapping output (if available)
  Classification reference: Load `.claude/references/stage-4-classifications.md` for Benefit Realisability Classification, Risk-Based Test Classification, and Application Clustering Draft procedures, formats, and rules.
  Checkpoint: Architecture layer completeness confirmed before tooling validation
  Output:     Architecture findings, layer gaps, tooling readiness
  **Estimation boundary:** Any sizing produced at Stage 4 by the Test Architect is directional and architecture-context only — it is NOT a deliverable estimate. The Stage 6 Project Manager estimate (Estimation & Sizing Thinking) is the authoritative sizing for all proposal submissions and supersedes Stage 4 directional sizing.
  **Output staging:** Append Stage 4 output to `outputs/staged-proposal.md` under `## Stage 4 — Solution Design`. Create the file with the header defined in `.claude/SETUP.md` if it does not exist.

  **Expected Client Outcomes — mandatory at Stage 4:**
  After defining architecture pillars, the Test Architect must synthesise 3–7 Expected Client Outcomes and write them to `claude-memory/notes.md` under `## Expected Client Outcomes`. These are business-outcome statements from the client's perspective — not capability labels, not tool names, not architecture pillar names.

  Format:
  ```
  ## Expected Client Outcomes
  | Business Outcome | Driven By | Phase |
  |---|---|---|
  | [outcome statement] | [architecture pillar + capability domain] | [Phase N] |
  ```

  Rules:
  - Minimum 3 outcomes; maximum 7. If fewer than 3 can be supported by evidence, declare: "Fewer than 3 client outcomes identified — remaining outcomes to be confirmed in Phase 0." Do not fabricate outcomes.
  - Each outcome must be traceable to at least one architecture pillar OR at least one capability coverage finding (Missing/Partial domain addressed by the solution).
  - Outcomes are client-facing statements of value (e.g., "Reduced defect escape to production", "Faster release cycle with maintained quality confidence") — not internal architecture descriptions.
  - Anti-fabrication guard: Do not invent percentages, dollar figures, or benchmark claims. Quantified outcomes require a sourced Finding ID or must be prefixed `[ASSUMPTION: ...]` or `[ILLUSTRATIVE]`.
  - This section is consumed by Stage 9 Section 6 Part B — do not omit.

  **AI Capability Tier Classification — mandatory at Stage 4:**
  Classify each proposed AI/GenAI capability as `Tier 1` (LLM-prompt-based / SaaS / IDE extension — no specialist ML infrastructure; Phase 2-viable; OC-1 does **not** apply) or `Tier 2` (predictive models requiring training data / specialist ML resourcing / ML infrastructure; Phase 3–4; OC-1 **applies**). Unclassified AI capabilities must not be assigned a phase. Full classification table and examples: see `## AI Capability Tier Classification` in `.claude/references/stage-4-classifications.md`.

  **Benefit Realisability Classification — mandatory at Stage 4:**
  For each benefit claim, classify as `Unconditional`, `Conditional — Client Infrastructure`, or `Conditional — Vendor Delivery`. Unarticulated claims must not pass Stage 4. Write to `claude-memory/notes.md` under `## Benefit Claim Classification`.
  Classification values, rules, and column format: see `Benefit Realisability Classification` in `.claude/references/stage-4-classifications.md`. This table is consumed by Stage 9 Section 10.

  **Risk-Based Test Classification — conditional at Stage 4:**
  Activation condition: `application_count > 1` OR Discovery Maturity = `Deep`. When active, produce a 3-tier risk classification table before architecture pillars are finalised.
  Activation rules, tier determination, format, and minimum requirements: see `Risk-Based Test Classification` in `.claude/references/stage-4-classifications.md`. This table is referenced by Stage 9 Section 7.

  **Application Clustering Draft — conditional at Stage 4:**
  Activation condition: `application_count > 1`. When active, produce preliminary application clustering from Stage 1 evidence. Write to `claude-memory/notes.md` under `## Application Clustering Draft`.
  Tier model (A/B/C), column format, and consumption rules: see `Application Clustering Draft` in `.claude/references/stage-4-classifications.md`.

  **Transition Planning Stub — conditional at Stage 4:**
  Activation condition: `incumbent_vendor_present` confirmed in `plan.md` Engagement Signals (set at Stage 0). When active, write a Transition Planning Stub to `claude-memory/notes.md` under `## Transition Planning Stub` with the following minimum fields:
  - `Incumbent Vendor:` [named vendor, or `[CLIENT CONFIRMATION REQUIRED]` if name unavailable]
  - `Preliminary Parallel Run:` [estimated phase range, e.g., "Phase 0–1"]
  - `Known Handover Dependencies:` [knowledge transfer, data access, tool handover, credential transfer]
  Stage 6 must consume this stub when constructing phase durations — parallel run period must be reflected in Phase 0–1 timing and duration estimates.
  Stage 9 §15 expands this stub into the full Transition Model section — do not reconstruct from scratch at Stage 9.
  **If `incumbent_vendor_present` is not confirmed or is at OC status:** do NOT produce a stub — wait for HITL confirmation before transition planning begins.

  **Dependency Register — Stage 4 contribution:**
  For each architecture pillar or benefit claim, check: does this require a client-controlled decision that is not yet confirmed? If yes, log an entry to `## Dependency Register` in `claude-memory/notes.md`.

  **Governance Forum participation dependency — Stage 4 (IP-MAN-14):**
  If `engagement_type` ∈ {`transformation_partnership`, `managed_service`} AND `application_count` >= 3 (i.e., the Delivery Risk Ownership subsection will be generated): log a dependency entry for client-side governance forum participant nomination. Format (5 fields, canonical schema):
  `D-[n] | Stage 4 | [Client] governance forum participant nominated — [Client] Delivery Lead or equivalent confirmed to participate in joint weekly governance forum from Phase 1; if not confirmed by Phase 0 Day 1, forum cannot convene with joint authority and escalation path is weakened | Client | Open`

  **Vendor Capability Manifest — Stage 4 consumption:**
  If `## Vendor Capability Manifest` is present in `claude-memory/memory.md`, the Test Architect reads it and populates relevant architecture pillars with vendor tool names and tier-appropriate phases. Tier assignments in the manifest are accepted for named vendor tools and do not require independent reclassification unless conflicting evidence exists.

  **Tooling Three-Tier Framing — mandatory at Stage 4 and Stage 9:**
  Classify all proposed tooling as `Confirmed` (currently in use — list without caveat), `Suggested` (new capability — "Suggested — subject to Phase 0 confirmation"), or `Proposed — Vendor Platform` (from Vendor Capability Manifest — "Proposed — subject to Phase 0 assessment"). Confirmed tools are named without deferral. Stage 9 tooling tables must display the tier label alongside tool name and rationale. Full tier definitions and output framing strings: see `## Tooling Three-Tier Framing` in `.claude/references/stage-4-classifications.md`.

## Stage 5 — Architecture Validation (Execution Feasibility)
  Agent:      QA Manager
  Input:      Stage 4 output
  Skill:      Assumption & Dependency Management
  Checkpoint: Adoption risks classified and surfaced
  Output:     Adoption risk, team sustainability findings
  **Output staging:** Append Stage 5 output to `outputs/staged-proposal.md` under `## Stage 5 — Architecture Validation`. Create the file with the header defined in `.claude/SETUP.md` if it does not exist.

  **SME Demand Impact — named evaluation prompt at Stage 5:**
  As part of adoption risk assessment, explicitly evaluate: "Does the proposed transformation increase upfront SME demand before tools reduce it?"
  - If yes: classify as HIGH adoption risk and raise in the Risk Register immediately. The QA Manager must produce a mitigation recommendation (e.g., phased onboarding, SME rotation model, knowledge documentation sprint) before Stage 5 findings are passed to Stage 6.
  - If no: note the absence of SME demand spike as a positive adoption signal.

  **Dependency Register — Stage 5 contribution:**
  For each adoption risk identified, check: does the mitigation depend on a client action or decision? If yes, log an entry to `## Dependency Register` in `claude-memory/notes.md`.

## Stage 6 — Delivery Validation
  Agent:      Project Manager
  Input:      Stage 4 + 5 output
  Skill:      Estimation & Sizing Thinking (if timelines in scope)
  Checkpoint: All delivery dependencies identified and classified
  Output:     Sequencing risks, dependency gaps, planning realism findings
  **Output staging:** Append Stage 6 output to `outputs/staged-proposal.md` under `## Stage 6 — Delivery Validation`. Create the file with the header defined in `.claude/SETUP.md` if it does not exist.

  **Application Clustering — Stage 6 consumption:**
  If `## Application Clustering Draft` is present in `claude-memory/notes.md` (written at Stage 4), the Project Manager reads tier assignments (Tier A/B/C) and uses them to validate phase sequencing and wave ordering. Delivery timelines that contradict cluster tier assignments must be flagged as sequencing risks.

  **Transition Planning Stub — Stage 6 consumption:**
  If `## Transition Planning Stub` is present in `claude-memory/notes.md` (written at Stage 4 when `incumbent_vendor_present` confirmed), the Project Manager reads the stub and incorporates the parallel run period into Phase 0–1 duration estimates. The parallel run window must be reflected as a named phase component — it is not a separate phase but a constraint on Phase 0–1 capacity and duration. If the stub declares `[CLIENT CONFIRMATION REQUIRED]` for the incumbent name, log an Open Condition before finalising Phase 0–1 estimates.

  **In-Sprint Automation Definition of Done — Stage 6 mandatory check:**
  Suppression: Skip this check for `qa_audit` and `standalone_project` engagement types.
  For all other engagement types: verify the delivery plan includes in-sprint automation as a Definition of Done requirement from Phase 1 onwards. If in-sprint automation is not present as a DoD element, flag as a delivery risk in Stage 6 output and log a Phase 1 governance action to `## Dependency Register` in `claude-memory/notes.md`.

  **Dependency Register — Stage 6 contribution:**
  For each delivery timeline or phase boundary, check: are there unconfirmed client dependencies that could affect delivery? If yes, log an entry to `## Dependency Register` in `claude-memory/notes.md`.

  **Phase 0 Exit Criteria — Stage 6 mandatory output (IP-MAN-04):**
  After producing the Phase 0 deliverable list and milestone, produce a `### Phase 0 Exit Criteria` subsection in the Stage 6 delivery plan output. This subsection is mandatory — a deliverable list alone is not sufficient. Exit criteria are the named, verifiable conditions that must all be satisfied before Phase 1 begins; they are not a restatement of the deliverable list.

  Format as a two-column table:
  | Exit Condition | How Verified |
  |---|---|

  Minimum required conditions:
  1. Test strategies for all in-scope workstreams reviewed and approved by client QA lead.
  2. Integration dependencies confirmed — named external systems and API availability dates agreed.
  3. Environment readiness validated — test environment provisioned and accessible by QE team.
  4. Automation coverage baseline established — documenting automation coverage % per workstream, critical path coverage completeness (pass/fail per workstream), and regression suite readiness level (ready / conditional / not ready).
  5. Test data availability confirmed — data provisioning approach agreed and first dataset available.
  6. Refined estimates approved — Phase 1 effort and team composition signed off by sponsor.

  Add the following escalation statement at the end of the subsection:
  > Phase 0 does not close with outstanding exit criteria. Any condition not satisfied at the Phase 0 review is escalated to the joint steering committee. Phase 1 start is contingent on all conditions being met — not on the Phase 0 calendar date.

  Suppression: Do not suppress this subsection for any engagement type. Exit criteria apply to all engagements with a Phase 0.

## Stage 7 — Client Perspective Review
  Agent:      Client / RFP Evaluator
  Input:      Structured findings from Stages 4–6 (after Outcome & Risk Framing → Structuring)
  Skills:     Outcome & Risk Framing → Structuring & Consulting Thinking (pre-processing)
  Checkpoint: Scoring risks and defensibility gaps surfaced
  Output:     Scoring risks, defensibility gaps, red flags
  **Output staging:** Append Stage 7 output to `outputs/staged-proposal.md` under `## Stage 7 — Client Perspective Review`. Create the file with the header defined in `.claude/SETUP.md` if it does not exist.

  **Execution Sequence (three-step):**
  - Step 1: Conductor applies Outcome & Risk Framing to frame Stages 4–6 findings in business impact and scoring consequence terms
  - Step 2: Conductor applies Structuring & Consulting Thinking to pre-process and structure the consequence-framed output
  - Step 3: Client / RFP Evaluator reviews the structured, consequence-framed output for scoring risks, defensibility gaps, and procurement red flags

  **Rule:** The Client / RFP Evaluator does not invoke Outcome & Risk Framing or Structuring & Consulting Thinking directly. It receives already-framed and pre-structured input from the Conductor.

## Stage 8 — Governance Validation
  Purpose:    Enforce governance rules before output generation
  Actions:
    1. **Evidence Reconciliation** — read gap coverage report from `claude-memory/notes.md` (`## Gap Coverage`) and the staged solution output from `outputs/staged-proposal.md`; verify all High-confidence findings from `claude-memory/memory.md` are addressed in the staged solution or explicitly acknowledged as out of scope. `Deferred to Transition — Explicitly Declared` findings are treated as resolved only if all three required fields are declared (Discovery Limitation, Pre-award constraint rationale, Transition validation deliverable). If any field is missing, reclassify as Unresolved and trigger Governance HITL.
    2. **Decision-Centric HITL check** — assess whether any decisions exceed the risk threshold requiring human approval
    3. **Proposal Quality Rules** — verify output meets quality standards
    4. **Evidence Validation** — verify every architectural recommendation references at least one of: a Finding ID, a capability domain from `qe-capability-map.md`, or an explicit declared assumption. Recommendations that fail must be marked `⚠ EVIDENCE GAP` before output is cleared
    5. **Regulatory Control Mapping sub-check** — if any finding in `claude-memory/memory.md` has Evidence Type = `Compliance Requirement` AND Regulatory Context = `Explicit`, a Control Mapping Table is required before Stage 9 is cleared. If absent, flag `⚠ REGULATORY TRACE GAP` and require Governance HITL before proceeding.
  Checkpoint: All governance checks pass, or human approval obtained for exceptions
  Output:     Governance clearance or list of items requiring human decision

  **Control Mapping Table format** (required when Action 5 triggers):
  | Regulation / Framework | Control Objective | Proposal Mechanism | Evidence Source | Gap / Confirmed |

## Stage 9 — Output Generation (Quality Gate)
  Skill:      Review & Challenge Thinking (MANDATORY)
  Input:      Full output from all prior stages + governance clearance
  Checkpoint: `plan.md` engagement fields validated; gap classification complete; section-level completeness check passed; submission readiness confirmed
  Output:     Challenged, reviewed output ready for delivery
  Post-gate:  Executive Communication skill (if executive-facing output required)

  **`plan.md` field validation — required before any output sections are generated:**
  Before rendering any output section, confirm the following fields in `plan.md` are set to explicit values (not template placeholders, empty brackets, or default text):

  | Field | Valid | Invalid (blocks output) |
  |---|---|---|
  | `Engagement Type` | One of: `managed_service`, `transformation_partnership`, `retained_qe_delivery`, `standalone_project`, `qa_audit` | `[engagement type]`, blank, or any value not in the list |
  | `Engagement Signals` | `none` or one or more valid signal values | `[none / comma-separated list]`, blank |
  | `Discovery Maturity` | `Constrained`, `Moderate`, or `Deep` | `[Constrained / Moderate / Deep]`, blank |
  | `Application Count` | An integer ≥ 1 | `[integer]`, blank |

  If any field is invalid, raise before generating output:

  ```
  ⚠ BLOCKING HITL — plan.md Engagement Fields Not Confirmed
  Field(s): [list each field at its invalid value]
  Issue: One or more Stage 0 classification fields are unset or at template defaults.
  Impact: Conditional output sections (e.g., Section 14 Application Clustering, Section 15 Transition
          Model, Section 16 TaaS Operating Model) will be incorrectly generated or suppressed.
  Required: Confirm the correct value for each listed field before Stage 9 proceeds.
  ```

  If `plan.md` does not exist, raise the HITL with field list = "all fields" and do not proceed.

  **Self-validation loop — required before the quality gate clears:**
  Before the Review & Challenge quality gate passes, the conductor must run the completeness checklist defined in `.claude/skills/review-challenge-thinking/SKILL.md` against each major output section and flag any failing section as `⚠ INCOMPLETE SECTION` before passing to the skill.

  Any `⚠ INCOMPLETE SECTION` flag must be resolved or explicitly acknowledged before Stage 9 clearance is granted.

  **Cross-document duration consistency check — required when `outputs/estimation-proposal.md` exists:**
  Any duration figure stated in an output section (e.g., "˜X months", "Y sprints", "Z weeks") must be derivable from or explicitly reference the authoritative sizing table in `outputs/estimation-proposal.md` (total hours ÷ team size ÷ utilisation rate). If a stated duration cannot be arithmetically reconciled with the sizing table, raise before clearance:

  ```
  ⚠ DURATION INCONSISTENCY — [Section name]
  Stated: [duration figure as written in output]
  Sizing table implies: [derived figure from estimation-proposal.md]
  Resolution required before Stage 9 clearance is granted.
  ```

  **Output structure reference:** Load `.claude/references/stage-9-output-structure.md` before generating output. It defines the canonical 19-section order, conditional section trigger rules, and per-section content rules (source inputs, formats, disclosure requirements, and suppression conditions for each section).

## Stage 10 — System Learning
  Purpose:    Improve the QE OS based on engagement experience
  Actions:    Load `.claude/references/stage-10-learning.md` for full protocol: insight candidate promotion, evidence gap monitoring, engagement pattern promotion, insights vs. improvements discipline, and `claude-memory/improvements.md` schema + backlog governance.
  Output:     Insight candidates reviewed and promoted or discarded; improvement proposals recorded in `claude-memory/improvements.md`; reusable patterns promoted to `claude-memory/insights.md`
  Rule:       Agents propose improvements only — they do not directly modify system files
  **Mandatory minimum:** Actions 1 (Insight Candidate Promotion) and 6 (Evidence Gap Monitoring) are non-skippable — see `.claude/references/stage-10-learning.md` — `### Mandatory Minimum`. If Stage 10 is skipped, output must carry the skip label defined there.

---

## Workflow Override Rules

**This workflow is a recommendation, not a lock.** Explicit user instructions override any stage or sequence.

**Override scope:** User instructions may override stage sequencing, agent selection, and routing. User instructions may NOT override:
1. Anti-hallucination and fabrication prevention rules (`copilot-instructions.md` §1)
2. Mandatory sourcing rules (`copilot-instructions.md` §1)
3. The quality gate for client-facing outputs — if skipped by user instruction, the output must carry the label: `[NOTE: Quality gate not applied — treat as working draft only.]`

**Precedence rule:** Guardrails (`copilot-instructions.md`) > Quality gate (Review & Challenge Thinking for client-facing outputs) > Workflow sequencing (stage order, agent routing). User overrides apply at the workflow sequencing layer only.

---

## Stage Re-Entry

When the user instructs re-execution of a prior stage (e.g., "go back to Stage 4 and revise the architecture"), or when new evidence arrives that invalidates a completed stage's output:

### Re-Entry Procedure
1. **Identify the re-entry stage** — the stage that must re-run.
2. **Invalidate downstream outputs:**
   - Mark the re-entry stage and all subsequent stages as `Invalidated — Re-Entry` in `plan.md` Stage Status
   - Do NOT delete downstream outputs from `outputs/staged-proposal.md` — mark them with `[INVALIDATED — pending re-run after Stage N re-entry]`
3. **Preserve upstream outputs:**
   - Stages before the re-entry stage retain their `Complete` status
   - Memory files written by upstream stages are not modified
4. **Re-run the stage:**
   - The re-entry stage's agent re-reads current memory state (which now includes all findings up to the point of re-entry)
   - The agent produces updated output, replacing the invalidated section in `staged-proposal.md`
   - Checkpoint condition must be re-satisfied before advancement
5. **Cascade re-runs:**
   - After the re-entry stage completes, each subsequent invalidated stage must re-run in sequence
   - Agents at each subsequent stage read the updated outputs from prior stages
   - The conductor manages the cascade — it does not skip stages even if prior output "looks unchanged"

### New Evidence Integration (Mid-Workflow)
When new artifacts arrive after Stage 1 (e.g., client Q&A responses, additional documentation):
1. Register the new artifact in `claude-memory/artifacts.md` with status `Pending Review`
2. Re-enter Stage 1 for the new artifact only — extract findings and append to `claude-memory/memory.md`
3. Re-run Stage 3 (Gap Coverage) to reassess with the expanded evidence base
4. If new High-confidence findings alter the gap picture, cascade re-entry from Stage 4 onward
5. If no material change, record in `claude-memory/notes.md`: "New artifact [name] processed — no material findings change. Stages 4+ output remains valid."

### Re-Entry Constraints
- Re-entry is user-initiated or conductor-recommended — agents do not self-trigger re-entry
- The conductor must confirm re-entry scope with the user before invalidating downstream outputs
- Stage 0 (Artifact Discovery) and Stage 2 (Memory Initialization) are never re-entered — they are additive by nature (new artifacts are appended, memory is extended)

---

## Post-Output Evidence Re-Entry Protocol

This protocol governs the scenario where Stage 9 output (a final or near-final proposal) already exists and new evidence arrives — such as vendor questionnaire responses, client clarifications, or supplementary technical assessments. This is distinct from mid-workflow re-entry (above), which assumes Stage 9 has not yet run.

### Materiality Threshold

New evidence warrants re-entry when it meets **at least one** of the following conditions:

| Condition | Tag | Description |
|---|---|---|
| Factual conflict | `CONTRADICTED` | New evidence directly contradicts a claim in the existing output |
| Scope removal | `REMOVED` | An application, environment, capability, or component is removed from scope |
| Blocker introduced | `BLOCKER` | New evidence introduces a dependency that blocks one or more workstreams |
| Inference confirmed | `REFINED` | New evidence replaces an inference-based finding with confirmed data |

> **Vocabulary note:** The Tags above (`CONTRADICTED`, `REMOVED`, `BLOCKER`, `REFINED`) are **re-entry trigger conditions** — they describe why a workflow re-entry is warranted. They are distinct from the **finding-level Relationship tags** in `evidence-extraction/SKILL.md` (`SUPERSEDED`, `CONTRADICTED`, `CONFIRMED`, `REFINED`). Although `CONTRADICTED` and `REFINED` appear in both vocabularies, their scope differs: here they classify the *impact on the output*; in evidence-extraction they classify the *relationship between two specific findings*. Do not conflate the two.

If the new evidence only adds detail that is consistent with existing output and introduces no contradictions, scope changes, blockers, or inference refinements — record it in `claude-memory/notes.md` and do not re-enter.

### Impact Analysis Step

Before any stage re-run, the conductor MUST produce a brief impact assessment:

```
## Re-Entry Impact Assessment — [date]
**New Artifact(s):** [list]
**Findings Changed:** [list finding IDs — new, contradicted, refined]
**Sections Affected:** [list proposal sections]
**Stages Requiring Re-Run:** [list stages with reason]
**Scope Changes:** [describe any added/removed scope elements]
```

This assessment must be confirmed by the user (HITL checkpoint) before re-entry begins.

### Selective Stage Re-Run Rules

| Stage | Re-Run When |
|---|---|
| Stage 1 — Evidence Extraction | Always — extraction is additive; new findings appended to `claude-memory/memory.md` |
| Stage 2 — Memory Initialization | Only if new findings contradict or supersede existing ones; skip if all new findings are additive |
| Stage 3 — Gap Coverage Enforcement | Only if scope changed (apps added/removed, environments changed, capability domains affected) |
| Stage 3.5 — Capability Coverage Check | Only if new evidence covers previously unassessed capability domains |
| Stage 4–6 — Architecture/Solution/Delivery | Only if contradictions or scope changes affect architecture decisions or delivery assumptions |
| Stage 7 — Client Perspective Review | Always — aggregation must incorporate all new findings before output updates |
| Stage 8 — Governance Validation | Always — reconciliation must cover all finding phases including the new phase |
| Stage 9 — Output Generation | Selective section updates only — update only the sections identified in the impact assessment |

### Phase Tagging Rule

When findings arrive in phases (e.g., an initial extraction followed by a vendor questionnaire phase), each phase's findings MUST be tagged with a phase identifier in `claude-memory/memory.md`:

```
Phase: [Phase Label]   (e.g., "Phase: Initial", "Phase: VQ-Response", "Phase: Angular-Assessment")
```

Phase tags enable per-phase reconciliation coverage (see `evidence-reconciliation/SKILL.md`) and contradiction tracking (see `evidence-extraction/SKILL.md`).

### Cross-Reference Update Rule

After re-entry is complete:
1. All cross-references in `claude-memory/notes.md` that cite superseded findings MUST be updated to reference the superseding finding ID
2. Superseded findings in `claude-memory/memory.md` MUST be marked: `Status: SUPERSEDED — see [new Finding ID]`
3. The proposal section(s) affected by contradicted or refined findings MUST be reviewed for any residual references to the old framing

**Discovery mechanism for step 1:** Search `claude-memory/notes.md` for the superseded Finding ID (e.g., search `F-12` to find all cross-references). If more than 20 references are found, raise a HITL checkpoint before bulk-updating — confirm scope of change with the user before proceeding. Document all updated references in the Re-Entry Impact Assessment under a `**Cross-References Updated:**` field.

### Scope-Change Propagation Rule

When any scope element changes mid-engagement (application added or removed, environment changed, technology superseded, date shifted, strategy reframed), the operator MUST produce a **Scope Delta List** before editing the proposal output.

**Scope Delta List — Mandatory Contents:**

| Delta Type | Examples |
|---|---|
| Removed terms | Application names no longer in scope, decommissioned tools, eliminated environments |
| Superseded terms | Prior strategy framing (e.g., "build-on" replaced by "greenfield"), superseded tool names |
| Changed numerical constants | App count, component count, environment count, FTE count, test case estimates |
| Changed dates | Milestone dates, go-live targets, engagement start dates |
| Changed framing | Risk levels, maturity scores, tier assignments modified by new evidence |

**Enforcement:** The Scope Delta List is a prerequisite for Stage 9 re-entry. Without a declared Scope Delta List, Stage 8 (Governance Validation) MUST flag the output: `⚠ SCOPE DELTA NOT DECLARED — proposal sections may contain stale references`.

**Post-edit sweep:** After all edits are complete, the full proposal MUST be swept against the Scope Delta List to confirm no residual references to removed or superseded terms remain. This sweep is operationalised by the Stale Reference Sweep lens in `.claude/skills/review-challenge-thinking/SKILL.md`.
