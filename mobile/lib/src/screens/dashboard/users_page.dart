import 'package:flutter/material.dart';

import '../../app.dart';
import '../../models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _search = TextEditingController();
  List<User> _users = <User>[];
  bool _loading = true;
  String? _error;

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadUsers();
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final scope = AppScope.of(context);
    final token = scope.notifier!.token;
    if (token == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final users = await scope.usersService.listUsers(token, search: _search.text);
      if (!mounted) return;
      setState(() => _users = users);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmDelete(User user) async {
    final scope = AppScope.of(context);
    final token = scope.notifier!.token;
    if (token == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete user'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await scope.usersService.deleteUser(token, user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      await _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // slate-50
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'System Users',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B), // slate-800
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage users',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B), // slate-500
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _loading ? null : _loadUsers,
                        icon: _loading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.sync),
                        color: const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5), // indigo-600
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        ),
                        onPressed: () {
                          // TODO: implement openAddDrawer equivalent
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Add User clicked')),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add User'),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: TextField(
                controller: _search,
                onSubmitted: (_) => _loadUsers(),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 18),
                    onPressed: () {
                      _search.clear();
                      _loadUsers();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)), // slate-200
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // List Content
            Expanded(
              child: _error != null
                  ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                  : _loading && _users.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : _users.isEmpty
                          ? const Center(
                              child: Text(
                                'No users found.',
                                style: TextStyle(color: Color(0xFF94A3B8)),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                final user = _users[index];
                                final initials = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Avatar
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE0E7FF), // indigo-100
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                initials,
                                                style: const TextStyle(
                                                  color: Color(0xFF4338CA), // indigo-700
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            
                                            // Name & Email
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    user.name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Color(0xFF1E293B),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    user.email,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF64748B),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Actions
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    // TODO: openEditDrawer equivalent
                                                  },
                                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                                  color: const Color(0xFF94A3B8),
                                                ),
                                                IconButton(
                                                  onPressed: () => _confirmDelete(user),
                                                  icon: const Icon(Icons.delete_outline, size: 20),
                                                  color: const Color(0xFF94A3B8), // slate-400 (hover effect handles the red in real life but we can leave it slate)
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(height: 12),
                                        
                                        // Roles and Date
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Wrap(
                                              spacing: 6,
                                              children: user.roles.map((role) => Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEEF2FF), // indigo-50
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: const Color(0xFFE0E7FF)), // indigo-100
                                                ),
                                                child: Text(
                                                  role,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF4F46E5), // indigo-600
                                                  ),
                                                ),
                                              )).toList(),
                                            ),
                                            
                                            Text(
                                              user.createdAt != null 
                                                  ? '${user.createdAt!.year}-${user.createdAt!.month.toString().padLeft(2, '0')}-${user.createdAt!.day.toString().padLeft(2, '0')}'
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF94A3B8),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
