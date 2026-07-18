-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 16 Bulan Mei 2026 pada 06.11
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_hub_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `bookable_type` varchar(255) NOT NULL,
  `bookable_id` bigint(20) UNSIGNED NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `status` enum('pending','approved','rejected','completed','cancelled') NOT NULL DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `admin_notes` text DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `bookings`
--

INSERT INTO `bookings` (`id`, `user_id`, `bookable_type`, `bookable_id`, `start_time`, `end_time`, `status`, `notes`, `admin_notes`, `approved_by`, `created_at`, `updated_at`) VALUES
(1, 2, 'App\\Models\\Room', 6, '2026-05-10 13:38:00', '2026-05-10 15:38:00', 'completed', 'Halloo', NULL, 1, '2026-05-10 05:39:14', '2026-05-10 05:41:32'),
(2, 7, 'App\\Models\\Equipment', 5, '2026-05-10 13:42:00', '2026-05-10 15:42:00', 'cancelled', 'MANTAP', NULL, NULL, '2026-05-10 05:42:32', '2026-05-10 05:43:30'),
(3, 7, 'App\\Models\\Room', 2, '2026-05-10 13:42:00', '2026-05-10 15:42:00', 'approved', 'BUAT FOTO SAMA TEMAN', NULL, 1, '2026-05-10 05:42:46', '2026-05-10 05:43:26'),
(4, 2, 'App\\Models\\Equipment', 1, '2026-05-10 13:43:00', '2026-05-10 15:43:00', 'pending', 'assas', NULL, NULL, '2026-05-10 05:43:59', '2026-05-10 05:43:59'),
(5, 2, 'App\\Models\\Equipment', 11, '2026-05-10 13:44:00', '2026-05-10 15:44:00', 'rejected', 'GILA', 'Lagi Kosong', 1, '2026-05-10 05:44:11', '2026-05-10 05:44:44');

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Kamera & Fotografi', 'kamera-fotografi', 'Peralatan kamera, lensa, dan aksesoris fotografi', '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(2, 'Audio & Sound', 'audio-sound', 'Microphone, speaker, mixer, dan peralatan audio', '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(3, 'Lighting & Studio', 'lighting-studio', 'Lampu studio, softbox, dan peralatan pencahayaan', '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(4, 'Video & Film', 'video-film', 'Peralatan videografi, stabilizer, dan editing', '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(5, 'Komputer & Electronic', 'komputer-digital', 'Laptop, tablet, dan peralatan digital', '2026-05-10 05:01:24', '2026-05-10 05:30:14');

-- --------------------------------------------------------

--
-- Struktur dari tabel `check_ins`
--

CREATE TABLE `check_ins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('check_in','check_out') NOT NULL,
  `checked_at` datetime NOT NULL,
  `condition_notes` text DEFAULT NULL,
  `photo_evidence` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `check_ins`
--

INSERT INTO `check_ins` (`id`, `booking_id`, `user_id`, `type`, `checked_at`, `condition_notes`, `photo_evidence`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'check_in', '2026-05-10 12:41:14', 'sudah', NULL, '2026-05-10 05:41:14', '2026-05-10 05:41:14'),
(2, 1, 2, 'check_out', '2026-05-10 12:41:32', 'sudah logout', NULL, '2026-05-10 05:41:32', '2026-05-10 05:41:32'),
(3, 3, 1, 'check_in', '2026-05-10 12:46:34', 'as', NULL, '2026-05-10 05:46:34', '2026-05-10 05:46:34');

-- --------------------------------------------------------

--
-- Struktur dari tabel `equipment`
--

CREATE TABLE `equipment` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('available','in_use','maintenance','retired') NOT NULL DEFAULT 'available',
  `condition` enum('excellent','good','fair','poor') NOT NULL DEFAULT 'good',
  `image` varchar(255) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `daily_rate` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `equipment`
--

INSERT INTO `equipment` (`id`, `category_id`, `name`, `code`, `description`, `status`, `condition`, `image`, `quantity`, `daily_rate`, `created_at`, `updated_at`) VALUES
(1, 1, 'Canon EOS R5', 'EQ-0001', 'Kamera mirrorless full-frame 45MP', 'available', 'excellent', NULL, 2, 350000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(2, 1, 'Sony A7 III', 'EQ-0002', 'Kamera mirrorless full-frame 24.2MP', 'available', 'good', NULL, 3, 250000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(3, 1, 'Lensa Canon 50mm f/1.4', 'EQ-0003', 'Lensa prime 50mm aperture f/1.4', 'in_use', 'good', NULL, 4, 75000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(4, 2, 'Rode NT1-A', 'EQ-0004', 'Microphone condenser studio-grade', 'available', 'excellent', NULL, 3, 100000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(5, 2, 'Yamaha MG10XU Mixer', 'EQ-0005', 'Audio mixer 10-channel dengan USB', 'available', 'good', NULL, 2, 150000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(6, 3, 'Godox SL-60W', 'EQ-0006', 'LED video light daylight-balanced', 'available', 'good', NULL, 5, 80000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(7, 3, 'Softbox Kit 60x90', 'EQ-0007', 'Softbox dengan stand dan bracket', 'maintenance', 'fair', NULL, 3, 50000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(8, 4, 'DJI Ronin-S', 'EQ-0008', 'Gimbal stabilizer 3-axis untuk kamera', 'available', 'excellent', NULL, 2, 200000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(9, 4, 'GoPro Hero 12', 'EQ-0009', 'Action camera 5.3K waterproof', 'available', 'good', NULL, 4, 120000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(10, 5, 'MacBook Pro M3', 'EQ-0010', 'Laptop editing 14-inch M3 Pro chip', 'in_use', 'excellent', NULL, 3, 400000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(11, 5, 'iPad Pro 12.9\"', 'EQ-0011', 'Tablet dengan Apple Pencil untuk desain', 'available', 'good', NULL, 5, 200000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(12, 5, 'Wacom Intuos Pro', 'EQ-0012', 'Drawing tablet untuk ilustrasi digital', 'available', 'good', NULL, 4, 100000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24');

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2024_01_01_000001_create_categories_table', 1),
(5, '2024_01_01_000002_create_equipment_table', 1),
(6, '2024_01_01_000003_create_rooms_table', 1),
(7, '2024_01_01_000004_create_bookings_table', 1),
(8, '2024_01_01_000005_create_check_ins_table', 1),
(9, '2026_05_10_114958_create_personal_access_tokens_table', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(10, 'App\\Models\\User', 1, 'auth-token', '86fdfcebda0a911ab725ad4ef871eaf7ab49002ce3637d9f10b4ea95bfe8d877', '[\"*\"]', '2026-05-16 03:01:18', NULL, '2026-05-16 00:15:03', '2026-05-16 03:01:18');

-- --------------------------------------------------------

--
-- Struktur dari tabel `rooms`
--

CREATE TABLE `rooms` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `capacity` int(11) NOT NULL DEFAULT 1,
  `facilities` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`facilities`)),
  `status` enum('available','occupied','maintenance') NOT NULL DEFAULT 'available',
  `image` varchar(255) DEFAULT NULL,
  `hourly_rate` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `code`, `description`, `capacity`, `facilities`, `status`, `image`, `hourly_rate`, `created_at`, `updated_at`) VALUES
(1, 'Studio Foto A', 'RM-0001', 'Studio foto profesional dengan backdrop dan lighting lengkap', 6, '[\"Backdrop\",\"Lighting Kit\",\"AC\",\"WiFi\"]', 'available', NULL, 150000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(2, 'Studio Foto B', 'RM-0002', 'Studio foto ukuran medium untuk portrait dan produk', 4, '[\"Backdrop\",\"Basic Light\",\"AC\"]', 'available', NULL, 100000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(3, 'Ruang Editing', 'RM-0003', 'Ruang editing video dan foto dengan peralatan Apple', 8, '[\"iMac\",\"Monitor 4K\",\"WiFi\",\"AC\",\"Headphone\"]', 'available', NULL, 200000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(4, 'Meeting Room', 'RM-0004', 'Ruang meeting kapasitas 12 orang dengan proyektor', 12, '[\"Projector\",\"Whiteboard\",\"WiFi\",\"AC\",\"Sound System\"]', 'occupied', NULL, 120000.00, '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(5, 'Podcast Room', 'RM-0005', 'Ruang podcast kedap suara dengan peralatan audio', 4, '[\"Soundproof\",\"Mic Setup\",\"Mixer\",\"AC\",\"Webcam\"]', 'available', NULL, 180000.00, '2026-05-10 05:01:25', '2026-05-10 05:01:25'),
(6, 'Co-Working Space', 'RM-0006', 'Area kerja bersama dengan fasilitas lengkap', 20, '[\"WiFi\",\"Power Outlet\",\"AC\",\"Coffee Machine\",\"Printer\"]', 'available', NULL, 50000.00, '2026-05-10 05:01:25', '2026-05-10 05:01:25'),
(7, 'Green Screen Studio', 'RM-0007', 'Studio green screen untuk produksi video', 6, '[\"Green Screen\",\"Lighting Kit\",\"AC\",\"WiFi\",\"Monitor\"]', 'maintenance', NULL, 250000.00, '2026-05-10 05:01:25', '2026-05-10 05:01:25'),
(8, 'Music Studio', 'RM-0008', 'Studio musik kedap suara dengan peralatan recording', 5, '[\"Soundproof\",\"Instrument\",\"Mixer\",\"AC\",\"Recording Setup\"]', 'available', NULL, 300000.00, '2026-05-10 05:01:25', '2026-05-10 05:01:25');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('yfc6KMCdgoXTkBLszQiGGI2Yo4e7zPRHSyZauYM7', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaW43Q2Q3NEhMUlJVc0VSSjU5bUI0N3NmSlBxb2s2cUoyWGlYTU5TSSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1778389410);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','member') NOT NULL DEFAULT 'member',
  `phone` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `phone`, `address`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin Smart-Hub', 'admin@smarthub.com', NULL, '$2y$12$D.YlN2WFZCZ0IG7daqNzbuDYvpZCQDcOjau3Kfz.jLFfdmYnDjVBW', 'admin', '081234567890', 'Jl. Kreativitas No. 1, Jakarta', NULL, '2026-05-10 05:01:18', '2026-05-10 05:01:18'),
(2, 'Budi Santoso', 'budi@member.com', NULL, '$2y$12$cgCahPYlxGBj1CVSvRyyRuHrqRH3VR4OhsagHPpBxjE24lfIAhkkC', 'member', '081298765432', 'Jl. Anggota No. 10, Jakarta', NULL, '2026-05-10 05:01:19', '2026-05-10 05:01:19'),
(3, 'Siti Rahayu', 'siti@member.com', NULL, '$2y$12$M1xJaVrLatelYJU71myd8OjVq8Uwyh0J8bUpSU8QxUzVsmIcenK5W', 'member', '081377778888', NULL, NULL, '2026-05-10 05:01:20', '2026-05-10 05:01:20'),
(4, 'Mursinin Luis Simanjuntak', 'permadi.dimaz@example.com', '2026-05-10 05:01:24', '$2y$12$XiB2KVqa.Qhj4E22HHeRxe/LxF0VBSo4IXT.SVyyLc6TvoPJ1mUJm', 'member', NULL, NULL, 'oJX8o8GuEo', '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(5, 'Almira Lidya Purnawati S.Gz', 'xharyanti@example.org', '2026-05-10 05:01:24', '$2y$12$XiB2KVqa.Qhj4E22HHeRxe/LxF0VBSo4IXT.SVyyLc6TvoPJ1mUJm', 'member', NULL, NULL, '1rjN21Fpcq', '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(6, 'Yessi Vera Wahyuni S.Psi', 'oman.habibi@example.org', '2026-05-10 05:01:24', '$2y$12$XiB2KVqa.Qhj4E22HHeRxe/LxF0VBSo4IXT.SVyyLc6TvoPJ1mUJm', 'member', NULL, NULL, 'EEqji7GOUH', '2026-05-10 05:01:24', '2026-05-10 05:01:24'),
(7, 'ZAKY AULIA QOLBI 411231026', '411231026@mahasiswa.undira.ac.id', NULL, '$2y$12$eQq1ZJIayKabjciX6GaGK.P3zeBAaVSXL1hioXD62bX5w63VCHi2C', 'member', '0881025300997', NULL, NULL, '2026-05-10 05:42:10', '2026-05-10 05:42:10');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookings_user_id_foreign` (`user_id`),
  ADD KEY `bookings_bookable_type_bookable_id_index` (`bookable_type`,`bookable_id`),
  ADD KEY `bookings_approved_by_foreign` (`approved_by`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

--
-- Indeks untuk tabel `check_ins`
--
ALTER TABLE `check_ins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `check_ins_booking_id_foreign` (`booking_id`),
  ADD KEY `check_ins_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `equipment`
--
ALTER TABLE `equipment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `equipment_code_unique` (`code`),
  ADD KEY `equipment_category_id_foreign` (`category_id`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indeks untuk tabel `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rooms_code_unique` (`code`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `check_ins`
--
ALTER TABLE `check_ins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `equipment`
--
ALTER TABLE `equipment`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `bookings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `check_ins`
--
ALTER TABLE `check_ins`
  ADD CONSTRAINT `check_ins_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `check_ins_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `equipment`
--
ALTER TABLE `equipment`
  ADD CONSTRAINT `equipment_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
