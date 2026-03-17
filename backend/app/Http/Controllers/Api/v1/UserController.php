<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
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
    public function store(\Illuminate\Http\Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'roles' => 'array',
            'roles.*' => 'string|exists:roles,name',
        ]);

        $user = $this->userService->createUser($validated);

        return $this->successResponse(
            data: $user,
            message: 'User created successfully',
            status: 201
        );
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(\Illuminate\Http\Request $request, User $user): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,'.$user->id,
            'password' => 'nullable|string|min:8',
            'roles' => 'array',
            'roles.*' => 'string|exists:roles,name',
        ]);

        $user = $this->userService->updateUser($user, $validated);

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
