---
name: tooling-technology-recommendation
description: Recommend QE, automation, and shift-left tooling in a capability-driven, assumption-aware, and RFP-defensible manner — grounded in confirmed inputs and never based on inferred environments. Use when tooling guidance is explicitly requested in RFP responses or solution design, and only after QE Architect Thinking has defined the required capabilities. Never invoke to lead architecture decisions. Tooling is always a supporting decision, not a leading one. Trigger when the Test Architect Agent requests tooling validation or when a client explicitly asks for tooling recommendations.
---

# Skill: Tooling & Technology Recommendation

## Purpose
Recommend QE, automation, and shift-left tooling in a capability-driven, assumption-aware, and defensible manner — so that tooling narratives hold up under CIO, procurement, and technical evaluation.

Tooling chosen before capabilities are defined is a red flag to experienced evaluators. This skill ensures the sequence is always: capability first, tooling second.

---

## Invocation Check — STOP If Conditions Are Not Met

**Before making any tooling recommendation, perform this mandatory check:**

1. **Have required capabilities been defined by QE Architect Thinking?**
   - Check: Are specific capability requirements explicitly stated in the context?
   - If NO: State "Tooling cannot be recommended before capabilities are defined. Return to QE architecture definition first." Then HALT.
   
2. **Are architecture layers clearly articulated?**
   - Check: Are test layers, integration points, and quality gates specified?
   - If NO: State "Tooling cannot be validated against an undefined architecture. Complete architecture definition first." Then HALT.

**If either check fails, do not proceed.** Do not attempt to infer capabilities or architecture from the request. Tooling recommendations without defined capabilities are never defensible.

Only proceed if BOTH conditions are confirmed as met.

---

## Recommendation Sequence — Always Follow This Order

1. Identify required capabilities from the QE Architect Thinking output
2. Validate available inputs — what is confirmed about the client context?
3. Apply conditional recommendations based on confirmed inputs only
4. Declare assumptions and constraints explicitly, before presenting options
5. Present illustrative tooling options — framed as options, never as commitments

---

## Capability Domains

Evaluate tooling across these domains — never assume their existence in any client environment:

### Automation Execution
- UI automation execution
- API automation execution
- Cross-browser / cross-device support
- Parallel execution and scalability

### Shift-Left Enablement
- Test design support in early lifecycle stages
- Developer-facing quality feedback and local execution
- Contract and schema validation (Pact, Spring Cloud Contract)
- Pre-commit/pre-push hooks for fast local feedback (Husky, Git hooks)
- CI/CD pipeline integration for automated checks on every commit
- Early defect prevention mechanisms

Propose shift-left tooling only where development workflows and ownership models support early adoption. Contract testing requires API contract governance; local hooks require developer buy-in.

### CI/CD & Integration
- Pipeline integration and execution triggering
- Source control integration
- Environment orchestration compatibility
- Scheduling and parallel run management

Discuss in capability terms only — never assume connectivity.

### Reporting & Visibility
- Centralised result aggregation
- Quality trend analysis across builds and releases
- Release-level quality dashboards
- Stakeholder-oriented reporting views

Distinguish clearly: execution metrics vs quality trends vs release readiness indicators.

### Governance & Control
- Role-based access control
- Execution auditability
- Requirement-to-test-to-defect traceability
- Policy enforcement and approval workflows

---

## Defensibility Rules

Apply these in every response:

Language:
- Use capability-first framing throughout
- Use qualifying phrases: "where applicable", "subject to client ecosystem alignment", "based on confirmed constraints"
- Never use vendor marketing language
- Never imply architectural decisions have been made

Assumptions:
- Explicitly list all assumptions made in the absence of confirmed inputs
- Classify each: confirmed / client-dependent / to-be-validated
- Provide alternative recommendations where assumptions vary significantly
- No recommendation may be presented as factual without confirmed supporting input

---

## AI Capability Recommendation Guidance

This guidance applies when Domain 9 (AI-Assisted Quality Engineering) capabilities are being considered for inclusion in tooling recommendations. It is advisory — it does not override the Invocation Check gate.

**Recommend AI capabilities when:**
- The regression suite is large and maintenance burden is high (self-healing automation value applies)
- UI change velocity is high (self-healing and visual validation reduce brittle test maintenance)
- Exploratory coverage gaps exist that manual testing cannot close cost-effectively (AI-driven exploration applies)
- Test generation volume is high and requirements are machine-readable (GenAI test generation applies)
- Defect triage and root cause analysis are consuming significant analyst time (intelligent defect analysis applies)

**Do not recommend AI capabilities when:**
- Automation fundamentals are not yet in place (no CI/CD, no existing automation framework, no test pyramid) — AI accelerates an existing capability; it cannot substitute for foundational capability that does not yet exist
- The test suite is small and stable — ROI from self-healing or AI generation is insufficient to offset tooling and adoption overhead
- Compliance or contractual constraints prohibit AI-generated test artifacts or AI-assisted decision-making in the client environment
- The client has explicitly excluded AI tooling from scope
- Domain 9 status in the capability coverage assessment is `Missing` — do not position AI tooling when there is no evidence of AI QE readiness

**Always declare:**
- AI tooling recommendations are `client-dependent` or `to-be-validated` in the assumption classification (not `confirmed` unless client has an existing AI QE tool already in use)
- AI capability recommendations are conditional on Domain 9 capability maturity progressing to at least `Partial` by Phase 1 — do not schedule Tier 1 AI capability activation before Phase 1 unless Domain 9 evidence supports earlier readiness
- The AI recommendation must not substitute for or skip foundational tooling in the same capability category (e.g., recommending only self-healing automation without a stable base automation framework is not defensible)

---

## Illustrative Tool Categories

Reference as examples only — never as mandates. Verify current ecosystem fit before including in a client-facing submission, as tool landscapes evolve.

| Category | Examples |
|----------|---------|
| UI Automation | Playwright, Cypress, Selenium, WebdriverIO |
| API Testing | Playwright API, RestAssured, Postman/Newman |
| Contract Testing | Pact, Spring Cloud Contract, Specmatic |
| AI-Based Testing | WebMCP, browser-agent (Vercel), Applitools Eyes, Mabl |
| Test Management | Zephyr, Xray, TestRail, Azure DevOps Test Plans |
| CI/CD & Orchestration | GitHub Actions, Azure DevOps Pipelines, GitLab CI, Jenkins |
| Local Shift-Left Hooks | Husky, pre-commit, lint-staged, Git hooks |
| Reporting | Allure, native framework reporting, CI-native dashboards |
| Low-Code / No-Code | UiPath Test Suite, Tricentis Tosca, Functionize |

---

## Output Expectations

Produce:
- Capability-to-tool mapping, conditional on confirmed inputs
- Clearly declared assumptions and their classification
- Alternative options where inputs are uncertain
- Integration and governance considerations
- Phased adoption suggestions where relevant

---

## Do Not

- Define QE strategy or architecture — that belongs to QE Architect Thinking
- Perform discovery or gap analysis
- Create delivery timelines or staffing plans
- Simulate client-side evaluation
- Recommend tools before capabilities are defined