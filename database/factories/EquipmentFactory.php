<?php

namespace Database\Factories;

use App\Models\Category;
use App\Models\Equipment;
use Illuminate\Database\Eloquent\Factories\Factory;

class EquipmentFactory extends Factory
{
    protected $model = Equipment::class;

    public function definition(): array
    {
        return [
            'category_id' => Category::factory(),
            'name' => fake()->words(3, true),
            'code' => strtoupper(fake()->unique()->bothify('EQ-####')),
            'description' => fake()->paragraph(),
            'status' => fake()->randomElement(['available', 'available', 'available', 'in_use', 'maintenance']),
            'condition' => fake()->randomElement(['excellent', 'good', 'good', 'fair']),
            'quantity' => fake()->numberBetween(1, 10),
            'daily_rate' => fake()->randomFloat(2, 25000, 500000),
        ];
    }
}
