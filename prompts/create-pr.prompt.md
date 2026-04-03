---
description: "Cria um Pull Request completo com commit convencional, descrição detalhada, e checklist de quality gates."
agent: "tech-lead"
tools: [read, search, edit, execute, agent]
argument-hint: "branch-alvo ticket-id (ex: develop PROJ-123)"
---

Crie um Pull Request para as mudanças atuais.

## Instruções

1. **Analise as mudanças** — Use `git diff` para entender o que foi alterado.
2. **Delegue ao `git-specialist`** — Para:
   - Gerar mensagens de commit seguindo conventional commits
   - Agrupar mudanças em commits lógicos (se necessário)
3. **Gere a descrição do PR** com este template:

```markdown
## Descrição
{Resumo conciso do que foi feito e por que}

## Ticket
{Link para o Jira/Notion/Issue se aplicável}

## Mudanças
- {Lista das mudanças principais}

## Testing
- [ ] Testes unitários passando
- [ ] Testes de integração passando (se aplicável)
- [ ] Testado manualmente (se aplicável)

## Security Checklist
- [ ] Input validation em novos endpoints
- [ ] Sem secrets hardcoded
- [ ] Auth/authz verificados

## Screenshots
{Se houver mudanças visuais}
```

4. **Execute os checks finais**:
   - `git status` para confirmar que nada ficou de fora
   - Rode os testes uma última vez
   - Verifique se não há lint/type errors
5. **Apresente os comandos git** — Mostre os comandos para commit, push e criação do PR, mas **espere aprovação do usuário** antes de executar.
