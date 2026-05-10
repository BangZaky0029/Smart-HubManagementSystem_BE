<?php

namespace Database\Factories;

use App\Models\Room;
use Illuminate\Database\Eloquent\Factories\Factory;

class RoomFactory extends Factory
{
    protected $model = Room::class;

    public function definition(): array
    {
        return [
            'name' => 'Room ' . fake()->unique()->numberBetween(101, 999),
            'code' => strtoupper(fake()->unique()->bothify('RM-####')),
            'description' => fake()->paragraph(),
            'capacity' => fake()->randomElement([4, 6, 8, 10, 15, 20]),
            'facilities' => fake()->randomElements([
                'WiFi', 'Projector', 'Whiteboard', 'AC', 'Sound System',
                'Monitor', 'Webcam', 'Printer', 'Coffee Machine',
            ], fake()->numberBetween(3, 6)),
            'status' => fake()->randomElement(['available', 'available', 'occupied', 'maintenance']),
            'hourly_rate' => fake()->randomFloat(2, 50000, 300000),
        ];
    }
}
