# DIONSHE - Digital Information SHE

Situs statis (HTML/CSS/JS) tanpa build step. Siap di-deploy ke Vercel.

## Struktur
- `public/index.html`  : beranda (desain, data, dan skrip)
- `public/masuk.html`  : masuk, daftar, dan atur ulang kata sandi
- `public/admin.html`  : manajemen akun (khusus Admin)
- `public/config.js`   : isi URL dan kunci anon Supabase
- `public/assets/`     : logo, gaya, `auth.js`, dan library Supabase
- `supabase/schema.sql`: skema database akun (jalankan di Supabase SQL Editor)
- `PANDUAN-AKUN.md`    : langkah mengaktifkan sistem akun
- `vercel.json`        : konfigurasi Vercel (folder output + header keamanan)

## Cara mengubah isi
Buka `public/index.html`, cari bagian `PENGATURAN` dan `DATA` di dalam tag `<script>`:
- `CONFIG`   : nama portal, nama perusahaan, email, WhatsApp, jam layanan, pengumuman tersemat
- `STATUS`   : daftar status sistem
- `SERVICES` : daftar layanan
- `NEWS`     : daftar kabar
- `DOCS`     : daftar dokumen

## Deploy ke Vercel
### Cara 1: lewat GitHub (disarankan)
1. Buat repository baru di GitHub, unggah seluruh isi folder ini.
2. Buka vercel.com, klik Add New > Project, pilih repository tersebut.
3. Framework Preset: Other. Klik Deploy. Selesai.

### Cara 2: lewat Vercel CLI
```
npm i -g vercel
cd infora
vercel          # preview
vercel --prod   # produksi
```

## Akun
Sebelum tombol Masuk berfungsi, ikuti `PANDUAN-AKUN.md`. Tanpa itu, situs tetap tampil normal tetapi layanan "Perlu akun" menampilkan pesan belum dikonfigurasi.

## Catatan
- Tombol layanan dan tombol Unduh masih menampilkan dialog placeholder. Isi `url` pada layanan di `index.html` dan arahkan tombol Unduh ke file Anda.
- Untuk domain sendiri: Vercel > Project > Settings > Domains.
