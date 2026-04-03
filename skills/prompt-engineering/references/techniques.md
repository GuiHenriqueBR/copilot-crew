# Técnicas de Prompt Engineering — Referência Detalhada

## Zero-shot Prompting

A forma mais simples — instruir diretamente sem exemplos.

**Quando usar:** Tarefas bem definidas onde o modelo tem conhecimento prévio.

```
Classifique o texto abaixo como positivo, neutro ou negativo.

Texto: "Achei o produto razoável, mas o atendimento foi péssimo."
Sentimento:
```

**Dica:** Funciona bem para classificação, tradução, extração e resumo de tarefas simples.

---

## Few-shot Prompting

Fornecer exemplos (demonstrações) dentro do prompt para guiar o modelo.

**Quando usar:** Quando o formato de saída é crítico ou a tarefa é ambígua sem exemplos.

```
<examples>
<example>
Texto: "O jantar estava maravilhoso!" → Sentimento: positivo
</example>
<example>
Texto: "O preço é justo, nada demais." → Sentimento: neutro
</example>
<example>
Texto: "Péssima experiência, nunca mais volto." → Sentimento: negativo
</example>
</examples>

Texto: "Adorei a decoração, mas a comida estava fria." → Sentimento:
```

**Boas práticas:**
- 3-5 exemplos diversos
- Cubra edge cases nos exemplos
- Mantenha exemplos relevantes ao caso real
- Varie os exemplos para evitar padrões não-intencionais

---

## Chain-of-Thought (CoT) Prompting

Guiar o modelo a raciocinar passo a passo antes de dar a resposta final.

### Few-shot CoT
Forneça exemplos com raciocínio explícito:

```
P: Os números ímpares neste grupo somam um número par: 4, 8, 9, 15, 12, 2, 1.
R: Somando os números ímpares: 9 + 15 + 1 = 25. A resposta é Falso.

P: Os números ímpares neste grupo somam um número par: 15, 32, 5, 13, 82, 7, 1.
R:
```

### Zero-shot CoT
Simplesmente adicione "Vamos pensar passo a passo" ao final:

```
Fui ao mercado e comprei 10 maçãs. Dei 2 para o vizinho e 2 para o mecânico. 
Depois comprei mais 5 maçãs e comi 1. Com quantas maçãs fiquei?

Vamos pensar passo a passo.
```

### Auto-CoT
Processo automatizado em 2 fases:
1. **Clusterização:** Agrupe perguntas por similaridade
2. **Amostragem:** Selecione uma pergunta representativa de cada cluster e gere o raciocínio automaticamente com "Vamos pensar passo a passo"

**Quando usar CoT:**
- Problemas de matemática e lógica
- Raciocínio com múltiplas etapas
- Decisões que exigem análise de prós e contras
- Debugging e análise de código

---

## Tree of Thoughts (ToT)

Generaliza CoT ao explorar uma ÁRVORE de pensamentos intermediários, permitindo busca (BFS/DFS) e backtracking.

**Modelo mental:** Múltiplos especialistas debatendo:

```
Imagine que três especialistas diferentes estão resolvendo este problema.
Cada um escreve um passo de seu raciocínio e compartilha com o grupo.
Em seguida, todos avaliam os passos uns dos outros.
Se algum especialista perceber uma falha em seu raciocínio, ele se retira.
Continue até convergir na melhor solução.

Problema: [SEU PROBLEMA AQUI]
```

**Quando usar:**
- Problemas criativos (escrita, planejamento)
- Problemas com múltiplas soluções possíveis
- Planejamento estratégico
- Quando uma única cadeia de raciocínio pode levar a becos sem saída

---

## Meta Prompting

O modelo atua como orquestrador, delegando sub-tarefas para "especialistas virtuais".

```
Você é um coordenador de projeto. Para responder a pergunta abaixo, 
consulte internamente os seguintes especialistas:
- Especialista em UX
- Especialista em Backend
- Especialista em Segurança

Cada especialista deve fornecer sua perspectiva. 
Depois, sintetize uma resposta integrada.

Pergunta: Como devo projetar o sistema de autenticação do meu app?
```

**Quando usar:** Tarefas multidisciplinares que se beneficiam de múltiplas perspectivas.

---

## Self-Consistency

Gere múltiplas respostas com diferentes caminhos de raciocínio e escolha a resposta mais frequente/consistente.

**Processo:**
1. Use CoT para gerar N respostas independentes (temperature > 0)
2. Extraia a resposta final de cada uma
3. Vote na resposta mais comum (majority voting)

