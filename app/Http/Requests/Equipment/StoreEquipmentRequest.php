<?php

namespace App\Http\Requests\Equipment;

use Illuminate\Foundation\Http\FormRequest;

class StoreEquipmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->isAdmin();
    }

    public function rules(): array
    {
        return [
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50|unique:equipment,code',
            'description' => 'nullable|string',
            'status' => 'nullable|in:available,in_use,maintenance,retired',
            'condition' => 'nullable|in:excellent,good,fair,poor',
            'image' => 'nullable|string',
            'quantity' => 'nullable|integer|min:1',
            'daily_rate' => 'nullable|numeric|min:0',
        ];
    }
}
