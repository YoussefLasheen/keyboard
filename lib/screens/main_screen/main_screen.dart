import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:gtk_window/gtk_window.dart';
import 'package:keyboard/constants.dart';
import 'package:piano/piano.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _loadSounds() {
    FlameAudio.audioCache.loadAll(Constants.audioAssets);
  }

  @override
  void initState() {
    super.initState();
    _loadSounds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GTKHeaderBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey,
      body: InteractivePiano(
        naturalColor: Colors.white,
        accidentalColor: Colors.black,
        keyWidth: 60,
        noteRange: NoteRange.forClefs([
          Clef.Treble,
          Clef.Alto,
          Clef.Bass,
        ]),
        hideNoteNames: true,
        animateHighlightedNotes: false,
        onNotePositionTapped: (position) async {
          String name = '';
          if (position.name.startsWith('C') || position.name.startsWith('F')) {
            name = position.name.replaceFirst('♯', '');
          } else {
            name = position.name.replaceFirst('♯', 'b');
          }

          FlameAudio.play('$name.mp3');
        },
      ),
    );
  }
}
