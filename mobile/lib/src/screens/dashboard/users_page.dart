import 'package:flutter/material.dart';

import '../../app.dart';
import '../../models/user.dart';

import '../../../l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.deleteUser),
          content: Text(loc.deleteConfirm(user.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(loc.delete),
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
    final loc = AppLocalizations.of(context)!;
    final settings = SettingsScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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
                    children: [
                      Text(
                        loc.appTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B), // slate-800
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loc.manageUsers,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B), // slate-500
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.language, color: Color(0xFF64748B)),
                        onSelected: (val) => settings.updateLocale(Locale(val)),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'en', child: Text('English')),
                          PopupMenuItem(value: 'fr', child: Text('Français')),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          settings.updateThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
                        },
                        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: const Color(0xFF64748B)),
                      ),
                      IconButton(
                        onPressed: _loading ? null : _loadUsers,
                        icon: _loading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.sync),
                        color: const Color(0xFF64748B),
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
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: loc.searchUsers,
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                  suffixIcon: _search.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 18),
                        onPressed: () {
                          _search.clear();
                          _loadUsers();
                        },
                      )
                    : null,
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
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
                          ? Center(
                              child: Text(
                                loc.noUsersFound,
                                style: const TextStyle(color: Color(0xFF94A3B8)),
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
                                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)), 
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
                                              decoration: BoxDecoration(
                                                color: isDark ? const Color(0xFF312E81) : const Color(0xFFE0E7FF), 
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                initials,
                                                style: TextStyle(
                                                  color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA), 
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
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: isDark ? Colors.white : const Color(0xFF1E293B),
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
                                                    // edit
                                                  },
                                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                                  color: const Color(0xFF94A3B8),
                                                ),
                                                IconButton(
                                                  onPressed: () => _confirmDelete(user),
                                                  icon: const Icon(Icons.delete_outline, size: 20),
                                                  color: const Color(0xFF94A3B8), 
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
                                                  color: isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF), 
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: isDark ? const Color(0xFF4338CA) : const Color(0xFFE0E7FF)), 
                                                ),
                                                child: Text(
                                                  role,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
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
