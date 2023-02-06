import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gtk_window/gtk_window.dart';
import 'package:keyboard/constants.dart';
import 'package:keyboard/screens/main_screen/widgets/settings_drawer.dart';
import 'package:keyboard/settings.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:piano/piano.dart';
import 'package:segment_display/segment_display.dart';
import 'package:wheel_spinner/wheel_spinner.dart';

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
    KnobStyle knobStyle = const KnobStyle(
      minorTicksPerInterval: 5,
      pointerStyle: PointerStyle(
        offset: 4,
        color: Colors.black12,
      ),
      tickOffset: 5,
      labelOffset: 5,
      majorTickStyle:
          MajorTickStyle(color: Colors.grey, highlightColor: Colors.black),
      minorTickStyle:
          MinorTickStyle(color: Colors.grey, highlightColor: Colors.black),
    );
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
      body: Stack(
        children: [
          NeumorphicBackground(),
          Positioned.fill(
            child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  "assets/textures/noise-300x300.png",
                  fit: BoxFit.scaleDown,
                  repeat: ImageRepeat.repeat,
                )),
          ),
          Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Spacer(),
                    Knob(
                      style: knobStyle,
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Center(
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              depth: -25,
                              intensity: 1,
                              surfaceIntensity: 1,
                              boxShape: NeumorphicBoxShape.rect(),
                            ),
                            child: const SixteenSegmentDisplay(
                              value: "TEST",
                              segmentStyle: DefaultSegmentStyle(
                                  enabledColor: Colors.blue,
                                  disabledColor: Colors.white12),
                              characterCount: 4,
                              size: 6.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const NeuomorphicSlider(),
                            _buildSpacer(),
                            const NeuomorphicSlider(),
                            _buildSpacer(),
                            const NeuomorphicSlider(),
                            _buildSpacer(),
                            const NeuomorphicSlider(),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Knob(
                      style: knobStyle,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: InteractivePiano(
                  naturalColor: Colors.white,
                  accidentalColor: Colors.black,
                  keyWidth: _settings.keyWidth,
                  noteRange: NoteRange.forClefs([
                    Clef.Treble,
                    Clef.Alto,
                    Clef.Bass,
                  ]),
                  hideNoteNames: _settings.hideNoteName,
                  hideNoteKeyboardkey: _settings.hideKeyboardShortcuts,
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _buildSpacer({double space = 24}) => SizedBox(width: space);
}

class NeuomorphicSlider extends StatelessWidget {
  const NeuomorphicSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            child: Neumorphic(
              style: const NeumorphicStyle(
                depth: 5,
                shape: NeumorphicShape.convex,
                surfaceIntensity: 0.5,
                lightSource: LightSource.top,
              ),
              child: WheelSpinner(
                theme: WheelSpinnerThemeData.light().copyWith(
                    color: Colors.transparent,
                    dividerColor: Colors.white54,
                    border: Border.all(color: Colors.transparent)),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const SizedBox(
            height: 250,
            child: RotatedBox(
              quarterTurns: -1,
              child: NeumorphicProgress(
                percent: 0.8,
                height: 25,
              ),
            ),
          )
        ],
      ),
    );
  }
}
