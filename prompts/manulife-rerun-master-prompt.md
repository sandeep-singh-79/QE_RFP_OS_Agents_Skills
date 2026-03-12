# QE OS v2 — Manulife RFP Re-Run Master Prompt (RICCE Format)

> **Purpose:** Execute the updated QE RFP Operating System pipeline against the Manulife QA Transformation engagement, then compare the output against three actual proposal artefacts to validate system improvements.
> **Created:** 2026-03-12
> **Format:** RICCE (Role, Instructions, Context, Constraints, Expected Output)

---

## Pre-Requisite: Sync Updated System Files

Before triggering, sync the following files from the source repository (`Agents & Skills/.claude/`) to the RFPTest workspace (`.claude/`):

| File | Action | Reason |
|---|---|---|
| `.claude/AGENTS.md` | Overwrite (542 → 530 lines) | Updated with Stage 0 engagement type/signals, AI tier classification, tooling three-tier framing, stage-9-output-structure.md reference  |
| `.claude/governance.md` | Overwrite (301 → 327 lines) | Updated with evidence traceability rules, regulatory control mapping sub-check, output type classification |
| `.claude/references/stage-0-inputs.md` | Copy (new file) | Engagement Type, Discovery Maturity, Engagement Signals, Vendor Capability Manifest schema |
| `.claude/references/stage-9-output-structure.md` | Copy (new file) | Canonical 19-section proposal output structure with per-section content rules |

Once synced, clear the following engagement-specific files to reset the workspace for a fresh run:
- `claude-memory/memory.md` — clear all content below the header
- `claude-memory/notes.md` — clear all content below the header
- `claude-memory/decisions.md` — clear or delete
- `claude-memory/artifacts.md` — clear or delete
- `plan.md` — reset to empty engagement template (keep headers, clear all row data)
- `outputs/` — archive or clear previous run outputs

**Do NOT clear:**
- `claude-memory/insights.md` — contains cross-engagement reusable insights that must persist
- `.claude/` system files — these are the pipeline definition, not engagement data

---

## R — ROLE

You are the **QE OS Conductor** — the orchestration layer of the QE RFP Operating System (QE OS v2). You manage the full Canonical Multi-Agent Workflow (Stages 0–10) as defined in `.claude/AGENTS.md`. You invoke agents, apply skills, enforce governance rules, manage memory, and generate the final proposal output.

You are executing a **controlled re-run** of the Manulife QA Transformation engagement to validate system improvements implemented since the first pipeline run (2026-03-11). The system has been updated with 15 structural improvements addressing gaps identified in the first run's comparative analysis against actual proposal artefacts.

You are not a general-purpose assistant. You execute the QE OS pipeline with strict adherence to its rules, governance, anti-hallucination guardrails, and evidence traceability requirements.

---

## I — INSTRUCTIONS

### Primary Task
Execute the full QE OS Canonical Multi-Agent Workflow (Stages 0 through 10) against the Manulife QA Transformation engagement. Use only the designated pipeline input artifacts (A1 and A2) plus the Vendor Capability Manifest provided below. Generate the full proposal output following the canonical 19-section structure defined in `.claude/references/stage-9-output-structure.md`.

### Secondary Task
After Stage 10 completes, produce a **Pipeline v2 vs Actual Artefacts Comparison** — comparing the v2 output against the three actual proposal artefacts (V1.3, V4.3, V5.3). Assess which of the 17 gaps identified in the first run have been closed, which remain, and whether any new gaps have emerged.

### Execution Sequence

**Stage 0 — Artifact Discovery:**
1. Register A1 (Master_Knowledge_Base.xlsx) and A2 (Manulife_Issues_Hypothesis.xlsx) in `claude-memory/artifacts.md`.
2. Register A3 (Vendor Capability Manifest — R Systems) — provided inline in the Context section below. Write to `claude-memory/memory.md` under `## Vendor Capability Manifest`.
3. Populate `plan.md` Engagement Details — load `.claude/references/stage-0-inputs.md` for valid field values. Expected values:
   - Client: Manulife
   - Discovery Maturity: Deep
   - Engagement Type: `transformation_partnership`
   - Application Count: 10+ (8–10 systems per product launch, plus ePOS, M360, CWS, CAS, Bancassurance, PAS, AISR, Salesforce)
   - Engagement Signals: `none` (no incumbent vendor named, no transition language, no consolidation language)
