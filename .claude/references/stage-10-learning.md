# Stage 10 — System Learning Protocol

> **Used by:** Conductor at Stage 10 — System Learning.
> Load this file when Stage 10 begins. Contains the full learning protocol, improvements.md schema, and backlog governance rules.

---

## Learning Actions

At Stage 10, the conductor performs all eight of the following actions:

1. **Insight candidate promotion** — scan `claude-memory/notes.md` for all `## Insight Candidates` entries (flagged during Stages 1–8 using the `INSIGHT CANDIDATE` marker). For each candidate, evaluate: Is this pattern likely to recur across other engagements? Is it actionable for future analysis? If yes — promote to `claude-memory/insights.md` as a named insight with a carry-forward rule (see Action 7 below for the Insights vs. Improvements distinction). If no — discard with a one-line note explaining why. Clear the `## Insight Candidates` section in `claude-memory/notes.md` after promotion.

2. **Missed findings** — review `claude-memory/memory.md` for any finding with no downstream resolution. Log missed findings as improvement proposals in `claude-memory/improvements.md`.

3. **Reasoning weaknesses** — identify where agents produced shallow, assumed, or unsourced analysis. Propose specific skill or prompt improvements.

4. **Workflow inefficiencies** — identify stages that were redundant, out of order, or produced low-value output in this engagement.

5. **Improvement proposals** — generate specific, actionable improvement proposals for the QE OS and record in `claude-memory/improvements.md`.

6. **Evidence gap monitoring** — identify conclusions delivered in the output that lacked evidence traceability (no Finding ID, capability baseline, or declared assumption). Record each as an improvement proposal with Root Cause = "Reasoning without evidence source". If more than 3 evidence gap proposals accumulate, flag for human review before the next engagement.

7. **Engagement pattern promotion** — identify any finding, behaviour, or pattern from this engagement likely to recur across future bids. Promote to `claude-memory/insights.md` as a named insight with a carry-forward rule. Examples: how clients frame constrained-discovery bids, evidence types consistently missing, common proposal defensibility failures.

8. **Distinguish insights from improvements** — `claude-memory/insights.md` receives recurring engagement *patterns* (how clients behave, how proposals fail, what evidence is typically missing). `claude-memory/improvements.md` receives *system fixes* (schema changes, new workflow checks, new rules). The same observation may generate entries in both files if it is both a pattern worth preserving AND a system gap that needs fixing. Do not conflate the two.

---

## improvements.md Schema

Each improvement proposal must follow this format:

```
### Improvement Proposal: [ID]
- **Observation:** [what was observed during the engagement]
- **Root Cause:** [why the system produced a suboptimal result]
- **Suggested Change:** [specific change to agent, skill, or workflow]
- **Impact:** High / Medium / Low
- **Status:** Proposed / Approved / Implemented / Rejected
- **Priority:** High / Medium / Low
```

---

## Backlog Governance

- Maximum **10 active proposals** may exist at one time (Status: Proposed or Approved)
- When the limit is reached, new proposals must replace a lower-priority active proposal or wait until one is resolved
- Resolved and rejected proposals must be moved to an `## Archive` section within `claude-memory/improvements.md` — they must not be deleted
- The archive preserves institutional learning without inflating active context

**System file protection:** Agents propose changes in `claude-memory/improvements.md` only — they do not directly modify `.claude/` system files. See `.claude/governance.md` — System File Protection.
