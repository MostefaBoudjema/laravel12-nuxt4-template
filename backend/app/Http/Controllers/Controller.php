<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Controller as BaseLaravelController;

abstract class Controller extends BaseLaravelController
{
    /**
     * Build a standardized success JSON response.
     *
     * @param  mixed       $data
     * @param  string|null $message
     * @param  int         $status
     */
    protected function successResponse(mixed $data = null, ?string $message = null, int $status = 200): JsonResponse
    {
        $payload = [
            'success' => true,
        ];

        if (!is_null($message)) {
            $payload['message'] = $message;
        }

        if (!is_null($data)) {
            $payload['data'] = $data;
        }

        return response()->json($payload, $status);
    }

    /**
     * Build a standardized error JSON response.
     *
     * @param  string      $message
     * @param  int         $status
     * @param  mixed       $errors
     */
    protected function errorResponse(string $message, int $status = 400, mixed $errors = null): JsonResponse
    {
        $payload = [
            'success' => false,
            'message' => $message,
        ];

        if (!is_null($errors)) {
            $payload['errors'] = $errors;
        }

        return response()->json($payload, $status);
    }
}
