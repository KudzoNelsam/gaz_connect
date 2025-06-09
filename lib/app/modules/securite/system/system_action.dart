import 'package:flutter/material.dart';

class SystemAction {
  final String titre;
  final String description;
  final VoidCallback? onPressed;
  final IconData? icone;
  final Color? couleur;
  final bool enabled;

  SystemAction({
    required this.titre,
    required this.description,
    this.onPressed,
    this.icone,
    this.couleur,
    this.enabled = true,
  });
}
