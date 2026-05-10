<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Equipment;
use App\Models\Room;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // ── Create Admin ──
        User::create([
            'name' => 'Admin Smart-Hub',
            'email' => 'admin@smarthub.com',
            'password' => Hash::make('password123'),
            'role' => 'admin',
            'phone' => '081234567890',
            'address' => 'Jl. Kreativitas No. 1, Jakarta',
        ]);

        // ── Create Members ──
        User::create([
            'name' => 'Budi Santoso',
            'email' => 'budi@member.com',
            'password' => Hash::make('password123'),
            'role' => 'member',
            'phone' => '081298765432',
            'address' => 'Jl. Anggota No. 10, Jakarta',
        ]);

        User::create([
            'name' => 'Siti Rahayu',
            'email' => 'siti@member.com',
            'password' => Hash::make('password123'),
            'role' => 'member',
            'phone' => '081377778888',
        ]);

        User::factory(3)->create([
            'role' => 'member',
            'password' => Hash::make('password123'),
        ]);

        // ── Create Categories ──
        $categories = [
            ['name' => 'Kamera & Fotografi', 'slug' => 'kamera-fotografi', 'description' => 'Peralatan kamera, lensa, dan aksesoris fotografi'],
            ['name' => 'Audio & Sound', 'slug' => 'audio-sound', 'description' => 'Microphone, speaker, mixer, dan peralatan audio'],
            ['name' => 'Lighting & Studio', 'slug' => 'lighting-studio', 'description' => 'Lampu studio, softbox, dan peralatan pencahayaan'],
            ['name' => 'Video & Film', 'slug' => 'video-film', 'description' => 'Peralatan videografi, stabilizer, dan editing'],
            ['name' => 'Komputer & Digital', 'slug' => 'komputer-digital', 'description' => 'Laptop, tablet, dan peralatan digital'],
        ];

        foreach ($categories as $cat) {
            Category::create($cat);
        }

        // ── Create Equipment ──
        $equipmentData = [
            ['category_id' => 1, 'name' => 'Canon EOS R5', 'code' => 'EQ-0001', 'status' => 'available', 'condition' => 'excellent', 'quantity' => 2, 'daily_rate' => 350000, 'description' => 'Kamera mirrorless full-frame 45MP'],
            ['category_id' => 1, 'name' => 'Sony A7 III', 'code' => 'EQ-0002', 'status' => 'available', 'condition' => 'good', 'quantity' => 3, 'daily_rate' => 250000, 'description' => 'Kamera mirrorless full-frame 24.2MP'],
            ['category_id' => 1, 'name' => 'Lensa Canon 50mm f/1.4', 'code' => 'EQ-0003', 'status' => 'in_use', 'condition' => 'good', 'quantity' => 4, 'daily_rate' => 75000, 'description' => 'Lensa prime 50mm aperture f/1.4'],
            ['category_id' => 2, 'name' => 'Rode NT1-A', 'code' => 'EQ-0004', 'status' => 'available', 'condition' => 'excellent', 'quantity' => 3, 'daily_rate' => 100000, 'description' => 'Microphone condenser studio-grade'],
            ['category_id' => 2, 'name' => 'Yamaha MG10XU Mixer', 'code' => 'EQ-0005', 'status' => 'available', 'condition' => 'good', 'quantity' => 2, 'daily_rate' => 150000, 'description' => 'Audio mixer 10-channel dengan USB'],
            ['category_id' => 3, 'name' => 'Godox SL-60W', 'code' => 'EQ-0006', 'status' => 'available', 'condition' => 'good', 'quantity' => 5, 'daily_rate' => 80000, 'description' => 'LED video light daylight-balanced'],
            ['category_id' => 3, 'name' => 'Softbox Kit 60x90', 'code' => 'EQ-0007', 'status' => 'maintenance', 'condition' => 'fair', 'quantity' => 3, 'daily_rate' => 50000, 'description' => 'Softbox dengan stand dan bracket'],
            ['category_id' => 4, 'name' => 'DJI Ronin-S', 'code' => 'EQ-0008', 'status' => 'available', 'condition' => 'excellent', 'quantity' => 2, 'daily_rate' => 200000, 'description' => 'Gimbal stabilizer 3-axis untuk kamera'],
            ['category_id' => 4, 'name' => 'GoPro Hero 12', 'code' => 'EQ-0009', 'status' => 'available', 'condition' => 'good', 'quantity' => 4, 'daily_rate' => 120000, 'description' => 'Action camera 5.3K waterproof'],
            ['category_id' => 5, 'name' => 'MacBook Pro M3', 'code' => 'EQ-0010', 'status' => 'in_use', 'condition' => 'excellent', 'quantity' => 3, 'daily_rate' => 400000, 'description' => 'Laptop editing 14-inch M3 Pro chip'],
            ['category_id' => 5, 'name' => 'iPad Pro 12.9"', 'code' => 'EQ-0011', 'status' => 'available', 'condition' => 'good', 'quantity' => 5, 'daily_rate' => 200000, 'description' => 'Tablet dengan Apple Pencil untuk desain'],
            ['category_id' => 5, 'name' => 'Wacom Intuos Pro', 'code' => 'EQ-0012', 'status' => 'available', 'condition' => 'good', 'quantity' => 4, 'daily_rate' => 100000, 'description' => 'Drawing tablet untuk ilustrasi digital'],
        ];

        foreach ($equipmentData as $eq) {
            Equipment::create($eq);
        }

        // ── Create Rooms ──
        $roomsData = [
            ['name' => 'Studio Foto A', 'code' => 'RM-0001', 'capacity' => 6, 'facilities' => ['Backdrop', 'Lighting Kit', 'AC', 'WiFi'], 'status' => 'available', 'hourly_rate' => 150000, 'description' => 'Studio foto profesional dengan backdrop dan lighting lengkap'],
            ['name' => 'Studio Foto B', 'code' => 'RM-0002', 'capacity' => 4, 'facilities' => ['Backdrop', 'Basic Light', 'AC'], 'status' => 'available', 'hourly_rate' => 100000, 'description' => 'Studio foto ukuran medium untuk portrait dan produk'],
            ['name' => 'Ruang Editing', 'code' => 'RM-0003', 'capacity' => 8, 'facilities' => ['iMac', 'Monitor 4K', 'WiFi', 'AC', 'Headphone'], 'status' => 'available', 'hourly_rate' => 200000, 'description' => 'Ruang editing video dan foto dengan peralatan Apple'],
            ['name' => 'Meeting Room', 'code' => 'RM-0004', 'capacity' => 12, 'facilities' => ['Projector', 'Whiteboard', 'WiFi', 'AC', 'Sound System'], 'status' => 'occupied', 'hourly_rate' => 120000, 'description' => 'Ruang meeting kapasitas 12 orang dengan proyektor'],
            ['name' => 'Podcast Room', 'code' => 'RM-0005', 'capacity' => 4, 'facilities' => ['Soundproof', 'Mic Setup', 'Mixer', 'AC', 'Webcam'], 'status' => 'available', 'hourly_rate' => 180000, 'description' => 'Ruang podcast kedap suara dengan peralatan audio'],
            ['name' => 'Co-Working Space', 'code' => 'RM-0006', 'capacity' => 20, 'facilities' => ['WiFi', 'Power Outlet', 'AC', 'Coffee Machine', 'Printer'], 'status' => 'available', 'hourly_rate' => 50000, 'description' => 'Area kerja bersama dengan fasilitas lengkap'],
            ['name' => 'Green Screen Studio', 'code' => 'RM-0007', 'capacity' => 6, 'facilities' => ['Green Screen', 'Lighting Kit', 'AC', 'WiFi', 'Monitor'], 'status' => 'maintenance', 'hourly_rate' => 250000, 'description' => 'Studio green screen untuk produksi video'],
            ['name' => 'Music Studio', 'code' => 'RM-0008', 'capacity' => 5, 'facilities' => ['Soundproof', 'Instrument', 'Mixer', 'AC', 'Recording Setup'], 'status' => 'available', 'hourly_rate' => 300000, 'description' => 'Studio musik kedap suara dengan peralatan recording'],
        ];

        foreach ($roomsData as $room) {
            Room::create($room);
        }
    }
}