**Quando usar:**
- Problemas com resposta definitiva (matemática, lógica)
- Quando uma única geração pode ser inconsistente
- Validação de respostas críticas

---

## Prompt Chaining

Dividir uma tarefa complexa em sub-tarefas sequenciais, usando a saída de cada etapa como entrada da próxima.

### Tipos de Chains

**Sequential:** Saída do prompt N → Entrada do prompt N+1
```
Prompt 1: "Liste 5 tópicos relevantes sobre [TEMA]"
→ Resultado: [lista de tópicos]

Prompt 2: "Para cada tópico abaixo, escreva um parágrafo de 3 frases: [lista do prompt 1]"
→ Resultado: [parágrafos]

Prompt 3: "Organize os parágrafos abaixo em um artigo coerente com introdução e conclusão: [parágrafos do prompt 2]"
```

**Parallel:** Múltiplos prompts executados simultaneamente, resultados combinados depois
```
Prompt A (paralelo): "Analise os prós de [DECISÃO]"
Prompt B (paralelo): "Analise os contras de [DECISÃO]"
Prompt C (combina A+B): "Dada a análise de prós e contras, recomende uma decisão..."
```

**Conditional:** Roteamento baseado na saída anterior
```
Prompt 1: "Classifique o sentimento: [REVIEW]" → positivo/negativo
IF positivo → Prompt 2A: "Escreva uma resposta de agradecimento"
IF negativo → Prompt 2B: "Escreva uma resposta de desculpas com solução"
```

**Iterative (Recursive):** Loop de refinamento
```
Prompt 1: "Escreva um resumo de [TEXTO]"
Loop N vezes:
  Prompt 2: "Critique o resumo: [RESUMO]. Dê feedback específico."
  Prompt 3: "Reescreva o resumo incorporando o feedback: [FEEDBACK]"
```

**Quando usar Prompt Chaining:**
- Tarefas com múltiplas etapas distintas
- Quando você precisa inspecionar resultados intermediários
- Pipelines de processamento de dados
- Controle granular sobre cada etapa

---

## RAG (Retrieval-Augmented Generation)

Combinar busca de informações externas com geração do LLM.

```
<context>
Com base nos documentos recuperados abaixo, responda a pergunta do usuário.
Use APENAS informações dos documentos fornecidos.
Se a informação não estiver nos documentos, diga "Não encontrei essa informação nos documentos disponíveis."

<documents>
<document index="1">
<source>[TÍTULO/URL DO DOCUMENTO 1]</source>
<content>[CONTEÚDO DO DOCUMENTO 1]</content>
</document>
<document index="2">
<source>[TÍTULO/URL DO DOCUMENTO 2]</source>
<content>[CONTEÚDO DO DOCUMENTO 2]</content>
</document>
</documents>
</context>

Pergunta: [PERGUNTA DO USUÁRIO]
```

**Quando usar:** QA sobre documentos específicos, base de conhecimento, dados atualizados.

---

## ReAct (Reasoning + Acting)

O modelo alterna entre pensar (raciocínio) e agir (usar ferramentas).

```
Formato de resposta:
Pensamento: [O que preciso fazer/descobrir]
Ação: [Qual ferramenta usar e com quais parâmetros]
Observação: [Resultado da ação]
... (repita conforme necessário)
Resposta Final: [Conclusão baseada nas observações]
```

**Quando usar:** Agentes com ferramentas, pesquisa, navegação web, interação com APIs.

---

## Reflexion

Ciclo de geração → avaliação → refinamento com feedback explícito.

```
Tarefa: [DESCRIÇÃO]

Passo 1 - Gere uma solução inicial.
Passo 2 - Avalie criticamente a solução:
  - Está correta?
  - Cumpre todos os requisitos?
  - Há edge cases não cobertos?
Passo 3 - Liste problemas específicos encontrados.
Passo 4 - Gere uma solução melhorada que corrija os problemas.
Passo 5 - Repita passos 2-4 até satisfatório.
```

**Quando usar:** Código, escrita criativa, soluções que se beneficiam de auto-revisão.

---

## Generate Knowledge Prompting

Peça ao modelo gerar fatos/conhecimento relevante ANTES de responder.

```
Passo 1: Gere 5 fatos relevantes sobre [TÓPICO]:
[modelo gera fatos]

Passo 2: Usando os fatos acima, responda: [PERGUNTA]
```

**Quando usar:** Quando o modelo precisa de "aquecimento" sobre o tema antes de responder.

---

## Referências

- [Prompt Engineering Guide](https://www.promptingguide.ai/)
- [Claude Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [Mirascope Blog - Prompt Chaining](https://mirascope.com/blog/prompt-chaining)
