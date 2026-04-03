---
name: prompt-engineering
description: "PROMPT ENGINEERING SKILL — Guides creation of the perfect prompt for any LLM task. USE FOR: writing prompts, improving prompts, prompt design, prompt optimization, crafting system prompts, few-shot examples, chain-of-thought, tree-of-thoughts, prompt chaining, structured output, role prompting, XML structuring, meta prompting, self-consistency, RAG prompts, ReAct, reflexion. Triggers: prompt, write a prompt, improve prompt, optimize prompt, system prompt, few-shot, chain of thought, prompt template."
---

# Prompt Engineering — Guia Completo

Skill para guiar a criação do prompt perfeito para qualquer necessidade.
Fontes: promptingguide.ai, Anthropic Claude Docs, Mirascope Blog.

## Workflow: Criando o Prompt Perfeito

Siga estes passos em ordem para construir um prompt otimizado:

### Passo 1: Definir o Objetivo
Antes de escrever, responda:
- **O que** exatamente o LLM deve produzir? (formato, tamanho, estilo)
- **Para quem** é a saída? (público-alvo, nível técnico)
- **Qual é o critério de sucesso?** (como avaliar se a resposta é boa)
- **Quais restrições existem?** (limites, proibições, requisitos)

### Passo 2: Escolher a Técnica Adequada
Use o **Guia de Seleção de Técnicas** abaixo para decidir qual abordagem usar.

### Passo 3: Montar a Estrutura do Prompt
Componha o prompt usando a **Anatomia do Prompt** abaixo.

### Passo 4: Iterar e Otimizar
- Teste com casos diversos (incluindo edge cases)
- Compare variações do prompt
- Refine com base nos resultados

---

## Anatomia do Prompt

Todo prompt eficaz contém alguns ou todos estes elementos:

```
<role>        → Quem o LLM deve ser (persona, especialidade)
<context>     → Informação de fundo necessária para a tarefa
<instructions>→ O que fazer, passo a passo (ações claras e sequenciais)
<input>       → Os dados de entrada para processar
<constraints> → Limites, proibições, regras a cumprir
<format>      → Como formatar a saída (JSON, markdown, lista, prosa)
<examples>    → Exemplos de entrada/saída esperados (few-shot)
```

### Regra de Ouro
> Mostre seu prompt a um colega com contexto mínimo sobre a tarefa e peça que o siga. Se ele ficaria confuso, o LLM também ficará.

---

## Guia de Seleção de Técnicas

| Situação | Técnica | Quando Usar |
|----------|---------|-------------|
| Tarefa simples e direta | **Zero-shot** | Classificação, tradução, extração simples |
| Precisa de formato/padrão específico | **Few-shot** | Quando exemplos definem melhor que instruções |
| Raciocínio lógico/matemático | **Chain-of-Thought (CoT)** | Problemas multi-etapa, decisões complexas |
| Sem exemplos de raciocínio | **Zero-shot CoT** | Adicione "Vamos pensar passo a passo" |
| Explorar múltiplas soluções | **Tree of Thoughts (ToT)** | Problemas criativos, planejamento estratégico |
| Tarefa complexa decomponível | **Prompt Chaining** | Pipelines, processos multi-etapa |
| Precisa de dados externos | **RAG** | QA sobre documentos, base de conhecimento |
| Múltiplas respostas + consenso | **Self-Consistency** | Quando uma resposta pode variar, escolha a mais frequente |
| Raciocínio + ação com ferramentas | **ReAct** | Agentes, pesquisa, uso de APIs |
| Auto-correção iterativa | **Reflexion** | Código, escrita, tarefas com feedback |
| Orquestrar outros modelos | **Meta Prompting** | Tarefas complexas com sub-especialistas |

> Para detalhes e exemplos de cada técnica, consulte `./references/techniques.md`

---

## Princípios Fundamentais

### 1. Seja Claro e Direto
- Instruções explícitas e específicas superam instruções vagas
- Use verbos de ação: "Escreva", "Classifique", "Extraia", "Liste", "Compare"
- Numere os passos quando a ordem importa
- Diga o que FAZER, não o que NÃO fazer

**Ruim:** "Não seja muito técnico"
**Bom:** "Explique usando linguagem acessível para alunos do ensino médio"

### 2. Forneça Contexto
- Explique POR QUE a tarefa é importante (motivação melhora resultados)
- Inclua informações de fundo relevantes
- Especifique o domínio e público-alvo

### 3. Use Exemplos (Few-shot)
- 3-5 exemplos diversos são ideais
- Cubra casos normais E edge cases
- Estruture com tags: `<examples><example>...</example></examples>`
- Exemplos são a forma mais confiável de guiar formato, tom e estrutura

### 4. Estruture com XML Tags
- Separe instruções, contexto, entrada e exemplos com tags
- Tags descritivas e consistentes: `<instructions>`, `<context>`, `<input>`
- Aninhe quando há hierarquia: `<documents><document index="1">...</document></documents>`
- XML elimina ambiguidade em prompts complexos

### 5. Atribua um Papel (Role Prompting)
- Defina o papel no system prompt: "Você é um especialista em X..."
- Uma única frase de role já faz diferença significativa
- Combine role com expertise específica para a tarefa

### 6. Controle o Formato de Saída
- Declare explicitamente o formato desejado (JSON, markdown, prosa, lista)
- Demonstre o formato nos exemplos
- Diga "Responda APENAS com..." para eliminar preâmbulos
- Faça seu estilo de prompt refletir o estilo de saída desejado

---

## Templates Prontos

