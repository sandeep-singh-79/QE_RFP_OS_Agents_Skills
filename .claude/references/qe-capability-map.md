# QE Capability Map

> Reference file for the Capability Coverage Thinking skill.  
> Used during Stage 3.5 — Capability Coverage Check to evaluate client evidence against the expected QE capability baseline.  
> Eight capability domains are defined. All eight must be assessed regardless of whether evidence is present.

---

## 1. QE Strategy

Core quality engineering governance and direction-setting capabilities.

| Capability | Description |
|---|---|
| Test Strategy | Defined, documented test strategy aligned to project objectives |
| Quality Governance | Quality gates, sign-off criteria, and escalation paths |
| Metrics Framework | Quality KPIs, defect SLAs, test coverage targets |

---

## 2. Shift-left Testing

Practices that move defect detection earlier in the delivery lifecycle.

| Capability | Description |
|---|---|
| Requirement Validation | QA involvement in requirements review and acceptance criteria definition |
| API Contract Testing | Contract-level validation between services before integration testing |
| Early Defect Detection | Unit testing discipline, static analysis, and peer review processes |

---

## 3. Automation Strategy

Test automation capability across layers and platforms.

| Capability | Description |
|---|---|
| UI Automation | Automated end-to-end test coverage for user-facing interfaces |
| API Automation | Automated regression coverage at the service/API layer |
| Test Pyramid Alignment | Distribution of tests across unit, integration, and UI layers |

---

## 4. CI/CD Integration

Quality gates embedded in the delivery pipeline.

| Capability | Description |
|---|---|
| Pipeline Test Execution | Automated tests triggered on every build or merge |
| QA Quality Gates | Pass/fail quality thresholds enforced in the pipeline |
| Pipeline Validation | Validation that the pipeline itself is functioning correctly |

---

## 5. Test Data Management

Strategies for managing test data safely and effectively.

| Capability | Description |
|---|---|
| Data Masking | Anonymisation or masking of sensitive data for non-production use |
| Synthetic Data Generation | Creation of realistic test data without using production data |
| Data Provisioning | On-demand test data availability for environments and test runs |

---

## 6. Environment Strategy

Management of test environments to support reliable testing.

| Capability | Description |
|---|---|
| Service Virtualization | Simulation of dependent systems not available during testing |
| Ephemeral Environments | Short-lived, on-demand environments for isolated testing |
| Environment Parity | Consistency between test and production environment configurations |

---

## 7. Observability

Monitoring and telemetry capabilities that support QA in production-adjacent contexts.

| Capability | Description |
|---|---|
| Telemetry Validation | Verification that logs, metrics, and traces are correct and complete |
| Production Monitoring | Active monitoring of production quality signals post-release |
| Test Observability | Visibility into test execution status, failures, and trends |

---

## 8. Non-functional Testing

Testing coverage beyond functional correctness.

| Capability | Description |
|---|---|
| Performance Testing | Load, stress, and endurance testing for throughput and response time |
| Security Testing | SAST, DAST, penetration testing, and vulnerability scanning |
| Accessibility Testing | Compliance with accessibility standards (WCAG or equivalent) |

---

## 9. AI-Assisted Quality Engineering

Leveraging AI and GenAI capabilities to enhance QE delivery velocity, coverage, and intelligence.

| Capability | Description |
|---|---|
| AI/GenAI Test Generation | Using AI/LLM-based tools to generate test cases, test data, and test scripts from requirements or code |
| Self-Healing Automation | Automated test maintenance using AI to detect and repair broken selectors or test steps |
| AI-Driven Exploratory Testing | AI-assisted exploratory testing that surfaces edge cases by adapting to application behaviour |
| Intelligent Defect Analysis | AI-powered defect triage, root cause analysis, and defect prediction |

---

## Status Legend

| Status | Meaning |
|---|---|
| `Present` | Evidence in `claude-memory/memory.md` clearly confirms this capability is addressed |
| `Partial` | Some evidence exists but coverage is incomplete or surface-level only |
| `Missing` | No evidence in `claude-memory/memory.md` supports this capability being addressed |
