-- One-time setup for EDB 5 photo uploads. Paste into the Supabase SQL editor and run once.
--
-- Creates a PRIVATE bucket: photos are not publicly viewable. Students (the anonymous key the
-- page uses) can only add photos; they cannot list, open, replace or delete anything.
-- You view the photos in the Supabase dashboard: Storage > edb5-photos > pair-<N>.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('edb5-photos', 'edb5-photos', false, 10485760,
        array['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif'])
on conflict (id) do nothing;

create policy "edb5 photos: anyone can upload"
  on storage.objects for insert
  to anon, authenticated
  with check (bucket_id = 'edb5-photos');

-- To check it worked: after a test upload, Storage > edb5-photos should show a pair-99 folder.
-- To remove test photos, delete the pair-99 folder from the dashboard.
