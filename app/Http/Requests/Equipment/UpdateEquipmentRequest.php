<?php

namespace App\Http\Requests\Equipment;

use Illuminate\Foundation\Http\FormRequest;

class UpdateEquipmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->isAdmin();
    }

    public function rules(): array
    {
        return [
            'category_id' => 'sometimes|exists:categories,id',
            'name' => 'sometimes|string|max:255',
            'code' => 'sometimes|string|max:50|unique:equipment,code,' . $this->route('equipment'),
            'description' => 'nullable|string',
            'status' => 'sometimes|in:available,in_use,maintenance,retired',
            'condition' => 'sometimes|in:excellent,good,fair,poor',
            'image' => 'nullable|string',
            'quantity' => 'sometimes|integer|min:1',
            'daily_rate' => 'sometimes|numeric|min:0',
        ];
    }
}
