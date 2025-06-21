import 'package:equatable/equatable.dart';

enum FavouritesStatus { initial, loading, success, failure }

class FavouritesState extends Equatable {
  const FavouritesState({
    this.status = FavouritesStatus.initial,
    this.favouriteEventIds = const <String>{},
    this.errorMessage,
  });

  final FavouritesStatus status;
  final Set<String> favouriteEventIds;
  final String? errorMessage;

  bool isFavourite(String eventId) => favouriteEventIds.contains(eventId);

  FavouritesState copyWith({
    FavouritesStatus? status,
    Set<String>? favouriteEventIds,
    String? errorMessage,
  }) {
    return FavouritesState(
      status: status ?? this.status,
      favouriteEventIds: favouriteEventIds ?? this.favouriteEventIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        favouriteEventIds,
        errorMessage,
      ];
}