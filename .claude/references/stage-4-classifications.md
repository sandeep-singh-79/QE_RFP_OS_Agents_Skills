# Stage 4 — Classification Reference

> **Used by:** Test Architect at Stage 4 — Solution Design.
> Load this file when Benefit Realisability Classification, Risk-Based Test Classification, or Application Clustering Draft is required. Contains the full procedure, values, formats, and rules for each.

---

## Benefit Realisability Classification

**When:** Mandatory at Stage 4 — applies to every benefit claim proposed by the Test Architect.

### Classification values

| Category | Definition | Example |
|---|---|---|
| `Unconditional` | Governance or practice change; no infrastructure or tooling dependency | Defect triage process adoption, mandatory stage gates, shift-left discipline |
| `Conditional — Client Infrastructure` | Requires CI/CD, environment, or tooling that the client controls | Shift-left automation requiring client CI/CD pipeline; environment-on-demand requiring client cloud provisioning |
| `Conditional — Vendor Delivery` | Requires vendor tool deployment or platform readiness before the benefit can be realised | GenAI-assisted test case generation via vendor platform; vendor observability tooling |

### Rule
Unarticulated benefit claims must not pass Stage 4. Every proposed benefit claim must have a row in the output table.

### Output format
Write all classifications to `claude-memory/notes.md` under `## Benefit Claim Classification`:

```
| Benefit Claim | Category | Dependency | Phase Realisation Earliest |
|---|---|---|---|
```

**Consumption:** Stage 9 Section 10 (Benefit Realisation) reads this table. Conditional claims must display their dependency and earliest-phase qualifier. Unconditional claims display without caveat.

---

## Risk-Based Test Classification

**When:** Conditional at Stage 4. Activation condition: `application_count > 1` OR Discovery Maturity = `Deep`.

### Tier determination
Risk Tier = change frequency × business impact × integration complexity.

| Risk Tier | Guidance |
|---|---|
| High | High change frequency AND high business impact AND/OR high integration complexity |
| Medium | Moderate on at least two of the three dimensions |
| Low | Low change frequency AND contained business impact AND/OR simple integrations |

### Output format

```
| Change Type | Risk Tier (High/Medium/Low) | Required Test Depth | Automation Priority |
|---|---|---|---|
```

### Rules
- Minimum 3 change types must be classified (e.g., product launch, regulatory change, BAU maintenance).
- This table must be produced **before** architecture pillars are finalised.
- If insufficient artefact evidence exists, raise as Open Condition at Stage 4 rather than producing an unsupported table: "OC — Insufficient evidence to produce risk-tier classification. To be confirmed in Phase 0 discovery."
- This table is referenced by Stage 9 Section 7 (QE Architecture / Pillars) within the test strategy pillar.

---

## Application Clustering Draft

**When:** Conditional at Stage 4. Activation condition: `application_count > 1`.

### Tier model

| Tier | Definition | Wave Sequencing |
|---|---|---|
| Tier A | Complex/high-risk applications — high automation maturity gap AND/OR critical business function | Later delivery waves |
| Tier B | Mid-complexity — moderate risk and integration complexity | Middle waves |
| Tier C | Stable/low-risk — low complexity, strong quick-win automation potential | First waves; recommended pilot candidates |

### Output format
Write to `claude-memory/notes.md` under `## Application Clustering Draft`:

```
| Application | Risk Level | Automation Maturity | Integration Complexity | Business Criticality | Tier Assignment |
|---|---|---|---|---|---|
```

Rate each dimension: High / Med / Low. Tier Assignment: A / B / C.

### Rules
- Source: Stage 1 evidence — named applications from technology landscape findings, Section 3 artefact signals.
- Unknown applications: write "Phase 0 — to be confirmed during discovery" in all dimension cells.
- This draft is consumed by Stage 6 (delivery planning — wave sequencing validation against tier assignments).
- Stage 9 Section 14 confirms this draft — it does not rebuild from scratch. Section 14 may refine tier assignments based on Stage 5–8 findings.
