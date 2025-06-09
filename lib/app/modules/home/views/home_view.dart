import 'package:flutter/material.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';
import 'package:gaz_connect/app/views/views/graphique_donut_view.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final center = DefaultTabController(
      length: 3, // nombre d'onglets
      child: Column(
        children: [
          // Onglets
          const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Cuisine'),
              Tab(text: 'Restaurant'),
              Tab(text: 'Bar'),
            ],
          ),
          // Vue associée aux onglets
          Expanded(
            child: TabBarView(
              children: [
                Center(child: getCuisineInfo()),
                Center(child: getRestaurantInfo()),
                Center(child: getBarInfo()),
              ],
            ),
          ),
        ],
      ),
    );
    ;
    return ClientView(body: center);
  }

  Widget getCuisineInfo() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(5),
          child: getGraphique(),
        ),
      ],
    );
  }

  Widget getGraphique() {
    return GraphiqueDonutView(
      titre: 'Cuisine',
      sousTitre: 'Cuisine principale',
      pourcentage: 15.0,
      labelCentre: 'GAZ',
      couleurPrincipale: Colors.orange,
      couleurFond: Colors.grey[200],
    );
  }

  Widget getRestaurantInfo() {
    return Text('Page Restaurant');
  }

  Widget getBarInfo() {
    return Text('Page Bar');
  }
}
