---
description: "Implementa uma feature a partir de um arquivo de spec (.spec.md). Executa todas as tasks da spec automaticamente com quality gates."
agent: "tech-lead"
argument-hint: "Caminho do arquivo .spec.md (ex: notes/specs/PROJ-123-feature.spec.md)"
---

Implemente a feature descrita no arquivo de spec fornecido.

## Instruções

1. **Leia a spec completa** — Abra e leia o arquivo `.spec.md` fornecido.
2. **Verifique o status** — Se o status da spec não é "approved", avise o usuário que a spec precisa ser revisada primeiro.
3. **Execute as tasks** — Para cada task da spec:
   - Crie um item no todo list
   - Delegue ao agente especialista correto (frontend-dev, backend-dev, db-architect, etc.)
   - Inclua o contexto da spec (requisitos, design, arquivos afetados)
   - Siga a ordem TDD: escreva o teste primeiro, depois implemente
4. **Quality Gates** — Após completar todas as tasks:
   - Delegue ao `code-reviewer` para revisar todo o código novo
   - Delegue ao `security-auditor` se houver auth/input/data envolvido
   - Execute os testes para confirmar que passam
   - Corrija qualquer problema encontrado
5. **Atualize a spec** — Marque as tasks como concluídas no arquivo `.spec.md`
6. **Reporte** — Resuma o que foi implementado e quaisquer desvios da spec

REGRA: Siga a spec fielmente. Se algo na spec não faz sentido, pergunte antes de desviar.
