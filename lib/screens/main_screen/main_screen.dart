import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:piano/piano.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InteractivePiano(
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

          final player = AudioPlayer();
          await player.play(AssetSource('sounds/$name.mp3'),
              mode: PlayerMode.lowLatency);
          Future.delayed(const Duration(milliseconds: 2500), () async {
            await player.dispose();
          });
        },
      ),
    );
  }
}
