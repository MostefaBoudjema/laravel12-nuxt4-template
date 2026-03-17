<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Register a new user.
     */
    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'     => ['required', 'string', 'max:255'],
            'email'    => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
        ]);

        $user = User::create($validated);
        $user->assignRole('user');

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->successResponse(
            data: [
                'token' => $token,
                'user'  => $this->userData($user),
            ],
            message: 'Registration successful.',
            status: 201
        );
    }

    /**
     * Log in an existing user.
     */
    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email'    => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            return $this->errorResponse(
                message: 'The provided credentials are incorrect.',
                status: 422,
                errors: [
                    'email' => ['The provided credentials are incorrect.'],
                ]
            );
        }

        /** @var User $user */
        $user  = Auth::user();
        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->successResponse(
            data: [
                'token' => $token,
                'user'  => $this->userData($user),
            ],
            message: 'Login successful.'
        );
    }

    /**
     * Log out the authenticated user.
     */
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return $this->successResponse(message: 'Logged out successfully.');
    }

    /**
     * Return the authenticated user's data.
     */
    public function me(Request $request): JsonResponse
    {
        return $this->successResponse(
            data: [
                'user' => $this->userData($request->user()),
            ]
        );
    }

    /**
     * Build user data response with roles and permissions.
     */
    private function userData(User $user): array
    {
        return [
            'id'          => $user->id,
            'name'        => $user->name,
            'email'       => $user->email,
            'roles'       => $user->getRoleNames(),
            'permissions' => $user->getAllPermissions()->pluck('name'),
            'created_at'  => $user->created_at,
        ];
    }
}
