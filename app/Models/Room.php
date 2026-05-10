<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphMany;

class Room extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'code',
        'description',
        'capacity',
        'facilities',
        'status',
        'image',
        'hourly_rate',
    ];

    protected function casts(): array
    {
        return [
            'facilities' => 'array',
            'hourly_rate' => 'decimal:2',
            'capacity' => 'integer',
        ];
    }

    /**
     * Get bookings for this room (polymorphic).
     */
    public function bookings(): MorphMany
    {
        return $this->morphMany(Booking::class, 'bookable');
    }

    /**
     * Scope: only available rooms.
     */
    public function scopeAvailable($query)
    {
        return $query->where('status', 'available');
    }
}
