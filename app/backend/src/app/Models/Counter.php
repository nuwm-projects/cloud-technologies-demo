<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * @property $count
 */
class Counter extends Model
{
    protected $attributes = [
        'count' => 0,
    ];

    /**
     * @param int $number
     */
    public function addNumber(int $number): void
    {
        if ($number < 0) {
            $number = 0;
        }

        $this->count += $number;
    }
}
