# QE OS — Scenario Evaluations

This document evaluates 15 test scenarios across three categories: full end-to-end workflow, individual agent and skill invocations, and complex multi-component combinations. Each scenario is evaluated for what should activate, what guardrails should fire, where HITL pauses occur, and where the system is most likely to degrade or fail.

Scenarios are numbered for reference. They are not sequential — each is independent unless stated otherwise.

---

## Category A — End-to-End Workflow Scenarios

### Scenario A1 — Full RFP Review: Rich Artifact Set

**Setup**
A client in the energy sector issues an RFP for QA transformation services. The vendor team registers four artifacts:
- A1: The RFP document (40 pages, includes 18 explicit questions)
- A2: An architecture overview diagram (application topology)
- A3: A current-state test inventory spreadsheet (manual test cases only)
- A4: Clarification responses from a pre-bid call transcript

**What should fire — stage by stage**

| Stage | Expected System Behaviour |
|---|---|
| 0 — Artifact Discovery | All four artifacts registered in `artifacts.md`. `notes.md` populated with "Missing Artifacts" — no CI/CD pipeline description, no test data strategy, no monitoring/observability evidence. |
| 1 — Evidence Extraction | Findings extracted from A1–A4. A2 and A3 produce High-confidence findings (architecture explicitly described, test inventory explicitly enumerated). A4 produces Medium-confidence findings (verbal commitments in transcript — not confirmed in writing). Missing Evidence flags raised for anything referenced in A1 but not substantiated in any other artifact. |
| 2 — Memory Initialization | `memory.md` populated. `notes.md` updated. `insights.md` scanned for prior engagement patterns. |
| 3 — Gap Coverage Enforcement | Every High-confidence finding cross-referenced. At least two findings likely Unresolved at this stage: test data strategy (not addressed in any artifact), CI/CD QA integration (mentioned in RFP but no pipeline evidence). |
| 3.5 — Capability Coverage | All eight domains assessed against `qe-capability-map.md`. Based on the artifact set: QE Strategy = Partial (RFP mentions QA vision but no current-state strategy), Automation = Missing (test inventory shows manual only), CI/CD Integration = Missing, Test Data = Missing. At least three domains Missing — this is a high-baseline gap engagement. |
| Optional: Question→Capability Mapping | 18 questions exist in A1 and Stage 3.5 is complete — activation conditions met. Test Architect invokes this skill. Output written to `notes.md`: each of the 18 questions mapped to capability domain and evaluation dimension (architecture maturity, governance, tooling maturity, etc.). |
| 4 — Solution Design | Test Architect reads all prior output. Must declare assumptions for Missing domains (no client evidence exists for Test Data, CI/CD, Observability). Recommendations must be tagged with Finding IDs or capability domain references. Every recommendation without one triggers `⚠ EVIDENCE GAP`. |
| 5 — Architecture Validation | QA Manager flags adoption risk from the automation-gap finding — introducing automation to a team currently 100% manual is a high-change risk requiring enablement time that the proposal must account for. Assumption & Dependency skill invoked — dependency on client access to CI/CD environment declared. |
| 6 — Delivery Validation | Project Manager reviews the phased plan. Estimation & Sizing applied if the proposal contains timelines. Key finding: if automation onboarding is Week 1, the plan assumes CI/CD is already configured — this is an undeclared dependency. HITL pause likely here: "Delivery plan contains an undeclared prerequisite — CI/CD environment readiness. Confirm how this should be handled before we proceed." |
| 7 — Client Perspective | Client Evaluator reviews Stages 4–6 findings after Outcome & Risk Framing and Structuring are applied. 18 questions mapped — evaluator checks whether the solution demonstrably addresses each. Likely red flag: the automation claim ("full automation coverage") is not backed by a ramp-up timeline, which a procurement panel will challenge. |
| 8 — Governance Validation | Evidence Reconciliation checks all High-confidence findings. Any recommendations without Finding ID references flagged `⚠ EVIDENCE GAP`. HITL required if any High-confidence finding remains Unresolved. |
| 9 — Output Generation | Review & Challenge skill applied. Any over-commitment identified by QA Manager or PM surfaced again here. Executive Communication skill applied if output is for sponsor-level delivery. |
| 10 — System Learning | Improvement proposals recorded based on any `⚠ EVIDENCE GAP` flags, reasoning gaps, or skipped steps. |

