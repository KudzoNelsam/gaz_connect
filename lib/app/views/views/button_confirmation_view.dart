import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TypeNotification { snackBar, dialog, bottomSheet }

class ButtonConfirmationView extends StatefulWidget {
  // Textes personnalisables
  final String texteInitial;
  final String texteConfirmation;
  final String sousTitreInitial;
  final String sousTitreConfirmation;

  // Notification personnalisable
  final String titreNotification;
  final String messageNotification;
  final TypeNotification typeNotification;

  // Couleurs personnalisables
  final Color couleurInitiale;
  final Color couleurConfirmation;

  // Icône personnalisable
  final IconData icone;

  // Durées personnalisables
  final int dureeResetSeconde;
  final int dureeNotificationSeconde;

  // Callbacks
  final VoidCallback? onConfirmation;
  final VoidCallback? onPremierePression;

  // Messages de succès
  final String? messageSucces;
  final bool afficherMessageSucces;

  const ButtonConfirmationView({
    Key? key,
    // Textes
    this.texteInitial = 'COUPER LE GAZ',
    this.texteConfirmation = 'CONFIRMER COUPURE',
    this.sousTitreInitial = 'Double pression pour sécurité',
    this.sousTitreConfirmation = 'Appuyez à nouveau pour confirmer',

    // Notification
    this.titreNotification = 'Première pression',
    this.messageNotification = 'Appuyez à nouveau pour couper le gaz',
    this.typeNotification = TypeNotification.snackBar,

    // Couleurs
    this.couleurInitiale = Colors.orange,
    this.couleurConfirmation = Colors.red,

    // Icône
    this.icone = Icons.power_settings_new,

    // Durées
    this.dureeResetSeconde = 5,
    this.dureeNotificationSeconde = 4,

    // Callbacks
    this.onConfirmation,
    this.onPremierePression,

    // Messages
    this.messageSucces,
    this.afficherMessageSucces = true,
  }) : super(key: key);

  @override
  State<ButtonConfirmationView> createState() => _ButtonConfirmationViewState();
}

class _ButtonConfirmationViewState extends State<ButtonConfirmationView> {
  bool _premierePression = false;

  void _gererPression() {
    if (!_premierePression) {
      // Première pression
      setState(() {
        _premierePression = true;
      });

      // Callback première pression
      if (widget.onPremierePression != null) {
        widget.onPremierePression!();
      }

      // Afficher notification selon le type choisi
      _afficherNotification();

      // Reset automatique
      Future.delayed(Duration(seconds: widget.dureeResetSeconde), () {
        if (mounted && _premierePression) {
          setState(() {
            _premierePression = false;
          });
        }
      });
    } else {
      // Deuxième pression - confirmer
      _confirmerAction();
    }
  }

  void _afficherNotification() {
    switch (widget.typeNotification) {
      case TypeNotification.snackBar:
        _afficherSnackBar();
        break;
      case TypeNotification.dialog:
        _afficherDialog();
        break;
      case TypeNotification.bottomSheet:
        _afficherBottomSheet();
        break;
    }
  }

  void _afficherSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.titreNotification,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.messageNotification,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[800],
        duration: Duration(seconds: widget.dureeNotificationSeconde),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _afficherDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: widget.couleurConfirmation,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.titreNotification,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.messageNotification,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Compris',
                        style: TextStyle(color: widget.couleurConfirmation),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _afficherBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.couleurConfirmation.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info,
                      color: widget.couleurConfirmation,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titreNotification,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.messageNotification,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.couleurConfirmation,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Compris'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  void _confirmerAction() {
    setState(() {
      _premierePression = false;
    });

    // Exécuter l'action de confirmation
    if (widget.onConfirmation != null) {
      widget.onConfirmation!();
    }

    // Afficher message de succès si demandé
    if (widget.afficherMessageSucces) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(widget.messageSucces ?? 'Action confirmée avec succès'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _gererPression,
            style: ElevatedButton.styleFrom(
              backgroundColor: _premierePression
                  ? widget.couleurConfirmation
                  : widget.couleurInitiale,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icone, size: 20),
                const SizedBox(width: 8),
                Text(
                  _premierePression
                      ? widget.texteConfirmation
                      : widget.texteInitial,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _premierePression
              ? widget.sousTitreConfirmation
              : widget.sousTitreInitial,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
