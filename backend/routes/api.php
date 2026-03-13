<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Authenticated routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    // Admin only
    Route::middleware('role:admin')->group(function () {
        Route::get('/users', [UserController::class, 'index']);
        
        // Roles CRUD
        Route::apiResource('roles', \App\Http\Controllers\Api\Admin\RoleController::class);
        
        // Permissions CRUD
        Route::apiResource('permissions', \App\Http\Controllers\Api\Admin\PermissionController::class);
    });

    // Admin + Manager
    Route::middleware('role:admin|manager')->group(function () {
        Route::get('/reports', [ReportController::class, 'index']);
    });
});
