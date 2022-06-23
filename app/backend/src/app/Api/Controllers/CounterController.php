<?php

namespace App\Api\Controllers;

use App\Api\Requests\Counter\CounterUpdateRequest;
use App\Models\Counter;
use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Controller as BaseController;

class CounterController extends BaseController
{
    /**
     * @return JsonResponse
     */
    public function index(): JsonResponse
    {
        $record = Counter::query()->first();
        if (empty($record)) {
            return response()->json([
                'count' => 0
            ]);
        }

        return response()->json([
            'count' => $record->count,
        ]);
    }

    /**
     * @param CounterUpdateRequest $request
     * @return JsonResponse
     */
    public function update(CounterUpdateRequest $request): JsonResponse
    {
        $record = Counter::query()->first();
        if (empty($record)) {
            $record = new Counter();
        }

        $record->count += $request->json('count', 0);

        return response()->json([
            'result' => $record->save(),
        ]);
    }
}
