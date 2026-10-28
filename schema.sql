-- =====================================================================
-- DIONSHE - Skema akun (jalankan sekali di Supabase > SQL Editor)
-- =====================================================================

-- 1) Tabel profil: satu baris untuk setiap akun
create table if not exists public.profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  email        text,
  full_name    text not null default '',
  employee_id  text not null default '',
  role         text not null default 'karyawan' check (role in ('karyawan','admin')),
  status       text not null default 'pending'  check (status in ('pending','approved','rejected')),
  created_at   timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- 2) Fungsi pengecekan admin (security definer agar tidak memicu rekursi RLS)
create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin' and status = 'approved'
  );
$$;

-- 3) Setiap akun baru otomatis dibuatkan profil berstatus "pending" dan peran "karyawan".
--    Peran dan status SENGAJA tidak diambil dari input pengguna.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, employee_id)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    coalesce(new.raw_user_meta_data ->> 'employee_id', '')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4) Kebijakan akses (RLS)
drop policy if exists "baca profil sendiri"   on public.profiles;
drop policy if exists "admin baca semua"      on public.profiles;
drop policy if exists "admin ubah profil"     on public.profiles;

create policy "baca profil sendiri"
  on public.profiles for select
  to authenticated
  using (auth.uid() = id);

create policy "admin baca semua"
  on public.profiles for select
  to authenticated
  using (public.is_admin());

create policy "admin ubah profil"
  on public.profiles for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- Tidak ada kebijakan insert/update/delete untuk pengguna biasa,
-- sehingga karyawan tidak bisa menyetujui dirinya sendiri.

-- 5) Buat admin pertama.
--    Daftar dulu lewat halaman Masuk > Daftar, lalu jalankan baris di bawah
--    (ganti emailnya, hapus tanda -- di depan), lalu klik Run.
-- update public.profiles
--   set role = 'admin', status = 'approved'
--   where email = 'email-admin@perusahaan.co.id';
