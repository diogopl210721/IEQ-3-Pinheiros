# Diário de Culto — dashboard + registro (Supabase + GitHub Pages)

Site que substitui o Google Forms: **dashboard** (cultos no ano, cultos no mês, visitantes
no mês, média de pessoas por culto) + **formulário de registro** na mesma tela, dados
salvos no **Supabase**, hospedado gratuitamente no **GitHub Pages**.

Arquivos deste projeto:
- `index.html` — o site inteiro (dashboard + formulário)
- `logo.png` — a logo da Três Pinheiros Quadrangular, já usada no cabeçalho
- `config.js` — **já preenchido** com a URL e a chave do seu projeto Supabase
- `supabase/schema.sql` — script para criar a tabela no Supabase
- `supabase/import_dados_antigos.csv` — os 263 cultos que já estavam na sua planilha, prontos para importar

---

## ⚠️ Por que o painel não puxou os dados da última vez

Encontrei o motivo: a URL que você me passou era
`https://qiyparxwgabulolqkvzg.supabase.co/rest/v1/`, mas o site precisa da **URL base**
do projeto, **sem** o `/rest/v1/` no final — essa parte é adicionada automaticamente por
trás das cenas. Com o `/rest/v1/` colado na URL, todo pedido ao banco ia para um
endereço errado e falhava.

Já corrigi isso de duas formas:
1. O `config.js` que estou te enviando agora já está com a URL certa:
   `https://qiyparxwgabulolqkvzg.supabase.co`
2. Além disso, o site agora **remove sozinho** um `/rest/v1/` caso alguém cole por engano
   de novo no futuro — e se ainda assim algo der errado, uma faixa vermelha aparece no
   topo do site com a mensagem de erro exata (em vez de o painel simplesmente ficar em
   branco), com um botão "Tentar novamente".

## Passo 1 — Criar a tabela no Supabase

1. No painel do seu projeto Supabase, abra **SQL Editor** → **New query**.
2. Copie todo o conteúdo de `supabase/schema.sql` e cole no editor.
3. Clique **Run**. Isso cria a tabela `cultos` e as permissões de acesso.

(Pule este passo se você já rodou o `schema.sql` anteriormente.)

## Passo 2 — Importar os cultos que já existiam na planilha

1. No menu lateral, **Table Editor** → tabela `cultos`.
2. **Insert** → **Import data from CSV** → envie `supabase/import_dados_antigos.csv`.
3. Confirme o mapeamento das colunas e importe.

(Pule este passo se você já importou anteriormente.)

## Passo 3 — Colocar no GitHub Pages

1. Crie um repositório no GitHub (ex: `diario-de-culto`).
2. Envie os arquivos **`index.html`**, **`config.js`** e **`logo.png`** para o repositório
   (a pasta `supabase/` é opcional de enviar, só é usada dentro do Supabase).
3. **Settings** → **Pages** → "Deploy from a branch" → branch `main`, pasta `/ (root)` → **Save**.
4. Em ~1 minuto o GitHub mostra o link do site (`https://seu-usuario.github.io/diario-de-culto/`).

Como o `config.js` já vem preenchido, não precisa editar nada — é só subir os arquivos e usar.

---

## O que mudou nesta versão

- **Visual**: layout novo, mais limpo e moderno (cards brancos, um azul-índigo como cor
  de destaque, tipografia atual), com a logo da igreja no cabeçalho.
- **Responsivo**: o formulário e o dashboard se reorganizam automaticamente em telas
  menores (tablet e celular).
- **Equipe de serviço**: os campos de Pastores/Obreiros, Diáconos, Recepção, Músicos e
  Vocal agora aceitam **vários nomes** — digite um nome e aperte Enter (ou vírgula) para
  adicionar, e pode repetir quantas vezes precisar.
- **Finanças**: "Nome e valor dos dizimistas" agora é uma lista — você preenche nome e
  valor de um dizimista, clica em **"+ Adicionar dizimista"** para abrir a próxima linha,
  e assim por diante. O campo **"Dizimistas (total R$)"** soma tudo sozinho conforme você
  preenche. Ofertas de Missões, Primícias e Gerais continuam sendo digitadas manualmente.
- **Registros especiais**: a antiga seção "Manifestações espirituais" foi renomeada para
  **Registros especiais** (apresentação de criança, batismo, conversão, reconciliação,
  testemunho).
- **Conferido por**: agora existe **um único** campo "Preenchido e conferido por", no
  **final** do formulário, antes do botão de salvar (antes havia dois, um no meio do
  formulário).

## Sobre segurança

App pensado para uso interno da equipe: qualquer pessoa com o link consegue ver o
dashboard e registrar cultos, sem exigir login — igual ao Google Forms. Se quiser exigir
login no futuro (Supabase Auth), é só pedir.

## Como editar campos depois

Tudo está em `index.html`, organizado em blocos numerados (1. Quando & quem pregou,
2. Presença, 3. Equipe de serviço, 4. Finanças, 5. Registros especiais). Para adicionar
um campo novo, localize o bloco correspondente no HTML, adicione o `name="..."`
equivalente no JavaScript que monta o `payload` do envio, e crie a coluna correspondente
no Supabase com `alter table public.cultos add column ...`.
