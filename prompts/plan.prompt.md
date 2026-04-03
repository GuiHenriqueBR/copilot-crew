---
description: "Gera uma especificação técnica completa a partir de um ticket Jira, página Notion, issue do GitHub, ou descrição da feature."
agent: "planner"
argument-hint: "Ticket Jira (PROJ-123), URL Notion, GitHub issue, ou descrição da feature"
---

Crie uma especificação técnica completa para a feature descrita.

## Instruções

1. **Colete os requisitos** — Se foi fornecido um ticket Jira, busque os detalhes via MCP. Se for uma URL do Notion, busque o conteúdo. Se for texto livre, use como base.
2. **Analise o código existente** — Busque padrões, arquitetura e convenções no projeto atual.
3. **Gere a spec** — Crie o arquivo em `notes/specs/{id}-{nome}.spec.md` com:
   - Requisitos funcionais com user stories e acceptance criteria
   - Requisitos não-funcionais
   - Design técnico com diagrama de componentes
   - Lista de tasks ordenada (TDD-first)
4. **Apresente para revisão** — Mostre um resumo e aguarde aprovação antes de prosseguir.

O arquivo de spec gerado será usado pelo `/cook-plan` para implementação automática.
