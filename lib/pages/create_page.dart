import 'package:flutter/material.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final Note? note; // null = création, non-null = modification

  const CreateNotePage({super.key, this.note});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();
  String _couleurSelectionnee = '#FFE082'; // jaune par défaut

  // Les 6 couleurs disponibles
  final List<String> _couleurs = [
    '#FFE082', // jaune
    '#EF9A9A', // rouge
    '#A5D6A7', // vert
    '#90CAF9', // bleu
    '#CE93D8', // violet
    '#FFCC80', // orange
  ];

  @override
  void initState() {
    super.initState();
    // Mode modification : pré-remplir les champs
    if (widget.note != null) {
      _titreController.text = widget.note!.titre;
      _contenuController.text = widget.note!.contenu;
      _couleurSelectionnee = widget.note!.couleur;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  // Convertit hex en Color Flutter
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  void _sauvegarder() {
    // Validation : titre non vide
    if (_titreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre ne peut pas être vide !')),
      );
      return;
    }

    Note noteFinale;

    if (widget.note != null) {
      // Mode modification : copyWith pour garder id et dateCreation
      noteFinale = widget.note!.copyWith(
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
        couleur: _couleurSelectionnee,
        dateModification: DateTime.now(),
      );
    } else {
      // Mode création : nouvelle note
      noteFinale = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
        couleur: _couleurSelectionnee,
        dateCreation: DateTime.now(),
      );
    }

    Navigator.pop(context, noteFinale);
  }

  @override
  Widget build(BuildContext context) {
    final bool estModification = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(estModification ? 'Modifier la note' : 'Nouvelle Note'),
        backgroundColor: _hexToColor(_couleurSelectionnee),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _sauvegarder,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ Titre
            TextField(
              controller: _titreController,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Titre',
                hintText: 'Titre de la note...',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),

            // Champ Contenu
            TextField(
              controller: _contenuController,
              minLines: 4,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Contenu',
                hintText: 'Écrivez votre note ici...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sélecteur de couleur
            const Text(
              'Couleur :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: _couleurs.map((hex) {
                final bool estSelectionnee = hex == _couleurSelectionnee;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _couleurSelectionnee = hex;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _hexToColor(hex),
                      shape: BoxShape.circle,
                      border: estSelectionnee
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}