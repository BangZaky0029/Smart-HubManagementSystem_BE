<?php

namespace App\Http\Requests\CheckIn;

use Illuminate\Foundation\Http\FormRequest;

class StoreCheckInRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'booking_id' => 'required|exists:bookings,id',
            'type' => 'required|in:check_in,check_out',
            'condition_notes' => 'nullable|string|max:1000',
            'photo_evidence' => 'nullable|string',
        ];
    }
}
