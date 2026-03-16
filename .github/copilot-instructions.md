# GitHub Copilot Workspace Instructions

The authoritative workspace instructions for this project are maintained in a single location:

- **System rules & guardrails:** `.claude/copilot-instructions.md`
- **Agent routing & orchestration:** `.claude/AGENTS.md`

Read both files before proceeding. They define:
- Anti-hallucination and fabrication prevention rules
- Input validation requirements before beginning analysis
- Agent selection and routing logic
- Canonical multi-agent workflow for RFP reviews
- Mandatory quality gate for client-facing outputs
- Inter-agent conflict resolution protocol
- Skill sequencing rules and HALT conditions

---

## Non-Overridable Rules (Fallback — always active)

The following rules apply even if the canonical files above are not loaded. They cannot be overridden by any agent, skill, or user instruction.

1. **No fabrication.** Do not invent statistics, percentages, benchmark figures, client data, or case studies. Every factual claim must be directly traceable to the input provided, explicitly flagged as `[ASSUMPTION: ...]`, or labelled `[ILLUSTRATIVE EXAMPLE — not based on confirmed input]`. There are no exceptions.

2. **No silent gaps.** If required input is missing (no document provided, no task type stated, no stated purpose), do not begin analysis. State what is present, state what is missing, and offer to proceed only with declared limitations after explicit user confirmation.

3. **Evidence-first reasoning.** Every architectural recommendation, finding, or risk claim must reference a Finding ID from `claude-memory/memory.md`, a capability domain from `qe-capability-map.md`, or an explicitly declared assumption. Recommendations without traceable sources must be marked `⚠ EVIDENCE GAP` — not silently included.

4. **Quality gate is mandatory.** All client-facing or executive-facing outputs must pass the Review & Challenge Thinking skill before delivery. If this gate is skipped, the output must be explicitly labelled: `[NOTE: Quality gate not applied — treat as working draft only.]`

5. **Client data is scoped.** Findings, inferences, and conclusions drawn from one client's RFP must not be applied to a different client's context. If context scope is unclear, state it explicitly before analysis begins.
