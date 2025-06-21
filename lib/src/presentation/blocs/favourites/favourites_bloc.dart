import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/favourites_repository.dart';
import 'favourites_event.dart';
import 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  FavouritesBloc({required this.favouritesRepository}) 
      : super(const FavouritesState()) {
    on<LoadFavourites>(_onLoadFavourites);
    on<AddToFavourites>(_onAddToFavourites);
    on<RemoveFromFavourites>(_onRemoveFromFavourites);
    on<ToggleFavourite>(_onToggleFavourite);
  }

  final FavouritesRepository favouritesRepository;

  Future<void> _onLoadFavourites(
    LoadFavourites event,
    Emitter<FavouritesState> emit,
  ) async {
    emit(state.copyWith(status: FavouritesStatus.loading));

    try {
      final Set<String> favouriteEventIds = 
          await favouritesRepository.getFavouriteEventIds();

      emit(state.copyWith(
        status: FavouritesStatus.success,
        favouriteEventIds: favouriteEventIds,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FavouritesStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onAddToFavourites(
    AddToFavourites event,
    Emitter<FavouritesState> emit,
  ) async {
    try {
      await favouritesRepository.addToFavourites(event.eventId);
      
      final Set<String> updatedFavourites = Set<String>.from(state.favouriteEventIds)
        ..add(event.eventId);

      emit(state.copyWith(
        status: FavouritesStatus.success,
        favouriteEventIds: updatedFavourites,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FavouritesStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onRemoveFromFavourites(
    RemoveFromFavourites event,
    Emitter<FavouritesState> emit,
  ) async {
    try {
      await favouritesRepository.removeFromFavourites(event.eventId);
      
      final Set<String> updatedFavourites = Set<String>.from(state.favouriteEventIds)
        ..remove(event.eventId);

      emit(state.copyWith(
        status: FavouritesStatus.success,
        favouriteEventIds: updatedFavourites,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FavouritesStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onToggleFavourite(
    ToggleFavourite event,
    Emitter<FavouritesState> emit,
  ) async {
    try {
      final bool isFavourite = state.isFavourite(event.eventId);
      
      if (isFavourite) {
        add(RemoveFromFavourites(eventId: event.eventId));
      } else {
        add(AddToFavourites(eventId: event.eventId));
      }
    } catch (error) {
      emit(state.copyWith(
        status: FavouritesStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}