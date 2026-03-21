import '../models/user.dart';
import 'api_client.dart';

class UsersService {
  final ApiClient api;

  const UsersService(this.api);

  Future<List<User>> listUsers(String token, {String search = ''}) async {
    final suffix = search.trim().isEmpty ? '' : '?search=${Uri.encodeQueryComponent(search.trim())}';
    final json = await api.getJson('/users$suffix', token: token);
    final root = (json['data'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final paginated = (root['data'] as List? ?? <dynamic>[]);
    return paginated
        .whereType<Map<String, dynamic>>()
        .map(User.fromJson)
        .toList(growable: false);
  }

  Future<void> deleteUser(String token, int userId) async {
    await api.deleteJson('/users/$userId', token: token);
  }
}
