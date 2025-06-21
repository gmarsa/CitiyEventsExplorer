import 'package:equatable/equatable.dart';

abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadFavourites extends FavouritesEvent {
  const LoadFavourites();
}

class AddToFavourites extends FavouritesEvent {
  const AddToFavourites({required this.eventId});

  final String eventId;

  @override
  List<Object?> get props => <Object?>[eventId];
}

class RemoveFromFavourites extends FavouritesEvent {
  const RemoveFromFavourites({required this.eventId});

  final String eventId;

  @override
  List<Object?> get props => <Object?>[eventId];
}

class ToggleFavourite extends FavouritesEvent {
  const ToggleFavourite({required this.eventId});

  final String eventId;

  @override
  List<Object?> get props => <Object?>[eventId];
}