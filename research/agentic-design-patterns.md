---
title: "Agentic AI Design Patterns"
description: "Comprehensive research on reusable architectural patterns for building reliable, scalable AI agents"
date: 2026-06-25
category: research
tags:
  - agentic-ai
  - design-patterns
  - ai-architecture
  - agent-systems
sources:
  - name: "Agentic Design Patterns: A System-Theoretic Framework"
    url: "https://arxiv.org/abs/2601.19752"
    type: "academic paper"
    date: "2026-01-27"
  - name: "Agentic Design Patterns: The 2026 Guide + Examples (Heym)"
    url: "https://heym.run/blog/agentic-design-patterns"
    type: "technical guide"
    date: "2026-06-14"
  - name: "Google Cloud Architecture Center: Choose a design pattern for your agentic AI system"
    url: "https://docs.cloud.google.com/architecture/choose-design-pattern-agentic-ai-system"
    type: "documentation"
    date: "2026-05-28"
  - name: "Augment Code: What Are Agentic Design Patterns? 2026 Pattern Catalog"
    url: "https://www.augmentcode.com/guides/agentic-design-patterns"
    type: "technical guide"
  - name: "Building Effective AI Agents (Anthropic)"
    url: "https://www.anthropic.com/engineering/building-effective-agents"
    type: "engineering guide"
    date: "2024"
  - name: "Agentic Retrieval-Augmented Generation: A Survey"
    url: "https://arxiv.org/abs/2501.09136"
    type: "academic survey"
    date: "2025-01"
related_research:
  - agent-orchestration.md
  - multi-agent-systems.md
---

# Agentic AI Design Patterns

## Executive Summary

Agentic design patterns are **reusable architectural approaches** for structuring how AI agents reason, use tools, and recover from errors. They provide systematic solutions to recurring problems in agent design, transforming unreliable single-LLM calls into robust, production-ready autonomous systems.

As of 2026, the field has converged on **seven core patterns** that address specific failure modes:

1. **Reflection** - Self-critique and revision
2. **Tool Use** - External API and data access
3. **ReAct** - Reasoning and acting interleaved
4. **Planning** - Goal decomposition and sequencing
5. **Multi-Agent Collaboration** - Specialized agent coordination
6. **Evaluator-Optimizer** - Objective quality scoring and iteration
7. **Human-in-the-Loop** - Supervised approval for high-stakes actions

These patterns are **architectural, not framework-specific**, working in code-based implementations (LangGraph, CrewAI, AutoGen) or visual workflow systems alike.

---

## System-Theoretic Framework

### Five Functional Subsystems

