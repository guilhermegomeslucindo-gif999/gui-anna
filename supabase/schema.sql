-- Banco do painel G&A (já aplicado no projeto Supabase gxywpcnafudktgmygxbz).
-- Só rode de novo se um dia criar o banco em outro projeto.
create table if not exists public.ga_docs (
  colecao text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now(),
  primary key (colecao, id)
);
alter table public.ga_docs enable row level security;
alter table public.ga_docs replica identity full;
create policy "ga_docs leitura" on public.ga_docs for select to anon, authenticated using (true);
create policy "ga_docs insercao" on public.ga_docs for insert to anon, authenticated with check (colecao in ('campos','itens','depositos'));
create policy "ga_docs edicao" on public.ga_docs for update to anon, authenticated using (true) with check (colecao in ('campos','itens','depositos'));
create policy "ga_docs exclusao" on public.ga_docs for delete to anon, authenticated using (true);

create or replace function public.ga_jsonb_merge(a jsonb, b jsonb)
returns jsonb language sql immutable set search_path = '' as $$
  select case
    when jsonb_typeof(a) = 'object' and jsonb_typeof(b) = 'object' then
      (select coalesce(jsonb_object_agg(k,
        case when a ? k and b ? k then public.ga_jsonb_merge(a->k, b->k)
             when b ? k then b->k else a->k end), '{}'::jsonb)
       from (select jsonb_object_keys(a) k union select jsonb_object_keys(b)) s)
    else b end
$$;
create or replace function public.ga_update(p_colecao text, p_id text, p_patch jsonb)
returns void language sql security invoker set search_path = '' as $$
  update public.ga_docs set data = public.ga_jsonb_merge(data, p_patch), atualizado_em = now()
   where colecao = p_colecao and id = p_id;
$$;
grant execute on function public.ga_update(text,text,jsonb) to anon, authenticated;
grant execute on function public.ga_jsonb_merge(jsonb,jsonb) to anon, authenticated;
grant select, insert, update, delete on public.ga_docs to anon, authenticated;
alter publication supabase_realtime add table public.ga_docs;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('ga-fotos','ga-fotos', true, 20971520, array['image/png','image/jpeg','image/webp','image/gif'])
on conflict (id) do nothing;
create policy "ga-fotos envio" on storage.objects for insert to anon, authenticated with check (bucket_id = 'ga-fotos');
create policy "ga-fotos exclusao" on storage.objects for delete to anon, authenticated using (bucket_id = 'ga-fotos');
create policy "ga-fotos leitura" on storage.objects for select to anon, authenticated using (bucket_id = 'ga-fotos');
