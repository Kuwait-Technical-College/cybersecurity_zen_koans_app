import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const _key = 'favorite_koan_codes';

  Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? {};
  }

  Future<Set<String>> toggleFavorite(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key)?.toSet() ?? {};
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }
    await prefs.setStringList(_key, favorites.toList());
    return favorites;
  }
}
