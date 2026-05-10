# 🌿 Git Version Control Strategy

**Dokumen Strategi Kolaborasi Git untuk Pengembangan Smart-Hub Management System**

Dokumen ini mendeskripsikan strategi kontrol versi (Version Control System) yang diterapkan dalam proyek ini untuk memastikan stabilitas kode utama (`master`), sekaligus memungkinkan pengembangan fitur secara paralel oleh beberapa tim pengembang.

---

## 1. Pendekatan Branching: *Feature Branch Workflow*

Untuk menjawab tantangan: **"Bagaimana memungkinkan tim pengembang lain mengerjakan fitur 'Notifikasi Email' secara paralel tanpa mengganggu kode utama"**, proyek ini mengadopsi model **Feature Branch Workflow**.

Dalam model ini, branch `master` atau `main` dikhususkan secara eksklusif untuk kode yang stabil dan siap produksi (*production-ready*). Tidak boleh ada pengembang yang melakukan commit langsung (*direct commit*) ke branch utama.

### Struktur Branch
- `master` (atau `main`): Branch utama, berisi kode stabil.
- `feature/*`: Branch khusus untuk mengembangkan fitur baru (contoh: `feature/email-notification`).
- `bugfix/*`: Branch khusus untuk memperbaiki bug.

---

## 2. Standar Operasional Prosedur (SOP) untuk Tim "Email Notification"

Berikut adalah alur kerja yang **wajib** diikuti oleh tim pengembang (atau anggota tim lain) yang ditugaskan untuk mengerjakan fitur integrasi Email Notifikasi:

### Langkah 1: Sinkronisasi dengan Kode Utama
Sebelum mulai bekerja, tim pengembang harus memastikan mereka memiliki versi kode paling mutakhir dari branch utama.
```bash
git checkout master
git pull origin master
```

### Langkah 2: Membuat Branch Isolasi (Feature Branch)
Tim **tidak boleh** memodifikasi fitur di branch `master`. Mereka harus membuat ruang kerja terisolasi.
```bash
git checkout -b feature/email-notification
```
*Dengan perintah ini, semua perubahan, penambahan library (seperti setup SMTP, pembuatan Mailable, dan Jobs) tidak akan berdampak pada branch master.*

### Langkah 3: Pengembangan & Commit Rutin
Tim melakukan pengembangan fitur notifikasi email. Setiap kali satu sub-tugas selesai, mereka akan menyimpannya menggunakan format *Conventional Commits*:
```bash
git add .
git commit -m "feat: implement BookingApproved mailable template"
git commit -m "chore: add SMTP configuration variables to .env.example"
```

### Langkah 4: Sinkronisasi Ulang (Mencegah Conflict)
Sebelum mengajukan penggabungan kode, tim email harus memastikan kode mereka tidak bentrok (*conflict*) jika ada pembaruan baru dari tim lain di `master`.
```bash
git fetch origin
git rebase origin/master
# (Selesaikan konflik secara lokal jika ada)
```

### Langkah 5: Mengajukan Pull Request (PR)
Setelah fitur email diuji dan berhasil berjalan secara lokal, tim akan melakukan push branch fitur mereka ke repositori (GitHub/GitLab):
```bash
git push origin feature/email-notification
```
Tim kemudian membuka **Pull Request (PR)** dari branch `feature/email-notification` ke branch `master`.

---

## 3. Code Review & Penggabungan (Merge)

Pada tahap ini, **Lead Developer / Arsitek** (Pemilik Repositori) akan bertindak sebagai *reviewer*. 
- Kode akan diinspeksi untuk memastikan fitur email tidak merusak fungsionalitas Booking atau Check-in yang sudah ada.
- Jika ada kesalahan, reviewer dapat meminta revisi (*Request Changes*).
- Jika dinyatakan valid, stabil, dan aman, Lead Developer akan melakukan **Merge** dari Pull Request tersebut ke dalam branch `master`.

---

## 4. Kesimpulan Analisis

Strategi **Feature Branch + Pull Request** ini menjawab instruksi pengembangan sistem secara sempurna karena memberikan 3 lapis perlindungan:
1. **Isolasi Penuh**: Bug yang terjadi saat tim email melakukan eksperimen konfigurasi SMTP tidak akan membuat aplikasi utama *crash*.
2. **Review Gate**: Kode tidak bisa masuk ke master tanpa persetujuan (approval) dari pengembang utama.
3. **Traceability**: Memudahkan pelacakan kode mana yang menambah fitur email, karena semua terbungkus rapi dalam satu branch dan PR yang jelas.
