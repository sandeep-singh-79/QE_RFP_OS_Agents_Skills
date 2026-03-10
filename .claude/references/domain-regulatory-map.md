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
| Payments / Card Processing | Implicit          | PCI DSS scope likely; financial data governance rules apply |
| Healthcare                | Implicit           | Patient data obligations, clinical systems governance, data protection requirements |
| Insurance                 | Implicit           | Financial services regulation, solvency and data governance obligations |
| Telecommunications        | Implicit           | Consumer data and communications regulation in most jurisdictions |
| Energy Infrastructure     | Implicit           | Critical national infrastructure — operational and data protection obligations |
| Government / Public Sector | Implicit          | Data protection legislation, public sector governance requirements |
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
