---
description: "Gera ícones, logos e assets visuais. Usa IA (Gemini) para ícones complexos ou SVG para ícones simples. Perfeito para favicons, app icons, logos e ilustrações."
agent: "creative"
argument-hint: "Descreva o ícone: estilo, cores, forma, tamanho, onde salvar"
---

O usuário quer gerar um ícone ou asset visual. Siga este processo:

1. **Entenda o pedido**:
   - O que será o ícone? (app icon, favicon, logo, ilustração)
   - Qual estilo? (minimalista, flat design, 3D, pixel art, gradiente)
   - Quais cores? (peça cores específicas ou sugira com base no contexto)
   - Qual tamanho? (favicon=16/32, app icon=128/256/512, use presets)
   - Onde salvar? (caminho do projeto)

2. **Escolha a ferramenta certa**:
   - Ícone complexo/artístico → `#tool:generate_ai_icon`
   - Ícone simples/texto/geométrico → `#tool:generate_simple_icon`

3. **Gere o ícone** com os parâmetros otimizados
   - Para `generate_ai_icon`: SEMPRE use resolution `2K` (Nano Banana Pro). Use `4K` se o usuário pedir máxima qualidade. NUNCA use `flash`.

4. **Apresente o resultado** com os caminhos dos arquivos gerados

Se o usuário não especificou detalhes suficientes, faça perguntas objetivas antes de gerar.
