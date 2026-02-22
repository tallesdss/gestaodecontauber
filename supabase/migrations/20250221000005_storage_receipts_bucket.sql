-- Passo 5 — Storage: bucket para comprovantes e políticas
-- Backend.md § 2.5

-- Criar bucket privado 'receipts' (comprovantes de despesas)
insert into storage.buckets (id, name, public)
values ('receipts', 'receipts', false)
on conflict (id) do nothing;

-- Políticas: usuário acessa apenas a própria pasta {user_id}/...
-- Convenção de caminho: {user_id}/expenses/{expense_id}.jpg

-- Upload na própria pasta
create policy "receipts_upload_own"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'receipts'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

-- Visualizar os próprios arquivos
create policy "receipts_select_own"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'receipts'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

-- Atualizar (substituir comprovante ao editar despesa)
create policy "receipts_update_own"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'receipts'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

-- Deletar os próprios arquivos
create policy "receipts_delete_own"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'receipts'
    and auth.uid()::text = (storage.foldername(name))[1]
  );
