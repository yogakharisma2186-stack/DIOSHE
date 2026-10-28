# DIONSHE - Digital Information SHE

Situs statis (HTML/CSS/JS) tanpa build step. Siap di-deploy ke Vercel.

## Struktur
- `public/index.html`  : seluruh halaman (desain, data, dan skrip)
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

## Catatan
- Tombol layanan, tombol Masuk, dan tombol Unduh masih menampilkan dialog placeholder. Sambungkan ke alamat layanan atau file Anda.
- Untuk domain sendiri: Vercel > Project > Settings > Domains.
