# Architecture Decision Records (ADR)
### rmsecurity | 01-STANDARDS

## What is an ADR

An Architecture Decision Record captures an important decision made about
the CCOS system — what was decided, why, what alternatives were considered,
and what the consequences are.

ADRs answer the question every new team member asks: "Why does this work this way?"

They are short (1–2 pages), immutable once accepted, and never deleted —
only superseded by a newer ADR.

## When to Write an ADR

Write an ADR when:
- You are making a decision that will affect multiple domains
- The decision involves a significant trade-off
- The decision will be hard to reverse
- Someone will reasonably ask "why did we do it this way?" in 6 months

Do not write an ADR for:
- Routine implementation choices
- Decisions that only affect one file or template
- Choices with only one obvious option

## ADR Format

```markdown
# ADR-NNNN — Decision Title

| Field | Value |
|-------|-------|
| Status | Proposed / Accepted / Deprecated / Superseded by ADR-NNNN |
| Date | YYYY-MM-DD |
| Deciders | Name(s) |

## Context

What situation prompted this decision?
What problem needed solving?

## Decision

What was decided, stated clearly and specifically.

## Rationale

Why this option over alternatives?
What were the key factors?

## Alternatives Considered

| Alternative | Why rejected |
|------------|-------------|
| Option A | Reason |
| Option B | Reason |

## Consequences

### Positive
- What this decision makes easier or better

### Negative / Trade-offs
- What this decision makes harder or more constrained

## Related Decisions

Links to related ADRs if applicable.
```

## ADR Status Lifecycle

```
Proposed → Accepted → (years later) → Deprecated / Superseded
```

When superseding an ADR, update its status to `Superseded by ADR-NNNN`
and create the new ADR explaining the change.
Never delete old ADRs.

## Index

| ADR | Title | Status |
|-----|-------|--------|
| [ADR-0001](ADR-0001-ccos-architecture.md) | CCOS modular domain architecture | Accepted |
| [ADR-0002](ADR-0002-client-data-separation.md) | Client data lives outside the CCOS repo | Accepted |
