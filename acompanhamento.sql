-- Acompanhamento público seguro por token
alter table public.pedidos
add column if not exists tracking_token text not null default gen_random_uuid()::text;

create unique index if not exists pedidos_tracking_token_idx
on public.pedidos(tracking_token);

create or replace function public.get_pedido_tracking(p_token text)
returns table (
  numero integer,
  status text,
  tipo_entrega text,
  bairro text
)
language sql
security definer
set search_path = public
as $$
  select p.numero, p.status, p.tipo_entrega, p.bairro
  from public.pedidos p
  where p.tracking_token = p_token
  limit 1;
$$;

grant execute on function public.get_pedido_tracking(text) to anon, authenticated;
