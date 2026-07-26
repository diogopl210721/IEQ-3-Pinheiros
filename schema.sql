-- =========================================================
-- DIÁRIO DE CULTO — schema do Supabase
-- Rode este arquivo inteiro no SQL Editor do seu projeto Supabase
-- (Project > SQL Editor > New query > colar > Run)
-- =========================================================

create extension if not exists pgcrypto;

create table if not exists public.cultos (
  id                    uuid primary key default gen_random_uuid(),
  data_culto            date not null,
  hora_culto            time,
  pregador              text,
  visitantes            integer default 0,
  criancas              integer default 0,
  adultos               integer default 0,
  apresentacao_crianca  text,
  pastores_obreiros     text,
  diaconos_servico      text,
  recepcao              text,
  musicos               text,
  vocal                 text,
  dizimistas_detalhe    text,
  dizimistas            numeric(10,2) default 0,
  ofertas_missoes       numeric(10,2) default 0,
  ofertas_primicias     numeric(10,2) default 0,
  ofertas_gerais        numeric(10,2) default 0,
  nome_dizimistas       text,
  conferido_por_1       text,
  testemunho            text,
  batismo_esp_santo     text,
  conversao             text,
  reconciliacao         text,
  conferido_por_2       text,
  -- total de pessoas = visitantes + crianças + adultos (calculado automaticamente)
  total_pessoas         integer generated always as
                          (coalesce(visitantes,0) + coalesce(criancas,0) + coalesce(adultos,0)) stored,
  criado_em             timestamptz not null default now()
);

create index if not exists idx_cultos_data on public.cultos (data_culto desc);

-- =========================================================
-- Segurança (RLS)
-- Como é um app interno de uso da equipe da igreja, liberamos leitura
-- e escrita para quem tiver a "anon key" do projeto (a mesma chave
-- pública usada no arquivo config.js do site). Se no futuro você quiser
-- exigir login, troque estas policies por policies com auth.uid().
-- =========================================================

alter table public.cultos enable row level security;

drop policy if exists "cultos_select_publico" on public.cultos;
create policy "cultos_select_publico"
  on public.cultos for select
  using (true);

drop policy if exists "cultos_insert_publico" on public.cultos;
create policy "cultos_insert_publico"
  on public.cultos for insert
  with check (true);

drop policy if exists "cultos_update_publico" on public.cultos;
create policy "cultos_update_publico"
  on public.cultos for update
  using (true);

drop policy if exists "cultos_delete_publico" on public.cultos;
create policy "cultos_delete_publico"
  on public.cultos for delete
  using (true);

-- =========================================================
-- View auxiliar: resumo mensal (usada pelo gráfico do dashboard)
-- =========================================================
create or replace view public.resumo_mensal as
select
  date_trunc('month', data_culto)::date as mes,
  count(*)                              as numero_cultos,
  sum(visitantes)                       as total_visitantes,
  sum(total_pessoas)                    as total_pessoas,
  round(avg(total_pessoas))             as media_pessoas
from public.cultos
group by 1
order by 1;
