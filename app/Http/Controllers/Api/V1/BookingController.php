<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Booking\StoreBookingRequest;
use App\Http\Resources\BookingResource;
use App\Models\Booking;
use App\Models\Equipment;
use App\Models\Room;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    /**
     * Display a listing of bookings.
     * Admin: all bookings. Member: own bookings only.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Booking::with(['user', 'bookable', 'approver']);

        // Member can only see their own bookings
        if (!$request->user()->isAdmin()) {
            $query->where('user_id', $request->user()->id);
        }

        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        $bookings = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => BookingResource::collection($bookings),
            'meta' => [
                'current_page' => $bookings->currentPage(),
                'last_page' => $bookings->lastPage(),
                'per_page' => $bookings->perPage(),
                'total' => $bookings->total(),
            ],
        ]);
    }

    /**
     * Store a newly created booking.
     */
    public function store(StoreBookingRequest $request): JsonResponse
    {
        // Resolve polymorphic type
        $bookableClass = $request->bookable_type === 'equipment'
            ? Equipment::class
            : Room::class;

        // Verify bookable exists
        $bookable = $bookableClass::findOrFail($request->bookable_id);

        $booking = Booking::create([
            'user_id' => $request->user()->id,
            'bookable_type' => $bookableClass,
            'bookable_id' => $request->bookable_id,
            'start_time' => $request->start_time,
            'end_time' => $request->end_time,
            'notes' => $request->notes,
            'status' => 'pending',
        ]);

        $booking->load(['user', 'bookable']);

        return response()->json([
            'success' => true,
            'message' => 'Booking created successfully. Waiting for admin approval.',
            'data' => new BookingResource($booking),
        ], 201);
    }

    /**
     * Display the specified booking.
     */
    public function show(Request $request, Booking $booking): JsonResponse
    {
        // Member can only see their own bookings
        if (!$request->user()->isAdmin() && $booking->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized.',
            ], 403);
        }

        $booking->load(['user', 'bookable', 'approver', 'checkIns.user']);

        return response()->json([
            'success' => true,
            'data' => new BookingResource($booking),
        ]);
    }

    /**
     * Approve a booking (Admin only).
     */
    public function approve(Request $request, Booking $booking): JsonResponse
    {
        if ($booking->status !== 'pending') {
            return response()->json([
                'success' => false,
                'message' => 'Only pending bookings can be approved.',
            ], 422);
        }

        $booking->update([
            'status' => 'approved',
            'approved_by' => $request->user()->id,
            'admin_notes' => $request->admin_notes,
        ]);

        $booking->load(['user', 'bookable', 'approver']);

        return response()->json([
            'success' => true,
            'message' => 'Booking approved successfully.',
            'data' => new BookingResource($booking),
        ]);
    }

    /**
     * Reject a booking (Admin only).
     */
    public function reject(Request $request, Booking $booking): JsonResponse
    {
        if ($booking->status !== 'pending') {
            return response()->json([
                'success' => false,
                'message' => 'Only pending bookings can be rejected.',
            ], 422);
        }

        $request->validate([
            'admin_notes' => 'required|string|max:1000',
        ]);

        $booking->update([
            'status' => 'rejected',
            'approved_by' => $request->user()->id,
            'admin_notes' => $request->admin_notes,
        ]);

        $booking->load(['user', 'bookable', 'approver']);

        return response()->json([
            'success' => true,
            'message' => 'Booking rejected.',
            'data' => new BookingResource($booking),
        ]);
    }

    /**
     * Cancel a booking (Owner or Admin).
     */
    public function cancel(Request $request, Booking $booking): JsonResponse
    {
        if (!$request->user()->isAdmin() && $booking->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized.',
            ], 403);
        }

        if (in_array($booking->status, ['completed', 'cancelled'])) {
            return response()->json([
                'success' => false,
                'message' => 'This booking cannot be cancelled.',
            ], 422);
        }

        $booking->update(['status' => 'cancelled']);

        return response()->json([
            'success' => true,
            'message' => 'Booking cancelled successfully.',
            'data' => new BookingResource($booking),
        ]);
    }
}