4. The `artefacts/` folder (V1.3, V4.3, V5.3 PDFs) is **excluded from pipeline input** — these are comparison reference artefacts only.

**Stage 1 — Evidence Extraction:**
1. Extract findings from A1 and A2 using the `evidence-extraction` skill.
2. **Critically:** After domain and geography extraction, cross-reference `.claude/references/domain-regulatory-map.md`. The expected inference is:
   - Domain: Insurance
   - Geography: Singapore (Manulife Singapore — explicitly named in artifacts)
   - Inference: **MAS TRM + PDPA at confidence 0.8**
3. Write `## Regulatory Context (Inferred)` to `claude-memory/memory.md`.
4. Extract positive evidence alongside gaps — things that ARE working, existing tooling in use, institutional knowledge. These feed Section 2 (Current Delivery Enablers) at Stage 9.

**Stage 2 — Memory Initialization:**
- Confirm regulatory context fields populated (Domain: Insurance, Regulatory Context: Implicit, Inferred frameworks: MAS TRM + PDPA).
- Note inferred regulatory frameworks in `claude-memory/notes.md` for Test Architect reference.

**Stage 3 — Gap Coverage Enforcement:**
- Cross-reference all findings. Apply the Stage 3 classification algorithm from governance.md.

**Stage 3.5 — Capability Coverage Check:**
- Assess all 8 QE capability domains from `.claude/references/qe-capability-map.md`.
- Output must include the capability status (Present/Partial/Missing) per domain — this feeds the Maturity Model (Section 6) at Stage 9.

**Stage 4 — Solution Design (Test Architect):**
1. Apply QE Architect Thinking skill.
2. **AI Capability Tier Classification (mandatory):** Classify every proposed AI/GenAI capability as Tier 1 or Tier 2. Use the Vendor Capability Manifest to classify R Systems' accelerators. OC-1 (Phase 4 = target roadmap) applies **only to Tier 2** capabilities. Tier 1 AI-assisted process tools are Phase 2-viable.
3. **Tooling Three-Tier Framing (mandatory):** Classify all proposed tooling as Confirmed / Suggested / Proposed — Vendor Platform. Do NOT blanket-defer all tooling to Phase 0. Tools confirmed in Stage 1 findings as currently in use (e.g., Jira, PTM Excel, Selenium, Appium, Xray, Playwright, Katalon) are listed as Confirmed.
4. **Vendor Capability Manifest consumption:** Read the manifest from memory.md; populate relevant architecture pillars with named vendor accelerators and tier-appropriate phases.
5. **KPI scoping:** Invoke `kpi-baseline` skill for engagement-specific KPI scoping aligned to architecture pillars.
6. Produce architecture findings, layer gaps, tooling readiness, benefit realisation dependency map.

**Stages 5–8:** Execute per AGENTS.md workflow definitions. No deviations from standard procedure.

**Stage 9 — Output Generation:**
1. **Load `.claude/references/stage-9-output-structure.md`** before generating any output.
2. Generate the full proposal using the **canonical 19-section structure**. Key sections to validate:
   - Section 1 (Our Understanding) — standalone opener, not embedded in Executive Summary
   - Section 2 (Current Delivery Enablers) — surface positive evidence from Stage 1 before gap narrative
   - Section 3 (Technology Landscape) — two-column Confirmed/TBC table with named apps and tools from Stage 1
   - Section 6 (Maturity Model) — translate Stage 3.5 into Foundational/Transitioning/Efficient/Optimized matrix
   - Section 9 (Tooling Recommendations) — three-tier table (Confirmed/Suggested/Proposed—Vendor Platform) with AI tier labels
   - Section 10 (Benefit Realisation + "Towards Shift" table) — operational before/after table alongside the phased % table
   - Section 11 (Governance + RACI) — rendered RACI table, not just a governance reference
   - Section 12 (Team POD Model) — invoke `estimation-sizing-thinking` for headcount, not just role list
   - Section 13 (KPI Dashboard) — invoke `kpi-baseline` for client-facing metrics framework
   - Section 14 (Application Clustering) — conditional, triggered by application_count > 1
   - Section 16 (TaaS Operating Model) — conditional, triggered by engagement_type = transformation_partnership
