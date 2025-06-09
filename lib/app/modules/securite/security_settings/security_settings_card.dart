import 'package:flutter/material.dart';

class SecurityOption {
  final String titre;
  final String description;
  bool isEnabled;
  final VoidCallback? onChanged;
  final IconData? icone;

  SecurityOption({
    required this.titre,
    required this.description,
    this.isEnabled = false,
    this.onChanged,
    this.icone,
  });
}

class SecuritySettingsCard extends StatefulWidget {
  final String titre;
  final List<SecurityOption> options;
  final Function(Map<String, bool>)? onSettingsChanged;
  final Color couleurAccent;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const SecuritySettingsCard({
    Key? key,
    this.titre = 'Paramètres de Sécurité',
    required this.options,
    this.onSettingsChanged,
    this.couleurAccent = Colors.blue,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  State<SecuritySettingsCard> createState() => _SecuritySettingsCardState();
}

class _SecuritySettingsCardState extends State<SecuritySettingsCard> {
  Map<String, bool> _getSettingsMap() {
    Map<String, bool> settings = {};
    for (SecurityOption option in widget.options) {
      settings[option.titre] = option.isEnabled;
    }
    return settings;
  }

  void _updateSetting(int index, bool value) {
    setState(() {
      widget.options[index].isEnabled = value;
    });

    // Callback spécifique à l'option
    if (widget.options[index].onChanged != null) {
      widget.options[index].onChanged!();
    }

    // Callback global avec toutes les valeurs
    if (widget.onSettingsChanged != null) {
      widget.onSettingsChanged!(_getSettingsMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            Text(
              widget.titre,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Liste des options
            ...widget.options.asMap().entries.map((entry) {
              int index = entry.key;
              SecurityOption option = entry.value;
              bool isLast = index == widget.options.length - 1;

              return Column(
                children: [
                  Row(
                    children: [
                      // Icône optionnelle
                      if (option.icone != null) ...[
                        Icon(
                          option.icone,
                          color: widget.couleurAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                      ],

                      // Contenu texte
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.titre,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              option.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Switch
                      Switch(
                        value: option.isEnabled,
                        onChanged: (value) => _updateSetting(index, value),
                        activeColor: widget.couleurAccent,
                        activeTrackColor: widget.couleurAccent.withOpacity(0.3),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],
                  ),

                  // Séparateur (sauf pour le dernier élément)
                  if (!isLast) ...[
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey[200], height: 1),
                    const SizedBox(height: 16),
                  ],
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Méthodes publiques pour récupérer les valeurs
  Map<String, bool> getAllSettings() {
    return _getSettingsMap();
  }

  bool? getSettingValue(String titre) {
    for (SecurityOption option in widget.options) {
      if (option.titre == titre) {
        return option.isEnabled;
      }
    }
    return null;
  }

  void updateSettingValue(String titre, bool value) {
    for (int i = 0; i < widget.options.length; i++) {
      if (widget.options[i].titre == titre) {
        _updateSetting(i, value);
        break;
      }
    }
  }
}
