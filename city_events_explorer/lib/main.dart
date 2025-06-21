import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/data/datasources/events_local_datasource.dart';
import 'src/data/datasources/favourites_local_datasource.dart';
import 'src/data/repositories/events_repository_impl.dart';
import 'src/data/repositories/favourites_repository_impl.dart';
import 'src/presentation/blocs/events/events_bloc.dart';
import 'src/presentation/blocs/favourites/favourites_bloc.dart';
import 'src/presentation/pages/home_page.dart';

void main() {
  runApp(const CityEventsApp());
}

class CityEventsApp extends StatelessWidget {
  const CityEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final EventsLocalDataSource eventsDataSource = EventsLocalDataSourceImpl();
    final FavouritesLocalDataSource favouritesDataSource = FavouritesLocalDataSourceImpl();

    final EventsRepositoryImpl eventsRepository = EventsRepositoryImpl(
      localDataSource: eventsDataSource,
    );
    final FavouritesRepositoryImpl favouritesRepository = FavouritesRepositoryImpl(
      localDataSource: favouritesDataSource,
    );

    return MaterialApp(
      title: 'City Events Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EventsBloc>(
            create: (context) => EventsBloc(
              eventsRepository: eventsRepository,
            ),
          ),
          BlocProvider<FavouritesBloc>(
            create: (context) => FavouritesBloc(
              favouritesRepository: favouritesRepository,
            ),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}