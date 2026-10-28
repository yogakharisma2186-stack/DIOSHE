# Panduan Mengaktifkan Akun DIONSHE (Supabase)

Sistem akun memakai **Supabase** (gratis untuk skala kecil). Alurnya:
karyawan daftar sendiri atau dibuatkan admin, akun baru berstatus **Menunggu**,
admin menyetujui di halaman `/admin`, lalu layanan internal terbuka.
Ada dua peran: **Karyawan** dan **Admin**.

## 1. Buat project Supabase
1. Buka **supabase.com**, klik *Start your project*, lalu masuk dengan GitHub.
2. Klik **New project**. Isi nama (misalnya `dionshe`), buat *Database Password* (simpan), pilih region terdekat (misalnya Singapore), lalu **Create new project**. Tunggu 1-2 menit.

## 2. Jalankan skema database
1. Di Supabase buka **SQL Editor** > **New query**.
2. Salin seluruh isi file `supabase/schema.sql`, tempel, lalu klik **Run**.
   Ini membuat tabel `profiles`, aturan keamanan (RLS), dan pemicu yang otomatis membuat profil berstatus *pending* untuk setiap akun baru.

## 3. Isi konfigurasi situs
1. Di Supabase buka **Project Settings > API**.
2. Salin **Project URL** dan kunci **anon / publishable**.
3. Buka `public/config.js` lalu isi:
   ```js
   window.DIONSHE_CONFIG = {
     SUPABASE_URL: "https://xxxx.supabase.co",
     SUPABASE_ANON_KEY: "eyJ..."
   };
   ```
   Kunci anon aman ditaruh di sini. **Jangan** memasukkan `service_role` key.

## 4. Atur alamat situs di Supabase
Buka **Authentication > URL Configuration**:
- **Site URL**: alamat situs Anda, misalnya `https://dionshe.vercel.app`
- **Redirect URLs**: tambahkan `https://dionshe.vercel.app/**`
  (tambahkan juga domain sendiri jika sudah dipasang)

Tanpa ini, tautan konfirmasi email dan reset kata sandi tidak akan kembali ke situs Anda.

## 5. Unggah ulang ke GitHub
Ganti file di repository dengan versi terbaru (terutama `public/config.js`).
Vercel akan men-deploy ulang otomatis.

## 6. Buat admin pertama
1. Buka situs Anda, klik **Masuk > Daftar**, lalu daftar dengan email Anda.
2. Di Supabase **SQL Editor**, jalankan (ganti emailnya):
   ```sql
   update public.profiles
     set role = 'admin', status = 'approved'
     where email = 'email-anda@perusahaan.co.id';
   ```
3. Muat ulang situs lalu masuk. Tautan **Admin** muncul di menu.

Setelah itu semua pengelolaan dilakukan lewat halaman **Admin**.

## Cara akun dibuat
- **Daftar sendiri:** karyawan membuka *Masuk > Daftar*. Akun berstatus *Menunggu* sampai admin menekan **Setujui**.
- **Dibuatkan admin:** di Supabase buka **Authentication > Users > Add user > Create new user**, isi email dan kata sandi, centang *Auto Confirm User*. Akun itu otomatis masuk daftar *Menunggu* di halaman Admin, lalu setujui di sana.

## Pengaturan email (penting)
- Secara bawaan Supabase mewajibkan **konfirmasi email**. Atur di **Authentication > Providers > Email**.
- Layanan email bawaan Supabase dibatasi jumlah kirimnya per jam, cukup untuk uji coba tetapi tidak untuk banyak karyawan. Untuk penggunaan nyata, pasang SMTP sendiri di **Authentication > Emails > SMTP Settings**.
- Anda bisa mengubah teks email (konfirmasi, reset kata sandi) di **Authentication > Emails**.

## Menghubungkan layanan
Di `public/index.html`, pada daftar `SERVICES`, tambahkan alamat layanan:
```js
{ id:"s2", ..., login:true, url:"https://hr.perusahaan.co.id/cuti", title:"Pengajuan cuti", ... }
```
Layanan dengan `login:true` hanya dibuka untuk akun berstatus **Disetujui**.

## Catatan keamanan
- Pengecekan login di halaman web bersifat **pengaturan tampilan**. Alamat layanan yang ditulis di `index.html` tetap bisa dilihat siapa pun yang membuka kode sumber halaman.
- Jika sebuah layanan menyimpan data sensitif, layanan itu sendiri harus meminta login (misalnya memakai Supabase dengan RLS, atau SSO perusahaan). Jangan hanya mengandalkan tombol di portal ini.
- Aturan pada `supabase/schema.sql` memastikan karyawan **tidak bisa** menyetujui dirinya sendiri atau mengubah perannya. Hanya admin yang berstatus disetujui yang bisa.
- Menolak atau mencabut akses tidak menghapus akun. Untuk menghapus permanen, gunakan **Authentication > Users** di Supabase.
- Project Supabase gratis akan dijeda jika lama tidak ada aktivitas. Buka dashboard Supabase dan klik *Restore* bila itu terjadi.

## Uji cepat setelah pengaturan
1. Daftar dengan email kedua, pastikan muncul status *Menunggu persetujuan* di menu.
2. Masuk sebagai admin, buka **Admin**, klik **Setujui**.
3. Masuk lagi sebagai akun kedua, pastikan statusnya *Aktif* dan layanan terbuka.