**Key tensions and risk points**

1. The test inventory (A3) shows 3,000 manual test cases. The proposal likely needs to claim automation coverage. The system will surface that this claim requires: (a) a declared assumption about client environment readiness, (b) a ramp-up timeline in the delivery plan, and (c) an evidence basis from A3 findings about test automation feasibility. Without all three, the recommendation gets flagged.
2. The transcript (A4) contains verbal commitments. The system will classify these as Medium-confidence. The system will NOT treat them as confirmed requirements — they will appear in the "Unresolved or Unverified Findings" section of any client-facing output. The user must decide whether to escalate to confirmed requirements before submission.
3. Stage 6–7 tension: PM may identify the 8-week timeline is unrealistic for a transformational QE engagement. The Client Evaluator may simultaneously flag that the proposal sounds under-resourced. These are not contradictions — both agents are producing valid but different lenses. The correct output is to surface both as distinct risks, not to reconcile them silently.

**Where the system is most likely to fail in practice**
- An agent producing tooling recommendations (e.g., recommending Playwright for UI automation) without having defined the capability requirement first — triggers `⚠ EVIDENCE GAP`.
- A Finding ID referenced in Stage 8 that doesn't match any entry in `memory.md` — phantom reference. The system flags it but cannot automatically resolve it.
- The question-capability mapping output being omitted from Stage 4 input — the Test Architect then designs a solution blind to the evaluation dimensions the client is actually assessing.

---

### Scenario A2 — Full RFP Review: Minimal Input (RFP Only)

**Setup**
A vendor team has only the RFP document. No architecture diagrams, no test inventory, no call transcripts. The system must function under this constraint — this is an explicitly supported configuration per AGENTS.md.

**What should fire — and how the system adapts**

| Stage | Expected Adaptation |
|---|---|
| 0 | One artifact registered. `notes.md` under "Missing Artifacts" is significantly populated: architecture context unknown, test asset inventory unknown, current-state tooling unknown, team size and capabilities unknown. |
| 1 | Evidence extraction runs on the RFP alone. Most findings will be Medium or Low confidence — RFPs state requirements without confirming client-side conditions. High-confidence findings are limited to explicit contractual requirements stated unambiguously in the RFP text. |
| 3 | Gap Coverage: almost all findings are Unresolved at this stage — not because they've been ignored, but because there is no client evidence to cross-reference. The system does NOT treat absence of evidence as evidence of absence. Each gap is flagged explicitly. |
| 3.5 | Capability Coverage will likely return 5–6 domains as Missing — correct behaviour. The system must not claim capabilities are Present without support. |
| 4 | Test Architect must declare assumptions for every capability area without evidence. The Recommendation Traceability Format forces every recommendation to declare which source applies — in a minimal-input scenario, almost all will be `Assumption: [X]`. |
| 5–7 | Agents work from declared assumptions, not fabricated client evidence. Every output must be honest about its evidential basis. |

**Critical guardrail stress test**
This scenario is the primary stress test for the anti-hallucination rule. A system (or agent) that silently fills information gaps with plausible-sounding content will produce outputs that look complete but are not traceable. The correct system behaviour is to produce outputs with significantly more `[ASSUMPTION: ...]` labels and fewer `Resolution: F[ID]` entries than Scenario A1. An output that looks as confident as A1 in this scenario is a red flag.

**Expected output shape**
The final output should explicitly note: "This assessment is based on the RFP document only. The following capability areas could not be assessed and are treated as out of scope for this response: [list]. The following assumptions underpin this proposal and require client confirmation before commitment: [list]." This is not a failure state — it is the correct honest output for minimal-input conditions.

---

### Scenario A3 — Mid-Workflow Conflict Discovery

