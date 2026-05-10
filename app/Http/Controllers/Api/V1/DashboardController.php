<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\CheckIn;
use App\Models\Equipment;
use App\Models\Room;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class DashboardController extends Controller
{
    /**
     * Get dashboard statistics for admin.
     */
    public function stats(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => [
                'total_users' => User::count(),
                'total_members' => User::where('role', 'member')->count(),
                'total_equipment' => Equipment::count(),
                'available_equipment' => Equipment::where('status', 'available')->count(),
                'total_rooms' => Room::count(),
                'available_rooms' => Room::where('status', 'available')->count(),
                'total_bookings' => Booking::count(),
                'pending_bookings' => Booking::where('status', 'pending')->count(),
                'active_bookings' => Booking::where('status', 'approved')->count(),
                'total_checkins' => CheckIn::count(),
                'recent_bookings' => Booking::with(['user', 'bookable'])
                    ->latest()
                    ->take(5)
                    ->get()
                    ->map(function ($booking) {
                        return [
                            'id' => $booking->id,
                            'user_name' => $booking->user->name,
                            'bookable_type' => class_basename($booking->bookable_type),
                            'bookable_name' => $booking->bookable->name ?? 'N/A',
                            'status' => $booking->status,
                            'start_time' => $booking->start_time->toIso8601String(),
                            'created_at' => $booking->created_at->toIso8601String(),
                        ];
                    }),
            ],
        ]);
    }
}
