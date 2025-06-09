import 'package:flutter/material.dart';
import 'package:gaz_connect/app/views/views/alert_card_view.dart';
import 'package:gaz_connect/app/views/views/button_confirmation_view.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';
import 'package:gaz_connect/app/views/views/graphique_donut_view.dart';
import 'package:gaz_connect/app/views/views/info_personalisable_view.dart';
import 'package:gaz_connect/app/views/views/prediction_widget_view.dart';

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
                Center(
                  child: Column(
                    children: [
                      getCuisineInfo(),
                      getPredictionPersonnalisee(),
                      getConsoAndCapteurInfo(),
                      getCard(),
                      getButtonConfirmerCoupure(),
                      getCardLivraison(),
                    ],
                  ),
                ),
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

  Widget getCard() {
    return AlertCardView(
      titre: 'Niveau critique!',
      message: 'Commande automatique prévue dans 2h',
      type: TypeAlerte.avertissement,
    );
  }

  Widget getCardLivraison() {
    return AlertCardView(
      titre: 'Demain 14h30',
      message: 'Prochaine livraison',
      type: TypeAlerte.succes,
    );
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

  Widget getButtonConfirmerCoupure() {
    return ButtonConfirmationView(
      onConfirmation: () {
        print('Gaz coupé !');
        Get.snackbar('Succès', 'Le gaz a été coupé');
      },
      onPremierePression: () {
        print('Première pression détectée');
      },
    );
  }

  Widget getPredictionPersonnalisee() {
    return PredictionWidgetView(
      titre: 'Maintenance prévue',
      date: 'lundi 16 juin',
      heure: 'à 09:00',
      couleurAccent: Color(0xFF004A99),
      icone: Icons.build,
    );
  }

  Widget getConsoAndCapteurInfo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: InfoPersonalisableView(
              titre: 'Consommation',
              valeur: '2.1 kg/j',
              icone: Icons.trending_down,
              couleurIcone: Colors.teal,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: InfoPersonalisableView(
              titre: 'Capteur',
              valeur: 'Optimal',
              icone: Icons.sensor_occupied,
              couleurIcone: Colors.cyan,
            ),
          ),
        ],
      ),
    );
  }

  Widget getRestaurantInfo() {
    return Text('Page Restaurant');
  }

  Widget getBarInfo() {
    return Text('Page Bar');
  }
}