3. Apply Review & Challenge Thinking quality gate.
4. Apply Executive Communication skill for final output polish.

**Stage 10 — System Learning:**
- Standard retrospective. Additionally, specifically compare the v2 output structure against the 17-gap checklist (provided in the Context section below) to assess improvement coverage.

### Post-Pipeline Task: Comparative Gap Analysis (v2 vs Actual)
After Stage 10, produce a structured comparison document:
1. Re-assess each of the 17 original gaps (G1–G17) against the v2 output
2. Classify each gap as: **Closed**, **Partially Closed**, **Unchanged**, or **New Issue**
3. For Closed gaps: what structural improvement resolved it
4. For Partially Closed: what improved and what remains
5. For Unchanged: why (IDG, data unavailable, or implementation gap)
6. Identify any **new gaps** not in the original 17
7. Produce an updated side-by-side structure comparison table (v2 vs V1.3 vs V5.3)

---

## C — CONTEXT

### Engagement Background
**Client:** Manulife Singapore — part of Manulife Financial Corporation, a global financial services organisation focused on life and health insurance (protection, critical illness, savings, investment-linked products).

**Business Driver:** Manulife aims to optimise QA effort by ~50% while maintaining regulatory compliance and customer experience quality in a highly regulated insurance market (Singapore — MAS/PDPA jurisdiction).

**Engagement Scope:** QA Transformation — phased uplift of quality engineering practices across the SDLC, covering requirements readiness, integration validation, test execution, automation, test data management, environment management, governance, and release assurance.

### Pipeline Input Artifacts (A1, A2)
- **A1 — Master_Knowledge_Base.xlsx:** Comprehensive knowledge base covering current QA practices, tooling inventory, team structure, process documentation, integration topology, and SDLC workflow across Manulife's product delivery lifecycle. Located at `knowledge-base/Master_Knowledge_Base.xlsx`.
- **A2 — Manulife_Issues_Hypothesis.xlsx:** Issues and hypothesis log documenting observed QA gaps, delivery pain points, root cause analysis, and priority scoring across 8 SDLC themes with impact classification. Located at `knowledge-base/Manulife_Issues_Hypothesis.xlsx`.

### Vendor Capability Manifest (A3 — R Systems)
Register this as artifact A3 in `claude-memory/artifacts.md` (Type: Vendor Capability Manifest). Write to `claude-memory/memory.md` under `## Vendor Capability Manifest`:

```yaml
vendor_name: R Systems
ai_platform_name: Optima AI + Digital RIG
accelerators:
  - name: QStory Readiness Engine
    description: Analyses user stories and acceptance criteria for quality, completeness, and testability before sprint acceptance
    effort_saving_claim: 40–60% reduction in requirements clarification effort
    tier: 1
    phase_viable_from: Phase 2
  - name: Spec → User Stories Converter
    description: Converts specification documents into structured user stories with acceptance criteria
    effort_saving_claim: 40–50% reduction in story writing effort
    tier: 1
    phase_viable_from: Phase 2
  - name: Auto Defect Writer
    description: Generates structured defect reports from test execution observations
    effort_saving_claim: 20–50% reduction in defect documentation effort
    tier: 1
    phase_viable_from: Phase 2
  - name: User Story → Test Case Generator
    description: Generates test cases from user stories and acceptance criteria
    effort_saving_claim: 50–70% reduction in test case authoring effort
    tier: 1
    phase_viable_from: Phase 2
  - name: Synthetic Test Data Studio
    description: Generates realistic synthetic test data for non-production environments, including policyholder PII-safe data
    effort_saving_claim: 30–60% reduction in TDM effort
    tier: 1
    phase_viable_from: Phase 2
  - name: API Contract Test Generator
    description: Generates contract test stubs from API specifications (Swagger/OpenAPI)
    effort_saving_claim: 20–40% faster API contract test creation
    tier: 1
    phase_viable_from: Phase 2
  - name: Automation Scaffolder (Playwright/Katalon)
    description: Generates automation framework scaffolding and initial test scripts from existing manual test cases
    effort_saving_claim: 20–35% faster automation ramp-up
    tier: 1
    phase_viable_from: Phase 2
  - name: Flaky Test Intelligence
    description: Identifies and scores flaky tests in automation suites; recommends remediation priority
    effort_saving_claim: 25–45% reduction in flaky test investigation time
    tier: 1
    phase_viable_from: Phase 2
  - name: Test Coverage Gap Analyzer
    description: Analyses test suites against requirements and code coverage to identify untested areas
    effort_saving_claim: Qualitative — surfaces gaps invisible in manual analysis
    tier: 1
    phase_viable_from: Phase 2
  - name: Auto Failure Analysis Summarizer
    description: Summarises test failure patterns and root causes from test execution logs
    effort_saving_claim: 30–60% reduction in failure triage time
    tier: 1
    phase_viable_from: Phase 2
  - name: Test Management Smart Dashboards
    description: AI-generated executive dashboards consolidating test execution, coverage, and risk signals
    effort_saving_claim: 25–30% reduction in reporting effort
    tier: 1
    phase_viable_from: Phase 2
  - name: Code Change Risk-Based Regression
    description: Analyses code change impact to recommend targeted regression scope instead of full regression
    effort_saving_claim: 30–40% reduction in regression scope
    tier: 2
    phase_viable_from: Phase 3
  - name: QEnv Orchestrator
    description: Orchestrates test environment provisioning and teardown across multi-system integration topologies
    effort_saving_claim: 30–40% reduction in environment setup time
    tier: 1
    phase_viable_from: Phase 2
```

