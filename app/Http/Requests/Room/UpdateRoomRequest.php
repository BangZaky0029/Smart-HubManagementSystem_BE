<?php

namespace App\Http\Requests\Room;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRoomRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->isAdmin();
    }

    public function rules(): array
    {
        return [
            'name' => 'sometimes|string|max:255',
            'code' => 'sometimes|string|max:50|unique:rooms,code,' . $this->route('room'),
            'description' => 'nullable|string',
            'capacity' => 'sometimes|integer|min:1',
            'facilities' => 'nullable|array',
            'facilities.*' => 'string',
            'status' => 'sometimes|in:available,occupied,maintenance',
            'image' => 'nullable|string',
            'hourly_rate' => 'sometimes|numeric|min:0',
        ];
    }
}
