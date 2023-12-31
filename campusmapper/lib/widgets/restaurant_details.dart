/*
Author: Darshilkumar Patel
 Presents a list of campus restaurants,
 allowing users to view location details and access menus or
 directions for each restaurant through interactive elements.
*/

import 'package:flutter/material.dart';
import 'package:campusmapper/models/constants/menu_constants.dart';
import 'package:campusmapper/utilities/classes/food_main.dart';
import 'package:campusmapper/utilities/classes/location.dart';
import 'package:campusmapper/widgets/drop_menu.dart';

class FoodPage extends StatelessWidget {
  final List<Restaurant> restaurants = [
    Restaurant(name: 'Cafe', location: 'Student Services Building - SSB105'),
    Restaurant(name: 'Booster Juice', location: 'Student Center - SC126'),
    Restaurant(name: 'Drip Cafe', location: 'Student Center - SC129'),
    Restaurant(name: 'Tim Hortons', location: 'Shawenjigewining Hall - SHA126'),
    Restaurant(name: 'Tim Hortons Food', location: 'Gordon Wiley - B218'),
    Restaurant(
        name: 'Hunter Kitchen', location: 'Business and IT Building - UB1080'),
    Restaurant(
        name: 'North 2200 Grill', location: 'Campus Ice center - Floor 2'),
  ];

  FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2ECC71),
        title: const Row(
          children: [
            Icon(Icons.fastfood_sharp),
            SizedBox(width: 10), // Add some spacing between the icon and text
            Expanded(
              child: Text(
                "Restaurants on Campus with a potentially long title",
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // Limit the title to a single line
              ),
            ),
          ],
        ),
        actions: const <Widget>[Dropdown()],
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          var restaurant = restaurants[index];
          return ListTile(
            title: Text(restaurant.name),
            subtitle: Text(restaurant.location),
            onTap: () {
              _showRestaurantOptions(context, restaurant);
            },
          );
        },
      ),
    );
  }

  void _showRestaurantOptions(BuildContext context, Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.directions),
              title: const Text('Directions'),
              onTap: () {
                Navigator.pop(context);
                LocationService().navigateToRestaurantLocation(
                  context,
                  RestaurantLocation(
                    name: restaurant.name,
                    latitude: getRestaurantLatitude(restaurant),
                    longitude: getRestaurantLongitude(restaurant),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Menu'),
              onTap: () {
                _showMenuImage(context, restaurant);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showMenuImage(BuildContext context, Restaurant restaurant) {
    String? imagePath = MenuService.getMenuImagePath(restaurant.name);
    if (imagePath != null) {
      MenuService.showMenuImage(context, imagePath);
    } else {
      // Handle case when the menu image path is not available
    }
  }
}

double getRestaurantLatitude(Restaurant restaurant) {
  // Access the predefined list of RestaurantLocation instances
  final List<RestaurantLocation> restaurantLocations =
      LocationService().getAllRestaurantLocations();

  // Find the RestaurantLocation with a matching name
  final RestaurantLocation? selectedRestaurant = restaurantLocations.firstWhere(
    (location) => location.name == restaurant.name,
    orElse: () => RestaurantLocation(
        name: '', latitude: 0.0, longitude: 0.0), // Default values if not found
  );

  // Return the latitude of the selected restaurant
  return selectedRestaurant?.latitude ?? 0.0;
}

double getRestaurantLongitude(Restaurant restaurant) {
  // Access the predefined list of RestaurantLocation instances
  final List<RestaurantLocation> restaurantLocations =
      LocationService().getAllRestaurantLocations();

  // Find the RestaurantLocation with a matching name
  final RestaurantLocation? selectedRestaurant = restaurantLocations.firstWhere(
    (location) => location.name == restaurant.name,
    orElse: () => RestaurantLocation(
        name: '', latitude: 0.0, longitude: 0.0), // Default values if not found
  );

  // Return the longitude of the selected restaurant
  return selectedRestaurant?.longitude ?? 0.0;
}
/*
void _fetchMenuData(Restaurant restaurant) async {
  final String? menuData = await MenuService.fetchMenu(restaurant.name);

  if (menuData != null) {
    print('Menu data for ${restaurant.name}: $menuData');
    // Perform further operations with the menu data
  } else {
    // Handle null or error cases when fetching menu data fails
  }
}
*/