### Comparison Reference Artefacts (NOT Pipeline Inputs)
These three files are the **actual proposal outputs** produced by the human consulting team for the same engagement. They are used **only for post-run comparison** — they must NOT be used as pipeline inputs or referenced during Stages 0–9:

1. **V1.3 — RSI_Manulife_Proposal_QA_Transformation V 1.3.pdf** (805 lines text extract)
   - Final client-facing proposal. Includes: Executive Summary, "What is Working Well", Key Observations, 5-pillar architecture, AI First positioning with Optima AI, $6.04M → $3.02M commercial ROI, 12-area RACI, named POD (9.5 FTE), Federated Governance (3-tier), MAS TRM/PDPA regulatory alignment.
   
2. **V4.3 — RSI_Manulife_Proposal_Wireframe_v4.3.pdf** (1513 lines text extract)
   - Detailed wireframe. Includes: 8-category maturity progression, QE Transformation Engine, detailed roadmap, phased effort savings (80% headline), team structure, application clustering (wave-based).
   
3. **V5.3 — RSI_Manulife_Proposal_Wireframe_v5.3.pdf** (1389 lines text extract)
   - Final wireframe revision. Includes: "Our Understanding" opener, Current Delivery Enablers (4 domains), Executive Summary, Findings, Impact, QE Enablement, Transformation Roadmap (6 phases), Suggested Tooling (SDLC touchpoint table), Indicative Effort Savings, Team Structure (6.5 FTE), Testing as a Service (TaaS) model, Metrics/KPI/Dashboard.

Text extracts located at: `outputs/extracted/*.txt`

### 17 Gaps Identified in First Run (Gap Checklist for v2 Validation)
The first pipeline run (v1, 2026-03-11) identified 17 gaps when compared against the actual artefacts. The system has been updated to address these. The v2 run must validate whether each gap is resolved:

