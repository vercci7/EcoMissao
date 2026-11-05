import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStore extends ChangeNotifier {
  String name = 'Eco Explorador';
  String avatar = '🐼';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('profile_name') ?? 'Eco Explorador';
    avatar = prefs.getString('profile_avatar') ?? '🐼';
    notifyListeners();
  }

  Future<void> save({required String newName, required String newAvatar}) async {
    final prefs = await SharedPreferences.getInstance();

    name = newName.trim().isEmpty ? 'Eco Explorador' : newName.trim();
    avatar = newAvatar;

    await prefs.setString('profile_name', name);
    await prefs.setString('profile_avatar', avatar);

    notifyListeners();
  }
}