**Setup**
The workflow reaches Stage 5 (QA Manager). The Test Architect's Stage 4 output includes a recommendation to implement automated regression testing starting in sprint 1. The QA Manager's review of `memory.md` and the Stage 4 findings reveals a constraint extracted from the RFP transcript (F07, Medium confidence): "client confirmed in pre-bid call that teams are not permitted to introduce new tools without a 6-week change governance process."

F07 was present in `memory.md` since Stage 1 but was not referenced by the Test Architect in Stage 4.

**What should fire**

1. The QA Manager must NOT silently resolve this. The Memory Integrity Rule prohibits modifying the Test Architect's findings. Instead, the QA Manager writes a `⚠ CONFLICTING FINDING` entry:
   ```
   ⚠ CONFLICTING FINDING
   Related Recommendation: Stage 4 automation start
   Conflicting Finding: F07 — change governance constraint (Medium confidence, from pre-bid transcript)
   Explanation: Sprint 1 automation introduction violates the 6-week change governance constraint.
   Resolution Status: Unresolved — requires human review
   ```

2. HITL pause triggers: "Conflicting finding identified between the Test Architect's automation timeline (F04) and the change governance constraint (F07). This requires a decision before Stage 6 can proceed. Options: (a) Adjust automation start to Week 7 or later, (b) Confirm with client that change governance does not apply to QA tooling, (c) Declare F07 as unconfirmed and note it as a risk. Please confirm."

3. Stage 6 (PM) is blocked until this is resolved. The delivery plan cannot be finalised around a timeline assumption that has an open conflict.

4. Stage 8: Even if a resolution is chosen, the Evidence Reconciliation skill must verify the chosen resolution is traceable. If the user selects option (c), the output must include F07 in the "Unresolved or Unverified Findings" section.

**Why this scenario matters**
It tests the core workflow assumption: that agents operate sequentially and surface what they find, rather than silently patching problems to produce a cleaner output. The correct system behaviour looks messier — it produces a HITL pause and a visible conflict — but that messiness is signal, not failure.

---

## Category B — Individual Agent Scenarios

### Scenario B1 — Client Evaluator: Spot Task on a Single Section

**Setup (Mode 2 — no full workflow)**
User pastes a 200-word methodology section from a draft proposal and asks: "Review this as a client evaluator and flag scoring risks."

**What should fire**

- Input validation: task type ✓ (scoring review), primary input ✓ (section text), purpose ✓ (client-facing scoring assessment). Minimum context requirements met.
- The Client Evaluator agent activates. It does NOT invoke Test Architect, QA Manager, or Project Manager — they are not needed.
- No `memory.md` exists in this spot-task context. The agent acknowledges this: "This review is based solely on the provided section. No prior engagement findings have been loaded."
- Output: scoring risks, defensibility concerns, and procurement panel red flags — all traceable to specific phrases or claims in the submitted text. No invented client context.

**What should NOT happen**
- The agent should not invent information about the client's industry, team size, or procurement criteria.
- It should not run evidence reconciliation (no memory to reconcile against).
- It should not invoke the Test Architect to validate the architecture — it simulates the evaluator's perspective on what is written, not what the architecture should be.

**Key evaluation point: scope boundary**
If the methodology section mentions "Selenium" and the user then asks "What do you think of that tooling choice?", the correct redirect is: "Tool selection assessment falls within the Test Architect agent. Invoking that, or would you like to continue with the evaluator perspective only?"

---

### Scenario B2 — Project Manager: Timeline With a Hidden Dependency

**Setup (Mode 2)**
User provides a phased delivery plan:
> Phase 1 (Weeks 1–4): Test strategy + environment setup  
> Phase 2 (Weeks 5–8): Automation development (200 tests)  
> Phase 3 (Weeks 9–12): UAT support + handover

And asks: "Review this — are there any hidden dependencies or delivery risks?"

**What should fire**

