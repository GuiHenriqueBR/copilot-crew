---
description: "Workflow completo de desenvolvimento. Diga o que quer e o tech-lead cuida de tudo automaticamente — planejamento, implementação, review, segurança e testes."
agent: "tech-lead"
argument-hint: "Descreva a feature, bug fix, ou mudança que você quer"
---

O usuário está pedindo uma mudança no código. Execute o pipeline completo automaticamente:

1. **Entenda o pedido** — Se algo estiver ambíguo, faça UMA pergunta objetiva. Se claro, execute.
2. **Analise o código existente** — Busque padrões, convenções e arquitetura atual.
3. **Planeje** — Crie um todo list com as tarefas necessárias.
4. **Execute** — Delegue cada tarefa ao agente especialista correto. Faça o trabalho, não apenas sugira.
5. **Quality Gates** — Após implementar:
   - Delegue review de código ao `code-reviewer`
   - Se envolver segurança, delegue ao `security-auditor`
   - Execute os testes existentes
   - Corrija qualquer problema encontrado
6. **Entregue** — Resuma o que foi feito de forma breve.

REGRA: Não pergunte "quer que eu faça X?" — apenas faça. O usuário quer resultado, não perguntas.
