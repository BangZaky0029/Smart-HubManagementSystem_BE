<?php

namespace Tests\Feature;

use App\Models\Booking;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CheckInTest extends TestCase
{
    use RefreshDatabase;

    public function test_owner_can_check_in_an_approved_booking(): void
    {
        $user = User::factory()->create(['role' => 'member']);
        $booking = Booking::factory()->approved()->create(['user_id' => $user->id]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/check-ins', [
            'booking_id' => $booking->id,
            'type' => 'check_in',
            'condition_notes' => 'Kondisi baik',
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('check_ins', [
            'booking_id' => $booking->id,
            'user_id' => $user->id,
            'type' => 'check_in',
        ]);
    }

    public function test_check_in_rejected_when_booking_is_not_approved_yet(): void
    {
        $user = User::factory()->create(['role' => 'member']);
        $booking = Booking::factory()->create([
            'user_id' => $user->id,
            'status' => 'pending', // belum di-approve admin
        ]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/check-ins', [
            'booking_id' => $booking->id,
            'type' => 'check_in',
        ]);

        $response->assertStatus(422);
        $response->assertJsonFragment(['message' => 'Only approved bookings can be checked-in.']);
    }

    public function test_user_cannot_check_in_another_users_booking(): void
    {
        $owner = User::factory()->create(['role' => 'member']);
        $otherUser = User::factory()->create(['role' => 'member']);
        $booking = Booking::factory()->approved()->create(['user_id' => $owner->id]);

        $response = $this->actingAs($otherUser, 'sanctum')->postJson('/api/v1/check-ins', [
            'booking_id' => $booking->id,
            'type' => 'check_in',
        ]);

        $response->assertStatus(403);
    }

    public function test_admin_can_check_in_any_users_booking(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $member = User::factory()->create(['role' => 'member']);
        $booking = Booking::factory()->approved()->create(['user_id' => $member->id]);

        $response = $this->actingAs($admin, 'sanctum')->postJson('/api/v1/check-ins', [
            'booking_id' => $booking->id,
            'type' => 'check_in',
        ]);

        $response->assertStatus(201);
    }

    public function test_check_out_marks_booking_as_completed(): void
    {
        $user = User::factory()->create(['role' => 'member']);
        $booking = Booking::factory()->approved()->create(['user_id' => $user->id]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/check-ins', [
            'booking_id' => $booking->id,
            'type' => 'check_out',
            'condition_notes' => 'Selesai dipakai',
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('bookings', [
            'id' => $booking->id,
            'status' => 'completed',
        ]);
    }

    public function test_check_in_requires_valid_type(): void
    {
        $user = User::factory()->create(['role' => 'member']);
        $booking = Booking::factory()->approved()->create(['user_id' => $user->id]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/check-ins', [
            'booking_id' => $booking->id,
            'type' => 'invalid_type',
        ]);

        $response->assertStatus(422);
    }
}
