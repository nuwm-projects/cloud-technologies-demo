<?php

namespace App\Api\Requests\Counter;

use Illuminate\Foundation\Http\FormRequest;

class CounterUpdateRequest extends FormRequest
{
    /**
     * @return string[]
     */
    public function rules(): array
    {
        return [
            'count' => 'required|numeric',
        ];
    }
}
