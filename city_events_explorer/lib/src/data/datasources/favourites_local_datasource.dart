import 'package:shared_preferences/shared_preferences.dart';

abstract class FavouritesLocalDataSource {
  Future<Set<String>> getFavouriteEventIds();
  Future<void> addToFavourites(String eventId);
  Future<void> removeFromFavourites(String eventId);
  Future<bool> isFavourite(String eventId);
}

class FavouritesLocalDataSourceImpl implements FavouritesLocalDataSource {
  static const String _favouritesKey = 'favourite_events';

  @override
  Future<Set<String>> getFavouriteEventIds() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? favouritesList = prefs.getStringList(_favouritesKey);
      return favouritesList?.toSet() ?? <String>{};
    } catch (e) {
      throw Exception('Failed to load favourites: $e');
    }
  }

  @override
  Future<void> addToFavourites(String eventId) async {
    try {
      final Set<String> favourites = await getFavouriteEventIds();
      favourites.add(eventId);
      await _saveFavourites(favourites);
    } catch (e) {
      throw Exception('Failed to add to favourites: $e');
    }
  }

  @override
  Future<void> removeFromFavourites(String eventId) async {
    try {
      final Set<String> favourites = await getFavouriteEventIds();
      favourites.remove(eventId);
      await _saveFavourites(favourites);
    } catch (e) {
      throw Exception('Failed to remove from favourites: $e');
    }
  }

  @override
  Future<bool> isFavourite(String eventId) async {
    try {
      final Set<String> favourites = await getFavouriteEventIds();
      return favourites.contains(eventId);
    } catch (e) {
      throw Exception('Failed to check favourite status: $e');
    }
  }

  Future<void> _saveFavourites(Set<String> favourites) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favouritesKey, favourites.toList());
  }
}