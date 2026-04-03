---
description: "Pipeline completo: melhora o prompt → planeja → executa → review → entrega. Use para tarefas complexas que precisam de máxima qualidade. Full pipeline, prompt improvement + orchestration."
agent: "tech-lead"
model: Claude Opus 4.6 (copilot)
argument-hint: "Descreva a tarefa completa que quer executar com máxima qualidade"
---

Execute o **pipeline completo de qualidade máxima**:

## Pipeline

### Fase 1: Refinamento do Prompt
- Delegue ao `prompt-improver` para analisar e melhorar o pedido do usuário
- Use a versão refinada como base para todas as fases seguintes

### Fase 2: Planejamento
- Com o prompt refinado, delegue ao `planner` para criar uma spec completa
- Apresente o plano ao usuário e ESPERE aprovação antes de executar

### Fase 3: Execução
- Delegue cada tarefa ao agente especialista correto
- Siga a ordem TDD: testes primeiro, implementação depois
- Paralelizar tarefas independentes

### Fase 4: Quality Gates
- Delegue review ao `code-reviewer`
- Se envolver segurança, delegue ao `security-auditor`
- Se envolver UI, delegue ao `accessibility`
- Execute testes automatizados

### Fase 5: Entrega
- Resuma tudo que foi feito
- Liste os arquivos alterados/criados
- Mencione decisões tomadas e trade-offs

REGRA: Este pipeline é para tarefas que exigem máxima qualidade. NÃO pule nenhuma fase. Se o usuário quer algo mais rápido, use `/dev-workflow` ao invés.