- Estimation & Sizing skill invoked alongside the Project Manager assessment (timelines are explicitly in scope).
- Key findings:
  - Phase 1 includes "environment setup" but does not declare who is responsible (vendor or client). This is an unclassified dependency — classified as External, High Impact.
  - Phase 2 starts Week 5 and assumes environment is ready. If client-side environment setup slips by even one week, Phase 2 start is directly blocked.
  - 200 automation tests in 4 weeks = 50 tests/week. Without knowing test complexity, team size, or automation framework readiness, this cannot be confirmed as realistic. The Estimation & Sizing skill will surface this as an `[ASSUMPTION: team of 2 automation engineers with framework in place]` — and flag it as an input the client should confirm.
  - Phase 3 starts Week 9 with no buffer between Phase 2 end and UAT support. A 0-day contingency on automation delivery is a planning risk.

- Output: structured risk table with dependency type, owner, probability, and impact — not prose narrative.

**Anti-hallucination check**
The system must not claim "industry standard automation throughput is X tests per day." That would be a fabricated benchmark. If invoked, `[ILLUSTRATIVE EXAMPLE — not based on confirmed input]` label must appear.

---

### Scenario B3 — QA Manager: Adoption Feasibility for an Unsustainable Claim

**Setup (Mode 2)**
A draft proposal section states: "We will deliver 100% automated regression coverage across all three applications within 6 weeks, transitioning the client's 14 manual testers to full automation engineers."

User asks: "Does this hold up from a QA management perspective?"

**What should fire**

- QA Manager activates. Assumption & Dependency skill invoked immediately (the section contains multiple unverified inputs).
- Key findings:
  1. "100% automated regression coverage" — an over-commitment. No evidence of test inventory depth, application complexity, or existing automation asset base.
  2. "6 weeks" — no dependency declared on client test environment, existing automation framework, or tooling procurement timeline.
  3. "Transitioning 14 manual testers to automation engineers" — a workforce transformation claim. This requires: training programme, change management, client HR approval, role regrading in many organisations. None declared.
  4. The combination — 100% coverage + full team transition + 6 weeks — is not internally consistent. Delivering automation at scale and training the team doing it at the same time creates resource contention that the plan does not account for.

- The QA Manager does NOT rewrite the section. It diagnoses feasibility risk. The output is a risk rating and a list of assumptions that must be declared before this section can be submitted.

- If there are no Finding IDs (no `memory.md` in spot-task mode), the QA Manager must state: "This assessment is based on the submitted text only. No prior engagement evidence has been loaded. All findings reference the submitted text directly."

---

## Category C — Individual Skill Scenarios

### Scenario C1 — Evidence Extraction: Varied Confidence Classification

**Setup**
A single RFP artifact is provided. It contains:
- Section 3.1: "All regression tests must be automated before production deployment." (Explicit requirement)
- Section 5.2: "The vendor should consider the use of BDD frameworks where applicable." (Advisory, non-binding)
- Section 7.4 (footnote): "The client's current CI/CD toolchain may be relevant to the proposed solution." (Implied, unconfirmed)
- Section 9: 12 evaluation questions with no further clarification.

**Expected classification**

| Finding | Type | Confidence | Binding Status | Rationale |
|---|---|---|---|---|
| Automated regression required pre-deployment | Requirement | High | Mandatory | Explicit, unambiguous contractual language |
| BDD framework usage | Opportunity | High | Advisory | Explicitly stated ("should consider") — non-binding advisory |
| CI/CD toolchain relevance | Constraint | Medium | Unknown | "May be relevant" — implied constraint, not confirmed; binding status unclear |
| 12 evaluation questions | Requirement | High | Mandatory | Formally posed questions in an RFP are always High confidence and require a response |

**What should NOT happen**
- "Should consider BDD" should not be classified as a confirmed Requirement.
- The CI/CD footnote should not generate an assumption about what the toolchain is — only a flag that client confirmation is needed.
- The extraction skill should flag "Missing Evidence" for the CI/CD toolchain: a finding references something that is relevant but unprovided.

---

### Scenario C2 — Outcome & Risk Framing: From Technical Observation to Business Risk

**Setup (skill applied directly)**
Raw finding: "No test data strategy exists. The RFP does not mention synthetic data generation, data masking, or test environment refresh cycles."

