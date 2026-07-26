# Diário de Culto — dashboard + registro (Supabase + GitHub Pages)

Sistema web que substitui o Google Forms: um site com **dashboard** (cultos no ano, cultos
no mês, visitantes no mês, média de pessoas por culto) e um **formulário de registro**
na mesma tela, com os dados salvos no **Supabase**. Hospedagem gratuita no **GitHub Pages**.

Arquivos deste projeto:
- `index.html` — o site inteiro (dashboard + formulário)
- `config.js` — onde você cola as credenciais do seu Supabase
- `supabase/schema.sql` — script para criar a tabela no Supabase
- `supabase/import_dados_antigos.csv` — os 263 cultos que já estavam na sua planilha, prontos para importar

---

## Passo 1 — Criar o projeto no Supabase

1. Acesse [supabase.com](https://supabase.com) → crie uma conta gratuita → **New project**.
2. Escolha um nome (ex: `diario-de-culto`) e uma senha de banco (guarde-a, não vai precisar dela aqui).
3. Aguarde ~2 minutos até o projeto ficar pronto.

## Passo 2 — Criar a tabela

1. No menu lateral, abra **SQL Editor** → **New query**.
2. Abra o arquivo `supabase/schema.sql` deste projeto, copie todo o conteúdo e cole no editor.
3. Clique **Run**. Isso cria a tabela `cultos`, as permissões de acesso e uma view auxiliar.

## Passo 3 — Importar os cultos que já existiam na planilha

1. No menu lateral, vá em **Table Editor** → selecione a tabela `cultos`.
2. Clique no botão **Insert** → **Import data from CSV**.
3. Envie o arquivo `supabase/import_dados_antigos.csv`.
4. Confirme o mapeamento das colunas (os nomes já batem automaticamente) e importe.
   Isso vai trazer os 263 cultos já registrados desde janeiro de 2024.

> Alguns registros antigos tinham o campo "Dizimistas" preenchido com nomes em vez de valor
> numérico (ex: "Robson 300,00" em vez de só "300,00"). Nesses casos o valor total foi calculado
> automaticamente e o texto original foi preservado em `dizimistas_detalhe`, para você conferir depois.

## Passo 4 — Pegar as credenciais do site

1. No Supabase, vá em **Project Settings** (ícone de engrenagem) → **API**.
2. Copie a **Project URL** e a chave **anon public** (não a `service_role`, que é secreta).
3. Abra o arquivo `config.js` deste projeto e cole os dois valores:

```js
window.SUPABASE_URL = "https://xxxxxxxx.supabase.co";
window.SUPABASE_ANON_KEY = "eyJhbGciOi...";
```

## Passo 5 — Colocar no GitHub Pages

1. Crie um repositório novo no GitHub (pode ser privado ou público), ex: `diario-de-culto`.
2. Envie os arquivos `index.html` e `config.js` (e a pasta `supabase/`, se quiser manter o histórico) para o repositório.
3. No repositório, vá em **Settings** → **Pages**.
4. Em "Build and deployment", escolha **Deploy from a branch**, branch `main`, pasta `/ (root)` → **Save**.
5. Em ~1 minuto o GitHub mostra o link do site, algo como `https://seu-usuario.github.io/diario-de-culto/`.

Pronto — esse link é o novo sistema, acessível de qualquer navegador (computador ou celular),
substituindo o Google Forms.

---

## Sobre segurança

Este é um app pensado para uso interno da equipe da igreja: qualquer pessoa que tenha o link
do site consegue ver o dashboard e registrar cultos (não precisa de login), da mesma forma que
qualquer pessoa com o link do Google Forms conseguia responder. Se no futuro você quiser exigir
login (por exemplo, só a secretaria poder registrar), o Supabase tem autenticação pronta
(Supabase Auth) e as políticas de acesso no `schema.sql` podem ser ajustadas para isso — é só pedir.

## Como editar os campos depois

Todo o site está em um único arquivo (`index.html`), com o formulário organizado em blocos
("Quando & quem pregou", "Presença", "Equipe de serviço", "Finanças", "Manifestações espirituais").
Para adicionar ou remover um campo, procure o bloco correspondente no HTML e o mesmo nome
(`name="..."`) dentro do JavaScript que salva os dados — e adicione a coluna equivalente na
tabela `cultos` do Supabase (`alter table public.cultos add column ...`).
