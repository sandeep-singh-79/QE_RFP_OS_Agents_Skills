# Stage 0 — Engagement Inputs Reference

> **Used by:** Conductor at Stage 0 — Artifact Discovery.
> Load this file when populating the Engagement Details block in `plan.md`. It defines valid values and classification rules for all Stage 0 fields.

---

## Discovery Maturity Classification

Assess and record the Discovery Maturity level based on the depth of artifact access available. Record in `plan.md` Engagement Details and append to the `claude-memory/artifacts.md` header block.

| Level | Definition | Implication for Downstream Stages |
|---|---|---|
| `Constrained` | Client explicitly limited pre-award access, or stated that deeper discovery is post-award. Only high-level briefs or RFP documents available. | Missing evidence at Stage 0 is expected — not a system failure. Gap classification at Stages 3 and 8 must account for this before escalating findings to Unresolved. |
| `Moderate` | Standard artifact set available (RFP + some clarifications or supporting documents) but no deep technical access (architecture, CI/CD, test inventory). **Default if not otherwise determinable.** | Some gaps are expected. Flag as expected where clearly pre-award constraints apply. |
| `Deep` | Full artifact set including architecture diagrams, CI/CD pipeline descriptions, test inventories, and/or direct access to technical teams. | Gaps have less justification — missing evidence is a genuine gap unless explicitly explained. |

**Determination criteria:**
- `Constrained`: Explicit client language limiting pre-award access; or stated model where full discovery is a post-award transition activity; or only an RFP document is available with no supporting technical artifacts.
- `Deep`: Architecture diagrams, CI/CD pipeline descriptions, test inventories, KEDB, or call transcripts with technical detail are all present.
- `Moderate`: Everything in between — some but not all supporting artifacts present.

**Downstream stage behaviour when Discovery Maturity = `Constrained`:**
- Stages 3 and 8: Classify expected gaps as `Deferred to Transition — Explicitly Declared` (see Stage 3) rather than `Unresolved`, provided all three required fields are declared.
- Do not escalate missing evidence to HITL unless the missing evidence was explicitly required by the RFP itself.
- Record the Constrained classification in `claude-memory/notes.md` so all downstream agents are aware.

---

## Engagement Type Classification

Determine Engagement Type from artifact signals (RFP framing, SOW structure, engagement model language) and record in `plan.md`. Used by Stage 9 to determine which conditional output sections to generate.

| Value | Definition |
|---|---|
| `managed_service` | Ongoing QE delivery under a managed service or shared service model — R Systems owns execution |
| `transformation_partnership` | Multi-phase QA transformation engagement — R Systems leads uplift, client retains ongoing delivery |
| `retained_qe_delivery` | Retained QE capacity — R Systems provides embedded resources within client delivery teams |
| `standalone_project` | Fixed-scope QA project with clear end date and defined deliverables |
| `qa_audit` | Assessment or audit engagement — no transformation roadmap in scope; evaluation and recommendations only |

If engagement type cannot be determined from artifacts, default to `transformation_partnership` and note the uncertainty in `claude-memory/notes.md`.

---

## Engagement Signal Classification

Engagement Signals capture specific delivery-context flags that are orthogonal to Engagement Type but control conditional output sections in Stage 9. Detect from artifact language (RFP framing, incumbent vendor references, team distribution descriptions, consolidation intent). Record all that apply — signals are not mutually exclusive.

| Signal | Definition | Detection Indicators |
|---|---|---|
| `incumbent_vendor_present` | A named delivery vendor currently holds the QA/QE function or a portion of it | "current vendor", "existing supplier", "incumbent", named third party in scope description, TUPE / staff transfer reference |
| `distributed_delivery_consolidation` | QA delivery is currently spread across multiple teams, geographies, or business units and the engagement seeks to consolidate it | "fragmented", "siloed", "multiple teams", "consolidate", "standardise across", "centre of excellence" |
| `vendor_transition` | The engagement explicitly involves transitioning delivery from the incumbent to R Systems | "transition", "handover", "take over", "cutover", "migration of delivery", TUPE reference, transition period in SOW |
| `greenfield_delivery` | No pre-existing QA function or delivery team — building from scratch | "no QA team", "greenfield", "build from scratch", "no current testing process" |