User asks: "Frame this as a business risk for the executive summary."

**Expected output shape**
The skill should produce something along these lines (content illustrative — not to be treated as real):

```
Risk: Test Data Strategy Absent
Business Impact: Without a test data strategy, testing will proceed against production or 
near-production data. This creates: (a) [regulatory framing — see conditional logic below],
(b) test environment instability — tests fail due to state changes, not code defects, and 
(c) inability to run repeatable pre-production validation at scale.
Urgency: Addressing this before automation development begins. If discovered mid-delivery, 
remediation requires environment redesign — a schedule and cost risk with downstream impact 
on go-live.
Decision Owner: Whoever owns environment strategy and compliance obligations.
```

**Regulatory framing — conditional on `Regulatory Context` in `memory.md`:**

| Regulatory Context | Framing to use for item (a) above |
| ------------------ | --------------------------------- |
| Explicit (e.g., GDPR found in artifact) | `data protection exposure under [named regulation]` |
| Implicit (e.g., domain = banking or healthcare) | `exposure under applicable data protection obligations` |
| Unknown | Omit regulatory framing entirely — remove item (a) from the output |

**What should NOT happen**
- The skill must not invent a regulatory framework. "GDPR" or "SOC 2" must not appear unless they were in the input.
- The skill must not claim an impact figure. "This could cost £X" is fabricated unless supported by evidence.
- The framing amplifies the finding's business consequence — it does not add new findings or create fictional context.

---

### Scenario C3 — Review & Challenge Thinking: Quality Gate on a Near-Final Section

**Setup**
A draft methodology section is submitted to the quality gate. It reads confidently and is well-structured. But it contains:
- "We have extensive experience delivering QA transformations in the energy sector." (No evidence cited)
- "Our automation framework delivers 60% reduction in regression testing time." (Benchmark figure, unsourced)
- "We will integrate with your existing CI/CD pipeline on Day 1." (Name of pipeline unknown)
- "Our team of certified QA engineers will..." (Certification not specified)

**What should fire**

The Review & Challenge skill must identify all four as challenges — not as content to rewrite:

1. **Sector experience claim** — unsupported credential. Client evaluators will ask for case studies or references. This is a scoring downgrade risk if no evidence is provided.
2. **60% reduction figure** — fabricated benchmark. Must be labelled `[ILLUSTRATIVE EXAMPLE]` or removed. If it stays, it will be challenged by a procurement panel and cannot be defended.
3. **"Day 1" CI/CD integration** — undeclared dependency on the client's pipeline being accessible, documented, and compatible. This is an over-commitment that creates delivery risk.
4. **"Certified QA engineers"** — vague credential. A procurement panel will ask: certified by whom, against what standard, at what level?

**What the skill does NOT do**
- It does not rewrite these passages.
- It does not say these claims are false — it says they cannot be defended without evidence.
- It does not invoke any other agent. It returns a challenge report that the user then acts on.

---

### Scenario C4 — Estimation & Sizing: Invoked Without Prior Architecture

**Setup (attempting to invoke estimation in isolation)**
User asks: "Give me a size estimate for a QA transformation engagement."

No RFP. No artifacts. No architecture findings. No team size information.

**What should fire**

Input validation fails at minimum required inputs check:
- Task type ✓ (sizing)
- Primary input ✗ (no RFP section, proposal text, or architecture findings to size)
- Stated purpose ✗ (no context for who will receive the estimate or what decisions it will inform)

**Correct system response:**
> "I have received: a request for a QA transformation size estimate.  
> To proceed, I also need: (1) a description of the scope to be sized — application count, test volume, team scale, or the engagement phases to estimate; (2) any constraints or assumptions about the transformation (timeline, tooling, automation targets); (3) the purpose of the estimate (internal planning, RFP commitment, or directional only).  
> I can proceed with declared limitations and produce a range-based illustrative estimate, but all assumptions will be explicitly labelled and the output must not be treated as a commitment. Confirm to proceed?"