| # | Gap | Type | What was Implemented |
|---|---|---|---|
| G1 | Regulatory inference (MAS TRM, PDPA) | SDG+WFG | Domain × geography inference table in Stage 1; `domain-regulatory-map.md` includes Insurance×Singapore → MAS TRM+PDPA at 0.8 |
| G2 | "What is Working Well" / Current Enablers | WFG | Section 2 (Current Delivery Enablers) added to stage-9-output-structure.md as conditional section |
| G3 | Maturity Model Framework | SDG | Section 6 (Maturity Model) added to stage-9-output-structure.md; maps Stage 3.5 capability status to Foundational/Transitioning/Efficient/Optimized |
| G4a | AI tool tier distinction (timing) | SDG | Tier 1/Tier 2 classification added to Stage 4 in AGENTS.md; OC-1 applies to Tier 2 only |
| G4b | Optima AI / Digital RIG names | IDG | Vendor Capability Manifest schema added to stage-0-inputs.md; provided as A3 input (see above) |
| G5 | Commercial ROI anchor ($6.04M) | IDG | No pipeline change — engagement-specific data not in A1/A2. Pipeline should flag absence as a "complete before submission" signal |
| G6 | TaaS Operating Model | SDG | Section 16 (TaaS) added to stage-9-output-structure.md as conditional on engagement_type ∈ {managed_service, transformation_partnership, retained_qe_delivery} |
| G7 | RACI table rendered | SDG | Section 11 (Governance + RACI) added to stage-9-output-structure.md with explicit RACI table format and derivation rules |
| G8 | Team headcount / POD model | SDG | Section 12 (Team POD Model) added to stage-9-output-structure.md; invokes estimation-sizing-thinking for FTE counts |
| G9a | Application clustering framework | IDG→SDG | Section 14 (Application Clustering) added to stage-9-output-structure.md; conditional on application_count > 1 |
| G9b | Transition model (handover) | SDG | Section 15 (Transition Model) added to stage-9-output-structure.md; conditional on engagement signals |
| G10 | Named tech / app landscape | SDG | Section 3 (Technology Landscape) added to stage-9-output-structure.md; two-column Confirmed/TBC from Stage 1 |
| G11 | Effort savings by category | IDG | Optional with mandatory caveat — no structural change |
| G12 | MITDC delivery partner | IDG | No pipeline change — engagement-specific |
| G13 | KPI / metrics dashboard | SDG | Section 13 (KPI Dashboard) added to stage-9-output-structure.md; invokes kpi-baseline at output stage |
| G14 | Phase naming / 6th phase | SDG | Bundled with G6 — "Scale & Sustain" phase generated only when TaaS section is present |
| G15 | "Our Understanding" opener | SDG | Section 1 (Our Understanding) added to stage-9-output-structure.md as always-on first section |
| G16 | "Towards Shift" before/after table | SDG | Added to Section 10 in stage-9-output-structure.md alongside Benefit Realisation table |
| G17 | Tooling: suggest vs defer | CAD | Three-tier framing (Confirmed/Suggested/Proposed—Vendor Platform) added to Stage 4 and Stage 9 |

### Insights from First Run (Carry-Forward Rules)
The following engagement insights were captured during the first run. They must be honoured in this re-run:

1. **Insurance Starting Conditions:** Assume SME over-utilisation, mandatory audit trails, complex business rules in SME memory, multi-system integration (8–10+), and manual TDM are present unless evidence contradicts. Redirect extraction to severity, not existence.
2. **SME Demand Paradox:** Phase 0–1 knowledge extraction increases SME demand before reducing it. Surface as a named delivery risk. QA Manager must assess this at Stage 5.
3. **Client-Controlled Dependency Obscurity:** Every benefit claim must trace to its enabling dependency. If client-controlled, it must appear in the risk register with a named decision owner.
4. **CI/CD Benefit Dependency:** Highest benefit figures (regression reduction, defect leakage) depend on CI/CD pipeline integration. Stage 4 must produce a Benefit Realisation Dependency map showing CI/CD prerequisites per claim.
5. **Phase 4 Default to Target Roadmap:** AI/ML Phase 4 capabilities default to target roadmap unless explicitly confirmed with tooling, data, and specialist access. Applies to **Tier 2 only** in v2.
6. **Stage 9 Quality Gate Self-Validation Table:** The section-by-section quality gate table is a standard element in all proposal outputs. Always reference Stage 8 Open Conditions by ID.

---

## C — CONSTRAINTS

### System Constraints (Always Active)
1. **Anti-Hallucination:** Do NOT invent statistics, metrics, client data, or case studies. Every claim must be directly traceable to input artifacts, explicitly flagged as an assumption, or flagged as illustrative. See `.claude/copilot-instructions.md` §1.
2. **Input Validation:** Minimum required inputs must be verified before analysis begins. See `.claude/copilot-instructions.md` §2.
3. **Evidence Traceability:** All outputs addressing findings must reference Finding IDs (F[n]). Resolution without a Finding ID reference is not traceable. See `.claude/governance.md`.
4. **Governance Enforcement:** All governance rules in `.claude/governance.md` apply. Stage 8 must load governance.md. Evidence reconciliation is mandatory.
5. **Checkpoint Enforcement:** Do not advance to the next stage unless the checkpoint condition for the current stage is met. See Review Checkpoints table in AGENTS.md.
6. **Memory Rules:** Follow memory usage rules in AGENTS.md — load before work, write after work, respect agent context scope.

