abstract class FavouritesRepository {
  Future<Set<String>> getFavouriteEventIds();
  Future<void> addToFavourites(String eventId);
  Future<void> removeFromFavourites(String eventId);
  Future<bool> isFavourite(String eventId);
}