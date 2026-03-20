<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    protected \App\Services\UserService $userService;

    public function __construct(\App\Services\UserService $userService)
    {
        $this->userService = $userService;
    }

    /**
     * Get all users (admin only).
     */
    public function index(\Illuminate\Http\Request $request): JsonResponse
    {
        $data = $this->userService->listUsers($request->only('search'));

        return $this->successResponse(data: $data);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreUserRequest $request): JsonResponse
    {
        $user = $this->userService->createUser($request->validated());

        return $this->successResponse(
            data: $user,
            message: 'User created successfully',
            status: 201
        );
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateUserRequest $request, User $user): JsonResponse
    {
        $user = $this->userService->updateUser($user, $request->validated());

        return $this->successResponse(
            data: $user,
            message: 'User updated successfully'
        );
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user): JsonResponse
    {
        try {
            $this->userService->deleteUser($user);
            return $this->successResponse(message: 'User deleted successfully');
        } catch (\Exception $e) {
            return $this->errorResponse(
                message: $e->getMessage(),
                status: 403
            );
        }
    }
}
