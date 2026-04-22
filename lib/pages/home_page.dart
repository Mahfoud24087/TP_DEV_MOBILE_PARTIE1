import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Note> _notes = [];

  // Convertit le code hex en Color Flutter
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  // Formate la date en texte lisible
  String _formatDate(DateTime date) {
    return  
        '${date.year}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/ '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}:'
        '${date.second.toString().padLeft(2, '0')}/'
        ;   
  }

  // Navigue vers CreatePage pour créer une nouvelle note
  void _allerCreerNote() async {
    final nouvelleNote = await Navigator.push<Note>(context, MaterialPageRoute(builder: (_) => const CreateNotePage()),);
    if (nouvelleNote != null) {
      setState(() {
        _notes.add(nouvelleNote);
      });
    }
  }

  // Navigue vers DetailPage pour voir une note
  void _allerDetailNote(int index) async {
    final resultat = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailNotePage(note: _notes[index]),
      ),
    );

    if (resultat is Note) {
      // Note modifiée
      setState(() {
        _notes[index] = resultat;
      });
    } else if (resultat == 'deleted') {
      // Note supprimée
      setState(() {
        _notes.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: const Color.fromARGB(255, 7, 7, 6),
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text(
                'Aucune note\nAppuyez sur + pour créer une note',
                textAlign: TextAlign.center,
                style:TextStyle(backgroundColor: Color.fromARGB(255, 183, 48, 39),fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return GestureDetector(
                  onTap: () => _allerDetailNote(index),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: _hexToColor(note.couleur),
                            width: 6,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.titre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note.contenu.length > 30
                                ? '${note.contenu.substring(0, 30)}.....'
                                : note.contenu,
                            style: const TextStyle(color: Color.fromARGB(255, 63, 61, 61)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatDate(note.dateCreation),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 16, 14, 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _allerCreerNote,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}