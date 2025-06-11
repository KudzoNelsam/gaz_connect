import 'package:flutter/material.dart';

import '../../../models/installation_response.dart';

class ClientCard extends StatelessWidget {
  final Client client;

  const ClientCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        print(this);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border(
            left: BorderSide(
              color: Colors.blue,
              width: 4.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  client.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                _buildStatusChip(client.status),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              'ID: ${client.id}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              client.address,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Text(
                  '${client.capteurs} capteurs',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '${client.bouteilles} bouteilles',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ) ;
  }

  Widget _buildStatusChip(ClientStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case ClientStatus.actif:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        text = 'Actif';
        break;
      case ClientStatus.aInstaller:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        text = 'À installer';
        break;
      case ClientStatus.aVerifier:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        text = 'À vérifier';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}