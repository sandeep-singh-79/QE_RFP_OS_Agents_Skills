# Trigger & Non-Trigger Prompt Reference

This file provides example prompts that **should** trigger each skill or agent, and example prompts that **should not** trigger them — even when they appear superficially related.

Use this reference to:
- Test that skills and agents are triggering correctly during setup
- Onboard new users to the system
- Diagnose undertriggering or overtriggering behaviour

---

## How to Read This File

Each entry contains:
- **Trigger prompts** — realistic user inputs that should activate the skill/agent
- **Non-trigger prompts** — inputs that touch adjacent territory but should NOT activate this skill/agent (a different one should handle them, or no skill is needed)
- **Why the distinction matters** — the reasoning behind the boundary

---

## Skills

---

### assumption-dependency-management

**Trigger prompts**
1. "We're putting together the assumptions section of the RFP response for the retail banking client. Can you help us identify what we're relying on and flag anything that needs client confirmation before we submit?"
2. "Our estimate assumes the client's environments will be ready on day one and that we'll have access to test data within two weeks. What other assumptions are we making that we haven't stated, and which of these are most likely to create problems?"
3. "Before we finalise the roadmap section, run through the dependencies — particularly anything the client controls that could block our delivery timeline."

**Non-trigger prompts**
1. "What's the best way to manage risks once delivery has started?" *(Delivery risk management post-award — not a pre-sales assumption capture task)*
2. "Can you help me write the executive summary for this proposal?" *(Executive Communication skill, not this one)*
3. "How should we estimate the automation effort for this engagement?" *(Estimation & Sizing Thinking, not this one)*

**Why the distinction matters:** This skill captures and classifies assumptions and dependencies at the point of committing to a proposal. It is a pre-submission quality gate, not a general risk management or delivery planning tool.

---

### domain-context-adaptation

**Trigger prompts**
1. "The client is a large retail bank. Can you review this QA strategy section and adjust the language so it resonates better with their context — especially around stability, compliance themes, and the kind of language their risk team would recognise?"
2. "We know this is a healthcare insurer. Go through the proposal and swap out the generic references to 'users' and 'defects' for language that aligns with their industry — but don't make any claims about specific regulations we haven't confirmed."
3. "The client is in government. The proposal is already structured and risks are framed. Now adapt the vocabulary and concern emphasis to match a public sector audience without overstating what we know about their regulatory environment."

