---
description: "Auditoria completa do site/app. Analisa qualidade, gaps, fluxos quebrados, acessibilidade, performance, segurança e UX. Site audit, quality review, gap analysis."
agent: "tech-lead"
model: Claude Opus 4.6 (copilot)
argument-hint: "Qual site/app ou área do projeto auditar?"
---

O usuário quer uma **auditoria completa** do site ou aplicação. Execute uma análise abrangente:

## Processo de Auditoria

### 1. Mapeamento Geral
- Identifique todas as pages/views do projeto
- Mapeie os fluxos de navegação do usuário
- Liste todas as rotas e seus estados (loading, error, empty, success)

### 2. Análise por Dimensão

Delegue cada dimensão ao especialista:

| Dimensão | Agente | O que verificar |
|----------|--------|-----------------|
| **Código** | `code-reviewer` | Padrões, duplicação, complexidade, code smells |
| **Segurança** | `security-auditor` | OWASP Top 10, auth, XSS, CSRF, input validation |
| **Performance** | `performance` | Bundle size, lazy loading, re-renders, queries |
| **Acessibilidade** | `accessibility` | WCAG 2.1 AA, keyboard nav, screen readers, contrast |
| **UX** | `ux-designer` | Fluxos quebrados, dead-ends, estados faltantes, consistência |
| **Testes** | `qa-engineer` | Cobertura, cenários faltantes, edge cases |

### 3. Relatório Consolidado

Compile os resultados em um relatório priorizado:

```markdown
# 🔍 Auditoria: {projeto}

## Resumo Executivo
- Status geral: {🔴 Crítico / 🟡 Atenção / 🟢 Saudável}
- Issues encontradas: {total}
- Críticas: {n} | Altas: {n} | Médias: {n} | Baixas: {n}

## Issues por Prioridade

### 🔴 Críticas (corrigir imediatamente)
1. {issue} — {arquivo} — {descrição}

### 🟠 Altas (corrigir em breve)
...

### 🟡 Médias (planejar)
...

### 🟢 Baixas (nice to have)
...

## Plano de Ação Sugerido
1. {ação prioritária}
2. {próxima ação}
...
```

REGRA: Seja específico. Não diga "melhorar a segurança" — diga exatamente O QUE está errado e ONDE.