**What should NOT happen**
- The skill must not produce figures based on guessed scope.
- It must not cite "industry average" transformation timelines without an `[ILLUSTRATIVE EXAMPLE]` label.

---

## Category D — Multi-Component Combination Scenarios

### Scenario D1 — Risk Narrative Chain: Three Skills in Sequence

**Setup**
After Stage 4 (Solution Design), the Test Architect has produced three raw findings:
1. "No test data strategy exists. Synthetic data or masking approach must be established."
2. "Automation framework layer is absent. No evidence of existing framework assets."
3. "Performance testing is not mentioned in the RFP or architecture. Non-functional requirements are unaddressed."

User asks: "Turn these into an executive risk briefing for the steering committee."

**What fires and in what order**

**Step 1: Outcome & Risk Framing** — each finding translated from technical observation to business impact, urgency, and decision ownership. No new information added. Fabricated regulatory context must not appear.

**Step 2: Structuring & Consulting Thinking** — three risk statements shaped into a prioritised hierarchy. Not a flat list — findings should be grouped and sequenced by urgency and business impact. The output structure becomes: critical risks (require decision before next milestone), significant risks (need mitigation in delivery plan), and watch items (flag for monitoring).

**Step 3: Executive Communication** — final transformation for steering committee delivery. Technical language replaced with consequence-focused language. Structure becomes scannable, not dense. Assumptions explicitly surfaced. Any `[ASSUMPTION: ...]` labels from prior steps must be preserved and made visible to the executive audience — not hidden.

**Integrity check across the chain**
The finding about performance testing must not become "Performance failures will cause production outages" — that introduces a fabricated consequence. The correct framing is "Non-functional requirements are not addressed in the current proposal. If performance behaviour at production scale is a go-live criterion, this gap creates delivery risk that is currently unplanned." That is a defensible framing because it is drawn from the finding, not invented.

---

### Scenario D2 — Test Architect + Tooling Recommender: Correct vs. Incorrect Invocation

**Two paths from the same starting point.**

**Path A — Correct invocation**

Test Architect completes Stage 4. Architecture layers defined: functional automation (UI), API integration testing, CI/CD quality gates, test reporting. Capabilities confirmed: automated regression, continuous testing, pipeline enforcement, coverage visibility.

Test Architect invokes Tooling Recommender: "Architecture and capabilities are defined. The client is on Azure DevOps. Validate tooling options for the automation execution layer."

Tooling Recommender has confirmed inputs. Output: capability-driven tooling table with options, declared assumptions, RFP-safe framing. No tool is presented as a definitive recommendation unless the client has confirmed environment constraints.

**Path B — Incorrect invocation (scope boundary test)**

User asks directly: "Tell me what tools we should use."

No Test Architect work has been done. No architecture defined. No capabilities confirmed.

The Tooling Recommender should HALT:
> "Tooling selection requires confirmed capability requirements as input. These are defined by the Test Architect after architecture layers are established. Without them, any tooling recommendation would be speculative. To proceed correctly: invoke the Test Architect first to define the QA architecture and required capabilities, then return to tooling selection. Alternatively, if you have capability requirements available, provide them now and I can proceed from that basis."

**What must NOT happen in Path B**
- The Tooling Recommender must not produce generic tooling recommendations because they "sound right" for a QA engagement.
- It must not infer capability requirements from the absence of other information.
- It must not defer to the Playwright-vs-Cypress framing embedded in many generic QA responses.

---

### Scenario D3 — Conductor Stages 1–3.5 + Optional Question Mapping

**Setup**
RFP document with 10 questions. Moderate artifact set: RFP + one architecture overview.

**Stage-by-stage evaluation**

**Stage 1 (Evidence Extraction):**
Both artifacts scanned. RFP questions classified as High-confidence Requirements — they are formal evaluation criteria. Architecture overview produces findings about application layers and integration points.

**Stage 3 (Gap Coverage):**
High-confidence findings from the architecture diagram — e.g., "three-tier web architecture with microservices" — are accounted for. The RFP's 10 questions are not all addressed by the architecture artifact alone, so several appear as Unresolved at this stage. This is correct — they will be addressed in Stage 4.