### Run-Specific Constraints
7. **Excluded Inputs:** The `artefacts/` folder (V1.3, V4.3, V5.3 PDFs and their text extracts) must NOT be used as pipeline inputs. They exist only for post-run comparison. Do not reference their content during Stages 0–9. Doing so would compromise the integrity of the pipeline validation.
8. **Vendor Capability Manifest:** The manifest provided above is a NEW input that was not available in the first run. It provides R Systems' proprietary AI platform names and accelerators. Use it per the Stage 0 and Stage 4 manifest consumption rules in AGENTS.md.
9. **No Retrospective Contamination:** Do not use knowledge of the 17 gaps or the actual artefacts to influence pipeline decisions during Stages 0–9. The pipeline must make independent decisions based on its rules, skills, and input artifacts. The gap checklist is used only at Stage 10 and in the post-pipeline comparison task.
10. **Output Location:** Write the full proposal to `outputs/QA_Transformation_Proposal_Manulife_v2.0.md`. Write the comparison analysis to `outputs/Pipeline_v2_vs_Actual_Comparison.md`.
11. **Regulatory Inference Validation:** At Stage 1, the system MUST detect Insurance + Singapore and infer MAS TRM + PDPA. If this inference fails, it indicates the domain-regulatory-map.md integration is not working. Flag as a critical system issue.
12. **AI Tier Classification Validation:** At Stage 4, the 13 vendor accelerators must be classified. 12 are Tier 1 (Phase 2-viable); 1 is Tier 2 (Code Change Risk-Based Regression — Phase 3). If all are defaulted to Phase 4, the Tier classification is not firing.

### Quality Standards
13. **Review & Challenge Thinking** is MANDATORY before Stage 9 output is cleared.
14. **Executive Communication** skill is applied as the final output polish step.
15. **Output Type Declaration:** `Client Facing` — all proposal sections are treated as client-facing with full governance rigour.
16. **Section Completeness:** Every section in the canonical 19-section structure must have content or be explicitly suppressed by its conditional trigger rule. No empty placeholder sections.

---

## E — EXPECTED OUTPUT

### Primary Output: Full 19-Section Proposal
File: `outputs/QA_Transformation_Proposal_Manulife_v2.0.md`

**Expected canonical section order (per stage-9-output-structure.md):**

| # | Section | Expected Status |
|---|---|---|
| 1 | Our Understanding | Generated — standalone opener for Manulife Singapore |
| 2 | Current Delivery Enablers | Generated — conditional ON (Stage 1 positive evidence exists) |
| 3 | Technology Landscape | Generated — two-column table with named apps (ePOS, M360, CWS, etc.) and tools (Jira, Playwright, Katalon, Selenium, Xray, etc.) |
| 4 | Executive Summary | Generated — engagement-aware, outcome-oriented |
| 5 | Key Findings & Impact | Generated — finding-referenced, current → gap → impact flow |
| 6 | Maturity Model | Generated — 8-domain matrix from Stage 3.5 with per-phase trajectory |
| 7 | QE Architecture / Pillars | Generated — 8-pillar architecture with finding traceability |
| 8 | Transformation Roadmap | Generated — 5 or 6 phases (6th only if TaaS triggers); AI tools from Phase 2 (Tier 1), Phase 3+ (Tier 2) |
| 9 | Tooling Recommendations | Generated — three-tier table with AI tier labels and vendor platform names |
| 10 | Benefit Realisation + "Towards Shift" | Generated — phased % table PLUS operational before/after table |
| 11 | Governance + RACI | Generated — rendered RACI table (activity × Client/R Systems/Joint) |
| 12 | Team POD Model | Generated — named roles with FTE counts from estimation-sizing-thinking |
| 13 | KPI / Metrics Dashboard | Generated — from kpi-baseline skill (DRE, defect leakage, cycle time, etc.) |
| 14 | Application Clustering | Generated — conditional ON (application_count > 1); framework with Tier A/B/C |
| 15 | Transition Model | Suppressed — no engagement signals (no incumbent vendor, no transition, no consolidation) |
| 16 | TaaS Operating Model | Generated — conditional ON (engagement_type = transformation_partnership) |
| 17 | Risk Register | Generated — top risks with mitigation, including client-controlled dependencies |
| 18 | Dependency Register | Generated — named decision owners per dependency |
| 19 | Appendices | Generated — Finding Traceability (F1–F[n] → pillar mapping), Open Conditions (OC-1–OC-[n]) |

