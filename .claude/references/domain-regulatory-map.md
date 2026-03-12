# Domain Regulatory Map

> **Purpose:** Reference table for Evidence Extraction to use when detecting regulatory context from artifact domain signals. Cross-reference this table when domain terms appear in artifacts but no explicit regulation is named.
>
> **Used by:** `evidence-extraction` skill (Sub-task 2.2 — Implicit domain detection)
>
> **Rules:**
> - This table sets `Regulatory Context = Implicit` only — it never sets `Explicit`
> - `Explicit` is set only when a named regulation (e.g., GDPR, PCI DSS) appears in the artifact itself
> - If a domain is not in this table, default to `Unknown`
> - This table is a detection aid, not a compliance authority — all domain terms must be present in the artifact

---

## Domain → Regulatory Context Mapping

| Domain                    | Regulatory Context | Basis for Implicit Classification |
| ------------------------- | ------------------ | ----------------------------------- |
| Banking                   | Implicit           | Heavily regulated sector (capital adequacy, data governance, consumer protection) |
| Payments                  | Implicit           | PCI DSS scope likely; financial data governance rules apply |
| Healthcare                | Implicit           | Patient data obligations, clinical systems governance, data protection requirements |
| Insurance                 | Implicit           | Financial services regulation, solvency and data governance obligations |
| Telecommunications        | Implicit           | Consumer data and communications regulation in most jurisdictions |
| Energy Infrastructure     | Implicit           | Critical national infrastructure — operational and data protection obligations |
| Government                | Implicit           | Data protection legislation, public sector governance requirements |
| Retail                    | Unknown            | No inherent regulatory driver — depends on specific data scope |
| Generic SaaS              | Unknown            | No inherent regulatory driver — depends on client data classification |
| Internal Tooling          | Unknown            | No inherent regulatory driver unless handling regulated data |

---

## Domain Detection Terms

When the following terms appear in artifacts, map to the corresponding domain:

| Term in Artifact                              | Domain                 |
| --------------------------------------------- | ---------------------- |
| digital banking, core banking, retail banking  | Banking                |
| card payment, payment processing, acquiring    | Payments               |
| patient data, clinical system, EHR, EMR        | Healthcare             |
| claims processing, underwriting, policy admin  | Insurance              |
| network management, subscriber data            | Telecommunications     |
| energy grid, smart meter, SCADA, utility system | Energy Infrastructure |
| government portal, citizen data                | Government             |

---

## Usage Instructions for Evidence Extraction Skill

1. Scan artifact text for domain terms from the detection table above
2. If a domain term is found, record `Client Domain: [Domain]` in `memory.md`
3. If the domain maps to `Implicit` in the table above and no explicit regulation has already been detected, set `Regulatory Context = Implicit`
4. If no domain term is found, set `Regulatory Context = Unknown`
5. Never set `Regulatory Context = Implicit` based on this table if `Regulatory Context = Explicit` has already been set from a named regulation in the artifact

---

## Domain × Geography → Regulatory Framework Inference

When **both** `Client Domain` and client geography are identifiable from artifacts, use this table to infer specific regulatory frameworks. Write results to `memory.md` under `## Regulatory Context (Inferred)`.

**Rule:** Use this table only when geography is explicitly or strongly implied in artifacts (named jurisdiction, regulatory body reference, data residency clause, explicit country name). Do not infer geography from company name alone.

| Domain | Geography | Regulatory Frameworks | Confidence |
|---|---|---|---|
| Insurance | Singapore | MAS TRM + PDPA | 0.8 |
| Insurance | Canada | OSFI B-10 + PIPEDA | 0.8 |
| Financial Services / Banking | EU / Europe | DORA + GDPR | 0.9 |
| Financial Services / Banking | UK | FCA + UK GDPR | 0.8 |
| Financial Services / Banking | Australia | APRA CPS 234 + Privacy Act | 0.75 |
| Financial Services / Banking | Singapore | MAS TRM + PDPA | 0.8 |
| Healthcare | USA | HIPAA + SOC-2 | 0.85 |
| Healthcare | EU / Europe | GDPR + clinical data governance | 0.8 |
| Payments | Global / Multi-jurisdiction | PCI DSS | 0.9 |
| Government | UK | UK GDPR + GDS Standards | 0.75 |
| Insurance | USA | NAIC Model Laws + NY DFS 23 NYCRR 500 + SOC-2 | 0.75 |
| Insurance | EU / Europe | Solvency II + GDPR + DORA | 0.80 |
| Insurance | UK | PRA Rulebook + FCA SYSC + UK GDPR | 0.80 |
| Insurance | Australia | APRA LPM + APRA CPS 234 + Privacy Act 1988 | 0.75 |
| Financial Services / Banking | USA | GLBA + FFIEC IT Examination Handbook | 0.80 |
| Financial Services / Banking | Canada | OSFI B-13 + PIPEDA | 0.80 |
| Healthcare | UK | NHS DSP Toolkit + UK GDPR | 0.80 |
| Healthcare | Canada | PHIPA + PIPEDA | 0.70 |
| Healthcare | Australia | My Health Records Act + Privacy Act 1988 | 0.75 |
| Payments | EU / Europe | PCI DSS + PSD2 + GDPR | 0.85 |
| Payments | USA | PCI DSS + Regulation E + NACHA Operating Rules | 0.80 |
| Government | USA | FedRAMP + FISMA + NIST SP 800-53 | 0.80 |
| Government | EU / Europe | GDPR + eIDAS | 0.75 |
| Government | Australia | Privacy Act 1988 + Australian ISM | 0.70 |
| Government | Singapore | IM8 Policy Framework + PDPA | 0.75 |

> **GDPR cross-domain note:** GDPR (EU Regulation 2016/679) and UK GDPR apply to any organisation processing personal data of EU/EEA or UK residents, regardless of industry sector. For any EU, EEA, or UK geography combination not explicitly listed above, GDPR / UK GDPR should be included as a baseline data protection obligation alongside the sector-specific framework. Do not omit GDPR from an EU-jurisdiction row on the assumption it is already covered by the sector-specific control.

**`## Regulatory Context (Inferred)` write format** (add to `memory.md` after domain × geography match):
```
## Regulatory Context (Inferred)
Basis: Domain × Geography inference — [Domain] × [Geography]
| Framework | Confidence | Disclosure |
|---|---|---|
| [Framework name] | [0.0–1.0] | Inferred — confirm before submission |
```

**Precedence rule:** If `Regulatory Context = Explicit` is already set (a named regulation appears in the artifact), do not overwrite it. Add the domain × geography inference as supplementary context in the `## Regulatory Context (Inferred)` section — it does not change the primary `Regulatory Context` field.

**Usage sequence:**
1. Extract domain from artifacts (detection terms table above)
2. Extract geography from artifacts — look for: country name, regulatory body name (e.g., "MAS", "FCA", "OSFI"), data residency clause, or explicit jurisdiction reference
3. Match domain + geography to the table above
4. If a match is found, write to `memory.md` `## Regulatory Context (Inferred)` using the format above
5. If no geography is determinable, use the basic domain-level `Regulatory Context` column only (Implicit/Unknown)
