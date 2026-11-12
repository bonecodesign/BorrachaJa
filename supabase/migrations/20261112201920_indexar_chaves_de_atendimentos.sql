-- Indices para chaves estrangeiras identificadas no advisor de performance.
create index if not exists request_messages_sender_idx on public.request_messages(sender_id);
create index if not exists service_quotes_provider_idx on public.service_quotes(provider_id);
create index if not exists service_requests_category_idx on public.service_requests(category_id);
