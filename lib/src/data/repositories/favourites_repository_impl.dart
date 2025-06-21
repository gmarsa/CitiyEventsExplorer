import '../../domain/repositories/favourites_repository.dart';
import '../datasources/favourites_local_datasource.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  FavouritesRepositoryImpl({required this.localDataSource});

  final FavouritesLocalDataSource localDataSource;

  @override
  Future<Set<String>> getFavouriteEventIds() async {
    try {
      return await localDataSource.getFavouriteEventIds();
    } catch (e) {
      throw Exception('Failed to get favourite event IDs: $e');
    }
  }

  @override
  Future<void> addToFavourites(String eventId) async {
    try {
      await localDataSource.addToFavourites(eventId);
    } catch (e) {
      throw Exception('Failed to add to favourites: $e');
    }
  }

  @override
  Future<void> removeFromFavourites(String eventId) async {
    try {
      await localDataSource.removeFromFavourites(eventId);
    } catch (e) {
      throw Exception('Failed to remove from favourites: $e');
    }
  }

  @override
  Future<bool> isFavourite(String eventId) async {
    try {
      return await localDataSource.isFavourite(eventId);
    } catch (e) {
      throw Exception('Failed to check favourite status: $e');
    }
  }
}