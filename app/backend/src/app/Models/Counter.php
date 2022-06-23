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
}
