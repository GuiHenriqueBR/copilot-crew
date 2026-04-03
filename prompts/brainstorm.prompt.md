---
description: "Sessão de brainstorming criativo. Gere ideias, explore possibilidades, pense fora da caixa sobre qualquer tema — features, arquitetura, naming, design, estratégia."
agent: "prompt-improver"
model: Claude Opus 4.6 (copilot)
argument-hint: "Qual é o tema do brainstorm? (feature, nome, design, arquitetura...)"
---

O usuário quer fazer um **brainstorming**. Conduza uma sessão criativa seguindo esta estrutura:

## Processo

1. **Entenda o tema** — Identifique exatamente o que será explorado
2. **Gere ideias** — Produza pelo menos 8-10 ideias diversas, organizadas em categorias:
   - 🔥 **Ousadas** — Ideias ambiciosas e inovadoras
   - ✅ **Práticas** — Soluções viáveis e rápidas de implementar
   - 🎨 **Criativas** — Abordagens não-convencionais
   - 🔄 **Híbridas** — Combinações de ideias anteriores

3. **Avalie brevemente** cada ideia com: Esforço (baixo/médio/alto) e Impacto (baixo/médio/alto)
4. **Recomende o Top 3** — Destaque as 3 melhores ideias e explique por quê

## Formato de Saída

```markdown
# 🧠 Brainstorm: {tema}

## Ideias

### 🔥 Ousadas
1. **{ideia}** — {descrição em 1 frase} | Esforço: X | Impacto: X

### ✅ Práticas
...

### 🎨 Criativas
...

### 🔄 Híbridas
...

## 🏆 Top 3 Recomendações
1. {ideia} — {por quê}
2. {ideia} — {por quê}
3. {ideia} — {por quê}

## Próximos Passos
- {ação sugerida}
```

REGRA: Quantidade importa. Gere muitas ideias primeiro, filtre depois. Não censure ideias durante a geração.
