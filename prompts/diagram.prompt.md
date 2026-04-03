---
description: "Gera diagramas Mermaid (arquitetura, fluxograma, ER, sequência) a partir de código ou descrição."
---

# Generate Diagram

Create a **${input:diagram_type}** diagram for: **${input:subject}**

## Diagram Types
- **flowchart**: execution flow, decision trees, process workflows
- **sequence**: interaction between components/services/actors over time
- **er**: entity-relationship for database schemas
- **class**: class hierarchy, interfaces, composition
- **architecture**: system components, services, data flow
- **state**: state machine, lifecycle transitions
- **gantt**: project timeline, task dependencies

## Rules
1. Analyze the actual code/files if a subject references existing code
2. Use proper Mermaid syntax
3. Keep diagrams readable — max 15-20 nodes per diagram, split if larger
4. Use descriptive labels on edges/connections
5. Group related nodes with subgraphs
6. Use consistent styling and colors

## Output
```mermaid
<generated diagram>
```

With a brief legend explaining any abbreviations or conventions used.
