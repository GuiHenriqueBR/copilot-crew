---
description: "Revisa todas as mudanças de código feitas durante a implementação. Checa qualidade, segurança, testes e aderência à spec."
agent: "tech-lead"
argument-hint: "Caminho opcional do arquivo .spec.md para validar contra a spec"
---

Revise todas as mudanças de código recentes.

## Instruções

1. **Identifique os arquivos alterados** — Use `git diff` ou `git status` para listar todos os arquivos modificados.
2. **Delegue ao `code-reviewer`** — Peça uma revisão completa de todos os arquivos alterados, checando:
   - Corretude e edge cases
   - Legibilidade e manutenibilidade
   - Consistência com padrões do projeto
   - Error handling adequado
3. **Delegue ao `security-auditor`** — Se algum arquivo alterado envolve auth, input de usuário, queries de banco, ou dados sensíveis.
4. **Valide contra a spec** — Se um arquivo `.spec.md` foi fornecido, verifique se:
   - Todos os requisitos foram atendidos
   - Todos os acceptance criteria estão cobertos
   - Nenhum requisito "out of scope" foi introduzido
5. **Execute os testes** — Rode a test suite e reporte resultado.
6. **Reporte** — Apresente um resumo consolidado de todos os findings, agrupados por severidade.
