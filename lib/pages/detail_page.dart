import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';

class DetailNotePage extends StatelessWidget {
  final Note note;

  const DetailNotePage({super.key, required this.note});

  // Convertit hex en Color Flutter
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  // Formate la date complète
  String _formatDateComplete(DateTime date) {
    const mois = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    final heure = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${mois[date.month]} ${date.year} à $heure:$minute';
  }

  // Bouton Modifier
  void _modifierNote(BuildContext context) async {
    final noteModifiee = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateNotePage(note: note),
      ),
    );
    if (noteModifiee != null) {
      Navigator.pop(context, noteModifiee);
    }
  }

  // Bouton Supprimer avec confirmation
  void _supprimerNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la note'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette note ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Annuler
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Ferme le dialog
              Navigator.pop(context, 'deleted'); // Retourne à HomePage
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Note'),
        backgroundColor: _hexToColor(note.couleur),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _modifierNote(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _supprimerNote(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              note.titre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Date de création
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Color.fromARGB(255, 17, 3, 102)),
                const SizedBox(width: 4),
                Text(
                  'Créée le ${_formatDateComplete(note.dateCreation)}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),

            // Date de modification (si elle existe)
            if (note.dateModification != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.edit_calendar, size: 14, color: Color.fromARGB(255, 3, 13, 90)),
                  const SizedBox(width: 4),
                  Text(
                    'Modifiée le ${_formatDateComplete(note.dateModification!)}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),

            // Contenu complet
            Text(
              note.contenu,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}