import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/events/events_bloc.dart';
import '../blocs/events/events_event.dart';
import '../blocs/favourites/favourites_bloc.dart';
import '../blocs/favourites/favourites_event.dart';
import '../widgets/events_list.dart';
import '../widgets/search_and_filters.dart';
import 'favourites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales
    context.read<EventsBloc>().add(const LoadEvents());
    context.read<FavouritesBloc>().add(const LoadFavourites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Events Explorer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EventsBloc>().add(const RefreshEvents());
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          // Searchbox and filters
          SearchAndFilters(),
          
          // Event list
          Expanded(
            child: EventsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FavouritesPage(),
            ),
          );
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}