<?php

namespace App\Http\Requests\Room;

use Illuminate\Foundation\Http\FormRequest;

class StoreRoomRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->isAdmin();
    }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50|unique:rooms,code',
            'description' => 'nullable|string',
            'capacity' => 'required|integer|min:1',
            'facilities' => 'nullable|array',
            'facilities.*' => 'string',
            'status' => 'nullable|in:available,occupied,maintenance',
            'image' => 'nullable|string',
            'hourly_rate' => 'nullable|numeric|min:0',
        ];
    }
}
