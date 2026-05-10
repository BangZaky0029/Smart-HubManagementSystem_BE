<?php

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\BookingController;
use App\Http\Controllers\Api\V1\CategoryController;
use App\Http\Controllers\Api\V1\CheckInController;
use App\Http\Controllers\Api\V1\DashboardController;
use App\Http\Controllers\Api\V1\EquipmentController;
use App\Http\Controllers\Api\V1\RoomController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes - Smart-Hub Management System
|--------------------------------------------------------------------------
| All routes are prefixed with /api/v1
*/

Route::prefix('v1')->group(function () {

    // ══════════════════════════════════════════
    // PUBLIC ROUTES (No Authentication)
    // ══════════════════════════════════════════
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);

    // ══════════════════════════════════════════
    // PROTECTED ROUTES (Requires Bearer Token)
    // ══════════════════════════════════════════
    Route::middleware('auth:sanctum')->group(function () {

        // --- Auth ---
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::get('/auth/profile', [AuthController::class, 'profile']);

        // --- Dashboard (Admin only) ---
        Route::get('/dashboard/stats', [DashboardController::class, 'stats'])->middleware('admin');

        // --- Categories ---
        Route::get('/categories', [CategoryController::class, 'index']);
        Route::get('/categories/{category}', [CategoryController::class, 'show']);
        Route::middleware('admin')->group(function () {
            Route::post('/categories', [CategoryController::class, 'store']);
            Route::put('/categories/{category}', [CategoryController::class, 'update']);
            Route::delete('/categories/{category}', [CategoryController::class, 'destroy']);
        });

        // --- Equipment ---
        Route::get('/equipment', [EquipmentController::class, 'index']);
        Route::get('/equipment/{equipment}', [EquipmentController::class, 'show']);
        Route::middleware('admin')->group(function () {
            Route::post('/equipment', [EquipmentController::class, 'store']);
            Route::put('/equipment/{equipment}', [EquipmentController::class, 'update']);
            Route::delete('/equipment/{equipment}', [EquipmentController::class, 'destroy']);
        });

        // --- Rooms ---
        Route::get('/rooms', [RoomController::class, 'index']);
        Route::get('/rooms/{room}', [RoomController::class, 'show']);
        Route::middleware('admin')->group(function () {
            Route::post('/rooms', [RoomController::class, 'store']);
            Route::put('/rooms/{room}', [RoomController::class, 'update']);
            Route::delete('/rooms/{room}', [RoomController::class, 'destroy']);
        });

        // --- Bookings ---
        Route::get('/bookings', [BookingController::class, 'index']);
        Route::post('/bookings', [BookingController::class, 'store']);
        Route::get('/bookings/{booking}', [BookingController::class, 'show']);
        Route::patch('/bookings/{booking}/cancel', [BookingController::class, 'cancel']);
        Route::middleware('admin')->group(function () {
            Route::patch('/bookings/{booking}/approve', [BookingController::class, 'approve']);
            Route::patch('/bookings/{booking}/reject', [BookingController::class, 'reject']);
        });

        // --- Check-Ins (Tablet API) ---
        Route::post('/check-ins', [CheckInController::class, 'store']);
        Route::get('/bookings/{booking}/check-ins', [CheckInController::class, 'index']);
    });
});