**Stage 3.5 (Capability Coverage):**
Architecture finding confirms application architecture style (microservices). This informs the Automation domain: component-level testing is likely needed. Non-functional (performance, resilience) is assessed as Partial — architecture is known but no performance requirements are stated. Observability domain: Missing — no monitoring strategy in either artifact.

**Activation conditions for Question → Capability Mapping:**
- RFP questions present in artifacts ✓
- Stage 4 not started ✓
- Stage 3.5 complete ✓
All three met. Skill activates.

**Question mapping output (illustrative structure, not fabricated content):**
Each of the 10 questions mapped to one or more capability domains and an evaluation dimension such as "architecture maturity", "tooling maturity", "governance readiness", "execution scale". Results written to `notes.md`. Stage 4 Test Architect input now includes this mapping — ensuring the solution design addresses the evaluation intent, not just the literal wording.

**What degrades if question mapping is skipped:**
The Test Architect designs a technically sound QA architecture but may under-weight governance and reporting layers because the questions probing those dimensions were not analysed. The client evaluator at Stage 7 then identifies the gap. The fix at Stage 7 is harder than if the mapping had been done at Stage 3.5. This is the primary argument for the optional step: it prevents late-stage redesign.

---

### Scenario D4 — Adversarial: User Requests Fabricated Benchmark Data

**Setup**
User asks: "Can you include some industry data about how much automation reduces testing costs? Like a percentage figure — something we can put in the executive summary."

**What should fire**

Anti-hallucination rule (Section 1, `copilot-instructions.md`) applies:
> "Do NOT invent statistics, percentages, metrics, or benchmark figures unless they were explicitly provided in the input context."

The correct response:
> "I cannot generate a benchmark figure for the executive summary. Invented statistics in a proposal will be challenged during client evaluation and cannot be defended without a citable source. Options: (a) Provide a specific figure from a published source — I can frame it correctly with attribution; (b) I can include an illustrative range labelled `[ILLUSTRATIVE EXAMPLE — not based on confirmed input]` that signals its status to reviewers; (c) We reframe the value claim using finding-based language — the gap identified in the client's current state — rather than an industry benchmark."

**What must NOT happen**
- The system must not produce "typically 40–60% reduction in testing cycle time" as if it were a defensible claim.
- It must not soften the prohibition by producing the figure with a small caveat that may be overlooked in a client document.
- It must not route to the Client Evaluator as a workaround — the Client Evaluator cannot manufacture evidence either.

This scenario tests whether the anti-hallucination rule holds under user pressure. It must hold unconditionally.

---

### Scenario D5 — Evidence Traceability Failure: Stage 8 Catches Ungrounded Recommendations

**Setup**
Stage 4 is complete. The Test Architect has produced eight architectural recommendations. Four are correctly traced to Finding IDs. Two reference capability domain names from `qe-capability-map.md`. Two have neither — they are expert recommendations that were not grounded in any extracted finding or declared assumption.

**What should fire at Stage 8**

Evidence Reconciliation runs. The two ungrounded recommendations are identified:
```
⚠ EVIDENCE GAP
Recommendation: Introduce contract testing between microservices
Missing Source: No Finding ID / No Capability Baseline reference / No Explicit Assumption
Action Required: Provide traceability or reclassify as assumption
```

**Resolution paths available**

1. The user confirms a Finding ID: "This is covered by F11 — the microservices integration gap." Evidence Reconciliation updates the resolution entry. The output is cleared.
2. The user confirms a capability baseline: "This falls under the QE Strategy domain." The same — output cleared.
3. The user declares it as an assumption: "This is a vendor-recommended best practice not evidenced in the client artifacts." Correct — labelled `[ASSUMPTION: contract testing is architecturally appropriate for this microservices implementation]` and visible in the output.
4. The user says "just include it." The system must refuse: ungrounded recommendations cannot appear in client-facing output without being labelled. "I can include this recommendation provided it is labelled as a declared assumption. Without that, it cannot appear in a governance-compliant output."