**Determination rules:**
- Set `incumbent_vendor_present` whenever a named third party currently performing QA is referenced — even if a formal transition is not mentioned.
- Set `vendor_transition` only when the transition of delivery responsibility is explicitly described. `vendor_transition` implies `incumbent_vendor_present` — set both.
- `greenfield_delivery` and `incumbent_vendor_present` are mutually exclusive.
- If no signals are detectable from artifacts, record `none` and note the absence in `claude-memory/notes.md`.
- Signals are consumed by Stage 9 Section 15 (Transition Model) trigger logic.

**Incumbent vendor — dual-path detection (applied at Stage 0):**

Path 1 — Artefact-assisted detection: If A1/A2 artefacts name any of the following vendors in a QA or testing delivery context, auto-suggest `incumbent_vendor_present` and prompt the user to confirm before the signal is set:

> Cognizant, Infosys, Wipro, TCS, Capgemini, HCL, Accenture, DXC, LTIMindtree, Tech Mahindra, Mphasis, NTT Data

Vendor name alone is insufficient — it must appear in a delivery context (e.g., "current QA delivery", "existing testing partner", "incumbent vendor", "managed services provider"). Do not set the signal on a brand mention alone.

Path 2 — Explicit confirmation: If artefact scan does not detect an incumbent, the following question is mandatory before Stage 0 closes:
> "Is there an incumbent QA delivery vendor or testing partner currently engaged on this account? Confirm explicitly — this cannot be inferred from artefacts alone."

This question must be answered (yes + vendor name, or no) before Stage 0 closes. If unanswerable (e.g., automated run with no human present), raise an Open Condition at Stage 0: "OC — Incumbent vendor status unconfirmed. Section 15 may be suppressed. Confirm before submission."

**Signal format when confirmed:** Record in `plan.md` Engagement Signals as `incumbent_vendor_present ([vendor name])` — e.g., `incumbent_vendor_present (Cognizant)`.

---

## Regulatory Context Classification

Determine Regulatory Context from artifact signals and domain × geography inference. Record in `plan.md` Engagement Details under `Regulatory Context`. Consumed by Stage 4 architecture alignment and Stage 9 Section 10 output.

| Value | Definition | Determination Criteria |
|---|---|---|
| `Explicit` | A regulation or compliance framework is named in the artifacts | RFP, SoW, or supporting document explicitly names a regulation (e.g., GDPR, HIPAA, MAS TRM, SOC 2) |
| `Inferred ([framework], confidence [score])` | Domain × geography lookup in `domain-regulatory-map.md` yields a match | Client domain + geography combination maps to a known regulatory framework; no explicit naming in artifacts |
| `Unknown` | No artefact reference and no domain × geography match | Neither condition above applies |

**Determination procedure at Stage 0:**
1. Check artifacts for any named regulation → if found, set `Explicit`
2. If not found, run domain × geography lookup in `.claude/references/domain-regulatory-map.md`
3. If a match is found, set `Inferred ([framework name], confidence [score])` and raise Open Condition if confidence < 1.0
4. If no match, set `Unknown`

**Downstream behaviour:**
- Stage 1: reads `Regulatory Context` from `plan.md` and tags compliance-related findings as `Evidence Type: Compliance Requirement` where applicable. Does not re-run inference.
- Stage 2: notes the regulatory context value for the Test Architect in `claude-memory/notes.md`.
- Stage 4: uses the inferred/explicit frameworks to align architecture pillars with compliance requirements.
- Stage 8: if any finding has `Evidence Type: Compliance Requirement` AND `Regulatory Context = Explicit`, a Control Mapping Table is required before Stage 9 is cleared.

---

## Vendor Capability Manifest

If the engaging vendor has an AI or test automation platform, request the Vendor Capability Manifest before Stage 1 begins. Register it in `claude-memory/artifacts.md` (Type: Vendor Capability Manifest).

*Input declaration:* "If the vendor has an AI platform or test automation accelerator pack, provide a `vendor-capability-manifest` file before Stage 1 begins."

**Manifest schema** (YAML):
```yaml
vendor_name: [vendor name]
ai_platform_name: [platform name]
accelerators:
  - name: [accelerator name]
    description: [brief description]
    effort_saving_claim: [percentage or description — source evidence required]
    tier: [1 or 2]  # 1 = AI-assisted process tool, 2 = AI/ML predictive model
    phase_viable_from: [Phase 1 / Phase 2 / Phase 3 / Phase 4]
```

**Tier values:**
- `1` — AI-assisted process tool (LLM-based, SaaS/IDE extension, no specialist ML infrastructure; Phase 2-viable)
- `2` — AI/ML predictive model (training data + specialist ML resourcing required; Phase 3–4)

If no manifest is provided, skip this step — absence of a manifest does not block workflow progress.
