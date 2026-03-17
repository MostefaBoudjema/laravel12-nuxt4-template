<?php

namespace App\Http\Controllers\Api\v1\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Illuminate\Validation\Rule;

class PermissionController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Permission::query();
        if ($request->filled('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }
        $permissions = $query->get();
        return $this->successResponse(data: $permissions);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|unique:permissions,name',
        ]);

        $permission = Permission::create([
            'name' => $validated['name'],
            'guard_name' => 'web'
        ]);

        return $this->successResponse(
            data: $permission,
            message: 'Permission created successfully',
            status: 201
        );
    }

    /**
     * Display the specified resource.
     */
    public function show(Permission $permission)
    {
        return $this->successResponse(data: $permission);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Permission $permission)
    {
        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                Rule::unique('permissions', 'name')->ignore($permission->id),
            ],
        ]);

        $permission->update(['name' => $validated['name']]);

        return $this->successResponse(
            data: $permission,
            message: 'Permission updated successfully'
        );
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Permission $permission)
    {
        $permission->delete();

        return $this->successResponse(message: 'Permission deleted successfully');
    }
}