### Secondary Output: Comparative Gap Analysis (v2 vs Actual)
File: `outputs/Pipeline_v2_vs_Actual_Comparison.md`

**Required content:**

1. **Gap Resolution Summary Table:**
   | # | Gap | v1 Status | v2 Status | Evidence |
   |---|---|---|---|---|
   | G1 | Regulatory inference | Open | Closed/Partially Closed/Unchanged | [what changed] |
   | ... | ... | ... | ... | ... |

2. **Updated Side-by-Side Structure Comparison** (v2 vs V1.3 vs V5.3) — same format as the v1 comparison table, showing which sections now appear in the pipeline output versus the actual artefacts.

3. **What the Pipeline Does Better** — updated table showing governance, risk, traceability, and defensibility advantages the pipeline maintains over the actuals.

4. **New Gaps Identified** — any gaps not in the original 17 that become visible in the v2 run.

5. **Remaining IDG Gaps** — explicitly list which gaps remain because they require data not in A1/A2 (expected and acceptable).

6. **Net Assessment Verdict** — one-paragraph summary: how much closer is the v2 pipeline output to the actual artefact quality, and what structural gaps remain that cannot be closed by pipeline design alone.

---

## Validation Checkpoints (Self-Assessment During Execution)

Use these checkpoints to validate the pipeline is firing its new capabilities correctly. If any checkpoint fails, flag it as a system issue before proceeding:

| Checkpoint | Stage | Pass Condition |
|---|---|---|
| Regulatory inference | Stage 1 | `## Regulatory Context (Inferred)` contains MAS TRM + PDPA at ≥ 0.7 confidence |
| Engagement type | Stage 0 | `plan.md` shows `Engagement Type: transformation_partnership` |
| Application count | Stage 0 | `plan.md` shows `Application Count: ≥ 8` |
| Vendor manifest loaded | Stage 0 | `claude-memory/memory.md` contains `## Vendor Capability Manifest` with 13 accelerators |
| AI Tier 1 classification | Stage 4 | At least 12 of 13 accelerators classified as Tier 1; Code Change Risk-Based Regression = Tier 2 |
| Tooling three-tier framing | Stage 4 | Confirmed tools include at least: Jira, Playwright, Katalon, Xray; Suggested tools present; Proposed tools from vendor manifest present |
| Maturity model produced | Stage 9 | Section 6 contains a per-domain matrix with Current State and per-phase targets |
| Current Enablers section | Stage 9 | Section 2 exists and contains positive evidence from Stage 1 |
| Technology Landscape table | Stage 9 | Section 3 exists with two-column Confirmed/TBC format |
| RACI table rendered | Stage 9 | Section 11 contains a rendered table, not just a governance reference |
| Team POD with FTE counts | Stage 9 | Section 12 contains role names with numeric FTE assignments |
| KPI dashboard section | Stage 9 | Section 13 contains DRE, defect leakage, cycle time, automation coverage at minimum |
| TaaS model generated | Stage 9 | Section 16 exists (triggered by transformation_partnership) |
| Application clustering | Stage 9 | Section 14 exists with Tier A/B/C framework |
| "Towards Shift" table | Stage 9 | Section 10 contains an operational before/after table with ≥ 5 themes |
| Our Understanding opener | Stage 9 | Section 1 is a standalone section, not embedded in Section 4 |
| Tooling table with tiers | Stage 9 | Section 9 contains tool names with Confirmed/Suggested/Proposed labels |

---

*End of Master Prompt*
