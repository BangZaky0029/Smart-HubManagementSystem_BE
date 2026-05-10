<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\CheckIn\StoreCheckInRequest;
use App\Http\Resources\CheckInResource;
use App\Models\Booking;
use App\Models\CheckIn;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CheckInController extends Controller
{
    /**
     * Store a new check-in/check-out record.
     * Used by tablet app for real-time status updates.
     */
    public function store(StoreCheckInRequest $request): JsonResponse
    {
        $booking = Booking::findOrFail($request->booking_id);

        // Verify user is the booking owner or admin
        if (!$request->user()->isAdmin() && $booking->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. You can only check-in your own bookings.',
            ], 403);
        }

        // Verify booking is approved
        if ($booking->status !== 'approved') {
            return response()->json([
                'success' => false,
                'message' => 'Only approved bookings can be checked-in.',
            ], 422);
        }

        $checkIn = CheckIn::create([
            'booking_id' => $request->booking_id,
            'user_id' => $request->user()->id,
            'type' => $request->type,
            'checked_at' => now(),
            'condition_notes' => $request->condition_notes,
            'photo_evidence' => $request->photo_evidence,
        ]);

        // Update booking status based on check-in type
        if ($request->type === 'check_out') {
            $booking->update(['status' => 'completed']);
        }

        $checkIn->load('user');

        return response()->json([
            'success' => true,
            'message' => $request->type === 'check_in'
                ? 'Check-in recorded successfully.'
                : 'Check-out recorded. Booking completed.',
            'data' => new CheckInResource($checkIn),
        ], 201);
    }

    /**
     * Get check-in history for a booking.
     */
    public function index(Request $request, Booking $booking): JsonResponse
    {
        // Verify access
        if (!$request->user()->isAdmin() && $booking->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized.',
            ], 403);
        }

        $checkIns = $booking->checkIns()->with('user')->latest()->get();

        return response()->json([
            'success' => true,
            'data' => CheckInResource::collection($checkIns),
        ]);
    }
}