According to the [arXiv:2601.19752](https://arxiv.org/abs/2601.19752) paper by Dao et al. (2026), a robust agentic AI system decomposes into five interacting functional subsystems:

1. **Reasoning & World Model** - Planning, decision-making, maintaining understanding of environment
2. **Perception & Grounding** - Interpreting inputs, connecting to real-world state
3. **Action Execution** - Interacting with environment through tools and APIs
4. **Learning & Adaptation** - Improving from experience and feedback
5. **Inter-Agent Communication** - Coordination in multi-agent systems

These subsystems form the foundation for deriving the 12 agentic design patterns proposed in the paper, categorized as:

- **Foundational Patterns** - Core building blocks
- **Cognitive & Decisional Patterns** - Reasoning and planning
- **Execution & Interaction Patterns** - Tool use and action
- **Adaptive & Learning Patterns** - Improvement and memory

This framework provides a **principled methodology** for engineering robust AI agents, addressing the "inherent issues like hallucination and poor reasoning, coupled with the frequent ad-hoc nature of system design" that lead to unreliable applications.

---

## The Seven Core Patterns (2026 Consensus)

### 1. Reflection

**What it solves:** Sloppy or hallucinated first drafts  
**Mechanism:** Agent reviews its own output, identifies weaknesses, and revises before returning final answer  
**Production status:** Yes, battle-tested

**When to use:**
- Output quality matters more than latency
- Long-form writing, code generation, analysis
- High cost of wrong answers

**How it works:**
1. Generate initial output
2. Run critique pass on own output
3. Identify weaknesses (accuracy, tone, completeness)
4. Revise weak parts
5. Repeat until passes quality threshold or hits iteration limit

**Performance impact:**
- Boosts accuracy by up to 20 percentage points ([Medium, March 2026](https://medium.com/@server_62309/5-agent-design-patterns-every-developer-needs-to-know-in-2026-25e62fd9f3bb))
- Coding agents reach 91% accuracy vs. 71% without reflection
- Increases token usage 2-3x due to multiple passes

**Implementation considerations:**
- Always cap iterations (recommended: 3-5 max)
- Use cheaper model for critique to control costs
- Define explicit quality criteria for stopping condition

---

### 2. Tool Use

**What it solves:** Stale knowledge and inability to act  
**Mechanism:** Agent calls external functions, APIs, or data sources instead of relying on training data  
**Production status:** Yes, foundational pattern

**When to use:**
- Almost always
- Any agent needing current information
- Tasks requiring real-world actions (database queries, API calls, sending messages)

**Common implementations:**
- **Retrieval as a tool** - Core of agentic RAG systems
- **API integration** - Order lookups, user profiles, live data
- **MCP (Model Context Protocol)** servers - Standardized tool interfaces

**Example:**
Support agent looks up order status through API rather than guessing, then drafts reply grounded in real record.

**Best practices:**
- Provide clear tool descriptions in natural language
- Include example inputs/outputs
- Handle tool failures gracefully
- Log all tool calls for audit trails

---

### 3. ReAct (Reasoning and Acting)

**What it solves:** Blind tool calls without adaptation  
**Mechanism:** Interleaves reasoning ("think") and acting ("do"), with observation loops  
**Production status:** Yes, most widely deployed pattern in 2026

**Why it's dominant:**
- Mirrors human problem-solving (think → act → observe → adjust)
- Handles uncertainty gracefully
- Adapts based on observations
- Natural fit for multi-step tasks

**How it works:**
1. **Reason:** Think about what to do next
2. **Act:** Execute chosen tool/action
3. **Observe:** Review result
4. **Reason:** Incorporate observation, decide next step
5. Repeat until goal achieved

**When to use:**
- Multi-step tasks with dependencies
- Research, troubleshooting, data lookups
- Any task where next step depends on previous result

**Example:**
Agent searches database, realizes query was too narrow, reformulates search with new parameters, finds correct record.

**Framework support:**
- LangGraph: Native graph-based implementation
- LangChain: Built-in ReAct agent
- CrewAI: Role-based agents with ReAct loop
- Most agent frameworks include ReAct as default

---

### 4. Planning

**What it solves:** Losing track on long, complex tasks  
**Mechanism:** Decomposes goal into ordered steps before execution  
**Production status:** Yes, essential for complex workflows

**When to use:**
- Multi-step goals requiring coordination
- Report generation, data migration, research projects
- Tasks where overall structure matters

**Approaches:**

**Static Planning:**
- Pre-define steps at start
- Execute in order
- Good for predictable workflows

**Dynamic Planning:**
- Revise plan based on intermediate results
- More flexible but harder to control
- Combines with ReAct for adaptive execution

**How it works:**
1. Receive high-level goal
2. Decompose into ordered subtasks
3. Identify dependencies between tasks
4. Execute tasks in sequence or parallel
5. Synthesize results

**Example:**
Research agent plans: (1) gather sources, (2) extract themes, (3) write sections, (4) review, then executes each step.

**Best practices:**
- Make plan visible/loggable for debugging
- Allow plan revision for dynamic tasks
- Use orchestrator agent to manage plan execution
- Cap planning depth to avoid analysis paralysis

---

### 5. Multi-Agent Collaboration

**What it solves:** Single agent overloaded with too many roles or domains  
**Mechanism:** Specialized agents cooperate under orchestrator coordination  
**Production status:** Yes, standard for enterprise systems

**When to use:**
- Parallelizable tasks
- Cross-domain work (e.g., data + visualization + writing)
- Tasks exceeding single context window
- Need for role specialization

**Architectures:**

**Hierarchical:**
- Orchestrator delegates to specialist agents
- Clear command structure
- Good for complex, multi-domain tasks

**Collaborative:**
- Agents communicate peer-to-peer
- Shared state management
- Debate and consensus mechanisms

**Sequential:**
- Agents hand off in pipeline
- Each agent refines previous output
- Assembly-line pattern

**Example:**
Financial analysis system with:
- Data retrieval agent (pulls metrics)
- Analysis agent (calculates trends)
- Visualization agent (creates charts)
- Report writer agent (synthesizes narrative)
- Orchestrator (coordinates workflow)

**Challenges:**
- Coordination overhead
- State management across agents
- Error propagation
- Increased token costs (multiple agent calls)

**Best practices:**
- Keep nesting depth ≤5 levels
- Clear agent responsibilities (no overlap)
- Centralized state management
- Explicit handoff protocols
- Cap concurrent agents to control costs

---

### 6. Evaluator-Optimizer

**What it solves:** Inconsistent quality with no measurable standard  
**Mechanism:** Separate evaluator scores output against explicit criteria, drives revision loop  
**Production status:** Yes, critical for quality-sensitive tasks

**Difference from Reflection:**
- **Reflection:** Agent critiques own output (self-assessment)
- **Evaluator-Optimizer:** Separate judge with objective criteria (external assessment)

**When to use:**
- Can define what "good" means objectively
- Passing tests, matching schema, factual checklists
- Code generation (test suites)
- Structured output requirements

**How it works:**
1. Generator produces output
2. Evaluator scores against criteria
3. If failing: feedback sent to generator
4. Generator revises
5. Loop until pass or max iterations

**Example:**
Coding agent workflow:
1. Generate function
2. Run test suite (evaluator)
3. If tests fail: analyze failure, revise
4. Repeat until tests pass
5. Return validated code

**Evaluation criteria types:**
- **Unit tests** - Code correctness
- **Schema validation** - Structured output
- **Factual grounding** - Citation checking
- **Business rules** - Compliance requirements
- **LLM-as-judge** - Qualitative scoring

**Best practices:**
- Make criteria explicit and measurable
- Cap iterations (recommended: 5-10 max)
- Use structured output for evaluator (JSON with score + feedback)
- Log all attempts for debugging
- Track evaluation metrics over time

---

### 7. Human-in-the-Loop (HITL)

**What it solves:** Risky autonomous actions without oversight  
**Mechanism:** Agent pauses for human approval before executing high-stakes actions  
**Production status:** Yes, essential for production systems

**When to use:**
- Real side effects (payments, deletions, external messages)
- Regulatory requirements
- High cost of errors
- Learning phase for new agents

**Implementation patterns:**

**Threshold-based:**
- Automatic below threshold
- Manual approval above threshold
- Example: Auto-approve refunds <$50, require approval above

**Action-based:**
- Specific actions always require approval
- Delete operations, payment processing, public messaging
- Defined in agent configuration

**Confidence-based:**
- Agent self-assesses confidence
- Low confidence → request review
- High confidence → proceed
- Requires calibrated confidence scoring

**Workflow:**
1. Agent reaches decision point
2. Checks if action requires approval
3. Pauses execution, stores state
4. Notifies human reviewer
5. Human approves/rejects/edits
6. Agent resumes from stored state
7. Executes approved action

**Example:**
Finance agent workflow:
1. Analyzes expense report
2. Identifies reimbursement needed: $2,500
3. Pauses (above $500 threshold)
4. Sends notification to manager
5. Manager reviews and approves
6. Agent executes payment
7. Sends confirmation

**Best practices:**
- Clear approval criteria
- Timeout policies (what happens if no response)
- Escalation paths
- Audit trail of all approvals/rejections
- Resume capability from exact pause point

---

## Workflows vs. Agents: The Foundation

Before choosing patterns, understand this fundamental distinction ([Anthropic, 2024](https://www.anthropic.com/engineering/building-effective-agents)):

### Workflows
- Orchestrate LLMs through **predefined code paths**
- Developer controls execution flow
- More predictable, cheaper to debug
- Easier to trust and audit

### Agents
- LLM **dynamically directs** its own process
- Runtime decision-making
- More flexible, harder to constrain
- Required when path cannot be fixed in advance

**Decision rule:** Use workflow when steps are known; use agent only when path is truly dynamic.

**Trend in 2026:** Most production systems are hybrid - workflow structure with agent components at decision points.

---

## Pattern Composition in Production

### Symptom → Pattern Lookup Table

| Observable Failure | Pattern to Apply | Implementation |
|-------------------|------------------|----------------|
| Outdated/made-up answers | Tool Use | API integration, MCP servers |
| Sloppy first drafts | Reflection | Self-critique + revision loop |
| Inconsistent quality | Evaluator-Optimizer | External judge + iteration |
| Blind tool calls | ReAct | Reason-act-observe loop |
| Lost on long tasks | Planning | Goal decomposition |
| Single agent overloaded | Multi-Agent | Orchestrator + specialists |
| Risky actions unsupervised | Human-in-the-Loop | Approval gates |
| Context forgotten | Memory (supporting) | Persistent state |

### Common Production Recipes

**Customer Support Agent:**
```
Tool Use (order lookup)
+ ReAct (diagnose step-by-step)
+ Memory (conversation history)
+ Human-in-the-Loop (refunds >$X)
```

**Research Agent:**
```
Planning (decompose question)
+ Multi-Agent (gather + analyze in parallel)
+ Tool Use (live retrieval)
+ Reflection (fact-check)
```

**Coding Agent:**
```
Planning (lay out changes)
+ ReAct (execute with tools)
+ Evaluator-Optimizer (run tests)
+ Human-in-the-Loop (before deployment)
```

**Financial Analysis:**
```
Multi-Agent (data + viz + narrative)
+ Tool Use (API access)
+ Evaluator-Optimizer (validate calculations)
+ Human-in-the-Loop (final review)
```

---

## Cost and Performance Considerations

### Token Usage Multipliers

| Pattern | Cost Multiplier | Mitigation |
|---------|----------------|------------|
| Reflection | 2-3x | Cap iterations (3-5 max), use cheaper model for critique |
| Evaluator-Optimizer | 3-10x | Structured evaluator output, clear stopping criteria |
| ReAct | 1.5-4x | Depends on task complexity, tool call count |
| Multi-Agent | 2-10x | Limit concurrent agents, shallow nesting |
| Planning | 1.2-2x | Static plans when possible, cache common plans |

### Guardrails for Production

1. **Iteration caps:** Never allow unbounded loops
   - Reflection: 3-5 max
   - Evaluator-Optimizer: 5-10 max
   - ReAct: 10-20 max steps

2. **Nesting limits:** Cap multi-agent depth
   - Recommended: ≤5 levels
   - Track nesting in orchestrator
   - Alert on approaching limit

3. **Model right-sizing:** Use appropriate model for each step
   - Cheap model: routing, tool selection, critique
   - Expensive model: final synthesis, complex reasoning
   - Can reduce costs 50-70%

4. **Timeout policies:** Every step must have timeout
   - Tool calls: 30-60s typical
   - Agent turns: 2-5 minutes
   - Overall workflow: 10-30 minutes

5. **Circuit breakers:** Kill runaway executions
   - Token budget per workflow
   - Wall-clock time limits
   - Cost thresholds

---

## Framework Implementations

### LangGraph
**Strengths:** Graph-based, deterministic, time-travel debugging  
**Best for:** Complex workflows with conditional branching, fault tolerance needs  
**Pattern support:** All seven patterns natively supported

### CrewAI
**Strengths:** Role-based abstraction, business-friendly  
**Best for:** Multi-agent with clear roles, collaborative workflows  
**Limitations:** Fine-grained control harder at scale

### Microsoft Agent Framework
**Strengths:** Enterprise integration, Azure-native, unified AutoGen + Semantic Kernel  
**Best for:** Microsoft ecosystem, enterprise governance needs  
**Pattern support:** Group chat, debate, reflection patterns

### Google Agent Development Kit (ADK)
**Strengths:** Hierarchical agent trees, A2A protocol support  
**Best for:** Cross-framework communication, nested agents  
**Pattern support:** Hierarchical delegation, protocol-based communication

### OpenAI Agents SDK
**Strengths:** Simple API, GPT-optimized  
**Best for:** Quick prototypes, GPT-focused workflows  
**Limitations:** Less control over orchestration logic

---

## Anti-Patterns and Common Mistakes

### 1. Pattern Over-Engineering
**Symptom:** Using all seven patterns in every agent  
**Problem:** Unnecessary complexity, cost, latency  
**Solution:** Start with Tool Use + ReAct, add patterns only for observed failures

### 2. Unbounded Loops
**Symptom:** Reflection or Evaluator-Optimizer runs until timeout  
**Problem:** Runaway costs, unpredictable behavior  
**Solution:** Always cap iterations, prefer fewer iterations with better prompts

### 3. Single-Agent Overload
**Symptom:** One agent juggling 20+ tools and 5+ domains  
**Problem:** Context overflow, poor performance, hard to debug  
**Solution:** Split into specialized agents with Multi-Agent pattern

### 4. Missing HITL for High Stakes
**Symptom:** Agent autonomously deletes data or sends external messages  
**Problem:** Regulatory risk, user trust violation, unrecoverable errors  
**Solution:** Gate all destructive/external actions with Human-in-the-Loop

### 5. Blind Tool Use
**Symptom:** Agent calls tool but doesn't check result  
**Problem:** Proceeds with bad data, compounds errors  
**Solution:** Use ReAct pattern to observe and adapt

### 6. No Evaluation Criteria
**Symptom:** "Improve this" without defining "good"  
**Problem:** Reflection/evaluation loops produce inconsistent results  
**Solution:** Write explicit, measurable criteria (tests, schemas, checklists)

---

## Future Directions

### Emerging Patterns (2026+)

1. **Agent-to-Agent (A2A) Protocol**
   - Standardized communication between agents from different frameworks
   - Google ADK early adopter
   - Enables cross-framework orchestration

2. **Persistent Agent Memory**
   - Long-term memory across sessions
   - Vectorized episodic memory
   - Supporting pattern for all others

3. **Adversarial Agents**
   - Red team / blue team patterns
   - Security testing agents
   - Automatic vulnerability discovery

4. **Constitutional Agents**
   - Built-in ethical constraints
   - Value alignment patterns
   - Anthropic's "Constitutional AI" applied to agents

5. **Swarm Intelligence Patterns**
   - Large-scale agent coordination (100+ agents)
   - Emergent behavior from simple rules
   - Inspired by biological systems

---

## Key Takeaways

1. **Patterns solve specific failures** - Start from symptoms in traces, not from theory

2. **Tool Use is foundational** - Almost every production agent needs external data/actions

3. **ReAct is most common** - Handles uncertainty better than static workflows

4. **Combine thoughtfully** - Most agents use 2-4 patterns, not all seven

5. **Always cap iterations** - Unbounded loops are the #1 cost/reliability problem

6. **Measure before optimizing** - Add patterns only for observed failure modes

7. **Start simple, add complexity only when traces demand it**

8. **Production agents are hybrid** - Workflow structure with agent decision points

---

## References

### Primary Sources

1. Dao, D. et al. (2026). "Agentic Design Patterns: A System-Theoretic Framework." [arXiv:2601.19752](https://arxiv.org/abs/2601.19752)

2. Anthropic. (2024). "Building Effective AI Agents." [anthropic.com/engineering/building-effective-agents](https://www.anthropic.com/engineering/building-effective-agents)

3. Singh, P. et al. (2025). "Agentic Retrieval-Augmented Generation: A Survey on Agentic RAG." [arXiv:2501.09136](https://arxiv.org/abs/2501.09136)

4. Google Cloud. (2026). "Choose a design pattern for your agentic AI system." [Cloud Architecture Center](https://docs.cloud.google.com/architecture/choose-design-pattern-agentic-ai-system)

### Framework Documentation

5. LangChain. "LangGraph Documentation." [langchain.com/langgraph](https://langchain.com/langgraph)

6. Microsoft. "Agent Framework." [microsoft.com/agent-framework](https://microsoft.com/agent-framework)

7. CrewAI. "Multi-Agent Framework Documentation." [crewai.com/docs](https://crewai.com/docs)

8. Google. "Agent Development Kit (ADK)." [cloud.google.com/adk](https://cloud.google.com/adk)

### Technical Guides

9. Heym. (2026). "Agentic Design Patterns: The 2026 Guide + Examples." [heym.run/blog/agentic-design-patterns](https://heym.run/blog/agentic-design-patterns)

10. Augment Code. (2026). "What Are Agentic Design Patterns? 2026 Pattern Catalog." [augmentcode.com/guides/agentic-design-patterns](https://www.augmentcode.com/guides/agentic-design-patterns)

---

**Document Version:** 1.0  
**Last Updated:** 2026-06-25  
**Maintained by:** EponaLab AI News Research Team
