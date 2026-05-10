# 🏢 Smart-Hub Management System — Backend API

> REST API untuk sistem manajemen peminjaman ruang kerja dan peralatan studio berbasis Laravel 11 + MySQL + Sanctum Authentication.

---

## 📋 Daftar Isi

1. [Deskripsi Proyek](#-deskripsi-proyek)
2. [Arsitektur & Struktur MVC](#-arsitektur--struktur-mvc)
3. [Analisis Kebutuhan API](#-analisis-kebutuhan-api)
4. [Skema Database](#-skema-database)
5. [Strategi Autentikasi](#-strategi-autentikasi)
6. [Dokumentasi API Endpoint](#-dokumentasi-api-endpoint)
7. [Instalasi & Konfigurasi](#-instalasi--konfigurasi)
8. [Pengujian API](#-pengujian-api)

---

## 🎯 Deskripsi Proyek

**Smart-Hub Management System** dibangun untuk komunitas kreatif lokal yang membutuhkan sistem pengelolaan peminjaman ruang kerja dan peralatan studio secara mandiri. Sistem ini melayani **dua jenis pengguna**:

| Pengguna | Akses | Deskripsi |
|----------|-------|-----------|
| **Admin** | Dashboard Web | Mengelola data inventaris, menyetujui/menolak booking |
| **Member** | API / Tablet App | Melihat peralatan, membuat booking, check-in/check-out |

### Tantangan Utama
- Dual-user system (admin + member) dalam satu API
- REST API yang aman untuk aplikasi tablet
- Polymorphic booking (Equipment & Room dalam satu tabel)
- Role-based access control (RBAC)

---

## 🏗 Arsitektur & Struktur MVC

### Pola Arsitektur: MVC + Form Request + API Resource

```
app/
├── Http/
│   ├── Controllers/Api/V1/     # Controller (Business Logic)
│   │   ├── AuthController.php        → Register, Login, Logout, Profile
│   │   ├── CategoryController.php    → CRUD Kategori
│   │   ├── EquipmentController.php   → CRUD Equipment
│   │   ├── RoomController.php        → CRUD Room
│   │   ├── BookingController.php     → CRUD + Approve/Reject/Cancel
│   │   ├── CheckInController.php     → Check-in/out (Tablet API)
│   │   └── DashboardController.php   → Statistik Admin
│   ├── Middleware/
│   │   └── AdminMiddleware.php       → Guard admin-only routes
│   ├── Requests/                     # Form Request Validation
│   │   ├── Auth/
│   │   │   ├── LoginRequest.php
│   │   │   └── RegisterRequest.php
│   │   ├── Booking/
│   │   │   └── StoreBookingRequest.php
│   │   ├── CheckIn/
│   │   │   └── StoreCheckInRequest.php
│   │   ├── Equipment/
│   │   │   ├── StoreEquipmentRequest.php
│   │   │   └── UpdateEquipmentRequest.php
│   │   └── Room/
│   │       ├── StoreRoomRequest.php
│   │       └── UpdateRoomRequest.php
│   └── Resources/                    # API Resource (Response Transform)
│       ├── BookingResource.php
│       ├── CategoryResource.php
│       ├── CheckInResource.php
│       ├── EquipmentResource.php
│       ├── RoomResource.php
│       └── UserResource.php
├── Models/                           # Eloquent Models
│   ├── User.php
│   ├── Category.php
│   ├── Equipment.php
│   ├── Room.php
│   ├── Booking.php
│   └── CheckIn.php
database/
├── migrations/                       # Schema Definition
│   ├── create_users_table.php
│   ├── create_categories_table.php
│   ├── create_equipment_table.php
│   ├── create_rooms_table.php
│   ├── create_bookings_table.php
│   ├── create_check_ins_table.php
│   └── create_personal_access_tokens_table.php
└── seeders/
    └── DatabaseSeeder.php            # Data Awal (Admin + Member + Inventaris)
```

### Keunggulan Arsitektur

| Komponen | Teknik | Manfaat |
|----------|--------|---------|
| **Form Request** | Validasi terpisah dari controller | Single Responsibility Principle |
| **API Resource** | Transform model → JSON | Konsistensi response, hide sensitive data |
| **Middleware** | `AdminMiddleware` | Centralized authorization |
| **Eloquent ORM** | Relationships, Eager Loading | Query efisien, N+1 prevention |
| **Polymorphic Relations** | `bookable_type` + `bookable_id` | Satu tabel booking untuk Equipment & Room |

---

## 📊 Analisis Kebutuhan API

### Identifikasi Aktor dan Kebutuhan

```
┌──────────────────────────────────────────────────────┐
│                    SMART-HUB API                     │
├──────────────────────────────────────────────────────┤
│                                                      │
│  [Admin]                      [Member/Tablet]        │
│  ├─ Kelola Categories         ├─ Register/Login      │
│  ├─ Kelola Equipment          ├─ Lihat Equipment     │
│  ├─ Kelola Rooms              ├─ Lihat Rooms         │
│  ├─ Approve/Reject Booking    ├─ Buat Booking        │
│  ├─ Lihat Dashboard Stats     ├─ Cancel Booking      │
│  └─ Lihat Semua Booking       └─ Check-in/Check-out  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### Matriks Hak Akses (RBAC)

| Endpoint | Guest | Member | Admin |
|----------|:-----:|:------:|:-----:|
| `POST /auth/register` | ✅ | — | — |
| `POST /auth/login` | ✅ | — | — |
| `GET /equipment` | — | ✅ | ✅ |
| `POST /equipment` | — | ❌ | ✅ |
| `PUT /equipment/:id` | — | ❌ | ✅ |
| `DELETE /equipment/:id` | — | ❌ | ✅ |
| `GET /rooms` | — | ✅ | ✅ |
| `POST /rooms` | — | ❌ | ✅ |
| `GET /bookings` | — | ✅ (own) | ✅ (all) |
| `POST /bookings` | — | ✅ | ✅ |
| `PATCH /bookings/:id/approve` | — | ❌ | ✅ |
| `PATCH /bookings/:id/reject` | — | ❌ | ✅ |
| `POST /check-ins` | — | ✅ | ✅ |
| `GET /dashboard/stats` | — | ❌ | ✅ |

---

## 🗄 Skema Database

### Entity Relationship Diagram (ERD)

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│    users     │     │  categories  │     │    rooms     │
├─────────────┤     ├──────────────┤     ├─────────────┤
│ id (PK)     │     │ id (PK)      │     │ id (PK)     │
│ name        │     │ name         │     │ name        │
│ email (UQ)  │     │ slug (UQ)    │     │ code (UQ)   │
│ password    │     │ description  │     │ description │
│ role        │     │ timestamps   │     │ capacity    │
│ phone       │     └──────┬───────┘     │ facilities  │
│ address     │            │ 1:N         │ status      │
│ timestamps  │     ┌──────┴───────┐     │ image       │
└──────┬──────┘     │  equipment   │     │ hourly_rate │
       │            ├──────────────┤     │ timestamps  │
       │            │ id (PK)      │     └──────┬──────┘
       │            │ category_id  │            │
       │            │ name         │     Polymorphic
       │ 1:N        │ code (UQ)    │     Relation
       │            │ description  │       (bookable)
┌──────┴──────┐     │ status       │            │
│  bookings   │     │ condition    │            │
├─────────────┤     │ image        │            │
│ id (PK)     │     │ quantity     │            │
│ user_id (FK)│     │ daily_rate   │            │
│ bookable_type│◄───│ timestamps   │────────────┘
│ bookable_id │     └──────────────┘
│ start_time  │
│ end_time    │     ┌──────────────┐
│ status      │     │  check_ins   │
│ notes       │     ├──────────────┤
│ admin_notes │     │ id (PK)      │
│ approved_by │     │ booking_id   │──── FK → bookings
│ timestamps  │     │ user_id      │──── FK → users
└──────┬──────┘     │ type         │
       │ 1:N        │ checked_at   │
       └────────────│ cond_notes   │
                    │ photo_evid   │
                    │ timestamps   │
                    └──────────────┘
```

### Tabel & Kolom Detail

#### `users`
| Kolom | Tipe | Constraint | Keterangan |
|-------|------|------------|------------|
| id | BIGINT | PK, AUTO | Primary key |
| name | VARCHAR(255) | NOT NULL | Nama lengkap |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Email login |
| password | VARCHAR(255) | NOT NULL | Bcrypt hash |
| role | ENUM('admin','member') | DEFAULT 'member' | Role pengguna |
| phone | VARCHAR(20) | NULLABLE | No. telepon |
| address | TEXT | NULLABLE | Alamat |

#### `equipment`
| Kolom | Tipe | Constraint | Keterangan |
|-------|------|------------|------------|
| id | BIGINT | PK, AUTO | Primary key |
| category_id | BIGINT | FK → categories | Relasi kategori |
| name | VARCHAR(255) | NOT NULL | Nama peralatan |
| code | VARCHAR(50) | UNIQUE | Kode inventaris |
| status | ENUM | DEFAULT 'available' | available/in_use/maintenance/retired |
| condition | ENUM | DEFAULT 'good' | excellent/good/fair/poor |
| quantity | INT | DEFAULT 1 | Jumlah unit |
| daily_rate | DECIMAL(12,2) | DEFAULT 0 | Tarif per hari |

#### `bookings` (Polymorphic)
| Kolom | Tipe | Constraint | Keterangan |
|-------|------|------------|------------|
| bookable_type | VARCHAR(255) | NOT NULL | `App\Models\Equipment` atau `App\Models\Room` |
| bookable_id | BIGINT | NOT NULL | ID dari equipment/room |
| status | ENUM | DEFAULT 'pending' | pending/approved/rejected/completed/cancelled |

---

## 🔐 Strategi Autentikasi

### Laravel Sanctum — Token-Based Authentication

```
┌──────────┐    POST /auth/login     ┌───────────┐
│  Client  │ ──────────────────────► │  Laravel  │
│ (Tablet) │    {email, password}    │   API     │
│          │ ◄────────────────────── │           │
│          │    {token: "3|abc..."}  │           │
└────┬─────┘                         └───────────┘
     │
     │  Subsequent Requests:
     │  Authorization: Bearer 3|abc...
     │
     ▼
┌──────────┐    GET /equipment       ┌───────────┐
│  Client  │ ──────────────────────► │  Laravel  │
│          │  Header: Bearer token   │   API     │
│          │ ◄────────────────────── │           │
│          │    {data: [...]}        │           │
└──────────┘                         └───────────┘
```

### Keunggulan Sanctum untuk Smart-Hub:

1. **Token Ringan** — Tidak perlu OAuth2 server terpisah, cocok untuk tablet app
2. **Stateless** — Setiap request membawa token, tidak bergantung session
3. **Revokable** — Admin bisa revoke token user kapan saja
4. **Per-Device Token** — Setiap device/login mendapat token unik
5. **Auto-Revoke on Logout** — Token lama otomatis dihapus saat login baru

### Alur Keamanan:
```
Register → Password di-hash (Bcrypt) → Token dibuat → Disimpan di personal_access_tokens
Login    → Verifikasi Hash → Token lama di-revoke → Token baru dibuat
Logout   → Current token dihapus dari database
Request  → Middleware auth:sanctum → Cek token di DB → Allow/Deny
```

---

## 📡 Dokumentasi API Endpoint

**Base URL**: `http://localhost:8000/api/v1`

### 🔓 Authentication

#### Register
```
POST /auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "phone": "081234567890",       // optional
  "address": "Jakarta"           // optional
}

Response 201:
{
  "success": true,
  "message": "Registration successful.",
  "data": {
    "user": { "id": 3, "name": "John Doe", "email": "john@example.com", "role": "member" },
    "token": "3|abc123...",
    "token_type": "Bearer"
  }
}
```

#### Login
```
POST /auth/login
Content-Type: application/json

{ "email": "admin@smarthub.com", "password": "password" }

Response 200:
{
  "success": true,
  "message": "Login successful.",
  "data": {
    "user": { "id": 1, "name": "Admin", "role": "admin" },
    "token": "1|xyz789...",
    "token_type": "Bearer"
  }
}

Response 401: { "success": false, "message": "Invalid credentials." }
```

#### Logout
```
POST /auth/logout
Authorization: Bearer {token}

Response 200: { "success": true, "message": "Logged out successfully." }
```

### 📦 Equipment CRUD

| Method | Endpoint | Auth | Role | Keterangan |
|--------|----------|------|------|------------|
| GET | `/equipment` | ✅ | All | List + search + pagination |
| GET | `/equipment/{id}` | ✅ | All | Detail equipment |
| POST | `/equipment` | ✅ | Admin | Create equipment |
| PUT | `/equipment/{id}` | ✅ | Admin | Update equipment |
| DELETE | `/equipment/{id}` | ✅ | Admin | Delete equipment |

#### GET /equipment (with query params)
```
GET /equipment?search=canon&status=available&per_page=10&page=1
Authorization: Bearer {token}

Response 200:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Canon EOS R5",
      "code": "CAM-001",
      "category": { "id": 1, "name": "Cameras" },
      "status": "available",
      "condition": "excellent",
      "quantity": 2,
      "daily_rate": "500000.00"
    }
  ],
  "meta": { "current_page": 1, "last_page": 1, "per_page": 10, "total": 1 }
}
```

### 🏠 Rooms CRUD

| Method | Endpoint | Auth | Role | Keterangan |
|--------|----------|------|------|------------|
| GET | `/rooms` | ✅ | All | List rooms |
| GET | `/rooms/{id}` | ✅ | All | Detail room |
| POST | `/rooms` | ✅ | Admin | Create room |
| PUT | `/rooms/{id}` | ✅ | Admin | Update room |
| DELETE | `/rooms/{id}` | ✅ | Admin | Delete room |

### 📅 Bookings

| Method | Endpoint | Auth | Role | Keterangan |
|--------|----------|------|------|------------|
| GET | `/bookings` | ✅ | All* | Admin: semua. Member: milik sendiri |
| POST | `/bookings` | ✅ | All | Create booking (status: pending) |
| GET | `/bookings/{id}` | ✅ | All* | Detail booking |
| PATCH | `/bookings/{id}/approve` | ✅ | Admin | Setujui booking |
| PATCH | `/bookings/{id}/reject` | ✅ | Admin | Tolak booking (wajib admin_notes) |
| PATCH | `/bookings/{id}/cancel` | ✅ | Owner/Admin | Batalkan booking |

### 📋 Check-Ins (Tablet API)

| Method | Endpoint | Auth | Role | Keterangan |
|--------|----------|------|------|------------|
| POST | `/check-ins` | ✅ | All | Record check-in/check-out |
| GET | `/bookings/{id}/check-ins` | ✅ | Owner/Admin | History check-in per booking |

```
POST /check-ins
Authorization: Bearer {token}

{ "booking_id": 1, "type": "check_in", "condition_notes": "Peralatan dalam kondisi baik" }

Response 201: { "success": true, "message": "Check-in recorded successfully." }
```

### 📊 Dashboard (Admin Only)

```
GET /dashboard/stats
Authorization: Bearer {admin_token}

Response 200:
{
  "success": true,
  "data": {
    "total_users": 6,
    "total_members": 5,
    "total_equipment": 10,
    "available_equipment": 8,
    "total_rooms": 5,
    "available_rooms": 4,
    "total_bookings": 3,
    "pending_bookings": 1,
    "active_bookings": 1,
    "total_checkins": 2,
    "recent_bookings": [...]
  }
}
```

---

## ⚙ Instalasi & Konfigurasi

### Prasyarat
- PHP >= 8.2
- Composer
- MySQL (XAMPP)
- Node.js (untuk frontend)

### Langkah Instalasi

```bash
# 1. Clone / masuk ke direktori
cd Smart-HubManagementSystem_BE

# 2. Install dependencies
composer install

# 3. Konfigurasi environment
cp .env.example .env
php artisan key:generate

# 4. Edit .env
# DB_DATABASE=smart_hub_db
# DB_USERNAME=root
# DB_PASSWORD=

# 5. Jalankan migrasi & seeder
php artisan migrate:fresh --seed

# 6. Jalankan server
php artisan serve --port=8000
```

### Akun Default (Seeder)

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@smarthub.com | password |
| Member | member@smarthub.com | password |

---

## 🧪 Pengujian API

### Menggunakan cURL

```bash
# Login
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@smarthub.com","password":"password"}'

# List Equipment (gunakan token dari login)
curl http://localhost:8000/api/v1/equipment \
  -H "Authorization: Bearer {TOKEN}"

# Create Booking
curl -X POST http://localhost:8000/api/v1/bookings \
  -H "Authorization: Bearer {TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"bookable_type":"equipment","bookable_id":1,"start_time":"2026-05-11T10:00","end_time":"2026-05-11T15:00","notes":"Foto produk"}'
```

### Response Format Standar

Semua response mengikuti format konsisten:

```json
{
  "success": true|false,
  "message": "Pesan deskriptif",
  "data": { ... },
  "meta": { "current_page": 1, "last_page": 3, "per_page": 15, "total": 45 }
}
```

### HTTP Status Codes

| Code | Keterangan | Contoh |
|------|------------|--------|
| 200 | Sukses | GET, PATCH berhasil |
| 201 | Created | POST berhasil |
| 401 | Unauthorized | Token tidak valid |
| 403 | Forbidden | Akses ditolak (bukan admin / bukan pemilik) |
| 422 | Validation Error | Input tidak valid |
| 404 | Not Found | Resource tidak ditemukan |

---

## 📄 Teknologi yang Digunakan

| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| Laravel | 11.x | Framework PHP |
| PHP | 8.2+ | Bahasa pemrograman |
| MySQL | 8.x | Database relasional |
| Laravel Sanctum | 4.x | Token authentication |
| Eloquent ORM | — | Object-Relational Mapping |

---

> **Dibuat untuk UTS Pemrograman Full Stack — Semester 6**
"# Smart-HubManagementSystem_BE" 