**Non-trigger prompts**
1. "Can you make this proposal section sound more professional?" *(General writing improvement — no confirmed domain context provided; don't activate)*
2. "What regulations apply to QA in the insurance sector?" *(Domain knowledge question — this skill adapts language, it does not provide regulatory research)*
3. "The client hasn't told us their industry yet. Can you adapt the proposal for them anyway?" *(Activation gate blocks this — domain context must be confirmed first)*

**Why the distinction matters:** This skill must never activate without confirmed domain context. Adapting language to an assumed industry creates claims the proposal cannot back up.

---

### estimation-sizing-thinking

**Trigger prompts**
1. "We need to include an effort estimate in the response. The scope is approximately 200 test cases across three applications of varying complexity. What's a realistic range and how should we structure it?"
2. "The client is asking how long it will take to get to full automation coverage. Before we answer, I want to make sure we've separated the setup effort from the execution effort and accounted for ramp-up. Can you help structure this?"
3. "Our current estimate assumes the same productivity rate across all test cases. Is that defensible, or should we be applying a complexity adjustment? Walk me through how to do this properly."

**Non-trigger prompts**
1. "Can you build me a detailed project plan with named milestones and resource assignments?" *(This is a project plan, not a directional estimate — Project Manager Agent handles this)*
2. "What tools should we use to track our test execution progress?" *(Tooling question — Tooling & Technology Recommendation)*
3. "How do we present our approach to the client's steering committee?" *(Executive Communication — not estimation)*

**Why the distinction matters:** This skill produces directional, defensible sizing — not delivery plans. If the request requires committed dates, named resources, or task-level scheduling, it belongs to the Project Manager Agent.

---

### executive-communication

**Trigger prompts**
1. "We've got a solid risk analysis section but it's too technical for the CTO who'll be reading it. Can you rewrite it so the key risks and decisions come through clearly without all the QA-specific language?"
2. "This is going to the executive sponsor. I need the main message to land in under 30 seconds. Strip everything that doesn't directly answer: what's the risk, why does it matter, and what do we need from them."
3. "Turn these five findings into a one-page board-level summary. Keep it punchy — headlines, implications, asks. No technical detail."

**Non-trigger prompts**
1. "Can you write a full technical section on our regression approach for inclusion in the RFP response?" *(Technical content generation — QE Architect Thinking, not this skill)*
2. "What risks should we be flagging in this proposal?" *(Risk identification — Outcome & Risk Framing, not this skill)*
3. "We need a detailed breakdown of our automation framework for the client's technical evaluator." *(Technical audience, not executive — no adaptation needed)*

**Why the distinction matters:** This skill transforms content for a specific audience — senior, time-poor, non-technical decision-makers. If the audience is technical or the task is content creation rather than communication transformation, a different skill applies.

---

### outcome-risk-framing

**Trigger prompts**
1. "We've identified that the client has no test data management strategy. Can you frame this as a business risk — not a QA issue — with the right level of urgency and a clear statement of who needs to make a decision about it?"
2. "Here are three gaps we found during our discovery: no CI/CD integration, inconsistent test environments, and no traceability from requirements to tests. Frame each one in terms of business impact and urgency so we can include them in the proposal narrative."
3. "We want to flag the incumbent replacement risk in a way that resonates with the client's leadership team. Help me frame it as a delivery risk with a clear owner and decision needed — not as a technical concern."

**Non-trigger prompts**
1. "What are the typical risks in a QA transformation engagement?" *(General knowledge question — no framing of specific findings needed)*
2. "Can you restructure this risk section so it reads better?" *(Structuring & Consulting Thinking — not risk framing)*
3. "What tools would help us reduce the risk of test environment instability?" *(Tooling question — Tooling & Technology Recommendation)*

**Why the distinction matters:** This skill transforms specific, identified observations into business-impact narratives. It requires an actual finding to frame — it does not generate risks or restructure content.

---

### qe-architect-thinking

**Trigger prompts**
1. "Help me design the QA architecture for this proposal. The client is mid-maturity — they have some automation but it's fragmented and not integrated with CI/CD. What should our solution look like?"
2. "We're proposing a shift-left approach but I'm not sure we've thought through whether the client's teams are actually ready for it. Can you assess whether this is the right strategy and what guardrails we should put in place?"
3. "The client wants us to lead with GenAI-assisted test generation. Help me think through whether this is appropriate for their context and how to position it in a way that's credible under governance scrutiny."

**Non-trigger prompts**
1. "Which automation tool should we recommend for this client?" *(Tooling decision — Tooling & Technology Recommendation; capabilities must be defined first)*
2. "How long will it take to implement this QA strategy?" *(Estimation — Estimation & Sizing Thinking)*
3. "Can our team realistically deliver this approach?" *(Execution feasibility — QA Manager Agent)*

**Why the distinction matters:** This skill defines capabilities and architecture — the "what" and "why". Tool selection ("which") and execution feasibility ("can we") are handled downstream by other agents and skills.

---

### review-challenge-thinking

**Trigger prompts**
1. "Before we submit this response, I want someone to punch holes in it. Where are we over-committing, making assumptions we haven't stated, or saying things that a sceptical evaluator would flag?"
2. "Do a sense check on the delivery timeline section. Are there any sequencing issues, hidden dependencies, or optimism that could come back to hurt us?"
3. "Review the whole proposal as if you're a sceptical client-side QA Manager. What would you challenge, and what would you say doesn't hold up under real-world scrutiny?"

**Non-trigger prompts**
1. "Can you rewrite the methodology section to make it stronger?" *(Rewriting is explicitly excluded — this skill flags, not fixes)*
2. "What should we include in a QA proposal?" *(Content guidance, not critique of existing content)*
3. "Score this response out of 10." *(Client / RFP Evaluator Agent handles scoring simulation)*

**Why the distinction matters:** This skill critiques and classifies — it does not redesign, rewrite, or score. If the request is to improve content rather than identify problems, a different skill applies.

---

### structuring-consulting-thinking

**Trigger prompts**
1. "I've got a lot of raw notes from our discovery session. Can you turn these into a structured readout with clear priorities and a logical flow — something the client's leadership team can actually follow?"
2. "The methodology section is too long and flat — everything feels equally important. Restructure it so the main messages land first and the supporting detail sits underneath."
3. "We've got input from four different people and the proposal section is a mess. Consolidate, de-duplicate, and give it a proper hierarchy before we send it to the exec review."

**Non-trigger prompts**
1. "Can you assess which risks in this section are most serious?" *(Risk prioritisation — Outcome & Risk Framing)*
2. "Make this section sound more like it's coming from a banking expert." *(Domain & Context Adaptation)*
3. "Write me a new section on our automation approach." *(Content generation — QE Architect Thinking)*

**Why the distinction matters:** This skill structures and organises existing content — it does not create content, assess risk, or translate for domain audiences. If the material does not exist yet, content generation comes first.

---

### tooling-technology-recommendation

**Trigger prompts**
1. "We've defined the capabilities we need — UI automation, API testing, CI/CD integration, and a reporting layer. Given those requirements and the fact that the client is an Azure DevOps shop, what tooling options make sense to illustrate in the proposal?"
2. "The Test Architect has confirmed the architecture layers. Now help me work through the tooling options for the automation execution layer — keeping it illustrative and RFP-safe, with the right assumptions declared."
3. "The client has asked us to be specific about which tools we'd use for test management and traceability. We know they're on Jira. What options are appropriate to reference, and how should we frame them?"

**Non-trigger prompts**
1. "What QA tools are popular right now?" *(General market question — no capability requirements defined; this skill should not run without architecture inputs)*
2. "Should we recommend Playwright or Cypress for this client?" *(Tool comparison without confirmed capability requirements — activate pre-flight check first)*
3. "What's the best test management tool?" *(Generic tooling question with no capability or context inputs — cannot run)*

**Why the distinction matters:** This skill requires confirmed capability requirements as an input. Without them, the pre-flight check must halt and redirect to QE Architect Thinking / Test Architect first.

---

## Agents

---

### client-rfp-evaluator

**Trigger prompts**
1. "We've finished the methodology section. Before we lock it, can you review it from the perspective of a client evaluator — flag anything that would cause a score downgrade, any red flags, and anything that looks hard to defend internally?"
2. "Play the role of the client's procurement panel. Go through our proposal and tell me: what would you challenge, what would you score down, and is there anything here that's a potential disqualifier?"
3. "Do a defensibility review on the tooling narrative. Would a CIO or IT governance team see this as credible, or are there perception risks we haven't addressed?"

**Non-trigger prompts**
1. "Improve the methodology section so it reads better." *(Content improvement — this agent diagnoses, does not improve)*
2. "What do clients typically look for in a QA proposal?" *(General knowledge — no specific content to evaluate)*
3. "Review the plan for delivery risks." *(Delivery risk from a vendor perspective — Project Manager Agent, not this agent)*

**Why the distinction matters:** This agent simulates an adversarial external perspective on content that already exists. It only activates when there is specific vendor-authored content to evaluate from the client's scoring lens.

---

### project-manager

**Trigger prompts**
1. "We've proposed a 90-day onboarding timeline for the new tooling. Does this hold up — have we accounted for environment setup, licensing, and ramp-up time, or are we being optimistic?"
2. "Review the phasing in Section 4. Are the workstreams sequenced correctly, or are there dependencies we've assumed away that could cause scheduling problems?"
3. "The plan assumes the client will have test environments ready by week two. What are the delivery risks if that doesn't happen, and how should we reflect that in our response?"

**Non-trigger prompts**
1. "Should we recommend Jira or Azure DevOps for project tracking?" *(Tool selection — not a planning constraint assessment)*
2. "Is our automation approach technically sound?" *(Architecture — Test Architect Agent)*
3. "How do we communicate the delivery risk to the client's steering committee?" *(Executive Communication — not PM scope)*

**Why the distinction matters:** The Project Manager assesses plans, timelines, and sequencing from a delivery feasibility lens. Tool selection, architecture soundness, and executive communication are outside this agent's scope.

---

### qa-manager

**Trigger prompts**
1. "We're proposing a full BDD adoption for this client. Their QA team is mid-sized and has mostly been doing manual testing. Can you assess whether this is actually realistic for their teams to adopt and sustain?"
2. "The solution we've proposed involves Playwright with a custom framework and full CI/CD integration. A typical QA engineer on the client's team would need to learn Playwright, TypeScript, and pipeline configuration simultaneously. Is this adoption risk acceptable, or are we over-engineering?"
3. "From a day-to-day QA Manager perspective, what would break first in this proposal once the team is actually trying to run it? Where's the operational overhead going to cause problems?"

**Non-trigger prompts**
1. "Which automation framework is technically superior for this use case?" *(Technical tool comparison — Tooling & Technology Recommendation)*
2. "How long will it take to build out this automation suite?" *(Estimation — Estimation & Sizing Thinking)*
3. "Is this architecture scalable to enterprise level?" *(Architecture scalability — Test Architect Agent)*

**Why the distinction matters:** The QA Manager evaluates whether real teams with real skill profiles can adopt and sustain what is being proposed. Technical superiority and scalability are architecture concerns — execution realism is this agent's domain.

---

### test-architect

**Trigger prompts**
1. "Review the QA architecture section. Are all the layers covered — strategy, automation, shift-left, CI/CD gates, reporting, governance? Are there any gaps that a technical evaluator would flag?"
2. "We've proposed a Playwright-based automation framework. Before we finalise the tooling narrative, validate that the architecture is sound and that the tooling choice is appropriate for the capabilities we've defined."
3. "The client will be scaling this from a 3-application pilot to a 15-application enterprise rollout within 12 months. Is the architecture we've proposed actually scalable for that, or does it need rethinking?"

**Non-trigger prompts**
1. "Can delivery teams realistically adopt this framework?" *(Adoption feasibility — QA Manager Agent)*
2. "How long will it take to implement this architecture?" *(Estimation — Estimation & Sizing Thinking)*
3. "How should we present the architecture to the client's CIO?" *(Executive Communication)*

**Why the distinction matters:** The Test Architect focuses on whether the architecture itself is sound, complete, and scalable. Execution feasibility, sizing, and communication are owned by other agents.

---

### tooling-technology-recommender

**Trigger prompts**
1. "The Test Architect has signed off the architecture. The capabilities we need are: UI automation, API testing, CI/CD integration via Azure DevOps, and a release-level dashboard. The client is already on Azure. What tooling options should we illustrate in the proposal?"
2. "We need to validate that the tooling narrative in Section 3 holds up. Given the defined automation execution and reporting capability requirements, are the tools we've referenced appropriate, and are there any gaps or lock-in risks we should flag?"
3. "The client's technical team has confirmed they're a Jira/GitHub shop. Based on that and the integration capabilities we've specified, what are the most defensible tooling options to reference for CI/CD orchestration and test management?"

**Non-trigger prompts**
1. "What's the best automation tool for web applications generally?" *(No capability requirements defined — pre-flight check should block this and redirect to architecture definition)*
2. "We haven't defined the architecture yet but the client is asking about tools. Can you just give us something to work with?" *(Capability inputs missing — return to Test Architect first; do not guess)*
3. "Should we use cloud or on-prem test infrastructure?" *(Infrastructure decision — architecture and client context question, not tooling recommendation)*

**Why the distinction matters:** This agent requires confirmed capability requirements as a mandatory input. Without them it cannot run — it must redirect to the Test Architect to complete architecture definition before any tooling discussion begins.

---

## Where to Keep This File

Store this file at:

```
/references/trigger-prompts.md
```

within your skill and agent repository — as a sibling to the `skills/` and `agents/` folders.

Do not package this file inside individual `.skill` files. It is a shared reference resource for the whole system, not part of any individual skill's operating instructions.

Suggested repository structure:

```
qa-presales/
├── skills/
│   ├── assumption-dependency-management/
│   ├── domain-context-adaptation/
│   └── ... (all 9 skills)
├── agents/
│   ├── client-rfp-evaluator/
│   └── ... (all 5 agents)
└── references/
    └── trigger-prompts.md   ← this file
```

This location makes the reference:
- Discoverable alongside the skills and agents it describes
- Accessible to anyone onboarding to the system
- Easy to update when skill descriptions evolve
- Not confused with operating instructions inside any skill
