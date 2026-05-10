<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphMany;

class Equipment extends Model
{
    use HasFactory;

    protected $table = 'equipment';

    protected $fillable = [
        'category_id',
        'name',
        'code',
        'description',
        'status',
        'condition',
        'image',
        'quantity',
        'daily_rate',
    ];

    protected function casts(): array
    {
        return [
            'daily_rate' => 'decimal:2',
            'quantity' => 'integer',
        ];
    }

    /**
     * Get the category of this equipment.
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * Get bookings for this equipment (polymorphic).
     */
    public function bookings(): MorphMany
    {
        return $this->morphMany(Booking::class, 'bookable');
    }

    /**
     * Scope: only available equipment.
     */
    public function scopeAvailable($query)
    {
        return $query->where('status', 'available');
    }
}
