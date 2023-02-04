import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtk_window/gtk_window.dart';
import 'package:keyboard/constants.dart';
import 'package:keyboard/screens/main_screen/widgets/settings_drawer.dart';
import 'package:keyboard/settings.dart';
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

  Settings _settings = Settings();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GTKHeaderBar(
        leading: [
          Builder(builder: (context) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white12,
                    ),
                    child: const Icon(Icons.menu, size: 20),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      drawer: SettingsDrawer(
        settings: _settings,
        onSettingsChanged: (Settings value) {
          setState(() {
            _settings = value;
          });
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: InteractivePiano(
        naturalColor: Colors.white,
        accidentalColor: Colors.black,
        keyWidth: _settings.keyWidth,
        noteRange: NoteRange.forClefs([
          Clef.Treble,
          Clef.Alto,
          Clef.Bass,
        ]),
        hideNoteNames: false,
        animateHighlightedNotes: false,
        onNotePositionTapped: (position) async {
          String name = '';
          if (position.startsWith('C') || position.startsWith('F')) {
            name = position.replaceFirst('♯', '');
          } else {
            name = position.replaceFirst('♯', 'b');
          }
    
          FlameAudio.play('$name.mp3');
        },
      ),
    );
  }
}
