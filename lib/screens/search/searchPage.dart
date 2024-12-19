import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/screens/details/details_screen.dart';
import 'package:provider/provider.dart';
import 'package:foodly_ui/A-providers/SearchProvider.dart';
import 'package:foodly_ui/A-models/Restaurant.dart';

class SearchPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<SearchProvider>(context, listen: false)
        .fetchRestaurants(context);
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rechercher un restaurant"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                // Met à jour les résultats de la recherche
                searchProvider.filterRestaurants(value);
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un restaurant',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (searchProvider.isLoading) const CircularProgressIndicator(),
          if (!searchProvider.isLoading &&
              searchProvider.filteredRestaurants.isEmpty)
            const Text("Aucun restaurant trouvé."),
          Expanded(
            child: ListView.builder(
              itemCount: searchProvider.filteredRestaurants.length,
              itemBuilder: (context, index) {
                Restaurant restaurant =
                    searchProvider.filteredRestaurants[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(restaurant.image ?? 'url_par_defaut'),
                  ),
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.name),
                  onTap: () {
                    // Naviguer vers la page de détails du restaurant
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          restaurantId: restaurant.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