### Template Universal
```
<role>
Você é um [ESPECIALIDADE] com experiência em [DOMÍNIO].
</role>

<context>
[INFORMAÇÃO DE FUNDO RELEVANTE]
</context>

<instructions>
Sua tarefa é [AÇÃO PRINCIPAL].
Siga estes passos:
1. [PASSO 1]
2. [PASSO 2]
3. [PASSO 3]
</instructions>

<constraints>
- [RESTRIÇÃO 1]
- [RESTRIÇÃO 2]
</constraints>

<format>
Responda no seguinte formato:
[DESCRIÇÃO DO FORMATO ESPERADO]
</format>

<input>
[DADOS DE ENTRADA]
</input>
```

### Template Few-shot
```
<instructions>
[DESCRIÇÃO DA TAREFA]
</instructions>

<examples>
<example>
<input>[EXEMPLO DE ENTRADA 1]</input>
<output>[EXEMPLO DE SAÍDA 1]</output>
</example>
<example>
<input>[EXEMPLO DE ENTRADA 2]</input>
<output>[EXEMPLO DE SAÍDA 2]</output>
</example>
<example>
<input>[EXEMPLO DE ENTRADA 3]</input>
<output>[EXEMPLO DE SAÍDA 3]</output>
</example>
</examples>

<input>
[ENTRADA REAL]
</input>
```

### Template Chain-of-Thought
```
<instructions>
[DESCRIÇÃO DO PROBLEMA]

Pense passo a passo:
1. Analise os dados fornecidos
2. Identifique os elementos relevantes
3. Aplique o raciocínio lógico
4. Chegue à conclusão

Mostre seu raciocínio em <thinking> antes da resposta final em <answer>.
</instructions>

<input>
[PROBLEMA A RESOLVER]
</input>
```

### Template Tree of Thoughts
```
Imagine que três especialistas diferentes estão respondendo esta pergunta.
Cada especialista escreve um passo de raciocínio e compartilha com o grupo.
Se algum especialista perceber um erro no raciocínio, ele se retira.

Problema: [DESCRIÇÃO DO PROBLEMA]

Cada especialista deve:
1. Propor uma abordagem
2. Avaliar as abordagens dos outros
3. Refinar com base no feedback
4. Convergir para a melhor solução
```

### Template Prompt Chaining (Document QA)
```
--- Prompt 1: Extração ---
Sua tarefa é responder uma pergunta sobre o documento abaixo.
Primeiro, extraia citações relevantes delimitadas por <quotes></quotes>.
Se não encontrar citações relevantes, responda "Nenhuma citação relevante encontrada."

####
[DOCUMENTO]
####

Pergunta: [PERGUNTA]

--- Prompt 2: Resposta ---
Dado as citações extraídas (<quotes>) e o documento original, 
componha uma resposta precisa e útil para a pergunta.

####
[DOCUMENTO]
####

<quotes>[CITAÇÕES DO PROMPT 1]</quotes>

Pergunta: [PERGUNTA]
```

---

## Long Context (20k+ tokens)

Ao trabalhar com documentos longos:
1. **Dados no topo**: Coloque documentos longos ACIMA das instruções e da pergunta
2. **Pergunta no final**: Melhora qualidade em até 30%
3. **Estruture com XML**: `<document><source>...</source><document_content>...</document_content></document>`
4. **Cite antes de responder**: Peça ao modelo extrair citações relevantes primeiro

---

## Anti-Padrões (O Que Evitar)

| Anti-Padrão | Problema | Correção |
|-------------|----------|----------|
| Prompt vago | LLM adivinha intenção | Seja específico sobre formato e conteúdo |
| Muitas tarefas em um prompt | Falta de foco, respostas incompletas | Divida em sub-tarefas (prompt chaining) |
| Instruções negativas | "Não faça X" é menos eficaz | Diga o que FAZER: "Faça Y em vez disso" |
| Sem exemplos | Formato e tom imprevisíveis | Adicione 3-5 exemplos diversos |
| Contexto irrelevante | Ruído dilui informação útil | Inclua apenas contexto diretamente relevante |
| Complexidade prematura | Prompts complicados sem necessidade | Comece simples, adicione complexidade iterativamente |
| Assumir conhecimento implícito | Modelo não sabe seu contexto | Explicite todo contexto necessário |

---

## Otimização e Iteração

### Processo de Refinamento
1. **Comece simples** — prompt direto, sem complexidade desnecessária
2. **Teste com dados reais** — use exemplos do seu caso de uso
3. **Identifique falhas** — onde o modelo erra ou desvia
4. **Adicione precisão** — mais contexto, exemplos, restrições onde falhou
5. **Reduza ruído** — remova partes que não contribuem
6. **Repita** — prompt engineering é um processo iterativo

### Checklist Final
- [ ] Objetivo claro e critério de sucesso definido?
- [ ] Técnica adequada selecionada?
- [ ] Instruções claras e em ordem lógica?
- [ ] Contexto suficiente fornecido?
- [ ] Formato de saída especificado?
- [ ] Exemplos incluídos (se necessário)?
- [ ] Edge cases considerados?
- [ ] Prompt testado com dados variados?

---

## Dicas Específicas para Claude (Anthropic)

- Use XML tags extensivamente — Claude foi treinado para responder muito bem a elas
- `<thinking>` tags para separar raciocínio da resposta final
- Role no system prompt é especialmente eficaz
- Para comportamento "above and beyond", peça explicitamente
- Evite over-prompting — modelos Claude 4.6 já são proativos
- Use adaptive thinking (`thinking: {type: "adaptive"}`) para tarefas complexas
- Para pesquisa, peça hipóteses concorrentes e autocrítica
- Self-check: "Antes de finalizar, verifique sua resposta contra [critérios]"