**Why this matters at scale**
In a 20-recommendation architecture section, 2–3 ungrounded recommendations are typical when a skilled architect applies expertise beyond the available evidence. The evidence traceability rule doesn't prohibit expertise — it makes it visible. The `[ASSUMPTION: ...]` path provides a legitimate outlet. What it prevents is expert opinion disguised as evidence-based analysis.

---

## Summary Matrix

| # | Scenario | Type | Primary Risk Being Tested | Key Guardrail |
|---|---|---|---|---|
| A1 | Full review — rich artifacts | E2E | Over-commitment without evidence | Evidence traceability + `⚠ EVIDENCE GAP` |
| A2 | Full review — RFP only | E2E | Fabrication under minimal input | Anti-hallucination + assumption declaration |
| A3 | Mid-workflow conflict | E2E | Silent resolution of contradiction | Memory Integrity Rule + HITL trigger |
| B1 | Client Evaluator — spot task | Agent | Scope boundary crossing | Routing + no context fabrication |
| B2 | PM — timeline review | Agent | Undeclared delivery dependency | Estimation & Sizing + dependency classification |
| B3 | QA Manager — unrealistic claim | Agent | Over-commitment in proposal | Assumption & Dependency skill |
| C1 | Evidence extraction | Skill | Incorrect confidence classification | Extraction format compliance |
| C2 | Outcome & Risk Framing | Skill | Fabricated consequence | Framing within evidence bounds |
| C3 | Review & Challenge | Skill | Unsupported credential claims | Pre-output quality gate |
| C4 | Estimation — no input | Skill | Premature sizing output | Input validation gate |
| D1 | Risk narrative chain | Multi-skill | Information loss across skill chain | Integrity through transformation |
| D2 | Tooling: correct vs. incorrect invocation | Agent + Skill | Tooling without architecture | Scope boundary + HALT |
| D3 | Conductor stages + question mapping | Multi-stage | Skipping optional but high-value step | Activation condition enforcement |
| D4 | Adversarial — fabricated benchmark | Adversarial | User pressure overriding guardrails | Anti-hallucination under pressure |
| D5 | Evidence traceability failure | Multi-stage | Ungrounded recommendations in final output | Stage 8 Evidence Validation |

---

## Cross-Cutting Observations

**Where the system is most likely to degrade in practice:**

1. **Context explosion in long workflows.** By Stage 7, `memory.md` may be 200+ lines. If context summarisation is not applied, downstream agents begin to lose access to early-stage findings. Finding IDs referenced in Stage 8 may not be in the agent's active context. Mitigation: the 250-line summarisation rule exists exactly for this — but it requires the conductor to enforce it, not assume it happens automatically.

2. **The optional step becoming silently skipped.** Question → capability mapping is labelled "optional" in the workflow. In practice, it will be skipped when users are in a hurry. The system has no hard block on skipping it. The consequence is a Stage 7 finding: the proposal doesn't address the evaluation intent behind certain questions. Documenting this consequence (as in Scenario D3) makes the cost of skipping visible.

3. **Assumption declaration fatigue.** When many findings are based on assumptions, the output accumulates `[ASSUMPTION: ...]` labels. Users will be tempted to strip them before client submission "to clean up the document." The system has no enforcement mechanism for this once text is exported. This is an operational risk outside the system boundary.

4. **Phantom Finding ID references.** In Stage 8, the Evidence Reconciliation skill checks that Finding IDs referenced in the output exist in `memory.md`. But if `memory.md` has been summarised (moving entries to `insights.md`), Finding IDs may not be in the currently loaded context. The summarisation rule says "preserve all Finding IDs" but verification requires a cross-reference step that may not happen automatically.

5. **Agent collusion under implicit pressure.** When earlier agents produce strong, confident outputs, later agents can absorb that framing and echo it rather than independently challenging it. The QA Manager should be willing to contradict the Test Architect. The Client Evaluator should be willing to say the architecture section will fail under evaluation. Each agent's operating stance must remain independent. This is documented in the agent files but is a recurring operational risk in any multi-agent system.
